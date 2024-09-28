

import 'package:flutter/material.dart';

import 'package:zalonidentalapp/models/cart_item.dart';



class Cart with ChangeNotifier {
   final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

  void incrementItemQuantity(CartItem item) {
    item.quantity += 1;
    notifyListeners();
  }

  void decrementItemQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity -= 1;
      notifyListeners();
    }
  }

  void removeItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  int get itemCount => _items.length;

}



// class Cart {
//   final Map<String, int> _items = {};
//   final _logger = Logger('CartLogger');

//   void addItem(Product product) {
//     if (_items.containsKey(product.name)) {
//       _items[product.name] = _items[product.name]! + 1;
//     } else {
//       _items[product.name] = 1;
//     }
//   }

//   List<Map<String, dynamic>> get items => _items.entries.map((entry) {
//     // Assuming you have a way to find a product by its ID
//     final product = findProductById(entry.key);
//     return {
//       'product': product,
//       'quantity': entry.value,
//     };
//   }).toList();

//   double get total => items.fold(0, (total, item) => total + (item['product'].price * item['quantity']));

//   Future<Product> findProductById(String name) async {
//   Product? product = await _findProductInYourDataSource(name);
  
//   if (product != null) {
//     return product;
//   } else {
//     throw Exception('Product not found for name: $name');
//   }
// }

// Future<Product?> _findProductInYourDataSource(String name) async {
//   try {
//     var querySnapshot = await FirebaseFirestore.instance
//       .collection('products')
//       .where('name', isEqualTo: name)
//       .limit(1)
//       .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       var doc = querySnapshot.docs.first;
//       return Product.fromMap(doc.data());
//     }
//   } catch (error) {
//     _logger.warning('Error getting product: $error');
//   }
//   return null;
// }



// }