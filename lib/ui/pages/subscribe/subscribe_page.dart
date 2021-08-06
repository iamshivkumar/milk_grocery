import 'package:flutter/material.dart';
import 'package:grocery_app/core/models/product.dart';

class SubscribePage extends StatelessWidget {
  final Product product;

  const SubscribePage({Key? key, required this.product}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subscribe"),
      ),
    );
  }
}