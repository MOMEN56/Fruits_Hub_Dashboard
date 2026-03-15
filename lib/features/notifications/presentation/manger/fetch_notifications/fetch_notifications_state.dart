import 'package:fruit_hub_dashboard/core/repos/notifications_repo/notification_entity.dart';
import 'package:meta/meta.dart';

@immutable
abstract class FetchNotificationsState {
  const FetchNotificationsState();
}

class FetchNotificationsInitial extends FetchNotificationsState {}

class FetchNotificationsLoading extends FetchNotificationsState {}

class FetchNotificationsSuccess extends FetchNotificationsState {
  const FetchNotificationsSuccess({required this.notifications});

  final List<NotificationEntity> notifications;
}

class FetchNotificationsFailure extends FetchNotificationsState {
  const FetchNotificationsFailure(this.errMessage);

  final String errMessage;
}
