import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/repos/notifications_repo/notifications_repo.dart';

class SendManualNotificationUseCase {
  const SendManualNotificationUseCase(this._notificationsRepo);

  final NotificationsRepo _notificationsRepo;

  Future<Either<Failure, void>> call(
    SendManualNotificationParams params,
  ) {
    return _notificationsRepo.sendManualNotification(
      titleAr: params.titleAr,
      messageAr: params.messageAr,
      userId: params.userId,
      orderId: params.orderId,
    );
  }
}

class SendManualNotificationParams {
  const SendManualNotificationParams({
    required this.titleAr,
    required this.messageAr,
    this.userId,
    this.orderId,
  });

  final String titleAr;
  final String messageAr;
  final String? userId;
  final String? orderId;
}
