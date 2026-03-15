import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/services/get_it_service.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/delete_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/fetch_products_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/set_product_visibility_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/update_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manager/fetch_products/fetch_products_cubit.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manager/manage_product/manage_product_cubit.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/views/widgets/edit_data_view_body.dart';

class EditDataView extends StatelessWidget {
  const EditDataView({super.key});

  static const routeName = 'edit-data';

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => FetchProductsCubit(getIt.get<FetchProductsUseCase>())
            ..fetchProducts(),
        ),
        BlocProvider(
          create: (_) => ManageProductCubit(
            getIt.get<UpdateProductUseCase>(),
            getIt.get<DeleteProductUseCase>(),
            getIt.get<SetProductVisibilityUseCase>(),
          ),
        ),
      ],
      child: const Scaffold(
        body: EditDataViewBody(),
      ),
    );
  }
}
