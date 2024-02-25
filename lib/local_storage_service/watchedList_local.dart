import 'package:movie_assignment/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> addToWatchedListLocally(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watched movies list from local storage
    List<String>? watchedMovies = prefs.getStringList('watched_movies') ?? [];

    print('Existing watched movies: $watchedMovies');

    // Add the new movie to the list
    watchedMovies.add(movie.toString());

    print('Updated watched movies list: $watchedMovies');

    // Save the updated watched movies list back to local storage
    prefs.setStringList('watched_movies', watchedMovies);
    print('Watched movies list saved to local storage');
  }

  static Future<List<Movie>> getWatchedListLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the watched movies list from local storage
    List<String>? watchedMovies = prefs.getStringList('watched_movies');

    // Convert the list of strings back to a list of Movie objects
    List<Movie> watchedMovieList =
        watchedMovies?.map((string) => Movie.fromString(string)).toList() ?? [];

    return watchedMovieList;
  }

  static Future<void> removeFromWatchedListLocally(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watched movies list from local storage
    List<String>? watchedMovies = prefs.getStringList('watched_movies') ?? [];

    // Remove the movie with the specified ID from the list
    watchedMovies = watchedMovies.where((watchedMovie) {
      Movie movie = Movie.fromString(watchedMovie);
      return movie.id != movieId;
    }).toList();

    // Save the updated watched movies list back to local storage
    prefs.setStringList('watched_movies', watchedMovies);
  }
}
