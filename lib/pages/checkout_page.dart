import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_user_app/auth/auth_service.dart';
import 'package:e_commerce_user_app/providers/cart_provider.dart';
import 'package:e_commerce_user_app/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/order_provider.dart';

class CheckoutPage extends StatefulWidget {
  static const routeName = "check-out";
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  late CartProvider cartProvider;
  late OrderProvider orderProvider;
  late UserProvider userProvider;
  String groupValue = "COD";

  @override
  void didChangeDependencies() {
    cartProvider = Provider.of<CartProvider>(context);
    orderProvider = Provider.of<OrderProvider>(context);
    userProvider = Provider.of<UserProvider>(context);
    orderProvider.getOrderConstants();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(8),
              children: [
                Text(
                  "Product Info",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Card(
                  child: Column(
                    children: cartProvider.cartList
                        .map((cartModel) => ListTile(
                      dense: true,
                              title: Text(cartModel.productName!),
                              trailing: Text(
                                  "${cartModel.quantity}* ৳${cartModel.salePrice}"),
                            ))
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Payment Info",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text("Subtotal:"),
                        trailing: Text("৳${cartProvider.getCartSumtotal()}"),
                        dense: true,
                      ),
                      ListTile(
                        leading: Text("Discount(${orderProvider.orderConstantsModel.discount}%)"),
                        trailing: Text("৳${orderProvider.getDiscountAmount(cartProvider.getCartSumtotal())}"),
                        dense: true,
                      ),
                      ListTile(
                        leading: Text("Delivery Charge:"),
                        trailing: Text("৳${orderProvider.orderConstantsModel.deliveryCharge}"),
                        dense: true,
                      ),

                      ListTile(
                        leading: Text("Vat(15%)"),
                        trailing: Text("৳${orderProvider.getVatAmount(cartProvider.getCartSumtotal())}"),
                        dense: true,
                      ),
                      Divider(),
                      ListTile(
                        leading: Text("Grand total:", style: TextStyle(color: Colors.red),),
                        trailing: Text("৳${orderProvider.getGrandTotal(cartProvider.getCartSumtotal())}", style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),),
                        dense: true,

                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Delivery Address",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5,),
                Card(
                  child:  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream:  userProvider.getUserByUid(AuthService.user!.uid),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                        final userModel = UserModel.fromMap(snapshot.data!.data()!);
                        final addressModel = userModel.address;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(addressModel == null ? "No address found" : "${addressModel.streetAddress}\n ${addressModel.area}, ${addressModel.city}\n${addressModel.zipCode}"),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                  )
                                ),
                                  onPressed: (){}, child: Text("Change"))
                            ],
                          ),
                        );
                      }
                      if(snapshot.hasError){
                        return Center(child: Text("Failed to face data"),);
                      }
                      return Center(child: Text("Feacthing address..."),);
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Payment Method",
                  style: Theme.of(context).textTheme.headline6,
                  textAlign: TextAlign.center,
                ),
                Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListTile(
                          title: Text("COD"),
                          leading: Radio<String>(
                              value: "COD",
                              groupValue: groupValue,
                              fillColor: MaterialStateColor.resolveWith(
                                  (states) => groupValue == "COD"
                                      ? Colors.red
                                      : Colors.grey),
                              onChanged: (value) {
                                setState(() {
                                  groupValue = value as String;
                                });
                              }),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Online"),
                          leading: Radio<String>(
                            value: "Online",
                            groupValue: groupValue,
                            fillColor: MaterialStateColor.resolveWith((states) =>
                                groupValue == "Online" ? Colors.red : Colors.grey),
                            onChanged: (value) {
                              setState(() {
                                groupValue = value as String;
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15))),
                onPressed: () {},
                child: const Text("Place order")),
          )
        ],
      ),
    );
  }
}
