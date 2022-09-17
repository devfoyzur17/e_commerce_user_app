import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_user_app/providers/cart_provider.dart';
import 'package:e_commerce_user_app/providers/order_provider.dart';
import 'package:e_commerce_user_app/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';

class ProductDetailsPage extends StatelessWidget {
  static const routeName = "product-details-page";
  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pId = ModalRoute.of(context)!.settings.arguments as String;

    final provider = Provider.of<ProductProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: provider.getProductById(pId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final product = ProductModel.fromMap(snapshot.data!.data()!);
            return Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  color: Color(0xffEFEFEF),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'images/placeholder.jpg',
                    image: product.imageUrl!,
                    fadeInCurve: Curves.bounceInOut,
                    fadeInDuration: const Duration(seconds: 3),
                    width: MediaQuery.of(context).size.width - 100,
                    height: MediaQuery.of(context).size.height / 3.2,
                    fit: BoxFit.contain,
                  ),
                ),
                ListTile(
                  title: Text(
                    product.name!,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '৳${product.salePrice.toString()}',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.favorite_outline_sharp,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: RichText(
                    text: TextSpan(
                        text: "Description: ",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                            text: product.description ?? 'Not Available',
                            style: TextStyle(
                                color: Color(0xff666666),
                                fontWeight: FontWeight.normal),
                          )
                        ]),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            side: BorderSide(color:Theme.of(context).primaryColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {},
                        child: Text("Add your comment")),
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            side: BorderSide(color: Theme.of(context).primaryColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () async {
                          final canRate = await Provider.of<OrderProvider>(context,listen: false).canUserRateThisProduct(product.id!);
                         print(canRate);
                          if(canRate){
                            showMsg(context, "You can rate this product");
                          }else{
                            showMsg(context, "You can't rate for not buying this product");
                          }
                        },
                        child: Text("Rate this product")),
                  ],
                ),
                Spacer(),
                Consumer<CartProvider>(builder: (context, cartProvider, child) {
                  final isInCart = cartProvider.isInCart(product.id!);
                  return InkWell(
                    onTap: () {
                      if (isInCart) {
                        cartProvider.removeFromCart(product.id!);
                      } else {
                        final cartModel = CartModel(
                            productId: product.id!,
                            productName: product.name,
                            salePrice: product.salePrice,
                            imageUrl: product.imageUrl,
                            stock: product.stock,
                            category: product.category);
                        cartProvider.addToCart(cartModel);
                      }
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        height: 55,
                        width: MediaQuery.of(context).size.width - 40,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          trailing: Icon(
                            isInCart
                                ? Icons.remove_shopping_cart_outlined
                                : Icons.shopping_cart_outlined,
                            color: Color(0xfff2f2f2),
                          ),
                          title: Text(
                            isInCart ? "Remove from the cart" : "Add to cart",
                            style: TextStyle(
                                color: Color(0xfff2f2f2),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 10),
              ],
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
