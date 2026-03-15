import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/enums/order_enum.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatusEnum status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _statusBadgeBackgroundColor(status),
        border: Border.all(
          color: _statusBadgeBorderColor(status),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.name,
        style: TextStyle(
          fontSize: 14,
          color: _statusBadgeTextColor(status),
        ),
      ),
    );
  }

  Color _statusBadgeBackgroundColor(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.accepted:
        return const Color(0xFFEAF7EF);
      case OrderStatusEnum.cancelled:
        return const Color(0xFFFFEEF0);
      case OrderStatusEnum.delivered:
        return const Color(0xFFEAF2FF);
      case OrderStatusEnum.pending:
        return const Color(0xFFFFF7E8);
    }
  }

  Color _statusBadgeBorderColor(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.accepted:
        return const Color(0xFF63B37A);
      case OrderStatusEnum.cancelled:
        return const Color(0xFFE57373);
      case OrderStatusEnum.delivered:
        return const Color(0xFF64B5F6);
      case OrderStatusEnum.pending:
        return const Color(0xFFFFB74D);
    }
  }

  Color _statusBadgeTextColor(OrderStatusEnum status) {
    switch (status) {
      case OrderStatusEnum.accepted:
        return const Color(0xFF2E7D32);
      case OrderStatusEnum.cancelled:
        return const Color(0xFFC62828);
      case OrderStatusEnum.delivered:
        return const Color(0xFF1565C0);
      case OrderStatusEnum.pending:
        return const Color(0xFFEF6C00);
    }
  }
}
