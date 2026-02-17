import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:fruit_hub_dashboard/core/services/data_service.dart';
import 'package:fruit_hub_dashboard/features/add_product/data/models/product_model.dart';
import 'package:fruit_hub_dashboard/features/add_product/domain/entities/product_entity.dart';

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
      print('Data to add: $jsonData'); // Debug print
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
}
