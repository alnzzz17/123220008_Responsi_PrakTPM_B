import 'package:flutter/material.dart';

import 'package:responsi/models/movie_model.dart';
import 'package:responsi/utils/shared_prefs.dart';


abstract class FavoriteView {
  void showFavorites(List<Movie> favorites);
  void showError(String message);
}

class FavoritePresenter extends ChangeNotifier {
  final SharedPrefs _sharedPrefs;
  List<Movie> _favorites = [];

  FavoritePresenter(this._sharedPrefs);

  List<Movie> get favorites => _favorites;

  Future<List<Movie>> getFavorites() async {
    try {
      _favorites = await _sharedPrefs.getFavorites();
      notifyListeners();
      return _favorites;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addFavorite(Movie movie) async {
    try {
      if (!_favorites.any((m) => m.id == movie.id)) {
        _favorites.add(movie);
        await _sharedPrefs.saveFavorites(_favorites);
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeFavorite(String movieId) async {
    try {
      _favorites.removeWhere((m) => movieId == m.id);
      await _sharedPrefs.saveFavorites(_favorites);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> isFavorite(String movieId) async {
    try {
      final currentFavorites = await _sharedPrefs.getFavorites();
      return currentFavorites.any((m) => m.id == movieId);
    } catch (e) {
      rethrow;
    }
  }
}
