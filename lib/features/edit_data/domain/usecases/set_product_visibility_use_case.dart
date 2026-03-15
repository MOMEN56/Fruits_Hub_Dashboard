import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo.dart';

class SetProductVisibilityUseCase {
  const SetProductVisibilityUseCase(this._productsRepo);

  final ProductsRepo _productsRepo;

  Future<Either<Failure, void>> call({
    required String productId,
    required bool isVisible,
  }) {
    return _productsRepo.setProductVisibility(
      productId: productId,
      isVisible: isVisible,
    );
  }
}
