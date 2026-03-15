import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/repos/images_repo/images_repo.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/add_product/domain/entities/product_entity.dart';

class AddProductUseCase {
  const AddProductUseCase(this._productsRepo, this._imagesRepo);

  final ProductsRepo _productsRepo;
  final ImagesRepo _imagesRepo;

  Future<Either<Failure, void>> call(ProductEntity product) async {
    Failure? uploadFailure;
    final imageUrl =
        (await _imagesRepo.uploadImage(product.image)).fold<String?>(
      (failure) {
        uploadFailure = failure;
        return null;
      },
      (value) => value,
    );

    if (uploadFailure != null || imageUrl == null) {
      return Left(uploadFailure!);
    }

    product.imageUrl = imageUrl;
    return _productsRepo.addProduct(product);
  }
}
