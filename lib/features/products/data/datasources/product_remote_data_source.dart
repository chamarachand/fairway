import 'package:fairway/core/constants/api_constants.dart';
import 'package:fairway/core/enums/price_sort.dart';
import 'package:fairway/core/services/api_service.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
    int limit = 10,
    int skip = 0,
  });
  Future<List<String>> fetchCategories();
  Future<Product> getProductById(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiService apiService;

  ProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<Product>> fetchProducts({
    String? category,
    String? query,
    PriceSort? sortOrder,
    int limit = 10,
    int skip = 0,
  }) async {
    late String path;

    if (category != null && category.isNotEmpty) {
      path = ApiConstants.filterByCategory(category);
    } else if (query != null && query.isNotEmpty) {
      path = ApiConstants.productSearch;
    } else {
      path = ApiConstants.products;
    }

    final queryParams = {
      if (query != null && query.isNotEmpty) 'q': query,
      'limit': limit.toString(),
      'skip': skip.toString(),
      if (sortOrder != null && sortOrder.order != null) ...{
        'sortBy': 'price',
        'order': sortOrder.order!,
      },
    };

    final data = await apiService.get(path, queryParameters: queryParams);

    return (data['products'] as List)
        .map((product) => Product.fromJson(product))
        .toList();
  }

  @override
  Future<List<String>> fetchCategories() async {
    final data = await apiService.get(ApiConstants.categories);
    return List<String>.from(data);
  }

  @override
  Future<Product> getProductById(String id) async {
    final data = await apiService.get(ApiConstants.productById(id));
    return Product.fromJson(data.data);
  }
}
