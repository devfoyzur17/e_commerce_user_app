import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/helper_function.dart';

class ProductDetailsPage extends StatelessWidget {
  static const routeName = "product-details-page";
  ProductDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pId = ModalRoute.of(context)!.settings.arguments as String;

   final provider =   Provider.of<ProductProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Details"),
      ),
      body:  StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: provider.getProductById(pId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final product = ProductModel.fromMap(snapshot.data!.data()!);
              return ListView(
                children: [
                  Container(
                    color: Colors.white,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/placeholder.jpg',
                      image: product.imageUrl!,
                      fadeInCurve: Curves.bounceInOut,
                      fadeInDuration: const Duration(seconds: 3),
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.fitHeight,
                    ),
                  ),

                  ListTile(
                    title: Text(product.name!),

                  ),
                  ListTile(
                    title: Text('৳${product.salePrice.toString()}'),

                  ),
                  ListTile(
                    title: const Text('Product Description'),
                    subtitle: Text(product.description ?? 'Not Available'),

                  ),

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

  void _showPurchaseHistoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: const Text(
                    "Purchase History",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                ),
                Divider(),
                Expanded(
                  child: ListView.builder(
                      itemCount: context
                          .read<ProductProvider>()
                          .purchaseListOfSpecificProduct
                          .length,
                      itemBuilder: (context, index) {
                        final purchaseModel = context
                            .read<ProductProvider>()
                            .purchaseListOfSpecificProduct[index];
                        return Column(
                          children: [
                            ListTile(

                              title: Text(getFormatedDateTime(
                                  purchaseModel.dateModel.timestamp.toDate(),
                                  "dd/MM/yyyy")),
                              subtitle: Text(
                                  "Quantity: ${purchaseModel.quantity.toString()}"),
                              trailing:
                                  Text('৳ ${purchaseModel.purchaseprice} '),

                            ),
                            Divider(
                              height: 2,
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ));
  }



}
