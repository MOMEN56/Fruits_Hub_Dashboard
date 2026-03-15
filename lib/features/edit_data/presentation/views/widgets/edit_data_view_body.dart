import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fruit_hub_dashboard/core/utils/responsive_layout.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manager/fetch_products/fetch_products_cubit.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manager/fetch_products/fetch_products_state.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manager/manage_product/manage_product_cubit.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/manager/manage_product/manage_product_state.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/views/widgets/edit_product_sheet.dart';
import 'package:fruit_hub_dashboard/features/edit_data/presentation/views/widgets/editable_product_card.dart';

class EditDataViewBody extends StatefulWidget {
  const EditDataViewBody({super.key});

  @override
  State<EditDataViewBody> createState() => _EditDataViewBodyState();
}

class _EditDataViewBodyState extends State<EditDataViewBody> {
  Future<void> _openEditSheet(EditableProductEntity product) async {
    final result = await showModalBottomSheet<EditProductResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => EditProductSheet(product: product),
    );

    if (result == null || !mounted) {
      return;
    }

    context.read<ManageProductCubit>().updateProduct(
          product: result.product,
          newImage: result.newImage,
        );
  }

  Future<void> _confirmDelete(String productId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) {
      return;
    }

    context.read<ManageProductCubit>().deleteProduct(productId: productId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<ManageProductCubit, ManageProductState>(
        listener: (context, state) {
          if (state is ManageProductSuccess) {
            context.read<FetchProductsCubit>().fetchProducts();
            return;
          }

          if (state is ManageProductFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<FetchProductsCubit, FetchProductsState>(
          builder: (context, state) {
            if (state is FetchProductsLoading ||
                state is FetchProductsInitial) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is FetchProductsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.errMessage),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<FetchProductsCubit>().fetchProducts(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            final products = (state as FetchProductsSuccess).products;
            if (products.isEmpty) {
              return const Center(child: Text('No products found'));
            }

            return BlocBuilder<ManageProductCubit, ManageProductState>(
              builder: (context, manageState) {
                final loadingProductId = manageState is ManageProductLoading
                    ? manageState.productId
                    : null;

                return ResponsiveContent(
                  maxWidth: 1000,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: products.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final product = products[index];
                      final isBusy = loadingProductId == product.id;

                      return EditableProductCard(
                        product: product,
                        isBusy: isBusy,
                        onEdit: () => _openEditSheet(product),
                        onDelete: () => _confirmDelete(product.id),
                        onVisibilityChanged: (isVisible) {
                          context.read<ManageProductCubit>().toggleVisibility(
                                productId: product.id,
                                isVisible: isVisible,
                              );
                        },
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
