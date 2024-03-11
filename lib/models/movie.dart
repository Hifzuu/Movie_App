import 'package:movie_assignment/models/trailer.dart';

class Movie {
  final int id;
  final String title;
  final String backdropPath;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final int duration;
  List<Trailer> trailers; // List of trailers associated with the movie
  String genres;

  // Constructor to create a Movie instance
  Movie({
    required this.id,
    required this.title,
    required this.backdropPath,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.duration,
    required this.trailers,
    required this.genres,
  });

  // Factory method to create a Movie instance from JSON data
  factory Movie.fromJson(Map<String, dynamic> json) {
    List<Trailer> trailers = [];

    // Check if "videos" key is present in the JSON
    if (json.containsKey('videos')) {
      // trailers under results key
      List<dynamic> trailersJson = json['videos']['results'];

      // Parse trailers
      trailers = trailersJson.map((trailerJson) {
        return Trailer.fromJson(trailerJson);
      }).toList();
    }

    // Extract genre information from JSON
    List<dynamic> genreList = json['genres'];
    String genresString = genreList.map((genre) => genre['name']).join(', ');

    // Create and return a Movie instance
    return Movie(
      id: json['id'] as int? ?? 0,
      title: json["title"] ?? "",
      backdropPath: json["backdrop_path"] ?? "",
      originalTitle: json["original_title"] ?? "",
      overview: json["overview"] ?? "",
      posterPath: json["poster_path"] ?? "",
      releaseDate: json["release_date"]?.toString() ?? "",
      voteAverage: json["vote_average"]?.toDouble() ?? 0.0,
      duration: json["runtime"] as int? ?? 0,
      genres: genresString,
      trailers: trailers,
    );
  }

  // Convert Movie instance to a string
  String toString() {
    String trailersString =
        trailers.map((trailer) => trailer.toString()).join("|*|");
    // Return a formatted string representing the Movie instance
    return '$id|$title|$backdropPath|$originalTitle|$overview|$posterPath|$releaseDate|$voteAverage|$duration|$genres|$trailersString';
  }

  // Factory method to create a Movie instance from a string representation
  factory Movie.fromString(String string) {
    try {
      // Split the input string into parts
      List<String> parts = string.split('|');

      // Extract trailer information from the last part of the string
      List<Trailer> trailers = parts.last
          .split('|*|')
          .map((trailerString) => Trailer.fromString(trailerString))
          .toList();

      // Create and return a Movie instance
      return Movie(
        id: int.parse(parts[0]),
        title: parts[1],
        backdropPath: parts[2],
        originalTitle: parts[3],
        overview: parts[4],
        posterPath: parts[5],
        releaseDate: parts[6],
        voteAverage: double.parse(parts[7]),
        duration: int.parse(parts[8]),
        genres: parts[9],
        trailers: trailers,
      );
    } catch (e) {
      // Handle other potential errors during the process
      print('Error creating Movie from string: $string\nError: $e');
      return Movie(
        id: 0,
        title: 'Invalid Movie',
        backdropPath: '',
        originalTitle: '',
        overview: '',
        posterPath: '',
        releaseDate: '',
        voteAverage: 0.0,
        duration: 0,
        genres: '',
        trailers: [],
      );
    }
  }

  // Get the key of the first trailer, if available
  String? get trailerKey {
    return trailers.isNotEmpty ? trailers[0].key : null;
  }
}
