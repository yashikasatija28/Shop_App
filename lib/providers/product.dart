import 'dart:convert';
import '../providers/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  var id;
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

  get userId => null;

  get token => null;

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(token, userId) async {
    final oldstatus = isFavorite;
    isFavorite = !isFavorite;
    final url = Uri.https(
        'flutter-shop-app-c99a5-default-rtdb.firebaseio.com/$userId/',
        '/Products/$id.json?auth=$token');
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }));
      if (response.statusCode >= 400) {
        _setFavValue(oldstatus);
      }
    } catch (error) {
      _setFavValue(oldstatus);
    }
    notifyListeners();
  }
}
