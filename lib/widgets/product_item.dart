
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
      onTap: (){
        Navigator.pushNamed(context, ProductDetailsPage.routeName, arguments: product.id);
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(


            children: [
              FadeInImage.assetNetwork(
                image: product.imageUrl.toString(),
                height: 70,
                placeholder: "assets/images/photos.png",
                fadeInCurve: Curves.bounceInOut,
                fadeInDuration: const Duration(seconds: 2),
              ),
              SizedBox(height: 5,),

              Text(
                product.name.toString(),textAlign: TextAlign.start,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("৳${product.salePrice}", style: TextStyle(color: Colors.red,fontSize: 12),),
                  IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart_outlined,size: 18,)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
