class Product {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final String thumbnail;
  final List<String> images;
  final String brand;
  final int weight;
  final int stock;
  final String availabilityStatus;
  final String warrantyInformation;
  final String shippingInformation;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.thumbnail,
    required this.images,
    required this.brand,
    required this.weight,
    required this.stock,
    required this.availabilityStatus,
    required this.warrantyInformation,
    required this.shippingInformation,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      thumbnail: (json['thumbnail'] ?? '') as String,
      images: json['images'] != null
          ? List<String>.from(json['images'].map((x) => x.toString()))
          : [],
      brand: (json['brand'] ?? '') as String,
      weight: (json['weight'] as num?)?.toInt() ?? 0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      availabilityStatus: (json['availabilityStatus'] ?? '') as String,
      warrantyInformation: (json['warrantyInformation'] ?? '') as String,
      shippingInformation: (json['shippingInformation'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'thumbnail': thumbnail,
      'images': images,
      'brand': brand.isEmpty ? '' : brand,
      'weight': weight,
      'stock': stock,
      'availabilityStatus': availabilityStatus,
      'warrantyInformation': warrantyInformation,
      'shippingInformation': shippingInformation,
    };
  }

  @override
  String toString() {
    return 'Product{id: $id, title: $title, description: $description, category: $category, price: $price, thumbnail: $thumbnail, images: $images, brand: $brand, weight: $weight, stock: $stock, availabilityStatus: $availabilityStatus, warrantyInformation: $warrantyInformation, shippingInformation: $shippingInformation}';
  }
}
