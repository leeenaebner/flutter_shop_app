import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> updateProductIsFavorite(String token, String userId) async {
    final oldValue = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token";

    try {
      final response = await http.put(Uri.parse(url),
          body: json.encode({
            'isFavorite': isFavorite,
          }));

      if (response.statusCode >= 400) {
        isFavorite = oldValue;
        notifyListeners();
      }
    } catch (error) {
      isFavorite = oldValue;
      notifyListeners();
      throw error;
    }
  }
}
