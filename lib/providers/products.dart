import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';

// final URL =
//     "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products.json";

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String? authToken;
  final String? userId;

  Products(this.authToken, this.userId, this._items);
  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndStoreProducts([bool filterByUser = false]) async {
    var url =
        'https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken';
    if (filterByUser) url += '&orderBy="creatorId"&equalTo="$userId"';

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;

      if (extractedData == null) {
        return;
      }
      url =
          "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken";
      final favoritesResponse = await http.get(Uri.parse(url));
      final favoritesData = json.decode(favoritesResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: favoritesData == null
                ? false
                : favoritesData[key]['isFavorite'] ?? false,
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
    final url =
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products.json?auth=$authToken";

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': userId,
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
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken";

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
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products/$productId.json?auth=$authToken";
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
