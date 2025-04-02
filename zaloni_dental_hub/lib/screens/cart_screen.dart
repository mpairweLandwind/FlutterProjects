import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zaloni_dental_hub/models/cart_item.dart';
import 'package:zaloni_dental_hub/models/cart_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key, required List cartItems, required int cartTotal, required Cart cart}); // Removed unused parameters for simplicity

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) {
        final subtotal = calculateSubtotal(cart.cartItems);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Cart Summary',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Subtotal: UGX ${subtotal.toStringAsFixed(2)}'),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.cartItems.length,
                  itemBuilder: (context, index) {
                    final CartItem item = cart.cartItems[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                      child: Card(
                        elevation: 2,
                        child: ListTile(
                          leading: Image.network(
                            item.imageUrl,
                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'UGX ${item.salePrice.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  'UGX ${item.discountPrice.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  '-${item.percentageReduction.toStringAsFixed(0)}%',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => cart.removeFromCart(item),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () => cart.decrementQuantity(item),
                              ),
                              Text(item.quantity.toString()),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () => cart.incrementQuantity(item),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: UGX ${subtotal.toStringAsFixed(2)}'),
                    ElevatedButton(
                      onPressed: () {
                        // Implement checkout functionality
                      },
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }



  double calculateSubtotal(List<CartItem> items) {
    return items.fold(0, (total, item) => total + item.discountPrice * item.quantity);
  }
}