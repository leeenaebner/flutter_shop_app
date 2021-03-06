import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return _items;
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;

    _items.forEach((key, value) {
      total += value.quantity * value.price;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
                quantity: existingItem.quantity + 1,
                price: existingItem.price,
                title: existingItem.title,
                id: existingItem.id,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toIso8601String(),
              title: title,
              price: price,
              quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((key, value) => key == productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity > 1) {
      _items.update(
          productId,
          (item) => CartItem(
              id: item.id,
              title: item.title,
              quantity: item.quantity - 1,
              price: item.price));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
