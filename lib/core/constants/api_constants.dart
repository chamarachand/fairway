abstract class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';

  static const String products = '$baseUrl/products';

  static String productSearch(String query) =>
      '$baseUrl/products/search?q=$query';
}
