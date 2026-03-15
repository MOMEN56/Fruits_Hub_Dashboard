import 'package:meta/meta.dart';

@immutable
abstract class SendNotificationState {
  const SendNotificationState();
}

class SendNotificationInitial extends SendNotificationState {}

class SendNotificationLoading extends SendNotificationState {}

class SendNotificationSuccess extends SendNotificationState {}

class SendNotificationFailure extends SendNotificationState {
  const SendNotificationFailure(this.errMessage);

  final String errMessage;
}
