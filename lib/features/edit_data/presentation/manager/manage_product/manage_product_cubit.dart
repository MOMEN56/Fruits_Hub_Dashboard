import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/delete_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/set_product_visibility_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/update_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manager/manage_product/manage_product_state.dart';

class ManageProductCubit extends Cubit<ManageProductState> {
  ManageProductCubit(
    this._updateProductUseCase,
    this._deleteProductUseCase,
    this._setProductVisibilityUseCase,
  ) : super(const ManageProductInitial());

  final UpdateProductUseCase _updateProductUseCase;
  final DeleteProductUseCase _deleteProductUseCase;
  final SetProductVisibilityUseCase _setProductVisibilityUseCase;

  Future<void> updateProduct({
    required EditableProductEntity product,
    File? newImage,
  }) async {
    emit(ManageProductLoading(
        productId: product.id, action: ProductAction.update));

    final result = await _updateProductUseCase(
      UpdateProductParams(product: product, newImage: newImage),
    );
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
    final result = await _deleteProductUseCase(productId: productId);
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
    final result = await _setProductVisibilityUseCase(
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
