import 'package:fairway/core/services/api_service.dart';
import 'package:fairway/core/services/local_storage_service.dart';
import 'package:fairway/features/create_product/data/datasources/create_product_remote_data_source.dart';
import 'package:fairway/features/create_product/data/repository/create_product_repository.dart';
import 'package:fairway/features/create_product/presentation/cubit/create_product_cubit.dart';
import 'package:fairway/features/products/data/datasources/product_local_data_source.dart';
import 'package:fairway/features/products/data/datasources/product_remote_data_source.dart';
import 'package:fairway/features/products/data/repository/product_repository.dart';
import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:fairway/features/theme/theme_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  // Shared pref
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());
  getIt.registerLazySingleton<LocalStorageService>(
    () => LocalStorageService(getIt<SharedPreferences>()),
  );

  // Datasources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  getIt.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(
      localStorageService: getIt<LocalStorageService>(),
    ),
  );

  getIt.registerLazySingleton<CreateProductRemoteDataSource>(
    () => CreateProductRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: getIt<ProductRemoteDataSource>(),
      localDataSource: getIt<ProductLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<CreateProductRepository>(
    () => CreateProductRepositoryImpl(
      remoteDataSource: getIt<CreateProductRemoteDataSource>(),
    ),
  );

  // Cubits
  getIt.registerFactory<ProductCubit>(
    () => ProductCubit(repository: getIt<ProductRepository>()),
  );

  getIt.registerFactory<CategoryCubit>(
    () => CategoryCubit(repository: getIt<ProductRepository>()),
  );

  getIt.registerFactory<ProductDetailsCubit>(
    () => ProductDetailsCubit(repository: getIt<ProductRepository>()),
  );

  getIt.registerFactory<CreateProductCubit>(
    () => CreateProductCubit(repository: getIt<CreateProductRepository>()),
  );

  getIt.registerFactory<ThemeCubit>(
    () => ThemeCubit(localStorageService: getIt<LocalStorageService>()),
  );
}
