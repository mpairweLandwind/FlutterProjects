import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:logger/logger.dart'; // Import the logger package
import '../providers/product_provider.dart'; // Adjust the import path as needed
import '../models/product.dart'; // Adjust the import path as needed

// Create a logger instance
final Logger logger = Logger();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    logger.d('HomeScreen build method called'); // Log when the build method is called

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
              // Log the state of the ProductProvider
              logger.d('ProductProvider state:');
              logger.d('Categories: ${productProvider.category.length}');
              logger.d('Promotions: ${productProvider.promotion.length}');
              logger.d('All Products: ${productProvider.allProduct.length}');
              logger.d('Latest Products: ${productProvider.latestProducts.length}');
              logger.d('Recommended Products: ${productProvider.recommendedProducts.length}');
              logger.d('Most Popular Products: ${productProvider.mostPopularProducts.length}');
              logger.d('Is Loading: ${productProvider.isLoading}');

              // Extract data from the provider
              final category = productProvider.category;
              final promotion = productProvider.promotion;
              final allProducts = productProvider.allProduct;
              final latestProducts = productProvider.latestProducts;
              final recommendedProducts = productProvider.recommendedProducts;
              final mostPopularProducts = productProvider.mostPopularProducts;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildSearchFilterRow(),
                  const SizedBox(height: 20),
                  _buildImageCarousel(allProducts, productProvider.isLoading),
                  const SizedBox(height: 20),
                  _buildCategorySection(title: "Categories", onViewAll: () {}),
                  _buildResponsiveCategoryList(category, context),
                  const SizedBox(height: 20),
                  _buildSwipeForMoreText(),
                  _buildSection(
                    title: "Most Popular",
                    content: _buildProductSection(mostPopularProducts),
                    onViewAll: () {},
                  ),
                  _buildSwipeForMoreText(),
                  _buildSection(
                    title: "Promotion",
                    content: _buildPromotionSection(promotion),
                    onViewAll: () {},
                  ),
                  _buildSwipeForMoreText(),
                  _buildSection(
                    title: "Latest",
                    content: _buildProductSection(latestProducts),
                    onViewAll: () {},
                  ),
                  _buildSwipeForMoreText(),
                  _buildSection(
                    title: "Recommended",
                    content: _buildProductSection(recommendedProducts),
                    onViewAll: () {},
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Header Section
  Widget _buildHeader() {
    logger.d('Building header section'); // Log when the header is built
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Deliver To",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              Row(
                children: const [
                  Icon(Icons.location_on, color: Colors.redAccent, size: 20),
                  Text(
                    "Kampala, Uganda",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_drop_down, color: Colors.redAccent),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.grey),
            onPressed: () {
              logger.d('Notification button pressed'); // Log button press
            },
          ),
        ],
      ),
    );
  }

  // Search and Filter Row
  Widget _buildSearchFilterRow() {
    logger.d('Building search and filter row'); // Log when the search row is built
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search products...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.grey),
            onPressed: () {
              logger.d('Cart button pressed'); // Log button press
            },
          ),
        ],
      ),
    );
  }

  // Image Carousel Section
  Widget _buildImageCarousel(List<String> allProducts, bool isLoading) {
    logger.d('Building image carousel'); // Log when the carousel is built
    if (isLoading) {
      logger.d('Carousel is loading'); // Log loading state
      return const Center(child: CircularProgressIndicator());
    }

    if (allProducts.isEmpty) {
      logger.d('No images available for carousel'); // Log empty state
      return const Center(child: Text("No images available"));
    }

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: allProducts.length,
          itemBuilder: (context, index, realIndex) {
            logger.d('Loading carousel image at index $index'); // Log image loading
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                allProducts[index],
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  logger.e('Error loading carousel image at index $index', error: error, stackTrace: stackTrace); // Log errors
                  return const Icon(Icons.error, size: 50, color: Colors.red);
                },
              ),
            );
          },
          options: CarouselOptions(
            viewportFraction: 1,
            height: MediaQuery.of(context).size.height * 0.25,
            autoPlay: true,
            onPageChanged: (index, reason) {
              logger.d('Carousel page changed to index $index'); // Log page change
              setState(() => _currentIndex = index);
            },
          ),
        ),
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: _buildIndicator(allProducts.length),
        ),
      ],
    );
  }

  // Carousel Indicator
  Widget _buildIndicator(int length) {
    logger.d('Building carousel indicator'); // Log when the indicator is built
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return GestureDetector(
          onTap: () {
            logger.d('Carousel indicator tapped at index $index'); // Log indicator tap
            setState(() => _currentIndex = index);
          },
          child: Container(
            height: 10,
            width: 10,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentIndex == index
                  ? const Color(0xFF146ABE)
                  : const Color(0xFFEAEAEA),
            ),
          ),
        );
      }),
    );
  }

  // Section Builder
  Widget _buildSection({
    required String title,
    required Widget content,
    required VoidCallback onViewAll,
  }) {
    logger.d('Building section: $title'); // Log when a section is built
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    logger.d('View All pressed for section: $title'); // Log button press
                    onViewAll();
                  },
                  child: const Text(
                    "View All",
                    style: TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  // Category Section
  Widget _buildCategorySection({
    required String title,
    required VoidCallback onViewAll,
  }) {
    logger.d('Building category section: $title'); // Log when the category section is built
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () {
              logger.d('View All pressed for category section: $title'); // Log button press
              onViewAll();
            },
            child: const Text(
              "View All",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  // Responsive Category List
  Widget _buildResponsiveCategoryList(
      Map<String, String> category, BuildContext context) {
    logger.d('Building responsive category list'); // Log when the category list is built
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 48) / 4;

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: category.length,
        itemBuilder: (context, index) {
          String categoryName = category.keys.elementAt(index);
          String imageUrl = category.values.elementAt(index);

          logger.d('Loading category: $categoryName'); // Log category loading
          return Container(
            width: itemWidth,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  imageUrl,
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    logger.e('Error loading category image: $categoryName', error: error, stackTrace: stackTrace); // Log errors
                    return const Icon(Icons.error, size: 50, color: Colors.red);
                  },
                ),
                const SizedBox(height: 5),
                Text(
                  categoryName,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Product Section
  Widget _buildProductSection(List<Product> products) {
    logger.d('Building product section'); // Log when the product section is built
    if (products.isEmpty) {
      logger.d('No products available'); // Log empty state
      return const Center(child: Text("No Products Available"));
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          logger.d('Loading product: ${product.name}'); // Log product loading
          return GestureDetector(
            onTap: () {
              logger.d('Product tapped: ${product.name}'); // Log product tap
              // Handle product tap
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Column(
                children: [
                  Image.network(
                    product.imageUrl,
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      logger.e('Error loading product image: ${product.name}', error: error, stackTrace: stackTrace); // Log errors
                      return const Icon(Icons.error, size: 50, color: Colors.red);
                    },
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '\$${product.salePrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Promotion Section
  Widget _buildPromotionSection(List<String> promotions) {
    logger.d('Building promotion section'); // Log when the promotion section is built
    if (promotions.isEmpty) {
      logger.d('No promotions available'); // Log empty state
      return const Center(child: Text("No Promotions Available"));
    }

    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: promotions.length,
        itemBuilder: (context, index) {
          logger.d('Loading promotion at index $index'); // Log promotion loading
          return GestureDetector(
            onTap: () {
              logger.d('Promotion tapped at index $index'); // Log promotion tap
              // Handle promotion tap
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200],
              ),
              child: Image.network(
                promotions[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  logger.e('Error loading promotion image at index $index', error: error, stackTrace: stackTrace); // Log errors
                  return const Icon(Icons.error, size: 50, color: Colors.red);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Swipe for More Text
  Widget _buildSwipeForMoreText() {
    logger.d('Building swipe for more text'); // Log when the swipe text is built
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.blue,
      alignment: Alignment.center,
      child: const Text(
        "Swipe for More",
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }
}