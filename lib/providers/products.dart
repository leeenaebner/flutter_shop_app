import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> addProduct(Product product) {
    final url =
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products.json";
    return http
        .post(
          Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }),
        )
        .then((response) => {
              _items.add(Product(
                id: json.decode(response.body)['name'],
                title: product.title,
                description: product.description,
                price: product.price,
                imageUrl: product.imageUrl,
              )),
              notifyListeners()
            })
        .catchError((err) {
      throw err;
    });
  }

  void updateProduct(String productId, Product product) {
    final productIndex = _items.indexWhere((p) => p.id == productId);
    if (productIndex >= 0) {
      _items[productIndex] = product;
      notifyListeners();
    }
  }

  void removeProduct(String productId) {
    _items.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  Product findById(String id) {
    return items.firstWhere((p) => p.id == id);
  }
}
