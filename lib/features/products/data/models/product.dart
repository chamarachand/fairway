class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String thumbnail;
  final List<String> images;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnail: json['thumbnail'] as String,
      images: json['images'] != null
          ? List<String>.from(json['images'].map((x) => x.toString()))
          : [],
    );
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, category: $category, price: $price, thumbnail: $thumbnail, images: $images}';
  }
}
