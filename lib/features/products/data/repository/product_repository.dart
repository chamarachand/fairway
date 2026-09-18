import 'package:fairway/core/constants/app_constants.dart';
import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/core/errors/exceptions.dart';
import 'package:fairway/features/products/data/datasources/product_local_data_source.dart';
import 'package:fairway/features/products/data/datasources/product_remote_data_source.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRepository {
  Future<({List<Product> products, bool isOffline})> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
    int limit = AppConstants.paginationLimit,
    int skip = 0,
  });
  Future<List<String>> fetchCategories();
  Future<Product> getProductById(String id);
  Future<void> deleteProduct(String id);
  Future<List<Product>> fetchSimilarProducts({required String category});
  Set<int> getFavouriteIds();
  Future<void> saveFavouriteIds(Set<int> favouriteIds);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<({List<Product> products, bool isOffline})> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
    int limit = AppConstants.paginationLimit,
    int skip = 0,
  }) async {
    try {
      final products = await remoteDataSource.fetchProducts(
        category: category,
        query: query,
        sortOrder: sortOrder,
        limit: limit,
        skip: skip,
      );

      // cache initial products
      if ((query == null || query.isEmpty) &&
          (category == null || category.isEmpty)) {
        localDataSource.cacheProducts(products);
      }

      return (products: products, isOffline: false);
    } on NetworkException {
      final cachedProducts = localDataSource.getCachedProducts();
      if (cachedProducts != null) {
        if (skip > 0) return (products: <Product>[], isOffline: true);
        return (products: cachedProducts, isOffline: true);
      }
      throw const NetworkException();
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Future<List<Product>> fetchSimilarProducts({required String category}) async {
    try {
      final products = await remoteDataSource.fetchProducts(category: category);
      return products;
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }

  @override
  Future<List<String>> fetchCategories() async {
    return await remoteDataSource.fetchCategories();
  }

  @override
  Future<Product> getProductById(String id) async {
    return await remoteDataSource.getProductById(id);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);
  }

  @override
  Set<int> getFavouriteIds() {
    return localDataSource.getFavouriteIds();
  }

  @override
  Future<void> saveFavouriteIds(Set<int> favouriteIds) async {
    await localDataSource.saveFavouriteIds(favouriteIds);
  }
}
