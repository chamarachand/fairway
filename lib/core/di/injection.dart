import 'package:fairway/core/services/api_service.dart';
import 'package:fairway/features/products/data/datasources/product_remote_data_source.dart';
import 'package:fairway/features/products/data/repository/product_repository.dart';
import 'package:fairway/features/products/presentation/cubit/category_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_cubit.dart';
import 'package:fairway/features/products/presentation/cubit/product_details_cubit.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setUpDependencies() {
  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // Datasources
  getIt.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(apiService: getIt<ApiService>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: getIt<ProductRemoteDataSource>(),
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
}
