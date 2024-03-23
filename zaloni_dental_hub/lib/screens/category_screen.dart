import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zaloni_dental_hub/models/cart_icon_with_badge.dart';
import 'package:zaloni_dental_hub/models/product.dart';
import 'package:zaloni_dental_hub/screens/product_details.dart';

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


  List <String> subCategories = [
    "Dental Chairs",
    "Mobile Working Units",
    "Oil Free AirCompressor",
    "Wall Mount Units",
    "Dental X-Ray",
    "X-Ray Films",
    "Orthodontics",
    "Led-Aprons",
    "Intra-Oral Camera",
    "Access Opening",
    "Cleaning and Shaping",
    "Obturation Materials",
    "Extraction Forceps",
    "Elevators",
    "Disposables",
    "Impression Materials",
    "Restorative",
    "Brackets",
    "Ties",
    "Wires",
    "Dental Lab Materials",
    "Dental Lab Equipment",
    "Prosthetics",
    "Small Equipments",
    "Jewellery",
    "Tooth Whitening",
  ];


  @override
  Widget build(BuildContext context) {
    // Calculate the width of the sidebar as 25% of the screen width

   return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildSearchBar(),
          Expanded(
            child: Row(
              children: [
                _buildSidebar(context),                
                Expanded(
                  child: Column(
                    children: [
                       const AllProductsHeader(), // Display the permanent header
                       Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: selectedCategory != null
                        ? _buildMainContent(selectedCategory)
                        : _buildCategoryGrid(),
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
 

  Widget _buildSelectedCategoryHeader(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            category,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Icon(Icons.keyboard_arrow_left),
        ],
      ),
    );
  }

  Widget _buildSubcategoryTitle(String subcategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        subcategory,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


 Widget _buildSidebar(BuildContext context) {
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
            setState(() {
              selectedCategory = category; // Update the selected category
              // You might need to fetch the products for the selected category here
            });
          },
        )),
      ],
    ),
  );
}



