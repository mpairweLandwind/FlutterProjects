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
    'assets/CALCIUM-1.jpg',
    'assets/camera.jpg',
    'assets/Cention-N-starter-kit-430x430.jpg',
    'assets/china-2-430x358.jpg',
    'assets/COMPRESSOR.jpg',
    'assets/dental_chair.jpg',
    'assets/Dental_Disposable.jpg',
    'assets/dental-chair.jpg',
    'assets/DENTAL-CHIAR.jpg',
    'assets/Dentsply-Protaper-Universa.jpg',
    'assets/dycal-hidroxide-of-calcium-dentsply_2.jpg',
    'assets/EDON.jpg',
    'assets/elastics.jpg',
    'assets/ELEVATORS.jpg',
    'assets/ENDO-1.jpg',
    'assets/endo-ruler.jpg',
    'assets/ETCHANT-430x209.jpg',
  ];

  final List promotions = [
    'assets/EXCAR.png',
    'assets/fiber-post-430x430.jpg',
    'assets/finger-sperder-430x430.webp',
    'assets/FORMACRESOL.jpg',
    'assets/Fuji-II-430x430.jpg',
    'assets/GC_FUJI_1.jpg',
    'assets/GC-Fuji-IX-430x430.jpg',
    'assets/germany.jpg',
    'assets/GP-CLEAN-2.jpg',
    'assets/gutta-percha.png',
    'assets/H-FILE.jpg',
    'assets/IMPRESSION.jpg',
    'assets/k-files.jpg',
    'assets/k-flex--430x430.jpg',
    'assets/ligature-ties.jpg',
    'asssets/lower-anterior.jpg',
    'assets/lower-molar-430x287.jpg',
    'assets/lower-premolar.jpg',
    'assets/MIRROR.jpg',
    'assets/mixing-bowl-with-spatula.jpg',
    'assets/mobile_working_dental_unit.jpg',
    'assets/MOLAR-RT-430x430.jpg',
    'assets/oil_free_air_compressor.jpg',
    'asssets/open-spring.jpg',
    'assets/PAPER-POINT.jpg',
    'assets/Portable-Dental-X-Ray-Machine-Unit-430x430.jpeg',
    'assets/PORTAL-CHAIR-430x406.png',
    'assets/post-pins.jpg',
    'assets/Power-Chain.jpg',
    'assets/PROB-430x430.jpg',
    'assets/PULP-FILL-2.jpg',
    'assets/pyrax-rc-clean-softening-gutta-percha-15-ml-2018071217-94ugyap6.jpg',
    'assets/root_canal_obturoot_cement-400x400-1.jpg',
    'assets/rubyflow.png',
    'assets/SEALER.jpg',
    'assets/SIL-IONOMER-430x366.jpg',
    'assets/STONE.jpg',
    'assets/teeth_whiting_maschine-430x402.jpg',
    'assets/tooth_whitening-kit-430x287.jpg',
    'assets/TRAYS.jpg',
    'assets/ugandan-made-430x326.jpg',
    'assets/UPPER-ROOT-F-1-430x430.jpg',
    'assets/wall_mount_units.jpg',
    'assets/wire.jpg',
    'assets/WORKING-UNITE-430x430.jpg',
    'assets/Z-BUR.png',
    'assets/zero-box-430x430.jpg',
    'assets/ZERO-BOX-AIR.jpg',
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
