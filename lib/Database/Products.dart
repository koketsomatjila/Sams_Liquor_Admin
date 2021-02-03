import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'products';

  void uploadProduct(
      {String productName,
      String category,
      String picture,
      int quantity,
      // List images,
      double price}) {
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(ref).doc(productId).set({
      'Name': productName,
      'id': productId,
      'Category': category,
      'Quantity': quantity,
      'Price': price,
      'Picture': picture,
      // 'Image': images,
    });
  }
}
