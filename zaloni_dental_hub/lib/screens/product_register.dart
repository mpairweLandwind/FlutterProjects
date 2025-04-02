import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ProductRegistrationScreen extends StatefulWidget {
  static const routeName = '/product-registration';

  const ProductRegistrationScreen({super.key});

  @override
  State<ProductRegistrationScreen> createState() => _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  String? _selectedCategory;
  String? _selectedsubCategory;
  String? _productName;
  int? _quantity;
  double? _salePrice;
  double? _discountPrice;
  String? _description;

  List<File> _images = []; // List to hold selected images
  List<String?> _fileNames = [];

  List<String> categories = [
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

  List<String> subCategories = [
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

  // Format input with commas
  String _formatNumber(String value) {
    if (value.isEmpty) return '';
    final formatter = NumberFormat('#,##0.##');
    try {
      final number = double.parse(value.replaceAll(',', ''));
      return formatter.format(number);
    } catch (e) {
      return value;
    }
  }

  // Pick multiple images
  Future<void> _pickImage() async {
    final FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: true, // Enable multiple file selection
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );

    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.paths.map((path) => File(path!)).toList();
        _fileNames = pickedFiles.names.toList();
      });
    }
  }

  // Upload multiple images and return a list of URLs
  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];

    for (int i = 0; i < _images.length; i++) {
      final ref = FirebaseStorage.instance.ref().child('uploads/${_fileNames[i]}');
      await ref.putFile(_images[i]);
      String imageUrl = await ref.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    return imageUrls;
  }

  // Save form and upload multiple images
  Future<void> _saveForm() async {
    final isValid = _formKey.currentState?.validate();
    if (isValid != null && isValid) {
      _formKey.currentState?.save();
      List<String>? imageUrls;

      try {
        if (_images.isNotEmpty) {
          imageUrls = await _uploadImages();
        }

        final productData = {
          'category': _selectedCategory,
          'subcategory': _selectedsubCategory,
          'name': _productName,
          'quantity': _quantity,
          'salePrice': _salePrice,
          'discountPrice': _discountPrice,
          'description': _description,
          'imageUrls': imageUrls, // Store all image URLs
        };

        FirebaseService firebaseService = FirebaseService();
        await firebaseService.addProduct(productData);

        _scaffoldMessengerKey.currentState?.showSnackBar(
          const SnackBar(
            content: Text('Product registered successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        _scaffoldMessengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text('Failed to register product: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Register Product"),
          actions: [
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveForm,
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: const Text('Select Category'),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a category' : null,
                  onSaved: (value) {
                    _selectedCategory = value;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedsubCategory,
                  hint: const Text('Select subCategory'),
                  items: subCategories.map((subCategory) {
                    return DropdownMenuItem(
                      value: subCategory,
                      child: Text(subCategory),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedsubCategory = value;
                    });
                  },
                  validator: (value) => value == null ? 'Please select a subcategory' : null,
                  onSaved: (value) {
                    _selectedsubCategory = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productName = value;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty || int.tryParse(value) == null) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _quantity = int.tryParse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Sale Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
                  ],
                  onChanged: (value) {
                    final formattedValue = _formatNumber(value);
                    if (value != formattedValue) {
                      setState(() {
                        final controller =
                            TextEditingController(text: formattedValue);
                        controller.selection = TextSelection.collapsed(
                            offset: formattedValue.length);
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a sale price';
                    }
                    final sanitizedValue = value.replaceAll(',', '');
                    if (double.tryParse(sanitizedValue) == null) {
                      return 'Please enter a valid sale price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    final sanitizedValue = value!.replaceAll(',', '');
                    _salePrice = double.tryParse(sanitizedValue);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Discount Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
                  ],
                  onChanged: (value) {
                    final formattedValue = _formatNumber(value);
                    if (value != formattedValue) {
                      setState(() {
                        final controller =
                            TextEditingController(text: formattedValue);
                        controller.selection = TextSelection.collapsed(
                            offset: formattedValue.length);
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a discount price';
                    }
                    final sanitizedValue = value.replaceAll(',', '');
                    if (double.tryParse(sanitizedValue) == null) {
                      return 'Please enter a valid discount price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    final sanitizedValue = value!.replaceAll(',', '');
                    _discountPrice = double.tryParse(sanitizedValue);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  onSaved: (value) {
                    _description = value;
                  },
                ),
                // Display selected images
                if (_images.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _images.length,
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(_images[index], width: 100, height: 100, fit: BoxFit.cover),
                        );
                      },
                    ),
                  ),
                ElevatedButton(
                  onPressed: _pickImage, // Button to pick multiple images
                  child: const Text('Upload Images'),
                ),
                ElevatedButton(
                  onPressed: _saveForm,
                  child: const Text('Register Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FirebaseService {
  final CollectionReference _productsCollection = FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _productsCollection.add(productData);
  }
}
