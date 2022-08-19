import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../pages/product_details_page.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, ProductDetailsPage.routeName,
            arguments: product.id);
      },
      child: Card(
        elevation:3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: FadeInImage.assetNetwork(
                  image: product.imageUrl.toString(),
                  height: 75,
                  placeholder: "assets/images/photos.png",
                  fadeInCurve: Curves.bounceInOut,
                  fadeInDuration: const Duration(seconds: 2),
                ),
              ),
            Spacer(),
            Divider(),
              Text(
                product.name.toString(),
                textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "৳${product.salePrice}",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                  InkWell(
                      onTap: (){},
                      child: Icon(Icons.shopping_cart_outlined,size: 20, color: Colors.red,))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
