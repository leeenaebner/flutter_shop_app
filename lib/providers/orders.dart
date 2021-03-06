import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String? _authToken;
  final String? _userId;

  Orders(this._authToken, this._userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndStoreOrders() async {
    final url =
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/orders/$_userId.json?auth=$_authToken";

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        return;
      }
      final List<OrderItem> loadedOrders = [];
      extractedData.forEach((key, value) {
        loadedOrders.add(OrderItem(
            id: key,
            amount: value['amount'],
            products: (value['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price']))
                .toList(),
            dateTime: DateTime.parse(value['dateTime'])));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/orders/$_userId.json?auth=$_authToken";

    try {
      final timestamp = DateTime.now();

      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((p) => {
                      'id': p.id,
                      'title': p.title,
                      'quantity': p.quantity,
                      'price': p.price
                    })
                .toList(),
          }));
      final _newOrder = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timestamp,
        products: cartProducts,
      );

      _orders.add(_newOrder);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
