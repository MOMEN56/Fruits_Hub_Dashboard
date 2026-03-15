import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/utils/responsive_layout.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/data/models/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/widgets/orders_items_list_view.dart';

import 'filter_section.dart';

class OrdersViewBody extends StatelessWidget {
  const OrdersViewBody({super.key, required this.orders});

  final List<OrderEntity> orders;
  @override
  Widget build(BuildContext context) {
    return ResponsiveContent(
      maxWidth: 1040,
      child: Column(
        children: [
          const SizedBox(
            height: 24,
          ),
          const FilterSection(),
          const SizedBox(
            height: 16,
          ),
          Expanded(child: OrdersItemsListView(orderModels: orders)),
        ],
      ),
    );
  }
}
