import 'package:flutter/material.dart';

class RecomandedPage extends StatelessWidget {
  static const routeName = "recomanded";
  const RecomandedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recomanded Page"),
      ),
      body: Center(
        child: Text("Your recomanded product!"),
      ),
    );
  }
}
