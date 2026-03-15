import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';

import 'notification_entity.dart';

abstract class NotificationsRepo {
  Stream<Either<Failure, List<NotificationEntity>>> fetchNotifications();

  Future<Either<Failure, void>> sendManualNotification({
    required String titleAr,
    required String messageAr,
    String? userId,
    String? orderId,
  });
}
