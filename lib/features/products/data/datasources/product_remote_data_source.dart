import 'package:fairway/core/constants/api_constants.dart';
import 'package:fairway/core/services/api_service.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> fetchProducts();
  Future<List<Product>> searchProducts(String query);
  Future<List<String>> fetchCategories();
  Future<List<Product>> fetchProductsByCategory(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Product>> fetchProducts() async {
    final url = ApiConstants.products;
    final data = await apiService.get(url);

    return (data['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    final url = ApiConstants.productSearch(query);
    final data = await apiService.get(url);

    return (data['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  @override
  Future<List<String>> fetchCategories() async {
    final url = ApiConstants.categories;
    final data = await apiService.get(url);
    return List<String>.from(data);
  }

  @override
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final url = ApiConstants.filterByCategory(category);
    final data = await apiService.get(url);

    return (data['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }
}
