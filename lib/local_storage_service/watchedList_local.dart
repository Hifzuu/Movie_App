import 'package:movie_assignment/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static Future<void> addToWatchedListLocally(Movie movie) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the existing watched movies list from local storage
    List<String>? watchedMovies = prefs.getStringList('watched_movies') ?? [];

    print('Existing watched movies: $watchedMovies');

    try {
      // Convert the movie to a string representation
      String movieString = movie.toString();

      // Check if the movie is already in the list to avoid duplicates
      if (!watchedMovies.contains(movieString)) {
        // Add the new movie to the list
        watchedMovies.add(movieString);

        print('Updated watched movies list: $watchedMovies');

        // Save the updated watched movies list back to local storage
        prefs.setStringList('watched_movies', watchedMovies);
        print('Watched movies list saved to local storage');
      } else {
        print('Duplicate movie not added to watched list');
      }
    } catch (e) {
      // Handle any potential error during the process
      print('Error adding movie to watched list: $e');
    }
  }

  static Future<List<Movie>> getWatchedListLocally() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // Retrieve the watched movies list from local storage
      List<String>? watchedMovies = prefs.getStringList('watched_movies');

      // Check if the watchedMovies list is not null
      if (watchedMovies != null) {
        // Convert the list of strings back to a list of Movie objects
        List<Movie> watchedMovieList =
            watchedMovies.map((string) => Movie.fromString(string)).toList();

        return watchedMovieList;
      } else {
        // Return an empty list if watchedMovies is null
        return [];
      }
    } catch (e) {
      // Handle any potential error during the process
      print('Error getting watched movies list: $e');

      // Return an empty list in case of an error
      return [];
    }
  }

  static Future<void> removeFromWatchedListLocally(int movieId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // Retrieve the existing watched movies list from local storage
      List<String>? watchedMovies = prefs.getStringList('watched_movies') ?? [];

      // Remove the movie with the specified ID from the list
      watchedMovies = watchedMovies.where((watchedMovie) {
        Movie movie = Movie.fromString(watchedMovie);
        return movie.id != movieId;
      }).toList();

      // Save the updated watched movies list back to local storage
      prefs.setStringList('watched_movies', watchedMovies);
    } catch (e) {
      // Handle any potential error during the process
      print('Error removing movie from watched list: $e');
    }
  }
}
