import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:fruit_hub_dashboard/core/services/data_service.dart';
import 'package:fruit_hub_dashboard/features/add_product/data/models/product_model.dart';
import 'package:fruit_hub_dashboard/features/add_product/domain/entities/product_entity.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';

import '../../errors/failures.dart';
import '../../utils/backend_endpoint.dart';

class ProductsRepoImpl implements ProductsRepo {
  final DatabaseService databaseService;

  ProductsRepoImpl(this.databaseService);

  @override
  Future<Either<Failure, void>> addProduct(
      ProductEntity addProductInputEntity) async {
    try {
      final jsonData = ProductModel.fromEntity(addProductInputEntity).toJson();
      log('Adding product with payload: $jsonData');
      await databaseService.addData(
        path: BackendEndpoint.productsCollection,
        data: jsonData,
      );
      log('Add product success');
      return const Right(null);
    } catch (e) {
      log('Add product error: $e');
      return Left(ServerFailure('Failed to add product: $e'));
    }
  }

  @override
  Stream<Either<Failure, List<EditableProductEntity>>> fetchProducts() async* {
    await for (final rawData in databaseService.streamData(
        path: BackendEndpoint.productsCollection)) {
      if (rawData is! List) {
        continue;
      }
      final products = <EditableProductEntity>[];
      for (final row in rawData.whereType<Map>()) {
        try {
          final product = EditableProductEntity.fromJson(
            Map<String, dynamic>.from(row),
          );
          products.add(product);
        } catch (e, stackTrace) {
          log('Skipping malformed product row: $e', stackTrace: stackTrace);
        }
      }
      products.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      yield Right(products);
    }
  }

  @override
  Future<Either<Failure, void>> updateProduct(
      EditableProductEntity product) async {
    try {
      await databaseService.updateData(
        path: BackendEndpoint.productsCollection,
        documentId: product.id,
        data: product.toUpdateJson(),
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update product: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(
      {required String productId}) async {
    try {
      await databaseService.deleteData(
        path: BackendEndpoint.productsCollection,
        documentId: productId,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to delete product: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> setProductVisibility({
    required String productId,
    required bool isVisible,
  }) async {
    try {
      await databaseService.updateData(
        path: BackendEndpoint.productsCollection,
        documentId: productId,
        data: {'is_visible': isVisible},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update visibility: $e'));
    }
  }
}
