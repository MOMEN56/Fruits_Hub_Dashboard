import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:fruit_hub_dashboard/core/repos/images_repo/images_repo.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manger/manage_product/manage_product_state.dart';

class ManageProductCubit extends Cubit<ManageProductState> {
  ManageProductCubit(this.productsRepo, this.imagesRepo)
      : super(ManageProductInitial());

  final ProductsRepo productsRepo;
  final ImagesRepo imagesRepo;

  Future<void> updateProduct({
    required EditableProductEntity product,
    File? newImage,
  }) async {
    emit(ManageProductLoading(
        productId: product.id, action: ProductAction.update));

    var updatedProduct = product;
    if (newImage != null) {
      final uploadResult = await imagesRepo.uploadImage(newImage);
      final imageUrl = uploadResult.fold<String?>(
        (failure) {
          emit(ManageProductFailure(failure.message));
          return null;
        },
        (url) => url,
      );

      if (imageUrl == null) {
        return;
      }
      updatedProduct = product.copyWith(imageUrl: imageUrl);
    }

    final result = await productsRepo.updateProduct(updatedProduct);
    result.fold(
      (failure) => emit(ManageProductFailure(failure.message)),
      (_) => emit(
        const ManageProductSuccess(
          action: ProductAction.update,
          successMessage: 'Product updated successfully',
        ),
      ),
    );
  }

  Future<void> deleteProduct({required String productId}) async {
    emit(ManageProductLoading(
        productId: productId, action: ProductAction.delete));
    final result = await productsRepo.deleteProduct(productId: productId);
    result.fold(
      (failure) => emit(ManageProductFailure(failure.message)),
      (_) => emit(
        const ManageProductSuccess(
          action: ProductAction.delete,
          successMessage: 'Product deleted successfully',
        ),
      ),
    );
  }

  Future<void> toggleVisibility({
    required String productId,
    required bool isVisible,
  }) async {
    emit(
      ManageProductLoading(
        productId: productId,
        action: ProductAction.visibility,
      ),
    );
    final result = await productsRepo.setProductVisibility(
      productId: productId,
      isVisible: isVisible,
    );
    result.fold(
      (failure) => emit(ManageProductFailure(failure.message)),
      (_) => emit(
        ManageProductSuccess(
          action: ProductAction.visibility,
          successMessage:
              isVisible ? 'Product is visible now' : 'Product moved to hold',
        ),
      ),
    );
  }
}
