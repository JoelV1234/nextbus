import 'package:get_it/get_it.dart';
import 'package:nextbus/services/permission_service.dart';
import 'package:nextbus/services/storage_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<PermissionService>(() => PermissionService());
  locator.registerLazySingleton<StorageService>(() => StorageService());
}
