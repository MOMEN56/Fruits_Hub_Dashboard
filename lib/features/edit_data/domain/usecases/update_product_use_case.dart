import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/repos/images_repo/images_repo.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';

class UpdateProductUseCase {
  const UpdateProductUseCase(this._productsRepo, this._imagesRepo);

  final ProductsRepo _productsRepo;
  final ImagesRepo _imagesRepo;

  Future<Either<Failure, void>> call(UpdateProductParams params) async {
    var product = params.product;

    if (params.newImage != null) {
      Failure? uploadFailure;
      final imageUrl =
          (await _imagesRepo.uploadImage(params.newImage!)).fold<String?>(
        (failure) {
          uploadFailure = failure;
          return null;
        },
        (value) => value,
      );

      if (uploadFailure != null || imageUrl == null) {
        return Left(uploadFailure!);
      }

      product = product.copyWith(imageUrl: imageUrl);
    }

    return _productsRepo.updateProduct(product);
  }
}

class UpdateProductParams {
  const UpdateProductParams({
    required this.product,
    this.newImage,
  });

  final EditableProductEntity product;
  final File? newImage;
}
