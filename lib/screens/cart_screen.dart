import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    final _isLoading = false;

    return Scaffold(
      appBar: AppBar(
        title: Text("Shopping Cart"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(fontSize: 15),
                    ),
                    Chip(
                      label: Text(
                        '\$${cartData.totalAmount.toStringAsFixed(2)}',
                      ),
                      backgroundColor: Theme.of(context).primaryColorLight,
                    ),
                    OrderNowButton(cartData: cartData),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 500,
              child: ListView.builder(
                itemBuilder: (ctx, i) => CartItem(
                  productId: cartData.items.keys.toList().first,
                  id: cartData.items.values.toList()[i].id,
                  title: cartData.items.values.toList()[i].title,
                  quantity: cartData.items.values.toList()[i].quantity,
                  price: cartData.items.values.toList()[i].price,
                ),
                itemCount: cartData.itemCount,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderNowButton extends StatefulWidget {
  const OrderNowButton({
    Key? key,
    required this.cartData,
  }) : super(key: key);

  final Cart cartData;

  @override
  _OrderNowButtonState createState() => _OrderNowButtonState();
}

class _OrderNowButtonState extends State<OrderNowButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    return TextButton(
      onPressed: (widget.cartData.totalAmount == 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cartData.items.values.toList(),
                  widget.cartData.totalAmount,
                );
                widget.cartData.clear();
              } catch (error) {
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(
                      "Ordering failed...",
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              setState(() {
                _isLoading = false;
              });
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "ORDER NOW",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
    );
  }
}
