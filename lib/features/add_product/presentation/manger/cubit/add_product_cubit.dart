import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/add_product_use_case.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  AddProductCubit(this._addProductUseCase) : super(const AddProductInitial());

  final AddProductUseCase _addProductUseCase;

  Future<void> addProduct(ProductEntity addProductInputEntity) async {
    emit(const AddProductLoading());

    final result = await _addProductUseCase(addProductInputEntity);
    result.fold(
      (failure) => emit(AddProductFailure(failure.message)),
      (_) => emit(const AddProductSuccess()),
    );
  }
}
