import 'package:fairway/core/constants/api_constants.dart';
import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/core/services/api_service.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
  });
  Future<List<String>> fetchCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Product>> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
  }) async {
    final String url;

    if (category != null && category.isNotEmpty) {
      url = ApiConstants.filterByCategory(category, order: sortOrder?.order);
    } else if (query != null && query.isNotEmpty) {
      url = ApiConstants.productSearch(query, order: sortOrder?.order);
    } else {
      url = ApiConstants.products(order: sortOrder?.order);
    }

    final data = await apiService.get(url);

    return (data['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  @override
  Future<List<String>> fetchCategories() async {
    final data = await apiService.get(ApiConstants.categories);
    return List<String>.from(data);
  }
}
