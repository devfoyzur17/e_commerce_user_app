import 'package:cloud_firestore/cloud_firestore.dart';

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
}
