import 'package:e_commerce_user_app/pages/cart_page.dart';
import 'package:e_commerce_user_app/providers/cart_provider.dart';
import 'package:e_commerce_user_app/widgets/app_slider.dart';
import 'package:e_commerce_user_app/widgets/main_drawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';
import '../widgets/show_loading.dart';

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
  void initState() {
    // TODO: implement initState
    super.initState();

    //todo foreground state
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);

        Navigator.pushNamed(context, message.data["path"]);
      }
    });

    // todo App is open but not terminated
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data["path"]);

        Navigator.pushNamed(context, message.data["path"]);
      }
    });

    //todo when the app is terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data["path"]);
        Navigator.pushNamed(context, message.data["path"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product",
        ),
        elevation: 0,
        actions: [
          InkWell(
            onTap: () => Navigator.pushNamed(context, CartPage.routeName),
            child: Stack(
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
                        color: Color(0xffff704d), shape: BoxShape.circle),
                    child: Consumer<CartProvider>(
                        builder: (context, provider, child) => FittedBox(
                            child: Text(provider.totalItemsInCart.toString()))),
                  ),
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: ImageIcon(AssetImage("assets/images/filter.png"))),
        ],
      ),
      drawer: MainDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: ((BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 165,
              flexibleSpace: FlexibleSpaceBar(
                background: AppSlider(),
                collapseMode: CollapseMode.parallax,
              ),
              leading: Container(),
              floating: true,
              elevation: 0,
              backgroundColor: Colors.white.withOpacity(0),
            ),
          ];
        }),
        body: Consumer<ProductProvider>(
          builder: (context, provider, child) => Column(
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
              Expanded(
                child: provider.productList.isEmpty
                    ? Center(
                        child: ListTile(
                          title: ShowLoading(),
                          subtitle: Text(
                            "No product found",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, top: 5),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 5 / 7,
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 5),
                        itemCount: provider.productList.length,
                        itemBuilder: (context, index) =>
                            ProductItem(product: provider.productList[index])),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
