

import 'package:flutter/material.dart';

import 'package:zaloni_dental_hub/models/cart_item.dart';



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



