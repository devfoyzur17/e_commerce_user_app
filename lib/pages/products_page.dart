
import 'package:e_commerce_user_app/widgets/custom_slider.dart';
import 'package:e_commerce_user_app/widgets/main_drawer.dart';
import 'package:e_commerce_user_app/widgets/show_loading.dart';
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
  int _chipValue = 0;
  @override
  void didChangeDependencies() {
    productProvider = Provider.of<ProductProvider>(context,listen: false);
    productProvider.getAllProducts();
    Provider.of<ProductProvider>(context,listen: false).getAllCategories();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Product",style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white10,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black
        ),

      ),
      drawer: MainDrawer(),


      body: Consumer<ProductProvider>(
          builder: (context, provider, _) => provider.productList.isEmpty
              ? const Center(
            child: ShowLoading(),

          )
              : Column(

                children: [
                  const AppSlider(),
                  SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.categoryList.length,
                      itemBuilder: (context, index) {
                        final category = provider.categoryList[index];
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: ChoiceChip(
                            elevation: 2,

                            backgroundColor: Color(0xfff2f2f2),

                            selectedShadowColor: Theme.of(context).primaryColor,
                            selectedColor: Colors.deepOrange,
                            label: Text(category.catName!),
                            selected: _chipValue == index,
                            onSelected: (value){
                              setState(() {
                                _chipValue = value? index:0;
                              });
                            },
                          ),
                        );
                      }),
                  ),


                  Expanded(
                    child: GridView.builder(

            padding:const EdgeInsets.only(left: 5,right: 5,top: 5),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 4/5,
                        crossAxisCount: 3, crossAxisSpacing: 0, mainAxisSpacing: 5),
                    itemCount: provider.productList.length,
                    itemBuilder: (context, index) => ProductItem(product: provider.productList[index])),
                  ),
                ],
              ),),




    );
  }
}
