import 'package:flutter/material.dart';
import 'package:fruit_hub_dashboard/core/utils/responsive_layout.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_button.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/views/add_product_view.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/views/edit_data_view.dart';
import 'package:fruit_hub_dashboard/features/notifications/presentation/views/push_notifications_view.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/views/orders_view.dart';

class DashboardViewBody extends StatelessWidget {
  const DashboardViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveContent(
        maxWidth: 520,
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddProductView.routeName);
                },
                text: 'Add Data',
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, EditDataView.routeName);
                },
                text: 'Update data',
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, OrdersView.routeName);
                },
                text: 'View Orders',
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                onPressed: () {
                  Navigator.pushNamed(context, PushNotificationsView.routeName);
                },
                text: 'Push Notification',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
