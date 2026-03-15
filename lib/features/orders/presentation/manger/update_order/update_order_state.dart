part of 'update_order_cubit.dart';

sealed class UpdateOrderState {
  const UpdateOrderState();
}

final class UpdateOrderInitial extends UpdateOrderState {
  const UpdateOrderInitial();
}

final class UpdateOrderSuccess extends UpdateOrderState {
  const UpdateOrderSuccess();
}

final class UpdateOrderFailure extends UpdateOrderState {
  const UpdateOrderFailure(this.errMessage);

  final String errMessage;
}

final class UpdateOrderLoading extends UpdateOrderState {
  const UpdateOrderLoading();
}
