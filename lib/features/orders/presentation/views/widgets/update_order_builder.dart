import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/widgets/custom_progress_hud.dart';
import 'package:fruit_hub_dashboard/features/orders/presentation/manager/update_order/update_order_cubit.dart';

class UpdateOrderBuilder extends StatelessWidget {
  const UpdateOrderBuilder({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateOrderCubit, UpdateOrderState>(
      listener: (context, state) {},
      builder: (context, state) {
        return CustomProgressHud(
            isLoading: state is UpdateOrderLoading, child: child);
      },
    );
  }
}
