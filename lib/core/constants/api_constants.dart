abstract class ApiConstants {
  static const String baseUrl = 'dummyjson.com';

  static const String products = '/products';
  static const String categories = '/products/category-list';
  static String productSearch = '/products/search';
  static String filterByCategory(String category) =>
      '/products/category/$category';
  static String productById(String id) => '/products/$id';
}
