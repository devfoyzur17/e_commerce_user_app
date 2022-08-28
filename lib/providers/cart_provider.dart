import 'package:e_commerce_user_app/auth/auth_service.dart';
import 'package:e_commerce_user_app/db/db_helper.dart';
import 'package:flutter/material.dart';

import '../models/cart_model.dart';

class CartProvider extends ChangeNotifier{
  List<CartModel> cartList=[];

  increaseQuantity(CartModel cartModel) async{
  if(cartModel.quantity <cartModel.stock){
    await DBHelper.updateCartItemQuantity(AuthService.user!.uid, cartModel.productId!, cartModel.quantity+1);

  }
  }

  decreaseQuantity(CartModel cartModel) async{
   if(cartModel.quantity >1){
     await DBHelper.updateCartItemQuantity(AuthService.user!.uid, cartModel.productId!, cartModel.quantity-1);
   }
  }

  num itemPriceWithQuantity(CartModel cartModel)=>
  cartModel.salePrice * cartModel.quantity;

  num getCartSubtotal(){
    num total =0;
    for(var cartModel in cartList){
      total += cartModel.salePrice * cartModel.quantity;
    }
    return total;
  }


  Future<void> addToCart(CartModel cartModel){
    return DBHelper.addToCart(AuthService.user!.uid, cartModel);
  }

  Future<void> removeFromCart(String productId){
    return DBHelper.removeFromCart(AuthService.user!.uid, productId);
  }

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