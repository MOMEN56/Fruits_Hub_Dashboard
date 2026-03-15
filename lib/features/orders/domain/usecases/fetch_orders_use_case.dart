import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/data/models/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repos/orders_repo.dart';

class FetchOrdersUseCase {
  const FetchOrdersUseCase(this._ordersRepo);

  final OrdersRepo _ordersRepo;

  Stream<Either<Failure, List<OrderEntity>>> call() {
    return _ordersRepo.fetchOrders();
  }
}
