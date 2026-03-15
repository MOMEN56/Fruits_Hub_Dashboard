import 'package:bloc/bloc.dart';
import 'package:fruit_hub_dashboard/core/repos/notifications_repo/notifications_repo.dart';

import 'send_notification_state.dart';

class SendNotificationCubit extends Cubit<SendNotificationState> {
  SendNotificationCubit(this.notificationsRepo)
      : super(SendNotificationInitial());

  final NotificationsRepo notificationsRepo;

  Future<void> sendManualNotification({
    required String titleAr,
    required String messageAr,
    String? userId,
    String? orderId,
  }) async {
    emit(SendNotificationLoading());
    final result = await notificationsRepo.sendManualNotification(
      titleAr: titleAr,
      messageAr: messageAr,
      userId: userId,
      orderId: orderId,
    );

    result.fold(
      (failure) => emit(SendNotificationFailure(failure.message)),
      (_) => emit(SendNotificationSuccess()),
    );
  }
}
