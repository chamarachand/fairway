import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/features/products/data/datasources/product_remote_data_source.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
    int limit = 10,
    int skip = 0,
  });
  Future<List<String>> fetchCategories();
  Future<Product> getProductById(String id);
  Future<void> deleteProduct(String id);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
    int limit = 10,
    int skip = 0,
  }) {
    return remoteDataSource.fetchProducts(
      category: category,
      query: query,
      sortOrder: sortOrder,
      limit: limit,
      skip: skip,
    );
  }

  @override
  Future<List<String>> fetchCategories() {
    return remoteDataSource.fetchCategories();
  }

  @override
  Future<Product> getProductById(String id) async {
    return await remoteDataSource.getProductById(id);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);
  }
}
