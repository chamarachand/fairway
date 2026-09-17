import 'dart:convert';

import 'package:fairway/features/products/data/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;
  LocalStorageService(this._prefs);

  static const String _cachedProductsKey = 'cached_products';

  List<Product>? getProducts() {
    final jsonString = _prefs.getString(_cachedProductsKey);
    if (jsonString == null) return null;
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Product.fromJson(json)).toList();
  }

  Future<void> saveCacheProducts(List<Product> products) async {
    final jsonList = products.map((product) => product.toJson()).toList();
    await _prefs.setString(_cachedProductsKey, jsonEncode(jsonList));
  }
}
