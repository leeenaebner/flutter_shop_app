import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final loadedProducts = productsData.items;

    return GridView.builder(
      itemBuilder: (ctx, index) => ChangeNotifierProvider(
        create: (c) => loadedProducts[index],
        child: ProductItem(
            // loadedProducts[index].id,
            // loadedProducts[index].imageUrl,
            // loadedProducts[index].title,
            // loadedProducts[index].description,
            // loadedProducts[index].price,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
    );
  }
}
