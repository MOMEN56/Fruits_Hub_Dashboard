abstract class SendNotificationState {
  const SendNotificationState();
}

class SendNotificationInitial extends SendNotificationState {
  const SendNotificationInitial();
}

class SendNotificationLoading extends SendNotificationState {
  const SendNotificationLoading();
}

class SendNotificationSuccess extends SendNotificationState {
  const SendNotificationSuccess();
}

class SendNotificationFailure extends SendNotificationState {
  const SendNotificationFailure(this.errMessage);

  final String errMessage;
}
