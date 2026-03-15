import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/entities/data/models/order_product_entity.dart';

class OrderProductTile extends StatelessWidget {
  const OrderProductTile({super.key, required this.product});

  final OrderProductEntity product;

  @override
  Widget build(BuildContext context) {
    final subtotal =
        '\$${(product.price * product.quantity).toStringAsFixed(2)}';
    final details =
        'Quantity: ${product.quantity} | Price: \$${product.price.toStringAsFixed(2)}';

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 360) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 40,
                  height: 40,
                  child: _buildProductImage(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        details,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  subtotal,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          );
        }

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            width: 40,
            height: 40,
            child: _buildProductImage(),
          ),
          title: Text(product.name),
          subtitle: Text(details),
          trailing: Text(
            subtotal,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.green),
          ),
        );
      },
    );
  }

  Widget _buildProductImage() {
    return CachedNetworkImage(
      imageUrl: product.imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
