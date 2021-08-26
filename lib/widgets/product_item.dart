import 'package:flutter/material.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Product>(context);
    final cartContainer = Provider.of<Cart>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: productData.id);
            },
            child: Image.network(productData.imageUrl, fit: BoxFit.cover)),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            productData.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, _) => IconButton(
              icon: Icon(productData.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border),
              onPressed: () => productData.toggleFavorite(),
              color: Theme.of(context).accentColor,
            ),
            // child: Text("never changes"),
          ),
          trailing: IconButton(
            iconSize: 30,
            icon: Icon(Icons.shopping_cart),
            onPressed: () => cartContainer.addItem(
                productData.id, productData.price, productData.title),
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
