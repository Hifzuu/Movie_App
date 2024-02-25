import 'package:http/http.dart' as http;
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/models/trailer.dart';
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

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&append_to_response=videos'),
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body);
      return Movie.fromJson(decodedData);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<List<Movie>> getTrendingMovies() async {
    final Response = await http.get(Uri.parse(_trendingUrl));
    if (Response.statusCode == 200) {
      final decodedData = json.decode(Response.body)['results'] as List;
      List<Movie> movies = await _getMoviesWithDetails(decodedData);
      return movies;
    } else {
      throw Exception('Error fetching trending movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final Response = await http.get(Uri.parse(_topRatedUrl));
    if (Response.statusCode == 200) {
      final decodedData = json.decode(Response.body)['results'] as List;
      List<Movie> movies = await _getMoviesWithDetails(decodedData);
      return movies;
    } else {
      throw Exception('Error fetching top-rated movies');
    }
  }

  Future<List<Movie>> getUpcomingMovies() async {
    final Response = await http.get(Uri.parse(_upcomingUrl));
    if (Response.statusCode == 200) {
      final decodedData = json.decode(Response.body)['results'] as List;
      List<Movie> movies = await _getMoviesWithDetails(decodedData);
      return movies;
    } else {
      throw Exception('Error fetching upcoming movies');
    }
  }

  Future<List<Movie>> _getMoviesWithDetails(List<dynamic> movieList) async {
    List<Movie> moviesWithDetails = [];

    for (dynamic movie in movieList) {
      int movieId = movie['id'];
      Movie movieDetails = await getMovieDetails(movieId);
      moviesWithDetails.add(movieDetails);
    }

    return moviesWithDetails;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final searchUrl =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      List<Movie> movies = await _getMoviesWithDetails(decodedData);
      return movies;
    } else {
      throw Exception('Error searching movies');
    }
  }
}
