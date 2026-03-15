import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';

sealed class FetchProductsState {
  const FetchProductsState();
}

final class FetchProductsInitial extends FetchProductsState {
  const FetchProductsInitial();
}

final class FetchProductsLoading extends FetchProductsState {
  const FetchProductsLoading();
}

final class FetchProductsSuccess extends FetchProductsState {
  const FetchProductsSuccess({required this.products});

  final List<EditableProductEntity> products;
}

final class FetchProductsFailure extends FetchProductsState {
  const FetchProductsFailure(this.errMessage);

  final String errMessage;
}
