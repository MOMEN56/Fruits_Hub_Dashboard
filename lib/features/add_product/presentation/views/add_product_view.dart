import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/features/add_product/domain/usecases/add_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/add_product/presentation/manager/cubit/add_product_cubit.dart';

import '../../../../core/services/get_it_service.dart';
import '../../../../core/widgets/build_app_bar.dart';
import 'widgets/add_product_view_body_bloc_builder.dart';

class AddProductView extends StatelessWidget {
  const AddProductView({super.key});

  static const routeName = 'add-product';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        'Add Product',
      ),
      body: BlocProvider(
        create: (context) => AddProductCubit(getIt.get<AddProductUseCase>()),
        child: const AddProductsViewBodyBlocBuilder(),
      ),
    );
  }
}
