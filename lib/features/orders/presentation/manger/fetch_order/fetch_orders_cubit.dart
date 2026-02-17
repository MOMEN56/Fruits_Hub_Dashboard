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

  void fetchOrders() {
    emit(FetchOrdersLoading());
    _streamSubscription = ordersRepo.fetchOrders().listen(
      (result) {
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
        print('Stream error in Cubit: $e'); // log in Cubit
        print('Stack trace in Cubit: $stackTrace');
        emit(FetchOrdersFailure(e.toString()));
        Future.delayed(const Duration(seconds: 5), fetchOrders);
      },
      onDone: () {
        print('Stream done');
      },
    );
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
