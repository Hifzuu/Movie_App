import 'package:movie_assignment/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> addToWatchListLocally(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watched movies list from local storage
    List<String>? toWatchMovies = prefs.getStringList('to_watch_movies') ?? [];

    // Add the new movie to the list
    toWatchMovies.add(movie
        .toString()); // Assuming toString is implemented in your Movie class

    // Save the updated watched movies list back to local storage
    prefs.setStringList('to_watch_movies', toWatchMovies);
  }

  static Future<List<Movie>> getToWatchListLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the watched movies list from local storage
    List<String>? toWatchMovies = prefs.getStringList('to_watch_movies');

    // Convert the list of strings back to a list of Movie objects
    List<Movie> toWatchMovieList =
        toWatchMovies?.map((string) => Movie.fromString(string))?.toList() ??
            [];

    return toWatchMovieList;
  }

  static Future<void> removeToWatchListLocally(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watched movies list from local storage
    List<String>? toWatchMovies = prefs.getStringList('to_watch_movies') ?? [];

    // Remove the specified movie from the list
    toWatchMovies.remove(movie.toString());

    // Save the updated watched movies list back to local storage
    prefs.setStringList('to_watch_movies', toWatchMovies);
  }
}
