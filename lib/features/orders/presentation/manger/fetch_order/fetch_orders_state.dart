import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/data/models/order_entity.dart';

@immutable
sealed class FetchOrdersState {
  const FetchOrdersState();
}

final class FetchOrdersInitial extends FetchOrdersState {
  const FetchOrdersInitial();
}

final class FetchOrdersLoading extends FetchOrdersState {
  const FetchOrdersLoading();
}

final class FetchOrdersSuccess extends FetchOrdersState {
  const FetchOrdersSuccess({required this.orders});

  final List<OrderEntity> orders;
}

final class FetchOrdersFailure extends FetchOrdersState {
  const FetchOrdersFailure(this.errMessage);

  final String errMessage;
}
