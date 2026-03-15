import 'package:meta/meta.dart';

enum ProductAction { update, delete, visibility }

@immutable
sealed class ManageProductState {
  const ManageProductState();
}

final class ManageProductInitial extends ManageProductState {}

final class ManageProductLoading extends ManageProductState {
  const ManageProductLoading({required this.productId, required this.action});

  final String productId;
  final ProductAction action;
}

final class ManageProductSuccess extends ManageProductState {
  const ManageProductSuccess({
    required this.action,
    required this.successMessage,
  });

  final ProductAction action;
  final String successMessage;
}

final class ManageProductFailure extends ManageProductState {
  const ManageProductFailure(this.errMessage);

  final String errMessage;
}
