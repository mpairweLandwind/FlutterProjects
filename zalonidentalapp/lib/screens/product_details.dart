import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:zalonidentalapp/models/cart_icon_with_badge.dart';
import 'package:zalonidentalapp/models/cart_item.dart';
import 'package:zalonidentalapp/models/cart_model.dart';
import 'package:zalonidentalapp/models/product.dart';
import 'package:zalonidentalapp/screens/cart_screen.dart';

class ProductDetails extends StatelessWidget {
  final List<Product> products;

  const ProductDetails({
    required Key key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(products.first.subcategory),
        actions: _buildAppBarActions(),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: calculateCrossAxisCount(context),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: calculateChildAspectRatio(context),
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return _buildProductCard(context, products[index]);
        },
      ),
    );
  }

  int calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      return 2; // For smaller screens
    } else if (screenWidth <= 1200) {
      return 3; // For medium screens
    } else {
      return 4; // For larger screens
    }
  }

  double calculateChildAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // You may need to adjust these values to fit your content
    if (screenWidth <= 600) {
      return 0.75;
    } else if (screenWidth <= 1200) {
      return 0.85;
    } else {
      return 1.0;
    }
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          // Implement search functionality
        },
      ),
      const CartIconWithBadge(),
      
    ];
  }

  Widget _buildProductCard(
    BuildContext context,
    Product product,
  ) {
    return Card(
      elevation: 2,
      child: SingleChildScrollView(
        // Prevent vertical overflow
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                if (product.percentageReduction > 0)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-${product.percentageReduction.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  if (product.salePrice != product.discountPrice)
                    Flexible(
                      // Prevent horizontal overflow
                      child: Text(
                        'UGX ${product.salePrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  Flexible(
                    // Prevent horizontal overflow
                    child: Text(
                      'UGX ${product.discountPrice.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child:
                  _buildRatingBar(4.5), // Assuming you pass the actual rating
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                product.description,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child:  ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: const Text('Add to Cart'),
            onPressed: () {
              Provider.of<Cart>(context, listen: false).addItem( // Use Provider to add item to the cart
                CartItem(
                  name: product.name,
                  salePrice: product.salePrice,
                  discountPrice: product.discountPrice,
                  percentageReduction: product.percentageReduction,
                  imageUrl: product.imageUrl, 
                  quantity: product.quantity, 
                ),
              );
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen(cartItems: const [], cartTotal: 0, cart: Cart(),)),
              );
            },
          ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar(double rating) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => const Icon(
        Icons.star,
        color: Colors.amber,
      ),
      itemCount: 5,
      itemSize: 20.0,
      direction: Axis.horizontal,
    );
  }
}
