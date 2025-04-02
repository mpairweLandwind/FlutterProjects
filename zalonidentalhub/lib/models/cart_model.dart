
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zalonidentalhub/models/cart_item.dart';

class Cart extends StateNotifier<List<CartItem>> {
  Cart() : super([]);

  void addToCart(CartItem item) {
    final existingItemIndex = state.indexWhere((i) => i.name == item.name);
    if (existingItemIndex >= 0) {
      state[existingItemIndex].quantity += item.quantity;
    } else {
      state = [...state, item];
    }
  }

  void removeFromCart(CartItem item) {
    state = state.where((i) => i.name != item.name).toList();
  }

  void incrementQuantity(CartItem item) {
    state = state.map((i) {
      if (i.name == item.name) {
        return i.copyWith(quantity: i.quantity + 1);
      }
      return i;
    }).toList();
  }

  void decrementQuantity(CartItem item) {
    state = state.map((i) {
      if (i.name == item.name && i.quantity > 1) {
        return i.copyWith(quantity: i.quantity - 1);
      }
      return i;
    }).toList();
  }

  void clearCart() {
    state = [];
  }

  double get cartTotal {
    return state.fold(0, (total, item) => total + (item.discountPrice * item.quantity));
  }

  int get itemCount {
    return state.fold(0, (total, item) => total + item.quantity);
  }
}

final cartProvider = StateNotifierProvider<Cart, List<CartItem>>((ref) {
  return Cart();
});