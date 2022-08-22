import 'package:e_commerce_user_app/models/cart_model.dart';

import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final CartModel cartModel;
  final num priceWithQuantity;
  final VoidCallback onIncrease, onDecrease, onDelete;
  const CartItem({
    Key? key,
    required this.cartModel,
    required this.priceWithQuantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(cartModel.imageUrl!),
              ),
              title: Text(cartModel.productName!),
              subtitle: Text("৳${cartModel.salePrice.toString()}"),
              trailing: Text(
                "৳${priceWithQuantity}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Row(
                children: [
                  SizedBox(width: 60,),
                  IconButton(
                      onPressed: onDecrease,
                      icon: Icon(
                        Icons.remove_circle,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      )),
                  Text(cartModel.quantity.toString()),
                  IconButton(
                      onPressed: onIncrease,
                      icon: Icon(
                        Icons.add_circle,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      )),
                  Spacer(),
                  IconButton(
                      onPressed: onDelete,
                      icon: Icon(
                        Icons.delete,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
