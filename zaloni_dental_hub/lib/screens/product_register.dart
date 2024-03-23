import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';



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
  double? _percentageReduction;
  String? _description;
  File? _image;
  String? _fileName;

   List <String> categories = [
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




 Future<void> _pickImage() async {
    final FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.files.single.path!);
        _fileName = pickedFile.files.single.name;
      });
    }
  }

  Future<String?> _uploadImage(File image, String fileName) async {
   
    final ref = FirebaseStorage.instance
        .ref()
        .child('uploads/$fileName');
    await ref.putFile(image);
    return ref.getDownloadURL();
  }

// Update the _saveForm method in the _ProductRegistrationScreenState class.
Future<void> _saveForm() async {
  final isValid = _formKey.currentState?.validate();
  if (isValid != null && isValid) {
    _formKey.currentState?.save();
    String? imageUrl;
    try {
      if (_image != null) {
        imageUrl = await _uploadImage(_image!, _fileName!);
      }
      final productData = {
        'category': _selectedCategory,
        'subcategory': _selectedsubCategory,
        'name': _productName,
        'quantity': _quantity,
        'salePrice': _salePrice,
        'discountPrice': _discountPrice,
        'percentageReduction': _percentageReduction,
        'description': _description,
        'imageUrl': imageUrl,
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

  

 // Add a GlobalKey for Scaffold to the state class to use for SnackBars
//final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid sale price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _salePrice = double.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Discount Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid discount price';
                  }
                  return null;
                },
                onSaved: (value) {
                  _discountPrice = double.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Percentage Reduction'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Please enter a valid percentage reduction';
                  }
                  return null;
                },
                onSaved: (value) {
                  _percentageReduction = double.tryParse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
                onSaved: (value) {
                  _description = value;
                },
              ),
             
              if (_image != null)
                Image.file(_image!),
                  ElevatedButton(
                onPressed: () => _pickImage(), // Button to pick an image
                child: const Text('upload Image'),
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