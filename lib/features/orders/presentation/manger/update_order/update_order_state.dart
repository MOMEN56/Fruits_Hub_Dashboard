part of 'update_order_cubit.dart';

@immutable
sealed class UpdateOrderState {}

final class UpdateOrderInitial extends UpdateOrderState {}

final class UpdateOrderSuccess extends UpdateOrderState {}

final class UpdateOrderFailure extends UpdateOrderState {
  final String errMessage;
  UpdateOrderFailure(this.errMessage);
}

final class UpdateOrderLoading extends UpdateOrderState {}
