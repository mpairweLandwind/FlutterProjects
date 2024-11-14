import 'dart:developer'; // Add this import for logging
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  String? _selectedCategory;
  List<Product> _products = [];
  List<String> _promotionalImages = [];

  String? get selectedCategory => _selectedCategory;
  List<Product> get products => _products;
  List<String> get promotionalImages => _promotionalImages;

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    fetchProducts(category);
    notifyListeners();
  }

  Future<void> fetchProducts(String? category) async {
    if (category == null) return;

    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      _products = querySnapshot.docs.map((doc) {
        var data = doc.data();

        return Product(
          category: data['category'],
          subcategory: data['subcategory'],
          name: data['name'],
          quantity: data['quantity'],
          imageUrl: data['imageUrl'],
          salePrice: (data['salePrice'] as num?)?.toDouble() ?? 0.0,
          discountPrice: (data['discountPrice'] as num?)?.toDouble() ?? 0.0,
          description: data['description'],
        );
      }).toList();

      notifyListeners();
    } catch (error, stackTrace) {
      log(
        'Error fetching products for category: $category',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> fetchPromotionalImages() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('promotions')
          .get();

      _promotionalImages = querySnapshot.docs.map((doc) {
        return doc['imageUrl'] as String;
      }).toList();

      notifyListeners();
    } catch (error, stackTrace) {
      log(
        'Error fetching promotional images',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
