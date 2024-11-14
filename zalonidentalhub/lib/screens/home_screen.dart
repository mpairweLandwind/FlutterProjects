import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:zalonidentalapp/widgets/products_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// _HomeScreenState

class _HomeScreenState extends State<HomeScreen> {
  final List images = [
    'assets/alginate.jpg',
    'assets/AMALGUM-2.jpg',
    'assets/ARCHWIRE.jpg',
    'assets/archwires-stainless.jpg',
    'assets/biofactor-mta.jpg',
    'assets/BRACKETS-2.jpg',
    'assets/braket.jpg',
    'assets/buccal-tube-430x430.jpeg',
    'assets/profile.jpg',
    'assets/BURS.jpg',
   
  ];

  final List promotions = [
    'assets/EXCAR.png',
    'assets/fiber-post-430x430.jpg',
    'assets/finger-sperder-430x430.webp',
    'assets/FORMACRESOL.jpg',
    'assets/Fuji-II-430x430.jpg',
    'assets/GC_FUJI_1.jpg',
    'assets/GC-Fuji-IX-430x430.jpg',
  
  ];

  List category = [
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

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSearchFilterRow(),
            const SizedBox(height: 20),
            _buildImageCarousel(),
            _buildCategorySection(title: "Categories", onViewAll: () {}),
            _buildCategoryList(),
            _buildCategorySection(title: "Most Popular", onViewAll: () {}),
            ProductWidget(),
            const SizedBox(height: 20),
            _buildCategorySection(title: "Promotion", onViewAll: () {}),
            _buildPromotionList(),
            _buildCategorySection(title: "Latest", onViewAll: () {}),
            const SizedBox(height: 20),
            ProductWidget(),
            _buildCategorySection(title: "Recommended", onViewAll: () {}),
            ProductWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: _buildLocationRow(),
    );
  }

  Widget _buildLocationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLocationColumn(),
      ],
    );
  }

  Widget _buildLocationColumn() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Deliver To", style: TextStyle(fontSize: 18, color: Colors.black54)),
        SizedBox(height: 5),
        Row(
          children: [
            Icon(Icons.location_on, color: Colors.redAccent),
            Text("Kampala, Uganda", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Icon(Icons.arrow_drop_down, color: Colors.redAccent),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchFilterRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSearchBox(),
        _buildFilterButton(),
      ],
    );
  }

  Widget _buildSearchBox() {
    return Expanded(
      flex: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: const Color(0xFFF3F3F3), borderRadius: BorderRadius.circular(10)),
        child: TextFormField(
          decoration: const InputDecoration(
            hintText: "Search your product here....",
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: const Color(0xFF146ABE), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.filter_list, color: Colors.white, size: 26),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(images[index], fit: BoxFit.cover, width: double.infinity),
            );
          },
          options: CarouselOptions(
            viewportFraction: 1,
            height: MediaQuery.of(context).size.height * 0.25,
            autoPlay: true,
            onPageChanged: (index, reason) => setState(() => _currentIndex = index),
          ),
        ),
        Positioned(bottom: 10, left: 0, right: 0, child: _buildIndicator()),
      ],
    );
  }

  Widget _buildIndicator() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: images.asMap().entries.map((entry) {
          return GestureDetector(
            onTap: () => setState(() => _currentIndex = entry.key),
            child: Container(
              height: 10,
              width: 10,
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == entry.key
                    ? const Color(0xFF146ABE)
                    : const Color(0xFFEAEAEA),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategorySection({required String title, required VoidCallback onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          InkWell(
            onTap: onViewAll,
            child: const Text("View All", style: TextStyle(color: Color(0xFF146ABE), fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: category.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              width: 100,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(item, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPromotionList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: promotions.map((promotion) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(promotion, width: 100, height: 100, fit: BoxFit.cover),
            ),
          );
        }).toList(),
      ),
    );
  }
}
