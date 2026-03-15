import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/usecases/fetch_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/manger/fetch_order/fetch_orders_state.dart';

class FetchOrdersCubit extends Cubit<FetchOrdersState> {
  FetchOrdersCubit(this._fetchOrdersUseCase)
      : super(const FetchOrdersInitial());

  final FetchOrdersUseCase _fetchOrdersUseCase;
  StreamSubscription? _streamSubscription;
  Timer? _retryTimer;
  int _subscriptionGeneration = 0;
  bool _isClosed = false;

  void fetchOrders({bool showLoading = true}) {
    final currentGeneration = ++_subscriptionGeneration;
    _retryTimer?.cancel();

    if (showLoading) {
      emit(const FetchOrdersLoading());
    }

    _streamSubscription?.cancel();
    _streamSubscription = _fetchOrdersUseCase().listen(
      (result) {
        if (!_isCurrentSubscription(currentGeneration)) {
          return;
        }

        result.fold(
          (f) {
            emit(FetchOrdersFailure(f.message));
          },
          (r) {
            emit(FetchOrdersSuccess(orders: r));
          },
        );
      },
      onError: (e, stackTrace) {
        if (!_isCurrentSubscription(currentGeneration)) {
          return;
        }

        log('Stream error in FetchOrdersCubit: $e', stackTrace: stackTrace);
        emit(FetchOrdersFailure(e.toString()));
        _scheduleReconnect();
      },
      onDone: () {
        if (!_isCurrentSubscription(currentGeneration)) {
          return;
        }

        log('Orders stream closed unexpectedly.');
        _scheduleReconnect();
      },
    );
  }

  void _scheduleReconnect() {
    if (_isClosed) {
      return;
    }

    _retryTimer?.cancel();
    _retryTimer = Timer(
      const Duration(seconds: 5),
      () => fetchOrders(showLoading: false),
    );
  }

  bool _isCurrentSubscription(int generation) {
    return !_isClosed && generation == _subscriptionGeneration;
  }

  @override
  Future<void> close() {
    _isClosed = true;
    _subscriptionGeneration++;
    _retryTimer?.cancel();
    _streamSubscription?.cancel();
    return super.close();
  }
}
