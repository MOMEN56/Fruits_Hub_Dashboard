import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fruit_hub_dashboard/core/repos/notifications_repo/notifications_repo.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/manger/fetch_notifications/fetch_notifications_state.dart';

class FetchNotificationsCubit extends Cubit<FetchNotificationsState> {
  FetchNotificationsCubit(this.notificationsRepo)
      : super(FetchNotificationsInitial());

  final NotificationsRepo notificationsRepo;
  StreamSubscription? _streamSubscription;
  Timer? _reconnectTimer;
  int _subscriptionGeneration = 0;
  bool _isClosed = false;

  void fetchNotifications({bool showLoading = true}) {
    final currentGeneration = ++_subscriptionGeneration;
    _reconnectTimer?.cancel();

    if (showLoading) {
      emit(FetchNotificationsLoading());
    }

    _streamSubscription?.cancel();
    _streamSubscription = notificationsRepo.fetchNotifications().listen(
      (result) {
        if (!_isCurrentSubscription(currentGeneration)) {
          return;
        }

        result.fold(
          (failure) => emit(FetchNotificationsFailure(failure.message)),
          (notifications) =>
              emit(FetchNotificationsSuccess(notifications: notifications)),
        );
      },
      onError: (error, stackTrace) {
        if (!_isCurrentSubscription(currentGeneration)) {
          return;
        }

        log('Notifications stream error: $error', stackTrace: stackTrace);
        emit(FetchNotificationsFailure(error.toString()));
        _scheduleReconnect();
      },
      onDone: () {
        if (!_isCurrentSubscription(currentGeneration)) {
          return;
        }

        log('Notifications stream closed unexpectedly.');
        _scheduleReconnect();
      },
    );
  }

  void _scheduleReconnect() {
    if (_isClosed) {
      return;
    }

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(
      const Duration(seconds: 5),
      () => fetchNotifications(showLoading: false),
    );
  }

  bool _isCurrentSubscription(int generation) {
    return !_isClosed && generation == _subscriptionGeneration;
  }

  @override
  Future<void> close() {
    _isClosed = true;
    _subscriptionGeneration++;
    _reconnectTimer?.cancel();
    _streamSubscription?.cancel();
    return super.close();
  }
}
