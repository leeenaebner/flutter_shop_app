import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';

final URL =
    "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products.json";

class Products with ChangeNotifier {
  List<Product> _items = [];
  // List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndStoreProducts() async {
    try {
      final response = await http.get(Uri.parse(URL));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;

      if (extractedData == null) {
        return;
      }

      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final response = await http.post(Uri.parse(URL),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          }));
      final _newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _items.add(_newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String productId, Product product) async {
    final productIndex = _items.indexWhere((p) => p.id == productId);
    final url =
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json";

    if (productIndex >= 0) {
      try {
        await http.patch(Uri.parse(url),
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
            }));
      } catch (error) {
        throw error;
      }
      _items[productIndex] = product;
      notifyListeners();
    }
  }

  Future<void> removeProduct(String productId) async {
    final url =
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json";
    final _exitingProductIdx = _items.indexWhere((p) => p.id == productId);
    Product? _existingProduct = _items[_exitingProductIdx];
    _items.removeAt(_exitingProductIdx);
    notifyListeners();
    try {
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode >= 400) {
        throw HttpException("Problems deleting product...");
      }
      _existingProduct = null;
      notifyListeners();
    } catch (error) {
      _items.insert(_exitingProductIdx, _existingProduct!);
      notifyListeners();
    }
  }

  Product findById(String id) {
    return items.firstWhere((p) => p.id == id);
  }
}
