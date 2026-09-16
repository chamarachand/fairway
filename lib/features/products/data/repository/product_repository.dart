import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/features/products/data/datasources/product_remote_data_source.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
  });
  Future<List<String>> fetchCategories();
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
  }) {
    return remoteDataSource.fetchProducts(
      category: category,
      query: query,
      sortOrder: sortOrder,
    );
  }

  @override
  Future<List<String>> fetchCategories() {
    return remoteDataSource.fetchCategories();
  }
}
