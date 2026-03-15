import 'package:meta/meta.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/entities/editable_product_entity.dart';

@immutable
sealed class FetchProductsState {}

final class FetchProductsInitial extends FetchProductsState {}

final class FetchProductsLoading extends FetchProductsState {}

final class FetchProductsSuccess extends FetchProductsState {
  FetchProductsSuccess({required this.products});

  final List<EditableProductEntity> products;
}

final class FetchProductsFailure extends FetchProductsState {
  FetchProductsFailure(this.errMessage);

  final String errMessage;
}
