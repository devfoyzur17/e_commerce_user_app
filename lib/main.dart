import 'package:e_commerce_user_app/pages/launcher_page.dart';
import 'package:e_commerce_user_app/pages/login_page.dart';
import 'package:e_commerce_user_app/pages/product_details_page.dart';
import 'package:e_commerce_user_app/pages/products_page.dart';
import 'package:e_commerce_user_app/providers/order_provider.dart';
import 'package:e_commerce_user_app/providers/product_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => ProductProvider(),
    ),
    ChangeNotifierProvider(
      create: (context) => OrderProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Map<int, Color> pokeballRedSwatch = {
      50: const Color.fromARGB(255, 230, 66, 25),
      100: const Color.fromARGB(255, 230, 66, 25),
      200: const Color.fromARGB(255, 230, 66, 25),
      300: const Color.fromARGB(255, 230, 66, 25),
      400: const Color.fromARGB(255, 230, 66, 25),
      500: const Color.fromARGB(255, 230, 66, 25),
      600: const Color.fromARGB(255, 230, 66, 25),
      700: const Color.fromARGB(255, 230, 66, 25),
      800: const Color.fromARGB(255, 230, 66, 25),
      900: const Color.fromARGB(255, 230, 66, 25),
    };
    MaterialColor appColor = MaterialColor(0xffe64219, pokeballRedSwatch);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: appColor,
      ),
      initialRoute: LauncherPage.routeName,
      routes: {
        LauncherPage.routeName: (context) => const LauncherPage(),
        LoginPage.routeName: (context) => const LoginPage(),
        ProductPage.routeName: (context) => const ProductPage(),
        ProductDetailsPage.routeName: (context) => ProductDetailsPage(),
      },
    );
  }
}
