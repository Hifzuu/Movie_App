import 'package:movie_assignment/models/movie.dart';

String getMovieTitleWithYear(Movie movie) {
  String title = movie.title ?? 'Unknown Title';

  String releaseYear = '(Unknown Year)';
  if (movie.releaseDate != null) {
    try {
      releaseYear = '(${DateTime.parse(movie.releaseDate!).year})';
    } catch (e) {
      // Handle the case where releaseDate is in an invalid format
      print('Error parsing release date: ${movie.releaseDate}');
    }
  }

  return '$title $releaseYear';
}
