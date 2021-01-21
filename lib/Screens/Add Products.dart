import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Database/Category.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  CategoryService _categoryService = CategoryService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
      <DropdownMenuItem<String>>[];
  String _currentCategory;

  @override
  // ignore: must_call_super
  void initState() {
    _getCategories();
    // categoriesDropDown = getCategoriesDropDown();
    // _currentCategory = categoriesDropDown[0].value;
  }

  // ignore: missing_return
  List<DropdownMenuItem<String>> getCategoriesDropDown() {
    List<DropdownMenuItem<String>> items = List();
    for (DocumentSnapshot category in categories) {
      items.add(new DropdownMenuItem(
        child: Text(category['category']),
        value: category['category'],
      ));
      return items;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(
          Icons.close,
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
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 22, 8, 22),
                        child: Icon(
                          Icons.add,
                          color: Colors.grey,
                        ),
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 22, 8, 22),
                        child: Icon(
                          Icons.add,
                          color: Colors.grey,
                        ),
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlineButton(
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 22, 8, 22),
                        child: Icon(
                          Icons.add,
                          color: Colors.grey,
                        ),
                      ),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.7),
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            //Form

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Enter product name",
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
                    return "You must a product name";
                  } else if (value.length > 10) {
                    return "Product name can't be more than 10 characters";
                  }
                  return null;
                },
              ),
            ),
            Center(
              child: DropdownButton(
                value: _currentCategory,
                items: categoriesDropDown,
                onChanged: changeSelectedCategory,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropDown();
      _currentCategory = categoriesDropDown[2].value;
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }
}
