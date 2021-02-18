import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:sams_liquor_admin/Database/Products.dart';
import 'package:sams_liquor_admin/Screens/Admin.dart';
import '../Database/Category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flushbar/flushbar.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  ProductService productService = ProductService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productQuantityController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  String _currentCategory;
  File _image1;
  bool _featured = false;

  @override
  // ignore: must_call_super
  void initState() {
    _getCategories();
  }

  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(categories[i].data()['category']),
                value: categories[i].data()['category']));
      });
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => Admin()));
          },
          icon: Icon(Icons.close),
          color: Colors.black,
        ),
        title: Text(
          "Add Product",
          style: TextStyle(color: Colors.brown),
        ),
      ),

// start of body

      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Divider(
              color: Colors.transparent,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Upload image of product",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  onPressed: () {
                    // ignore: deprecated_member_use
                    _selectImage(
                      // ignore: deprecated_member_use
                      ImagePicker.pickImage(source: ImageSource.gallery),
                    );
                  },
                  child: _displayChild1(),
                  borderSide: BorderSide(
                    color: Colors.grey.withOpacity(0.7),
                    width: 2,
                  ),
                ),
              ),
            ),

            //Form
            Divider(
              color: Colors.transparent,
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Enter product details",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: productNameController,
                decoration: InputDecoration(hintText: "Product name"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "You must enter a product name";
                  } else if (value.length > 100) {
                    return "Product name can't be more than 100 characters";
                  }
                  return null;
                },
              ),
            ),

            // price field

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
              child: TextFormField(
                controller: productPriceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Price"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "minimum of 1 is required";
                  }
                  return null;
                },
              ),
            ),

            // quantity field

            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
              child: TextFormField(
                controller: productQuantityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: "Quantity"),
                validator: (value) {
                  if (value.isEmpty) {
                    return "minimum of 1 is required";
                  }
                  return null;
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(8),
                child: CheckboxListTile(
                  title: Text("Featured Item"),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: _featured,
                  onChanged: (bool value) {
                    setState(() {
                      _featured = value;
                    });
                  },
                )),
            Divider(
              color: Colors.transparent,
            ),
            Divider(
              color: Colors.transparent,
            ),

            // category title

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Select category for product",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),

            // category dropdown and button

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButton(
                      value: _currentCategory,
                      items: categoriesDropDown,
                      onChanged: changeSelectedCategory,
                    ),
                  ),

                  // add product button

                  Expanded(
                    child: FlatButton(
                      child: Text('Add Product'),
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        validateAndUpload();

                        // _formKey.currentState.dispose();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categories[0].data()['category'];
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  void _selectImage(Future<File> pickImage) async {
    _image1 = await pickImage;
  }

  void selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(38, 62, 38, 62),
        child: Icon(
          Icons.add,
          color: Colors.grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        width: double.infinity,
      );
    }
  }

  Future<void> validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      if (_image1 != null) {
        String picUrl1;

        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture1 =
            "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task1 = storage.ref().child(picture1).putFile(_image1);

        TaskSnapshot snapshot1 = await task1.then((snapshot1) => snapshot1);

        task1.then((snapshot1) async {
          picUrl1 = await snapshot1.ref.getDownloadURL();

          productService.uploadProduct(
              name: productNameController.text,
              price: double.parse(productPriceController.text),
              featured: _featured,
              picture: picUrl1,
              category: _currentCategory,
              quantity: int.parse(productQuantityController.text));

          Fluttertoast.showToast(msg: "Product Added Successfully");
        });
      } else {
        Fluttertoast.showToast(msg: "all images must be provided");
      }
    }
  }
}
