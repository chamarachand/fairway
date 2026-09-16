import 'package:fairway/features/products/data/datasources/product_remote_data_source.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts();
  Future<List<Product>> searchProducts(String query);
  Future<List<String>> fetchCategories();
  Future<List<Product>> fetchProductsByCategory(String category);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> fetchProducts() {
    return remoteDataSource.fetchProducts();
  }

  @override
  Future<List<Product>> searchProducts(String query) {
    return remoteDataSource.searchProducts(query);
  }

  @override
  Future<List<String>> fetchCategories() async {
    return await remoteDataSource.fetchCategories();
  }

  @override
  Future<List<Product>> fetchProductsByCategory(String category) {
    return remoteDataSource.fetchProductsByCategory(category);
  }
}
