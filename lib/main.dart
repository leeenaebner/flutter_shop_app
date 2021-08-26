import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: ChangeNotifierProvider(
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
              '/cart': (ctx) => CartScreen(),
              '/orders': (ctx) => OrdersScreen(),
            }),
      ),
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
