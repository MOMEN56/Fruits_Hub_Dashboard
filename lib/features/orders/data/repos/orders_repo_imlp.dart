import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/enums/order_enum.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/services/data_service.dart';
import 'package:fruit_hub_dashboard/core/services/notification_event_service.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/data/models/order_entity.dart';

import '../../../../core/utils/backend_endpoint.dart';
import '../../domain/repos/orders_repo.dart';
import '../models/order_model.dart';

class OrdersRepoImpl implements OrdersRepo {
  final DatabaseService _dataService;
  final NotificationEventService _notificationEventService;

  OrdersRepoImpl(this._dataService, this._notificationEventService);

  @override
  Stream<Either<Failure, List<OrderEntity>>> fetchOrders() async* {
    await for (final data
        in _dataService.streamData(path: BackendEndpoint.getOrders)) {
      if (data is! List) {
        continue;
      }

      final orders = <OrderEntity>[];
      for (final rawItem in data.whereType<Map>()) {
        try {
          final order = OrderModel.fromJson(Map<String, dynamic>.from(rawItem))
              .toEntity();
          orders.add(order);
        } catch (e, stackTrace) {
          log(
            'Skipping malformed order row: $e\nRow: $rawItem',
            stackTrace: stackTrace,
          );
        }
      }
      yield Right(orders);
    }
  }

  @override
  Future<Either<Failure, void>> updateOrder(
      {required OrderStatusEnum status,
      required String orderID,
      required String userId}) async {
    try {
      await _dataService.updateData(
        data: {
          'status': status.name,
        },
        path: BackendEndpoint.updateOrder,
        documentId: orderID,
      );
      try {
        await _notificationEventService.sendOrderStatusNotification(
          userId: userId,
          orderId: orderID,
          status: status,
        );
      } catch (_) {}
      return right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update order'));
    }
  }
}
