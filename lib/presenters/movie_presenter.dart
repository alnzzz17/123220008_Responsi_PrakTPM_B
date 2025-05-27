import 'package:flutter/material.dart';

import 'package:responsi/models/movie_model.dart';
import 'package:responsi/network/base_network.dart';

abstract class MovieView {
  void showMovies(List<Movie> movies);
  void showMovieDetail(Movie movie);
  void showError(String message);
  void showLoading();
  void hideLoading();
}

class MoviePresenter extends ChangeNotifier {
  final BaseNetwork _apiService;
  List<Movie> _movies = [];
  Movie? _selectedMovie;

  MoviePresenter(this._apiService);

  List<Movie> get movies => _movies;
  Movie? get selectedMovie => _selectedMovie;

  Future<List<Movie>> getMovies() async {
    try {
      _movies = await _apiService.getMovies();
      notifyListeners();
      return _movies;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Movie>> getMovieDetail(String id) async {
    try {
      _selectedMovie = await _apiService.getMovieDetail(id);
      notifyListeners();
      if (_selectedMovie != null) {
        return [_selectedMovie!];
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }

}
