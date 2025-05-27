import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:responsi/models/movie_model.dart';
import 'package:responsi/network/api_exception.dart';

class BaseNetwork {
  static const String _baseUrl = 'https://681388b3129f6313e2119693.mockapi.io/api/v1/';

  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/movie'));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Movie.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load movies: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }

  Future<Movie> getMovieDetail(String id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/movie/$id'));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromJson(data);
      } else {
        throw ApiException('Failed to load movie details: ${response.statusCode}');
      }
    } catch (e) {
      throw ApiException('Network error: ${e.toString()}');
    }
  }
}