import 'package:fairway/core/constants/api_constants.dart';
import 'package:fairway/core/services/api_service.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class CreateProductRemoteDataSource {
  Future<Product> createProduct({
    required String title,
    required double price,
    required String category,
    required String description,
    required String condition,
  });
}

class CreateProductRemoteDataSourceImpl
    implements CreateProductRemoteDataSource {
  final ApiService apiService;

  CreateProductRemoteDataSourceImpl({required this.apiService});

  @override
  Future<Product> createProduct({
    required String title,
    required double price,
    required String category,
    required String description,
    required String condition,
  }) async {
    final body = {
      'title': title,
      'price': price,
      'category': category,
      'description': description,
      'condition': condition,
    };

    final data = await apiService.post(
      '${ApiConstants.products}/add',
      data: body,
    );

    return Product.fromJson(data);
  }
}
