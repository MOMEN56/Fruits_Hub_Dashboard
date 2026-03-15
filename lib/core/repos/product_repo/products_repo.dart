import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';

import '../../../features/add_product/domain/entities/product_entity.dart';

abstract class ProductsRepo {
  Future<Either<Failure, void>> addProduct(ProductEntity addProductInputEntity);
  Stream<Either<Failure, List<EditableProductEntity>>> fetchProducts();
  Future<Either<Failure, void>> updateProduct(EditableProductEntity product);
  Future<Either<Failure, void>> deleteProduct({required String productId});
  Future<Either<Failure, void>> setProductVisibility({
    required String productId,
    required bool isVisible,
  });
}
