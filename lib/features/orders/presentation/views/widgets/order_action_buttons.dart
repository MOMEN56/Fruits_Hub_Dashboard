import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/manager/update_order/update_order_cubit.dart';

import '../../../../../core/enums/order_enum.dart';
import '../../../domain/entities/data/models/order_entity.dart';

class OrderActionButtons extends StatelessWidget {
  const OrderActionButtons({
    super.key,
    required this.orderEntity,
  });

  final OrderEntity orderEntity;

  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [];

    if (orderEntity.status == OrderStatusEnum.pending) {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            context.read<UpdateOrderCubit>().updateOrder(
                  status: OrderStatusEnum.accepted,
                  orderID: orderEntity.orderID,
                  userId: orderEntity.uId,
                );
          },
          child: const Text('Accept'),
        ),
      );
      buttons.add(
        ElevatedButton(
          onPressed: () {
            context.read<UpdateOrderCubit>().updateOrder(
                  status: OrderStatusEnum.cancelled,
                  orderID: orderEntity.orderID,
                  userId: orderEntity.uId,
                );
          },
          child: const Text('Cancel'),
        ),
      );
    }

    if (orderEntity.status == OrderStatusEnum.accepted) {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            context.read<UpdateOrderCubit>().updateOrder(
                  status: OrderStatusEnum.delivered,
                  orderID: orderEntity.orderID,
                  userId: orderEntity.uId,
                );
          },
          child: const Text('Delivered'),
        ),
      );
      buttons.add(
        ElevatedButton(
          onPressed: () {
            context.read<UpdateOrderCubit>().updateOrder(
                  status: OrderStatusEnum.cancelled,
                  orderID: orderEntity.orderID,
                  userId: orderEntity.uId,
                );
          },
          child: const Text('Cancel'),
        ),
      );
    }

    if (buttons.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useFullWidthButtons = constraints.maxWidth < 420;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: buttons
              .map(
                (button) => useFullWidthButtons
                    ? SizedBox(width: constraints.maxWidth, child: button)
                    : button,
              )
              .toList(),
        );
      },
    );
  }
}
