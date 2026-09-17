import 'package:fairway/core/errors/exceptions.dart';
import 'package:fairway/features/create_product/data/datasources/create_product_remote_data_source.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class CreateProductRepository {
  Future<Product> createProduct({
    required String title,
    required double price,
    required String category,
    required String description,
    required String condition,
  });
}

class CreateProductRepositoryImpl implements CreateProductRepository {
  final CreateProductRemoteDataSource remoteDataSource;

  CreateProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Product> createProduct({
    required String title,
    required double price,
    required String category,
    required String description,
    required String condition,
  }) async {
    try {
      return await remoteDataSource.createProduct(
        title: title,
        price: price,
        category: category,
        description: description,
        condition: condition,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw const UnknownException();
    }
  }
}
