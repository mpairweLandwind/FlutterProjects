import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class ProductRegistrationScreen extends StatefulWidget {
  static const routeName = '/product-registration';

  const ProductRegistrationScreen({super.key});

  @override
  State<ProductRegistrationScreen> createState() =>
      _ProductRegistrationScreenState();
}

class _ProductRegistrationScreenState extends State<ProductRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  String? _selectedCategory;
  String? _selectedsubCategory;
  String? _productName;
  int? _quantity;
  double? _salePrice;
  double? _discountPrice;
  String? _description;

  final List<File> _images = []; // List to hold selected images
  final List<String?> _fileNames = [];
  final ImagePicker _imagePicker = ImagePicker();

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

  // Show image source selection dialog
  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Product Images',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.blue),
                  ),
                  title: const Text('Take Photo'),
                  subtitle: const Text('Use camera to capture images'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImagesFromCamera();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.green),
                  ),
                  title: const Text('Choose from Gallery'),
                  subtitle: const Text('Select multiple images from device'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImagesFromGallery();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.file_upload, color: Colors.orange),
                  ),
                  title: const Text('Upload Files'),
                  subtitle: const Text('Select files from computer'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImagesFromFiles();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Pick images from camera (one at a time, but can be called multiple times)
  Future<void> _pickImagesFromCamera() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (photo != null) {
        setState(() {
          _images.add(File(photo.path));
          _fileNames.add(photo.name);
        });

        // Ask if user wants to add more photos
        if (mounted) {
          _showAddMoreDialog();
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to capture image: $e');
    }
  }

  // Pick multiple images from gallery
  Future<void> _pickImagesFromGallery() async {
    try {
      final List<XFile> photos = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (photos.isNotEmpty) {
        setState(() {
          for (var photo in photos) {
            _images.add(File(photo.path));
            _fileNames.add(photo.name);
          }
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick images: $e');
    }
  }

  // Pick images using file picker
  Future<void> _pickImagesFromFiles() async {
    try {
      final FilePickerResult? pickedFiles = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'webp'],
      );

      if (pickedFiles != null) {
        setState(() {
          for (var file in pickedFiles.files) {
            if (file.path != null) {
              _images.add(File(file.path!));
              _fileNames.add(file.name);
            }
          }
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick files: $e');
    }
  }

  // Show dialog to add more photos
  void _showAddMoreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add More Photos?'),
          content: Text(
              'You have added ${_images.length} image(s). Do you want to add more?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _pickImagesFromCamera();
              },
              child: const Text('Add More'),
            ),
          ],
        );
      },
    );
  }

  // Remove image from list
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
      _fileNames.removeAt(index);
    });
  }

  // Show error snackbar
  void _showErrorSnackBar(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Upload multiple images and return a list of URLs
  Future<List<String>> _uploadImages() async {
    List<String> imageUrls = [];

    for (int i = 0; i < _images.length; i++) {
      final ref =
          FirebaseStorage.instance.ref().child('uploads/${_fileNames[i]}');
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
                  initialValue: _selectedCategory,
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
                  validator: (value) =>
                      value == null ? 'Please select a category' : null,
                  onSaved: (value) {
                    _selectedCategory = value;
                  },
                ),
                DropdownButtonFormField<String>(
                  initialValue: _selectedsubCategory,
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
                  validator: (value) =>
                      value == null ? 'Please select a subcategory' : null,
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
                    if (value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null) {
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid sale price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _salePrice = double.tryParse(value!);
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Discount Price'),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        double.tryParse(value) == null) {
                      return 'Please enter a valid discount price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _discountPrice = double.tryParse(value!);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  onSaved: (value) {
                    _description = value;
                  },
                ),
                // Display selected images with remove button
                if (_images.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Selected Images (${_images.length})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (ctx, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _images[index],
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text('Add Images'),
                  onPressed:
                      _showImageSourceDialog, // Show dialog to choose source
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
  final CollectionReference _productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _productsCollection.add(productData);
  }
}
