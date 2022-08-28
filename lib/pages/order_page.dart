
import 'package:e_commerce_user_app/providers/order_provider.dart';
import 'package:e_commerce_user_app/utils/helper_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  static const routeName = "order-page";
  const OrderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<OrderProvider>(context,listen: false).getOrdersByUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Order"),
      ),

      body: Consumer<OrderProvider>(
        builder: (context, provider, child) =>
         provider.orderList.isNotEmpty ?   ListView.builder(
          itemCount: provider.orderList.length,
            itemBuilder: (context,index){
            final orderModel = provider.orderList[index];
            return ListTile(
              title: Text(getFormatedDateTime(orderModel.orderDate.timestamp.toDate(), "dd/MM/yyy hh:mm:ss a")),
              subtitle: Text(orderModel.orderStatus),
              trailing: Text("৳${orderModel.grandTotal.round()}"),
            );

            }):
             Center(
               child: Text("You have no order yet!"),
             )
      ),


    );
  }
}
