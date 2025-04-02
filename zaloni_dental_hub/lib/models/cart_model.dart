import 'package:flutter/material.dart';
import 'package:zaloni_dental_hub/models/cart_item.dart';

class Cart with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get cartItems => _items;

  double get cartTotal {
    return _items.fold(0, (total, item) => total + (item.discountPrice * item.quantity));
  }

  void addToCart(CartItem item) {
    final existingItemIndex = _items.indexWhere((i) => i.name == item.name);
    if (existingItemIndex >= 0) {
      _items[existingItemIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void incrementQuantity(CartItem item) {
    item.quantity += 1;
    notifyListeners();
  }

  void decrementQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity -= 1;
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get itemCount {
    return _items.fold(0, (total, item) => total + item.quantity);
  }
}