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
    final scaffold = ScaffoldMessenger.of(context);

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
              onPressed: () async {
                try {
                  await productData.updateProductIsFavorite();
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        "Updating Favorite Status failed",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          trailing: IconButton(
            iconSize: 30,
            icon: Icon(Icons.shopping_cart),
            onPressed: () => {
              cartContainer.addItem(
                  productData.id, productData.price, productData.title),
              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart!'),
                  duration: Duration(
                    seconds: 2,
                  ),
                  action: SnackBarAction(
                    label: "Undo",
                    onPressed: () =>
                        cartContainer.removeSingleItem(productData.id),
                  ),
                ),
              ),
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
