import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'categories';

  void createCategory(String name) {
    var id = Uuid();
    String categoryId = id.v1();

    _firestore.collection('categories').doc(categoryId).set({'category': name});
  }

  Future<List<DocumentSnapshot>> getCategories() {
    return _firestore.collection(ref).get().then((snaps) {
      print(snaps.docs.length);
      return snaps.docs;
    });
  }
}
