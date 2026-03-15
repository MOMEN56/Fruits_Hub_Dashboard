import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/data/models/order_product_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/widgets/order_product_tile.dart';

class OrderProductsList extends StatelessWidget {
  const OrderProductsList({super.key, required this.products});

  final List<OrderProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return OrderProductTile(product: products[index]);
      },
    );
  }
}
