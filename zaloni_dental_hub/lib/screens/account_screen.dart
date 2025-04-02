import 'package:flutter/material.dart';
import 'package:zaloni_dental_hub/models/cart_item.dart'; 

class AccountScreen extends StatelessWidget {

   static const routeName = '/cart';
  final List<CartItem> cartItems;
  final double cartTotal;


  const AccountScreen({super.key,
    required this.cartItems,
    required this.cartTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: const Text('Shopping Cart'),
    actions: [
      IconButton(
        icon: const Icon(Icons.delete_forever),
        onPressed: () {
          // Code to clear the cart
        },
      ),
    ],
  ),
  body: ListView.builder(
    itemCount: cartItems.length,
    itemBuilder: (BuildContext context, int index) {
      return CartItemWidget(cartItem: cartItems[index]);
    },
  ),
  bottomNavigationBar: BottomAppBar(
    child: Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Total:'),
              Text('\$${cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton(
            child: const Text('CHECKOUT'),
            onPressed: () {
              // Code to initiate checkout
            },
          ),
        ],
      ),
    ),
  ),
);
  }
}


class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidget({super.key, required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cartItem.name),
      subtitle: Text('\$${cartItem.discountPrice.toStringAsFixed(2)}'),
      // Add other UI elements or functionality as needed
    );
  }
} 