Widget _buildCategoryGrid() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('products').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      // Extract the documents once, to avoid repetitive calls to snapshot.data
      List<DocumentSnapshot> documents = snapshot.data!.docs;

      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: categories.length,
        itemBuilder: (context, categoryIndex) {
          // Create a set of unique subcategories for the current category
          var uniqueSubcategories = documents
              .where((doc) => doc['category'] == categories[categoryIndex])
              .map((doc) => doc['subcategory'] as String)
              .toSet(); // This will remove any duplicates

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0), 
                child: Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Expanded(
      child: Text(
        categories[categoryIndex],
        style: Theme.of(context).textTheme.titleLarge,
        overflow: TextOverflow.ellipsis, // Optional: to display '...' if the text is too long
      ),
    ),
    InkWell(
      onTap: () {
        // Handle 'See All' onTap action for the category
      },
      child: Text(
        'See All',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: const Color.fromRGBO(252, 165, 3, 1)),
      ),
    ),
  ],
),

 ),


              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1.2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: uniqueSubcategories.length, // Use the unique subcategories count
                itemBuilder: (context, itemIndex) {
                  // Use the unique subcategory for this item
                  String subcategory = uniqueSubcategories.elementAt(itemIndex);

                  // Find the first product that matches the subcategory to display as the representative
                  var subcategoryProduct = documents.firstWhere(
                    (doc) => doc['subcategory'] == subcategory,
                    orElse: () => throw FlutterError('No product found for subcategory $subcategory'),
                  );

                  var productData = subcategoryProduct.data() as Map<String, dynamic>;

                  // Here we convert the DocumentSnapshot to a Product object
                  Product product = Product(
                    category: productData['category'],
                    subcategory: productData['subcategory'],
                    name: productData['name'],
                    quantity: productData['quantity'],
                    imageUrl: productData['imageUrl'],                    
                    salePrice: (productData['salePrice'] as num?)?.toDouble() ?? 0.0,
                    discountPrice: productData['discountPrice'].toDouble(),
                    percentageReduction: productData['percentageReduction'].toDouble(),
                    description: productData['description'], 
                    //rating: productData['rating'] != null ? productData['rating'] : null,
                  );
                  return GestureDetector(
                   onTap: () {
  // Filter the documents list to get all products that match the subcategory
  List<Product> productsInSubcategory = documents
      .where((doc) => doc['subcategory'] == subcategory)
      .map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Product(
          category: data['category'],
          subcategory: data['subcategory'],
          name: data['name'],
          quantity: data['quantity'],
          imageUrl: data['imageUrl'],
          salePrice: (data['salePrice'] as num?)?.toDouble() ?? 0.0,
          discountPrice: data['discountPrice'].toDouble(),
          percentageReduction: data['percentageReduction'].toDouble(),
          description: data['description'],
          // Assuming 'rating' is optional, check if it exists before using it
          // rating: data['rating'] != null ? data['rating'].toDouble() : null,
        );
      }).toList();

  // Pass the list of Product objects to the ProductDetails page
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => ProductDetails(products: productsInSubcategory, key: UniqueKey(),),
    ),
  );
},
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            product.imageUrl, // Product image URL from Firebase
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            product.subcategory, // Product name from Firebase
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      );
    },
  );
}

  Widget _buildMainContent(String? category) {
    if (category == null) {
      return Container(); // Return an empty container when no category is selected
    }

    // Show a header for the selected category
    List<Widget> contentList = [
      _buildSelectedCategoryHeader(category),
    ];

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').where('category', isEqualTo: category).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;

        // Group the products by subcategory
        Map<String, List<DocumentSnapshot>> groupedBySubcategories = {};
        for (var doc in documents) {
          String subcategory = doc['subcategory'];
          if (!groupedBySubcategories.containsKey(subcategory)) {
            groupedBySubcategories[subcategory] = [];
          }
          groupedBySubcategories[subcategory]!.add(doc);
        }

        // Create a list of widgets for each subcategory and its products
        groupedBySubcategories.forEach((subcategory, products) {
          // Add a title for each subcategory
          contentList.add(_buildSubcategoryTitle(subcategory));

          // Convert the products List into a GridView for that subcategory
          contentList.add(GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.5,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
                 var productData = products[index].data() as Map<String, dynamic>;


             Product product = Product(
                    category: productData['category'],
                    subcategory: productData['subcategory'],
                    name: productData['name'],
                    quantity: productData['quantity'],
                    imageUrl: productData['imageUrl'],                    
                    salePrice: (productData['salePrice'] as num?)?.toDouble() ?? 0.0,
                    discountPrice: productData['discountPrice'].toDouble(),
                    percentageReduction: productData['percentageReduction'].toDouble(),
                    description: productData['description'], 
                    //rating: productData['rating'] != null ? productData['rating'] : null,
                  );
  return GestureDetector(
                   onTap: () {
  List<Product> productsInSubcategory = products.map((doc) {
    var productData = doc.data() as Map<String, dynamic>;
    return Product(
      category: productData['category'],
      subcategory: productData['subcategory'],
      name: productData['name'],
      quantity: productData['quantity'],
      imageUrl: productData['imageUrl'],
      salePrice: productData['salePrice'].toDouble(),
      discountPrice: productData['discountPrice'].toDouble(),
      percentageReduction: productData['percentageReduction'].toDouble(),
      description: productData['description'],
      //rating: productData['rating'] != null ? productData['rating'] : null,
    );
  }).toList();

  Navigator.of(context).push(
  MaterialPageRoute(
    builder: (context) => ProductDetails(products: productsInSubcategory, key: UniqueKey()),
  ),
);
},

                    child: Column(
                      children: [
                        Expanded(
                          child: Image.network(
                            product.imageUrl, // Product image URL from Firebase
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            product.name, // Product name from Firebase
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
          
          );
        },
      );
        return SingleChildScrollView(
          child: Column(
            children: contentList,
          ),
        );
    },
    );
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

