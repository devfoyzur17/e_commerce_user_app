import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_user_app/auth/auth_service.dart';
import 'package:e_commerce_user_app/models/rating_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

class ProductProvider extends ChangeNotifier {
  List<ProductModel> productList = [];
  List<ProductModel> featureProductList = [];
  List<PurchaseModel> purchaseListOfSpecificProduct = [];
  List<CategoryModel> categoryList = [];
  List<String> categoryNameList = [];

  getAllCategories() {
    DBHelper.getAllCategories().listen((event) {
      categoryList = List.generate(event.docs.length,
          (index) => CategoryModel.fromMap(event.docs[index].data()));
      categoryNameList = List.generate(
          categoryList.length, (index) => categoryList[index].catName!);
      categoryNameList.insert(0, "All");

      notifyListeners();
    });
  }

  getAllProducts() {
    DBHelper.getAllProducts().listen((event) {
      productList = List.generate(event.docs.length,
          (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getAllFeatureProducts() {
    DBHelper.getAllFeatureProducts().listen((event) {
      featureProductList = List.generate(event.docs.length,
          (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  getAllProductsByCategory(String category) {
    DBHelper.getAllProductsByCategory(category).listen((event) {
      productList = List.generate(event.docs.length,
          (index) => ProductModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getProductById(String id) =>
      DBHelper.getProductById(id);

  Future<String> updateImage(XFile xFile) async {
    final imageName = DateTime.now().microsecondsSinceEpoch.toString();
    final photoRef =
        FirebaseStorage.instance.ref().child("UserImage/$imageName");
    final uploadTask = photoRef.putFile(File(xFile.path));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  Future<void> addNewRating(double value, String id) async {
    final ratingModel = RatingModel(
        rating: value, productId: id, userId: AuthService.user!.uid);

    await DBHelper.addRating(ratingModel);
    final qSnapshot = await DBHelper.getAllRatingByProductId(id);
    final List<RatingModel> ratingList =
    List.generate(qSnapshot.docs.length, (index) =>
        RatingModel.fromMap(qSnapshot.docs[index].data()));
    double ratingValue = 0.0;
    for(var ratingM in ratingList) {
      ratingValue += ratingM.rating;
    }
    final avgRating = ratingValue / ratingList.length;
    return DBHelper.updateProduct(id, {productRatting : avgRating});
  }
}
