import 'package:e_commerce_user_app/auth/auth_service.dart';
import 'package:e_commerce_user_app/db/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier{
  List<CartModel> cartList=[];

  getAllCartItems(){
    DBHelper.getAllCartItems(AuthService.user!.uid).listen((event) {
      cartList = List.generate(event.docs.length, (index) => CartModel.fromMap(event.docs[index].data()));
      notifyListeners();
    });

  }


  int get totalItemsInCart  => cartList.length;

  bool isInCart(String productId){
    bool flag = false;
    for(var cart in cartList){
      if(cart.productId == productId){
        flag = true;
        break;
      }
    }
    return flag;
  }

}