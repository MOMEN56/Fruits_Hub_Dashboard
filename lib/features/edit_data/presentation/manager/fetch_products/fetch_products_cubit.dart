import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/fetch_products_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manager/fetch_products/fetch_products_state.dart';

class FetchProductsCubit extends Cubit<FetchProductsState> {
  FetchProductsCubit(this._fetchProductsUseCase)
      : super(const FetchProductsInitial());

  final FetchProductsUseCase _fetchProductsUseCase;
  StreamSubscription? _streamSubscription;
  Timer? _reconnectTimer;
  int _subscriptionGeneration = 0;
  bool _isClosed = false;

  void fetchProducts({bool showLoading = true}) {
    final currentGeneration = ++_subscriptionGeneration;
    _reconnectTimer?.cancel();

    if (showLoading) {
      emit(const FetchProductsLoading());
    }

    _streamSubscription?.cancel();
    _streamSubscription = _fetchProductsUseCase().listen(
      (result) {
        if (!_isCurrentSubscription(currentGeneration)) {
          return;
        }

        result.fold(
          (failure) => emit(FetchProductsFailure(failure.message)),
          (products) => emit(FetchProductsSuccess(products: products)),
        );
      },
      onError: (error, stackTrace) {
        if (!_isCurrentSubscription(currentGeneration)) {
          return;
        }

        log('Products stream error: $error', stackTrace: stackTrace);
        emit(FetchProductsFailure(error.toString()));
        _scheduleReconnect();
      },
      onDone: () {
        if (!_isCurrentSubscription(currentGeneration)) {
          return;
        }

        log('Products stream closed unexpectedly.');
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
      () => fetchProducts(showLoading: false),
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
