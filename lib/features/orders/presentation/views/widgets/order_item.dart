import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/data/models/order_entity.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/widgets/order_action_buttons.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/widgets/order_products_list.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/widgets/order_status_badge.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderEntity orderModel;

  const OrderItemWidget({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    final customerName = (orderModel.shippingAddressModel.name ?? '').trim();

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 420;
            final totalPriceText =
                'Total Price: \$${orderModel.totalPrice.toStringAsFixed(2)}';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNarrow) ...[
                  Text(
                    totalPriceText,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  OrderStatusBadge(status: orderModel.status),
                ] else
                  Row(
                    children: [
                      Text(
                        totalPriceText,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      OrderStatusBadge(status: orderModel.status),
                    ],
                  ),
                const SizedBox(height: 8),
                Text(
                  'Customer: ${customerName.isEmpty ? 'Unknown' : customerName}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Shipping Address:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  orderModel.shippingAddressModel.toString(),
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  'Payment Method: ${orderModel.paymentMethod}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Products:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                OrderProductsList(products: orderModel.orderProducts),
                const SizedBox(height: 16),
                OrderActionButtons(orderEntity: orderModel),
              ],
            );
          },
        ),
      ),
    );
  }
}
