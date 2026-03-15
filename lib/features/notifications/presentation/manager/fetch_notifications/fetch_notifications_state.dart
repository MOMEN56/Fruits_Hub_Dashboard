import 'package:fruit_hub_dashboard/core/repos/notifications_repo/notification_entity.dart';

abstract class FetchNotificationsState {
  const FetchNotificationsState();
}

class FetchNotificationsInitial extends FetchNotificationsState {
  const FetchNotificationsInitial();
}

class FetchNotificationsLoading extends FetchNotificationsState {
  const FetchNotificationsLoading();
}

class FetchNotificationsSuccess extends FetchNotificationsState {
  const FetchNotificationsSuccess({required this.notifications});

  final List<NotificationEntity> notifications;
}

class FetchNotificationsFailure extends FetchNotificationsState {
  const FetchNotificationsFailure(this.errMessage);

  final String errMessage;
}
