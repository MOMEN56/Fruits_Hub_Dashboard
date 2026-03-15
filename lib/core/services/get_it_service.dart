import 'package:fruit_hub_dashboard/core/repos/images_repo/images_repo.dart';
import 'package:fruit_hub_dashboard/core/repos/images_repo/images_repo_impl.dart';
import 'package:fruit_hub_dashboard/core/repos/notifications_repo/notifications_repo.dart';
import 'package:fruit_hub_dashboard/core/repos/notifications_repo/notifications_repo_impl.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo.dart';
import 'package:fruit_hub_dashboard/core/repos/product_repo/products_repo_impl.dart';
import 'package:fruit_hub_dashboard/core/services/dashboard_push_notification_service.dart';
import 'package:fruit_hub_dashboard/core/services/data_service.dart';
import 'package:fruit_hub_dashboard/core/services/notification_event_service.dart';
import 'package:fruit_hub_dashboard/core/services/storage_service.dart';
import 'package:fruit_hub_dashboard/core/services/supabase_service.dart';
import 'package:fruit_hub_dashboard/core/services/supabase_storage_service.dart';
import 'package:fruit_hub_dashboard/features/add_product/domain/usecases/add_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/delete_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/fetch_products_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/set_product_visibility_use_case.dart';
import 'package:fruit_hub_dashboard/features/edit_data/domain/usecases/update_product_use_case.dart';
import 'package:fruit_hub_dashboard/features/notifications/domain/usecases/fetch_notifications_use_case.dart';
import 'package:fruit_hub_dashboard/features/notifications/domain/usecases/send_manual_notification_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/data/repos/orders_repo_imlp.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/repos/orders_repo.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/usecases/fetch_orders_use_case.dart';
import 'package:fruit_hub_dashboard/features/orders/domain/usecases/update_order_use_case.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetit() {
  if (!getIt.isRegistered<StorageService>()) {
    getIt.registerSingleton<StorageService>(SupabaseStorageService());
  }
  if (!getIt.isRegistered<DatabaseService>()) {
    getIt.registerSingleton<DatabaseService>(SupabaseService());
  }
  if (!getIt.isRegistered<NotificationEventService>()) {
    getIt.registerSingleton<NotificationEventService>(
      NotificationEventService(getIt.get<DatabaseService>()),
    );
  }
  if (!getIt.isRegistered<DashboardPushNotificationService>()) {
    getIt.registerSingleton<DashboardPushNotificationService>(
      DashboardPushNotificationService(),
    );
  }

  if (!getIt.isRegistered<ImagesRepo>()) {
    getIt.registerSingleton<ImagesRepo>(
      ImagesRepoImpl(getIt.get<StorageService>()),
    );
  }
  if (!getIt.isRegistered<OrdersRepo>()) {
    getIt.registerSingleton<OrdersRepo>(
      OrdersRepoImpl(
        getIt.get<DatabaseService>(),
        getIt.get<NotificationEventService>(),
      ),
    );
  }
  if (!getIt.isRegistered<NotificationsRepo>()) {
    getIt.registerSingleton<NotificationsRepo>(
      NotificationsRepoImpl(
        getIt.get<DatabaseService>(),
        getIt.get<NotificationEventService>(),
      ),
    );
  }
  if (!getIt.isRegistered<ProductsRepo>()) {
    getIt.registerSingleton<ProductsRepo>(
      ProductsRepoImpl(getIt.get<DatabaseService>()),
    );
  }

  if (!getIt.isRegistered<AddProductUseCase>()) {
    getIt.registerLazySingleton<AddProductUseCase>(
      () => AddProductUseCase(
        getIt.get<ProductsRepo>(),
        getIt.get<ImagesRepo>(),
      ),
    );
  }
  if (!getIt.isRegistered<FetchProductsUseCase>()) {
    getIt.registerLazySingleton<FetchProductsUseCase>(
      () => FetchProductsUseCase(getIt.get<ProductsRepo>()),
    );
  }
  if (!getIt.isRegistered<UpdateProductUseCase>()) {
    getIt.registerLazySingleton<UpdateProductUseCase>(
      () => UpdateProductUseCase(
        getIt.get<ProductsRepo>(),
        getIt.get<ImagesRepo>(),
      ),
    );
  }
  if (!getIt.isRegistered<DeleteProductUseCase>()) {
    getIt.registerLazySingleton<DeleteProductUseCase>(
      () => DeleteProductUseCase(getIt.get<ProductsRepo>()),
    );
  }
  if (!getIt.isRegistered<SetProductVisibilityUseCase>()) {
    getIt.registerLazySingleton<SetProductVisibilityUseCase>(
      () => SetProductVisibilityUseCase(getIt.get<ProductsRepo>()),
    );
  }
  if (!getIt.isRegistered<FetchOrdersUseCase>()) {
    getIt.registerLazySingleton<FetchOrdersUseCase>(
      () => FetchOrdersUseCase(getIt.get<OrdersRepo>()),
    );
  }
  if (!getIt.isRegistered<UpdateOrderUseCase>()) {
    getIt.registerLazySingleton<UpdateOrderUseCase>(
      () => UpdateOrderUseCase(getIt.get<OrdersRepo>()),
    );
  }
  if (!getIt.isRegistered<FetchNotificationsUseCase>()) {
    getIt.registerLazySingleton<FetchNotificationsUseCase>(
      () => FetchNotificationsUseCase(getIt.get<NotificationsRepo>()),
    );
  }
  if (!getIt.isRegistered<SendManualNotificationUseCase>()) {
    getIt.registerLazySingleton<SendManualNotificationUseCase>(
      () => SendManualNotificationUseCase(getIt.get<NotificationsRepo>()),
    );
  }
}
