import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_user_app/models/cart_model.dart';
import 'package:e_commerce_user_app/models/order_model.dart';
import 'package:e_commerce_user_app/models/product_model.dart';
import 'package:e_commerce_user_app/models/rating_model.dart';
import 'package:e_commerce_user_app/utils/constansts.dart';

import '../models/category_model.dart';
import '../models/user_model.dart';

class DBHelper {
  static String collectionCategory = "Category";
  static String collectionProducts = "Products";
  static String collectionRatings = "Ratings";
  static String collectionUsers = "User";
  static String collectionCart = "Cart";
  static String collectionCities = "cities";
  static String collectionOrder = "Order";
  static String collectionOrderDetails = "OrderDetails";
  static String collectionOrderSettings = "Setting";
  static String documentOrderConstant = "OrderConstant";

  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addNewOrder(
      OrderModel orderModel, List<CartModel> cartList) {
    final wb = _db.batch();
    final orderDoc = _db.collection(collectionOrder).doc();
    orderModel.orderId = orderDoc.id;
    wb.set(orderDoc, orderModel.toMap());
    for (var cartM in cartList) {
      final cartDoc =
          orderDoc.collection(collectionOrderDetails).doc(cartM.productId);
      wb.set(cartDoc, cartM.toMap());
    }
    return wb.commit();
  }

  static Future<void> updateProductStock(List<CartModel> cartList) {
    final wb = _db.batch();
    for (var cartM in cartList) {
      final productDoc =
          _db.collection(collectionProducts).doc(cartM.productId);
      wb.update(productDoc, {productStock: (cartM.stock - cartM.quantity)});
    }
    return wb.commit();
  }

  static Future<void> clearUserCartItems(String uid, List<CartModel> cartList) {
    final wb = _db.batch();
    final userDoc = _db.collection(collectionUsers).doc(uid);
    for (var cartM in cartList) {
      final cartDoc = userDoc.collection(collectionCart).doc(cartM.productId);
      wb.delete(cartDoc);
    }
    return wb.commit();
  }

  static Future<void> updateCategoryProductCount(
      List<CartModel> cartList, List<CategoryModel> categoryList) {
    final wb = _db.batch();
    for (var cartM in cartList) {
      final catM = categoryList
          .firstWhere((element) => element.catName == cartM.category);
      final catDoc = _db.collection(collectionCategory).doc(catM.catId);
      wb.update(
          catDoc, {categoryProductCount: catM.categoryCount - cartM.quantity});
    }
    return wb.commit();
  }

  static Future<void> addToCart(String uid, CartModel cartModel) {
    return _db
        .collection(collectionUsers)
        .doc(uid)
        .collection(collectionCart)
        .doc(cartModel.productId)
        .set(cartModel.toMap());
  }

  static Future<void> updateCartItemQuantity(
      String uid, String pId, num quantity) {
    return _db
        .collection(collectionUsers)
        .doc(uid)
        .collection(collectionCart)
        .doc(pId)
        .update({cartProductQuantity: quantity});
  }

  static Future<void> removeFromCart(String uid, String productId) {
    return _db
        .collection(collectionUsers)
        .doc(uid)
        .collection(collectionCart)
        .doc(productId)
        .delete();
  }

  static Future<bool> canUserRateThisProduct(String uid, String pid) async {
    final qSnapshot = await _db
        .collection(collectionOrder)
        .where(orderUserIdKey, isEqualTo: uid)
        .where(orderStatusKey, isEqualTo: OrderStatus.delivered)
        .get();
    if (qSnapshot.docs.isEmpty) return false;
    bool tag = false;
    for (var snapshot in qSnapshot.docs) {
      final docSnap = await snapshot.reference
          .collection(collectionOrderDetails)
          .doc(pid)
          .get();
      if (docSnap.exists) {
        tag = true;
        break;
      }
    }

    return tag;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCategories() =>
      _db.collection(collectionCategory).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() => _db
      .collection(collectionProducts)
      .where(productAvailable, isEqualTo: true)
      .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCities() =>
      _db.collection(collectionCities).snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllCartItems(
          String uid) =>
      _db
          .collection(collectionUsers)
          .doc(uid)
          .collection(collectionCart)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllProductsByCategory(
          String category) =>
      _db
          .collection(collectionProducts)
          .where(productCategory, isEqualTo: category)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getOrdersByUser(
          String uid) =>
      _db
          .collection(collectionOrder)
          .where(orderUserIdKey, isEqualTo: uid)
          .snapshots();

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllFeatureProducts() =>
      _db
          .collection(collectionProducts)
          .where(productFeatured, isEqualTo: true)
          .snapshots();

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

  static Future<QuerySnapshot<Map<String, dynamic>>> getAllRatingByProductId(
      String pid) {
    return _db
        .collection(collectionProducts)
        .doc(pid)
        .collection(collectionRatings)
        .get();
  }

  static Future<void> updateProfile(String uid, Map<String, dynamic> map) {
    return _db.collection(collectionUsers).doc(uid).update(map);
  }

  static Future<void> addRating(RatingModel ratingModel) {
    final prodDoc =
        _db.collection(collectionProducts).doc(ratingModel.productId);
    final ratingDoc =
        prodDoc.collection(collectionRatings).doc(ratingModel.userId);
    return ratingDoc.set(ratingModel.toMap());
  }

  static Future<void> updateProduct(String pid, Map<String, dynamic> map) {
    return _db.collection(collectionProducts).doc(pid).update(map);
  }
}
