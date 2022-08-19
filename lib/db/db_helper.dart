import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class DBHelper {
  static String collectionCategory = "Category";
  static String collectionProducts = "Products";
  static String collectionUsers = "User";
  static String collectionOrder = "Order";
  static String collectionOrderDetails = "OrderDetails";
  static String collectionOrderSettings = "Setting";
  static String documentOrderConstant = "OrderConstant";

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() =>
      _db.collection(collectionProducts).snapshots();

  static Future<DocumentSnapshot<Map<String, dynamic>>>
      getAllOrderConstants() => _db
          .collection(collectionOrderSettings)
          .doc(documentOrderConstant)
          .get();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(
          String id) =>
      _db.collection(collectionProducts).doc(id).snapshots();

  static Future<void> addUser(UserModel userModel) {
    return _db
        .collection(collectionUsers)
        .doc(userModel.uid)
        .set(userModel.toMap());
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUserByUid(
      String uid) {
    return _db.collection(collectionUsers).doc(uid).snapshots();
  }

  static Future<void> updateProfile(String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUsers).doc(uid).update(map);
  }
}
