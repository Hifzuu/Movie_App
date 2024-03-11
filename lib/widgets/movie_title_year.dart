import 'package:movie_assignment/models/movie.dart';

String getMovieTitleWithYear(Movie movie) {
  String title = movie.title;

  // Limit title to 2 lines
  if (title.length > 30) {
    title = '${title.substring(0, 30)}...';
  }

  String releaseYear = '(Unknown Year)';
  try {
    releaseYear = '(${DateTime.parse(movie.releaseDate!).year})';
  } catch (e) {
    // Handle the case where releaseDate is in an invalid format
    print('Error parsing release date: ${movie.releaseDate}');
  }

  // Concatenate title and releaseYear
  return '$title\n$releaseYear';
}
