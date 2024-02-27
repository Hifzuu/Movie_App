import 'package:http/http.dart' as http;
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/models/trailer.dart';
import 'dart:convert';

class api {
  static const apiKey = '?api_key=28bfc42e2b6e932f53de275690379158';
  static const imagePath = 'https://image.tmdb.org/t/p/w500';

  static const _trendingUrl =
      'https://api.themoviedb.org/3/trending/movie/day$apiKey';

  static const _topRatedUrl =
      'https://api.themoviedb.org/3/movie/top_rated$apiKey';

  static const _upcomingUrl =
      'https://api.themoviedb.org/3/movie/upcoming$apiKey';

  static const _popularUrl =
      'https://api.themoviedb.org/3/movie/popular$apiKey';

  Future<Movie> getMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId$apiKey&append_to_response=videos'),
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

  Future<List<Movie>> getPopularMovies() async {
    final Response = await http.get(Uri.parse(_popularUrl));
    if (Response.statusCode == 200) {
      final decodedData = json.decode(Response.body)['results'] as List;
      List<Movie> movies = await _getMoviesWithDetails(decodedData);
      return movies;
    } else {
      throw Exception('Error fetching popular movies');
    }
  }

  Future<List<Movie>> _getMoviesWithDetails(List<dynamic> movieList) async {
    List<Movie> moviesWithDetails = [];

    for (dynamic movie in movieList) {
      try {
        int movieId = movie['id'];
        Movie movieDetails = await getMovieDetails(movieId);
        moviesWithDetails.add(movieDetails);
      } catch (e) {
        print('Error processing movie: $e');
        // Handle the error, e.g., exclude the movie or log the issue
      }
    }

    return moviesWithDetails;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final searchUrl =
        'https://api.themoviedb.org/3/search/movie$apiKey&query=$query';

    final response = await http.get(Uri.parse(searchUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      List<Movie> movies = await _getMoviesWithDetails(decodedData);
      return movies;
    } else {
      throw Exception('Error searching movies');
    }
  }

  Future<String> getMovieTrailerKey(int movieId) async {
    final response = await http.get(
      Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos$apiKey',
      ),
    );

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      if (decodedData.isNotEmpty) {
        return decodedData[0]['key'];
      } else {
        throw Exception('No trailer available for this movie.');
      }
    } else {
      throw Exception('Failed to load movie trailer key');
    }
  }

  Future<List<Movie>> getSimilarMovies(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.themoviedb.org/3/movie/$movieId/recommendations$apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        print(
            'Similar Movies API Response: $decodedData'); // Print the entire response

        if (decodedData.containsKey('results')) {
          final results = decodedData['results'] as List?;
          if (results != null) {
            List<Movie> similarMovies = await _getMoviesWithDetails(results);
            print('Similar Movies List: $similarMovies');
            return similarMovies;
          }
        }

        print('Similar Movies List is null or empty.');
        return [];
      } else if (response.statusCode == 400) {
        print('Invalid request. Status code: 400');
        return [];
      } else {
        print(
            'Failed to load movie recommendations. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching similar movies: $e');
      return [];
    }
  }

  Future<List<Movie>> getMoviesByGenre(String genreId) async {
    final genreMoviesUrl =
        'https://api.themoviedb.org/3/discover/movie$apiKey&with_genres=$genreId';

    final response = await http.get(Uri.parse(genreMoviesUrl));

    if (response.statusCode == 200) {
      final decodedData = json.decode(response.body)['results'] as List;
      List<Movie> movies = await _getMoviesWithDetails(decodedData);
      return movies;
    } else {
      throw Exception('Error fetching movies by genre');
    }
  }
}
