import 'package:flutter/material.dart';

class FavoritesProvider with ChangeNotifier {

  final List<String> _favorites = [];

  List<String> get favorites => _favorites;

  void toggleFavorite(String coffeeId) {

    if (_favorites.contains(coffeeId)) {
      _favorites.remove(coffeeId);
    } else {
      _favorites.add(coffeeId);
    }

    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.contains(id);
  }

}