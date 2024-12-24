import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/products_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;


  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.fetchCategory();
    provider.fetchPromotion();
    provider.fetchSpecialCategories();
    provider.fetchProducts(null);
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final category = productProvider.category;
    final promotion = productProvider.promotion;
    final allProducts = productProvider.allProduct;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchFilterRow(),
              const SizedBox(height: 20),
              _buildImageCarousel(allProducts),
              _buildCategorySection(title: "Categories", onViewAll: () {}),
              _buildSwipeForMoreText(),
              _buildResponsiveCategoryList(category, context),
              const SizedBox(height: 20),
              _buildSection(
                title: "Most Popular",
                content: ProductWidget(
                    products: productProvider.mostPopularProducts),
                onViewAll: () {},
              ),
              _buildSection(
                title: "Promotion",
                content: _buildPromotionList(promotion),
                onViewAll: () {},
              ),
              _buildSection(
                title: "Latest",
                content:
                    ProductWidget(products: productProvider.latestProducts),
                onViewAll: () {},
              ),
              _buildSection(
                title: "Recommended",
                content: ProductWidget(
                    products: productProvider.recommendedProducts),
                onViewAll: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSwipeForMoreText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: const [
          Text(
            "Swipe for More",
            style: TextStyle(fontSize: 14, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFilterRow() {
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildImageCarousel(List<String> allProducts) {
    return allProducts.isNotEmpty
        ? Stack(
            children: [
              CarouselSlider.builder(
                itemCount: allProducts.length,
                itemBuilder: (context, index, realIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      allProducts[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, size: 50, color: Colors.red),
                    ),
                  );
                },
                options: CarouselOptions(
                  viewportFraction: 1,
                  height: MediaQuery.of(context).size.height * 0.25,
                  autoPlay: true,
                  onPageChanged: (index, reason) =>
                      setState(() => _currentIndex = index),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: _buildIndicator(allProducts.length),
              ),
            ],
          )
        : const Center(child: CircularProgressIndicator());
  }

  Widget _buildIndicator(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return GestureDetector(
          onTap: () => setState(() => _currentIndex = index),
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



  Widget _buildSection({
    required String title,
    required Widget content,
    required VoidCallback onViewAll,
  }) {
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
                  onTap: onViewAll,
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

  Widget _buildCategorySection(
      {required String title, required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: onViewAll,
            child: const Text("View All", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveCategoryList(
      Map<String, String> category, BuildContext context) {
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
                Image.network(imageUrl,
                    height: 60, width: 60, fit: BoxFit.cover),
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

  Widget _buildPromotionList(List<String> promotions) {
    return promotions.isEmpty
        ? const Center(
            child: Text("No promotions available"),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: promotions.map((promotion) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      promotion,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error,
                            size: 50, color: Colors.red);
                      },
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }
}
