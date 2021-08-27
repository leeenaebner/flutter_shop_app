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

  Future<void> updateProductIsFavorite() async {
    final newValue = !isFavorite;
    final url =
        "https://flutter-shop-app-91947-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json";

    try {
      await http.patch(Uri.parse(url),
          body: json.encode({
            'isFavorite': newValue,
          }));
    } catch (error) {
      isFavorite = !newValue;
      throw error;
    }
    this.isFavorite = newValue;
    notifyListeners();
  }
}
