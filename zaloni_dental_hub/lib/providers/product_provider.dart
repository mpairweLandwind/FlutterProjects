import 'dart:developer'; // Add this import for logging
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  String? _selectedCategory;
  List<Product> _products = [];
  List<String> _promotion = [];
  List<String> _allProduct = []; // List to store all product image URLs
  List<Product> _latestProducts = [];
  List<Product> _recommendedProducts = [];
  List<Product> _mostPopularProducts = [];

  Map<String, String> _category = {}; // Map to store category and first image URL

  bool _isLoading = false; // Add this loading state
  bool get isLoading => _isLoading; // Getter for isLoading


  String? get selectedCategory => _selectedCategory;
  List<Product> get products => _products;
  List<String> get promotion => _promotion;
  Map<String, String> get category => _category;
  List<String> get allProduct => _allProduct;
  List<Product> get latestProducts => _latestProducts;
  List<Product> get recommendedProducts => _recommendedProducts;
  List<Product> get mostPopularProducts => _mostPopularProducts;

  void setSelectedCategory(String? category) {
    _selectedCategory = category;
    fetchProducts(category);
    notifyListeners();
  }

   // Set loading state before and after fetching
  Future<void> fetchProducts(String? category) async {
    if (category == null) return;

    _isLoading = true; // Start loading
    notifyListeners();

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

      // Collect all image URLs
      _allProduct = _products.map((product) => product.imageUrl).toList();
    } catch (error, stackTrace) {
      log(
        'Error fetching products for category: $category',
        error: error,
        stackTrace: stackTrace,
      );
    } finally {
      _isLoading = false; // End loading
      notifyListeners();
    }
  }

 

  Future<void> fetchCategory() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      _category = {};
      for (var doc in querySnapshot.docs) {
        var data = doc.data();
        String category = data['category'];
        String imageUrl = data['imageUrl'];

        // Store only the first image per category
        if (!_category.containsKey(category)) {
          _category[category] = imageUrl;
        }
      }

      notifyListeners();
    } catch (error, stackTrace) {
      log(
        'Error fetching category images',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> fetchPromotion() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('salePrice', isGreaterThan: 100000) // Filter by salePrice > 100000
          .get();

      _promotion = querySnapshot.docs.map((doc) {
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

  Future<void> fetchSpecialCategories() async {
    try {
      // Fetch Latest Products by salePrice descending order
      var latestQuerySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .orderBy('salePrice', descending: true) // Sort by salePrice descending
          .limit(10)
          .get();
      _latestProducts = latestQuerySnapshot.docs.map((doc) {
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

      // Fetch Most Popular Products by salePrice < 20000
      var popularQuerySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('salePrice', isLessThan: 20000) // Filter by salePrice < 20000
          .limit(10)
          .get();
      _mostPopularProducts = popularQuerySnapshot.docs.map((doc) {
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

      // Fetch Recommended Products
      var recommendedQuerySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('salePrice', isGreaterThan: 200000) // Filter by salePrice > 200000
          .get();
      _recommendedProducts = recommendedQuerySnapshot.docs.map((doc) {
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
        'Error fetching special categories',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}