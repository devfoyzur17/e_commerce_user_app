import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce_user_app/providers/cart_provider.dart';
import 'package:e_commerce_user_app/widgets/main_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';

class ProductPage extends StatefulWidget {
  static const routeName = "product-page";
  const ProductPage({Key? key}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ProductProvider productProvider;
  late CartProvider cartProvider;
  int _chipValue = 0;
  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    productProvider.getAllProducts();
    productProvider.getAllFeatureProducts();
    cartProvider.getAllCartItems();
    Provider.of<ProductProvider>(context, listen: false).getAllCategories();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product",
        ),

        // elevation: 3,

        actions: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.shopping_cart,
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: EdgeInsets.all(1),
                  alignment: Alignment.center,
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                  child: Consumer<CartProvider>(
                      builder: (context, provider, child) => FittedBox(
                          child: Text(provider.totalItemsInCart.toString()))),
                ),
              )
            ],
          ),
          IconButton(
              onPressed: () {},
              icon: ImageIcon(AssetImage("assets/images/filter.png"))),
        ],
      ),
      drawer: MainDrawer(),
      body: Consumer<ProductProvider>(
        builder: (context, provider, _) => Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 70,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.categoryNameList.length,
                  itemBuilder: (context, index) {
                    final category = provider.categoryNameList[index];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ChoiceChip(
                        elevation: 5,
                        backgroundColor: Color(0xffEFEFEF),
                        selectedShadowColor: Color(0xffff8566),
                        selectedColor: Theme.of(context).primaryColor,
                        label: Text(category),
                        selected: _chipValue == index,
                        onSelected: (value) {
                          setState(() {
                            _chipValue = value ? index : 0;
                          });
                          if (_chipValue == 0) {
                            provider.getAllProducts();
                          } else {
                            provider.getAllProductsByCategory(
                                provider.categoryNameList[_chipValue]);
                          }
                        },
                        labelStyle: _chipValue == index
                            ? TextStyle(color: Colors.white)
                            : TextStyle(color: Color(0xff666666)),
                      ),
                    );
                  }),
            ),
            if (provider.featureProductList.isNotEmpty)
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Featured Products",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Divider(
                    height: 1.5,
                  ),
                  CarouselSlider.builder(
                      itemCount: provider.featureProductList.length,
                      itemBuilder: (context, index, realIndex) {
                        final product = provider.featureProductList[index];
                        return Card(
                          elevation: 5,
                          color: Color(0xffEFEFEF),
                          child: Stack(
                            children: [
                              FadeInImage.assetNetwork(
                                image: product.imageUrl.toString(),
                                height: 150,
                                placeholder: "assets/images/photos.png",
                                fadeInCurve: Curves.bounceInOut,
                                fadeInDuration: const Duration(seconds: 2),
                                width: double.infinity,
                                // fit: BoxFit.fill,
                              ),
                              Positioned(
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  alignment: Alignment.center,
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.6),
                                  child: Text(
                                    product.name!,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                bottom: 0,
                                left: 0,
                                right: 0,
                              )
                            ],
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 150,
                        aspectRatio: 16 / 9,
                        viewportFraction: 0.7,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ))
                ],
              ),
            Divider(),
            provider.productList.isEmpty
                ? const Center(
                    child: Text("No item found"),
                  )
                : Expanded(
                    child: GridView.builder(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, top: 5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 4 / 5,
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 5),
                        itemCount: provider.productList.length,
                        itemBuilder: (context, index) =>
                            ProductItem(product: provider.productList[index])),
                  ),
          ],
        ),
      ),
    );
  }
}
