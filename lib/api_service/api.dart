import 'package:http/http.dart' as http;
import 'package:movie_assignment/models/movie.dart';
import 'dart:convert';

class api {
  static const apiKey = '28bfc42e2b6e932f53de275690379158';
  static const imagePath = 'https://image.tmdb.org/t/p/w500';

  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey';

  static const _topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey';

  static const _upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey';

  Future<List<Movie>> getTrendingMovies() async {
    final Response = await http.get(Uri.parse(_trendingUrl));
    if (Response.statusCode == 200) {
      final decodedData = json.decode(Response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('error');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final Response = await http.get(Uri.parse(_topRatedUrl));
    if (Response.statusCode == 200) {
      final decodedData = json.decode(Response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('error');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final Response = await http.get(Uri.parse(_upcomingUrl));
    if (Response.statusCode == 200) {
      final decodedData = json.decode(Response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('error');
    }
  }
}
