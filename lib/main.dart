import 'package:flutter/material.dart';
import './screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
          title: 'Shopping App',
          theme: ThemeData(
              primarySwatch: Colors.brown,
              accentColor: Colors.orangeAccent,
              fontFamily: 'Lato'),
          //home: ProductsOverviewScreen(),
          routes: {
            '/': (ctx) => ProductsOverviewScreen(),
            '/product-details': (ctx) => ProductDetailScreen(),
          }),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping App"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome',
            ),
          ],
        ),
      ),
    );
  }
}
