import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/enums/order_enum.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repos/orders_repo.dart';

class UpdateOrderUseCase {
  const UpdateOrderUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Future<Either<Failure, void>> call(UpdateOrderParams params) {
    return _ordersRepo.updateOrder(
      status: params.status,
      orderID: params.orderId,
      userId: params.userId,
    );
  }
}

class UpdateOrderParams {
  const UpdateOrderParams({
    required this.status,
    required this.orderId,
    required this.userId,
  });

  final OrderStatusEnum status;
  final String orderId;
  final String userId;
}
