import 'package:movie_assignment/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> addToWatchedListLocally(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watched movies list from local storage
    List<String>? watchedMovies = prefs.getStringList('watched_movies') ?? [];

    // Add the new movie to the list
    watchedMovies.add(movie
        .toString()); // Assuming toString is implemented in your Movie class

    // Save the updated watched movies list back to local storage
    prefs.setStringList('watched_movies', watchedMovies);
  }

  static Future<List<Movie>> getWatchedListLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the watched movies list from local storage
    List<String>? watchedMovies = prefs.getStringList('watched_movies');

    // Convert the list of strings back to a list of Movie objects
    List<Movie> watchedMoviesList = watchedMovies?.map((string) {
          Movie movie = Movie.fromString(string);
          print('Movie details from local storage: ${movie.toString()}');
          return movie;
        }).toList() ??
        [];

    return watchedMoviesList;
  }

  static Future<void> removeFromWatchedListLocally(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watched movies list from local storage
    List<String>? watchedMovies = prefs.getStringList('watched_movies') ?? [];

    // Remove the specified movie from the list
    watchedMovies.remove(movie.toString());

    // Save the updated watched movies list back to local storage
    prefs.setStringList('watched_movies', watchedMovies);
  }
}
