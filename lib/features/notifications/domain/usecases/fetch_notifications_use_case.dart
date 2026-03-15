import 'package:dartz/dartz.dart';
import 'package:fruit_hub_dashboard/core/errors/failures.dart';
import 'package:fruit_hub_dashboard/core/repos/notifications_repo/notification_entity.dart';
import 'package:fruit_hub_dashboard/core/repos/notifications_repo/notifications_repo.dart';

class FetchNotificationsUseCase {
  const FetchNotificationsUseCase(this._notificationsRepo);

  final NotificationsRepo _notificationsRepo;

  Stream<Either<Failure, List<NotificationEntity>>> call() {
    return _notificationsRepo.fetchNotifications();
  }
}
