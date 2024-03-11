import 'package:movie_assignment/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  // Add a movie to the local watchlist
  static Future<void> addToWatchListLocally(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watched movies list from local storage
    List<String>? toWatchMovies = prefs.getStringList('to_watch_movies') ?? [];

    // Add the new movie to the list
    toWatchMovies.add(movie.toString());

    // Save the updated watched movies list back to local storage
    prefs.setStringList('to_watch_movies', toWatchMovies);
  }

  // Get the local to-watch movies list
  static Future<List<Movie>> getToWatchListLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the watched movies list from local storage
    List<String>? toWatchMovies = prefs.getStringList('to_watch_movies');

    // Convert the list of strings back to a list of Movie objects
    List<Movie> toWatchMovieList =
        toWatchMovies?.map((string) => Movie.fromString(string)).toList() ?? [];

    return toWatchMovieList;
  }

  // Remove a movie from the local to-watch list
  static Future<void> removeToWatchListLocally(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watched movies list from local storage
    List<String>? toWatchMovies = prefs.getStringList('to_watch_movies') ?? [];

    // Remove the movie with the specified ID from the list
    toWatchMovies = toWatchMovies.where((toWatchMovies) {
      Movie movie = Movie.fromString(toWatchMovies);
      return movie.id != movieId;
    }).toList();

    // Save the updated watched movies list back to local storage
    prefs.setStringList('to_watch_movies', toWatchMovies);
  }
}
