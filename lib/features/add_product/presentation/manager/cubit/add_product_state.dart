part of 'add_product_cubit.dart';

sealed class AddProductState {
  const AddProductState();
}

final class AddProductInitial extends AddProductState {
  const AddProductInitial();
}

final class AddProductLoading extends AddProductState {
  const AddProductLoading();
}

final class AddProductFailure extends AddProductState {
  const AddProductFailure(this.errMessage);

  final String errMessage;
}

final class AddProductSuccess extends AddProductState {
  const AddProductSuccess();
}
