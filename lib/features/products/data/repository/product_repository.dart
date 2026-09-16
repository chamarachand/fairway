import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/features/products/data/datasources/product_remote_data_source.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts({PriceSort? sortOrder, String? query});
  Future<List<Product>> searchProducts(String query, {PriceSort? sortOrder});
  Future<List<String>> fetchCategories();
  Future<List<Product>> fetchProductsByCategory(
    String category, {
    PriceSort? sortOrder,
  });
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> fetchProducts({PriceSort? sortOrder, String? query}) {
    return remoteDataSource.fetchProducts(sortOrder: sortOrder, query: query);
  }

  @override
  Future<List<Product>> searchProducts(String query, {PriceSort? sortOrder}) {
    return remoteDataSource.searchProducts(query, sortOrder: sortOrder);
  }

  @override
  Future<List<String>> fetchCategories() async {
    return await remoteDataSource.fetchCategories();
  }

  @override
  Future<List<Product>> fetchProductsByCategory(
    String category, {
    PriceSort? sortOrder,
  }) {
    print('fetchProductsByCategory calling');
    return remoteDataSource.fetchProductsByCategory(
      category,
      sortOrder: sortOrder,
    );
  }
}
