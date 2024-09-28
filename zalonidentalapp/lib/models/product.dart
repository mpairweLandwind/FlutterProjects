

class Product {
  final String category;
  final String subcategory;
  final String name;
  final int quantity;
  final double salePrice;
  final double discountPrice;
  final double percentageReduction;
  final String description;
  final String imageUrl;
  

  Product({
    required this.category,
    required this.subcategory,
    required this.name,
    required this.quantity,
    required this.salePrice,
    required this.discountPrice,
    required this.percentageReduction,
    required this.description,
    required this.imageUrl,
    
  });

   factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      category: map['category'] as String,
       subcategory: map['subcategory'] as String,
      name: map['name'] as String,
       quantity: map['quantity'] as int,
      salePrice: map['salePrice'] as double,
       discountPrice: map['discountPrice'] as double,
        percentageReduction: map['percentageReduction'] as double,
        description: map['description'] as String,
         imageUrl: map['salePrice'] as String,

     
    );
  }
}
