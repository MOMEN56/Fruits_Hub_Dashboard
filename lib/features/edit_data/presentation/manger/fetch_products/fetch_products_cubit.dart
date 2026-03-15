import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manger/fetch_products/fetch_products_state.dart';

class FetchProductsCubit extends Cubit<FetchProductsState> {
  FetchProductsCubit(this.productsRepo) : super(FetchProductsInitial());

  final ProductsRepo productsRepo;
  StreamSubscription? _streamSubscription;
  Timer? _reconnectTimer;
  int _subscriptionGeneration = 0;
  bool _isClosed = false;

  void fetchProducts({bool showLoading = true}) {
    final currentGeneration = ++_subscriptionGeneration;
    _reconnectTimer?.cancel();

    if (showLoading) {
      emit(FetchProductsLoading());
    }

    _streamSubscription?.cancel();
    _streamSubscription = productsRepo.fetchProducts().listen(
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
