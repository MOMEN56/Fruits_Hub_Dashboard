import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/features/notifications/domain/usecases/send_manual_notification_use_case.dart';

import 'send_notification_state.dart';

class SendNotificationCubit extends Cubit<SendNotificationState> {
  SendNotificationCubit(this._sendManualNotificationUseCase)
      : super(const SendNotificationInitial());

  final SendManualNotificationUseCase _sendManualNotificationUseCase;

  Future<void> sendManualNotification({
    required String titleAr,
    required String messageAr,
    String? userId,
    String? orderId,
  }) async {
    emit(const SendNotificationLoading());
    final result = await _sendManualNotificationUseCase(
      SendManualNotificationParams(
        titleAr: titleAr,
        messageAr: messageAr,
        userId: userId,
        orderId: orderId,
      ),
    );

    result.fold(
      (failure) => emit(SendNotificationFailure(failure.message)),
      (_) => emit(const SendNotificationSuccess()),
    );
  }
}
