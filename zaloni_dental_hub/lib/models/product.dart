class Product {
  final String category;
  final String subcategory;
  final String name;
  final int quantity;
  final double salePrice;
  final double discountPrice;
  final String description;
  final List<String> imageUrls; // Multiple image URLs

  // Backward compatibility: primary image is the first URL
  String get imageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  Product({
    required this.category,
    required this.subcategory,
    required this.name,
    required this.quantity,
    required this.salePrice,
    required this.discountPrice,
    required this.description,
    List<String>? imageUrls,
  }) : imageUrls = imageUrls ?? [];

  // Derived attribute for percentage reduction
  double get percentageReduction {
    if (salePrice > 0 && discountPrice > 0) {
      return ((salePrice - discountPrice) / salePrice) * 100;
    } else {
      return 0.0;
    }
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    // Handle both single imageUrl and multiple imageUrls for backward compatibility
    List<String> imageUrls = [];

    if (map['imageUrls'] != null && map['imageUrls'] is List) {
      imageUrls = (map['imageUrls'] as List<dynamic>)
          .map((url) => url.toString())
          .toList();
    } else if (map['imageUrl'] != null && map['imageUrl'] is String) {
      imageUrls = [map['imageUrl'] as String];
    }

    return Product(
      category: map['category'] as String,
      subcategory: map['subcategory'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      salePrice: map['salePrice'] as double,
      discountPrice: map['discountPrice'] as double,
      description: map['description'] as String,
      imageUrls: imageUrls,
    );
  }
}
