import 'package:fruit_hub_dashboard/core/enums/order_enum.dart';
import 'package:fruit_hub_dashboard/features/orders/data/models/shipping_address_model.dart';

import '../../domain/entities/data/models/order_entity.dart';
import 'order_product_model.dart';

class OrderModel {
  final double totalPrice;
  final String uId;
  final ShippingAddressModel shippingAddressModel;
  final List<OrderProductModel> orderProducts;
  final String paymentMethod;
  final String? status;
  final String orderID;
  OrderModel(
      {required this.totalPrice,
      required this.uId,
      required this.status,
      required this.orderID,
      required this.shippingAddressModel,
      required this.orderProducts,
      required this.paymentMethod});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawShippingAddress =
        json['shipping_address'] ?? json['shippingAddressModel'];
    final rawProducts = json['order_products'] ?? json['orderProducts'];

    return OrderModel(
      totalPrice: _toDouble(json['total_price'] ?? json['totalPrice']),
      uId: (json['u_id'] ?? json['uId'] ?? '').toString(),
      status: _normalizeStatus((json['status'] ?? 'pending').toString()),
      orderID:
          (json['id'] ?? json['order_id'] ?? json['orderId'] ?? '').toString(),
      shippingAddressModel: rawShippingAddress is Map
          ? ShippingAddressModel.fromJson(
              Map<String, dynamic>.from(rawShippingAddress))
          : ShippingAddressModel(),
      orderProducts: rawProducts is List
          ? rawProducts
              .whereType<Map>()
              .map((e) =>
                  OrderProductModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : <OrderProductModel>[],
      paymentMethod:
          (json['payment_method'] ?? json['paymentMethod'] ?? '').toString(),
    );
  }
  toJson() => {
        'totalPrice': totalPrice,
        'uId': uId,
        'status': 'pending',
        'date': DateTime.now().toString(),
        'shippingAddressModel': shippingAddressModel.toJson(),
        'orderProducts': orderProducts.map((e) => e.toJson()).toList(),
        'paymentMethod': paymentMethod,
      };

  toEntity() => OrderEntity(
        orderID: orderID,
        totalPrice: totalPrice,
        uId: uId,
        status: fetchEnum(),
        shippingAddressModel: shippingAddressModel.toEntity(),
        orderProducts: orderProducts.map((e) => e.toEntity()).toList(),
        paymentMethod: paymentMethod,
      );
  OrderStatusEnum fetchEnum() {
    final normalized = _normalizeStatus(status ?? 'pending');
    return OrderStatusEnum.values.firstWhere(
      (e) => e.name == normalized,
      orElse: () => OrderStatusEnum.pending,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  static String _normalizeStatus(String rawStatus) {
    final normalized = rawStatus.trim().toLowerCase();
    if (normalized == 'completed') {
      return OrderStatusEnum.delivered.name;
    }
    if (normalized.isEmpty) {
      return OrderStatusEnum.pending.name;
    }
    return normalized;
  }
}
