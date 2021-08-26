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
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(_selectedProduct.imageUrl),
          ),
          SizedBox(height: 10),
          Chip(
            label: Text(
              '\$ ${_selectedProduct.price}',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              _selectedProduct.description,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
