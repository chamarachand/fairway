import 'package:fairway/core/constants/api_constants.dart';
import 'package:fairway/core/services/api_service.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> fetchProducts();
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
}
