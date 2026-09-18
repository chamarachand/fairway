import 'dart:convert';

import 'package:fairway/features/products/data/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  final SharedPreferences _prefs;
  LocalStorageService(this._prefs);

  static const String _cachedProductsKey = 'cached_products';
  static const String _themeModeKey = 'is_dark_mode';
  static const String _favouritesKey = 'favourite_product_ids';

  bool getIsDarkMode() {
    return _prefs.getBool(_themeModeKey) ?? false;
  }

  Future<void> saveIsDarkMode(bool isDrakMode) async {
    await _prefs.setBool(_themeModeKey, isDrakMode);
  }

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

  Set<int> getFavouriteIds() {
    final favList = _prefs.getStringList(_favouritesKey);
    if (favList == null || favList.isEmpty) return {};

    return favList.map((id) => int.tryParse(id)).whereType<int>().toSet();
  }

  Future<void> saveFavouriteIds(Set<int> favouriteIds) async {
    final stringList = favouriteIds.map((id) => id.toString()).toList();
    await _prefs.setStringList(_favouritesKey, stringList);
  }
}
