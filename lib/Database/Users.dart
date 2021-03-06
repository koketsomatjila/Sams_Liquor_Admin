import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sams_liquor_admin/models/User.dart';

class UserServices {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String collection = "users";

  void createUser(Map<String, dynamic> data) {
    String uid = data['uid'];
    _firestore.collection(collection).doc(uid).set(data);
  }

  void updateUserData(Map<String, dynamic> data) {
    _firestore.collection(collection).doc(data['id']).update(data);
  }

  Future<UserModel> getUserById(String uid) => _firestore
      .collection(collection)
      .doc(uid)
      .get()
      .then((doc) => UserModel.fromSnapshot(doc));
}
