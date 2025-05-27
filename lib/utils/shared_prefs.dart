import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:responsi/models/movie_model.dart';

class SharedPrefs {
  static const String _favoritesKey = 'favorites';

Future<List<Movie>> getFavorites() async {
  final prefs = await SharedPreferences.getInstance();
  final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
  return favoritesJson
      .map((json) => Movie.fromJson(jsonDecode(json)))
      .toList();
}

Future<void> saveFavorites(List<Movie> favorites) async {
  final prefs = await SharedPreferences.getInstance();
  final favoritesJson = 
      favorites.map((m) => jsonEncode(m.toJson())).toList();
  await prefs.setStringList(_favoritesKey, favoritesJson);
}
}