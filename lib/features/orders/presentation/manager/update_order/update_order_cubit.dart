import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/enums/order_enum.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/usecases/update_order_use_case.dart';

part 'update_order_state.dart';

class UpdateOrderCubit extends Cubit<UpdateOrderState> {
  UpdateOrderCubit(this._updateOrderUseCase)
      : super(const UpdateOrderInitial());

  final UpdateOrderUseCase _updateOrderUseCase;

  Future<void> updateOrder({
    required OrderStatusEnum status,
    required String orderID,
    required String userId,
  }) async {
    emit(const UpdateOrderLoading());
    final result = await _updateOrderUseCase(
      UpdateOrderParams(
        status: status,
        orderId: orderID,
        userId: userId,
      ),
    );
    result.fold(
      (f) {
        emit(UpdateOrderFailure(f.message));
      },
      (_) {
        emit(const UpdateOrderSuccess());
      },
    );
  }
}
