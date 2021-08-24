import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final double price;
  // final double description;

  static const String routeName = "/product-details";

  ProductDetailScreen();

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final productsData = Provider.of<Products>(context, listen: false);
    final _selectedProduct = productsData.findById(productId);

    return Scaffold(
      appBar: AppBar(title: Text(_selectedProduct.title)),
      body: Column(
        children: [
          Text(_selectedProduct.description),
        ],
      ),
    );
  }
}
