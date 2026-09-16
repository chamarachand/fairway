import 'package:fairway/core/constants/api_constants.dart';
import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/core/services/api_service.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> fetchProducts({PriceSort? sortOrder});
  Future<List<Product>> searchProducts(String query, {PriceSort? sortOrder});
  Future<List<String>> fetchCategories();
  Future<List<Product>> fetchProductsByCategory(
    String category, {
    PriceSort? sortOrder,
  });
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Product>> fetchProducts({PriceSort? sortOrder}) async {
    final url = ApiConstants.products(order: sortOrder?.order);
    print('url: $url');
    final data = await apiService.get(url);

    return (data['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  @override
  Future<List<Product>> searchProducts(
    String query, {
    PriceSort? sortOrder,
  }) async {
    final url = ApiConstants.productSearch(query, order: sortOrder?.order);
    final data = await apiService.get(url);

    return (data['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  @override
  Future<List<Product>> fetchProductsByCategory(
    String category, {
    PriceSort? sortOrder,
  }) async {
    final url = ApiConstants.filterByCategory(
      category,
      order: sortOrder?.order,
    );

    print('url2: $url');

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
}
