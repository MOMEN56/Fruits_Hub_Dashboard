import 'package:fruits_hub_dashboard/core/repos/images_repo.dart';
import 'package:fruits_hub_dashboard/core/repos/images_repo_impl.dart';
import 'package:fruits_hub_dashboard/core/repos/products_repo.dart';
import 'package:fruits_hub_dashboard/core/repos/products_repo_impl.dart';
import 'package:fruits_hub_dashboard/core/service/data_service.dart';
import 'package:fruits_hub_dashboard/core/service/storage_service.dart';
import 'package:fruits_hub_dashboard/core/service/suba_stoarge.dart';
import 'package:fruits_hub_dashboard/core/service/subastore_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupGetit() {
  getIt.registerSingleton<StorageService>(SubaStorage());
  getIt.registerSingleton<DatabaseService>(SubastoreService());

  getIt.registerSingleton<ImagesRepo>(
    ImagesRepoImpl(getIt.get<StorageService>()),
  );
  getIt.registerSingleton<ProductsRepo>(
    ProductsRepoImpl(getIt.get<DatabaseService>()),
  );
}
