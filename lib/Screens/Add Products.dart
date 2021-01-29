import 'dart:io';
import 'dart:ui';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sams_liquor_admin/Database/Products.dart';
import 'package:sams_liquor_admin/Screens/Admin.dart';
import '../Database/Category.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flushbar/flushbar.dart';

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
  File _image2;
  File _image3;

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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
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

                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: OutlineButton(
                //       onPressed: () {
                //         selectImage(
                //             // ignore: deprecated_member_use
                //             ImagePicker.pickImage(source: ImageSource.gallery),
                //             2);
                //       },
                //       child: _displayChild2(),
                //       borderSide: BorderSide(
                //         color: Colors.grey.withOpacity(0.7),
                //         width: 2,
                //       ),
                //     ),
                //   ),
                // ),
                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: OutlineButton(
                //       onPressed: () {
                //         selectImage(
                //             // ignore: deprecated_member_use
                //             ImagePicker.pickImage(source: ImageSource.gallery),
                //             3);
                //       },
                //       child: _displayChild3(),
                //       borderSide: BorderSide(
                //         color: Colors.grey.withOpacity(0.7),
                //         width: 2,
                //       ),
                //     ),
                //   ),
                // ),
              ],
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
                  } else if (value.length > 10) {
                    return "Product name can't be more than 10 characters";
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
      case 2:
        setState(() => _image2 = tempImg);
        break;
      case 3:
        setState(() => _image3 = tempImg);
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

  // Widget _displayChild2() {
  //   if (_image2 == null) {
  //     return Padding(
  //       padding: const EdgeInsets.fromLTRB(8, 62, 8, 62),
  //       child: Icon(
  //         Icons.add,
  //         color: Colors.grey,
  //       ),
  //     );
  //   } else {
  //     return Image.file(
  //       _image2,
  //       width: double.infinity,
  //     );
  //   }
  // }

  // Widget _displayChild3() {
  //   if (_image3 == null) {
  //     return Padding(
  //       padding: const EdgeInsets.fromLTRB(8, 62, 8, 62),
  //       child: Icon(
  //         Icons.add,
  //         color: Colors.grey,
  //       ),
  //     );
  //   } else {
  //     return Image.file(
  //       _image3,
  //     );
  //   }
  // }

  Future<void> validateAndUpload() async {
    if (_formKey.currentState.validate()) {
      if (_image1 != null && _image2 != null && _image3 != null) {
        String imageUrl1;
        String imageUrl2;
        String imageUrl3;
        final FirebaseStorage storage = FirebaseStorage.instance;
        final String picture1 =
            "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task1 = storage.ref().child(picture1).putFile(_image1);
        final String picture2 =
            "2${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task2 = storage.ref().child(picture2).putFile(_image2);
        final String picture3 =
            "3${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task3 = storage.ref().child(picture3).putFile(_image3);

        TaskSnapshot snapshot1 = await task1.then((snapshot1) => snapshot1);
        TaskSnapshot snapshot2 = await task2.then((snapshot2) => snapshot2);

        task3.then((snapshot3) async {
          imageUrl1 = await snapshot1.ref.getDownloadURL();
          imageUrl2 = await snapshot2.ref.getDownloadURL();
          imageUrl3 = await snapshot3.ref.getDownloadURL();
          List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

          productService.uploadProduct(
              productName: productNameController.text,
              price: double.parse(productPriceController.text),
              images: imageList,
              category: _currentCategory,
              quantity: int.parse(productQuantityController.text));
          _formKey.currentState.reset();

          Flushbar(
            flushbarPosition: FlushbarPosition.BOTTOM,
            message: "Product Added Successfully",
          );

          // Fluttertoast.showToast(msg: "Product Added Successfully");
        });
      } else {
        // setState(() => isLoading = false);
        Fluttertoast.showToast(msg: "all images must be provided");
      }
    }
  }
}
