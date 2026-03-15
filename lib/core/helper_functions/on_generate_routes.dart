import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/views/add_product_view.dart';
import 'package:fruit_hub_dashboard/features/dashboard/views/dashboard_view.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/views/edit_data_view.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/views/push_notifications_view.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/orders_view.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case DashboardView.routeName:
      return MaterialPageRoute(builder: (context) => const DashboardView());
    case OrdersView.routeName:
      return MaterialPageRoute(builder: (context) => const OrdersView());

    case AddProductView.routeName:
      return MaterialPageRoute(builder: (context) => const AddProductView());
    case EditDataView.routeName:
      return MaterialPageRoute(builder: (context) => const EditDataView());
    case PushNotificationsView.routeName:
      return MaterialPageRoute(
          builder: (context) => const PushNotificationsView());
    default:
      return MaterialPageRoute(builder: (context) => const Scaffold());
  }
}
