import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/data/models/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repos/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/manger/fetch_order/fetch_orders_state.dart';
import 'package:meta/meta.dart';

class FetchOrdersCubit extends Cubit<FetchOrdersState> {
  FetchOrdersCubit(this.ordersRepo) : super(FetchOrdersInitial());
  final OrdersRepo ordersRepo;
  StreamSubscription? _streamSubscription;
  void fetchOrders() async {
    emit(FetchOrdersLoading());
    _streamSubscription = ordersRepo.fetchOrders().listen((result) {
      result.fold((f) {
        emit(FetchOrdersFailure(f.message));
      }, (r) {
        emit(FetchOrdersSuccess(
          orders: r,
        ));
      });
    });
    await for (var result in ordersRepo.fetchOrders()) {
      result.fold((f) {
        emit(FetchOrdersFailure(f.message));
      }, (r) {
        emit(FetchOrdersSuccess(
          orders: r,
        ));
      });
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
