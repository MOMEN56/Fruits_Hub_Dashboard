import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';

class FetchProductsUseCase {
  const FetchProductsUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Stream<Either<Failure, List<EditableProductEntity>>> call() {
    return _productsRepo.fetchProducts();
  }
}
