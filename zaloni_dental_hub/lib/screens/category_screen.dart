import 'package:flutter/material.dart';
import 'package:zaloni_dental_hub/models/cart_icon_with_badge.dart';
import 'package:zaloni_dental_hub/screens/product_details.dart';
import 'package:zaloni_dental_hub/providers/product_provider.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? selectedCategory;

  final List<String> categories = [
    "Dental Treatment Centre",
    "Dental Imaging",
    "Endodontics",
    "Oral Surgery",
    "Disposables",
    "Dental Materials",
    "Orthodontics",
    "Laboratory",
    "Prosthetics",
    "Small Equipments",
    "Cosmetic Dentistry",
  ];


  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

   return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildSearchBar(),
          Expanded(
            child: Row(
              children: [
                _buildSidebar(context, productProvider),
                Expanded(
                  child: Column(
                    children: [
                      const AllProductsHeader(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: productProvider.selectedCategory != null
                              ? _buildMainContent(context, productProvider)
                              : _buildCategoryGrid(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search on ZaloniDentalHub',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
           const CartIconWithBadge(),
        ],
      ),
    );
  }
 
  Widget _buildSidebar(BuildContext context, ProductProvider productProvider) {
    final double sidebarWidth = MediaQuery.of(context).size.width * 0.25;
    return SizedBox(
      width: sidebarWidth,
      child: ListView(
        padding: const EdgeInsets.all(6),
        children: [
          const _SidebarHeader(),
          const SizedBox(height: 8),
          ...categories.map((category) => _CategoryTile(
                category: category,
                onTap: () {
                  productProvider.setSelectedCategory(category);
                },
              )),
        ],
      ),
    );
  }



  Widget _buildCategoryGrid(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        String category = categories[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: Theme.of(context).textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
              InkWell(
                onTap: () {
                  productProvider.setSelectedCategory(category);
                },
                child: Text(
                  'See All',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: const Color.fromRGBO(252, 165, 3, 1)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
Widget _buildMainContent(BuildContext context, ProductProvider productProvider) {
  return productProvider.products.isNotEmpty
      ? ListView.builder(
          itemCount: productProvider.products.length,
          itemBuilder: (context, index) {
            var product = productProvider.products[index];
            return ListTile(
              leading: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              ),
              title: Text(product.name),
              subtitle: Text('Discount: ${product.percentageReduction.toStringAsFixed(2)}%'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(
                      key: ValueKey(product.name), // Add the key here
                      products: productProvider.products,
                    ),
                  ),
                );
              },
            );
          },
        )
      : const Center(child: Text('No products found'));
}

}


class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      color:Colors.white,
      child: const Text(
        'Categories',
        style: TextStyle(color: Color.fromARGB(255, 7, 7, 7), fontSize: 14, fontWeight: FontWeight.normal),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      tileColor: Colors.white,
      title: Text(
        category,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Color.fromARGB(255, 10, 10, 10)),
      ),
      onTap: onTap,
    );
  }
}


class AllProductsHeader extends StatelessWidget {
  const AllProductsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Products',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }
}

