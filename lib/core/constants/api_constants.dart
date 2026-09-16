abstract class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';

  static const String products = '$baseUrl/products';
  static const String categories = '$baseUrl/products/category-list';

  static String productSearch(String query) =>
      '$baseUrl/products/search?q=$query';

  static String filterByCategory(String category) =>
      '$baseUrl/products/category/$category';
}
