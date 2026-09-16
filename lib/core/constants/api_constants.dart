abstract class ApiConstants {
  static const String baseUrl = 'https://dummyjson.com';
  static const String categories = '$baseUrl/products/category-list';

  static String productSearch(String query, {String? order}) {
    if (order != null && order.isNotEmpty) {
      return '$baseUrl/products/search?q=$query&sortBy=price&order=$order';
    }
    return '$baseUrl/products/search?q=$query';
  }

  static String products({String? order}) {
    if (order != null && order.isNotEmpty) {
      return '$baseUrl/products/?sortBy=price&order=$order';
    }
    return '$baseUrl/products';
  }

  static String filterByCategory(String category, {String? order}) {
    if (order != null && order.isNotEmpty) {
      return '$baseUrl/products/category/$category?sortBy=price&order=$order';
    }
    return '$baseUrl/products/category/$category';
  }
}
