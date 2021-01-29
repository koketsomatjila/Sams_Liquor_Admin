import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  // constants

  static const String CATEGORY = 'category';
  static const String FEATURED = 'featured';
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String PICTURE = 'picture';
  static const String PRICE = 'price';
  static const String QUANTITY = 'quantity';
  static const String SALE = 'sale';

  // variables
  String _category;
  String _id;
  String _name;
  String _picture;
  double _price;
  int _quantity;
  bool _sale;
  bool _featured;

// getters
  String get category => _category;
  String get id => _id;
  String get name => _name;
  String get picture => _picture;
  double get price => _price;
  int get quantity => _quantity;
  bool get sale => _sale;
  bool get featured => _featured;

  Product.fromSnapshot(DocumentSnapshot snapshot) {
    _category = snapshot.get(CATEGORY);
    _id = snapshot.get(ID);
    _name = snapshot.get(NAME);
    _picture = snapshot.get(PICTURE);
    _price = snapshot.get(PRICE);
    _quantity = snapshot.get(QUANTITY);
    _sale = snapshot.get(SALE);
    _featured = snapshot.get(FEATURED);
  }
}
