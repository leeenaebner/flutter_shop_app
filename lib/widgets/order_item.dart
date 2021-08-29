import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool isExpanded = false;

  void _toggleExpand() {
    isExpanded = !isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: isExpanded
          ? min(widget.order.products.length * 20.0 + 150, 200)
          : 110,
      child: Card(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            ListTile(
              title: Text("\$${widget.order.amount}"),
              subtitle: Text(
                DateFormat("dd/MM/yyyy hh:mm").format(
                  widget.order.dateTime,
                ),
              ),
              trailing: IconButton(
                icon: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: isExpanded
                  ? min(widget.order.products.length * 20.0 + 20, 600)
                  : 0,
              child: Container(
                height: min(widget.order.products.length * 20.0 + 20, 600),
                padding: EdgeInsets.all(10),
                child: ListView(
                  children: widget.order.products
                      .map(
                        (p) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              p.title,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text("${p.quantity} x ${p.price}"),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
