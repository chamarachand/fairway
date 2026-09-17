import 'package:fairway/core/services/local_storage_service.dart';
import 'package:fairway/features/products/data/models/product.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<Product> products);
  List<Product>? getCachedProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  LocalStorageService localStorageService;

  ProductLocalDataSourceImpl({required this.localStorageService});

  @override
  Future<void> cacheProducts(List<Product> products) async {
    await localStorageService.saveCacheProducts(products);
  }

  @override
  List<Product>? getCachedProducts() {
    return localStorageService.getProducts();
  }
}
