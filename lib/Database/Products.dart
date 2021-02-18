import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'products';

  void uploadProduct(
      {String name,
      String category,
      String picture,
      int quantity,
      bool featured,
      // List images,
      double price}) {
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(ref).doc(productId).set({
      'Name': name,
      'id': productId,
      'Category': category,
      'Quantity': quantity,
      'Price': price,
      'Picture': picture,
      'Featured': featured,

      // 'Image': images,
    });
  }
}
