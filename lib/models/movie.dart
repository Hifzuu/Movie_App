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
  List<Trailer> trailers;

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
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? videosJson = json['videos'] as Map<String, dynamic>?;

    List<Trailer> trailers = [];
    if (videosJson != null) {
      List<dynamic> trailersJson = videosJson['results'];
      trailers = trailersJson.map((trailerJson) {
        return Trailer.fromJson(trailerJson);
      }).toList();
    }

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
      trailers: trailers,
    );
  }

  String toString() {
    String trailersString =
        trailers.map((trailer) => trailer.toString()).join("|*|");
    return '$id|$title|$backdropPath|$originalTitle|$overview|$posterPath|$releaseDate|$voteAverage|$duration|$trailersString';
  }

  factory Movie.fromString(String string) {
    try {
      List<String> parts = string.split('|');

      // Assuming trailers are the last part in the string
      List<Trailer> trailers = parts.last
          .split('|*|')
          .map((trailerString) => Trailer.fromString(trailerString))
          .toList();

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
        trailers: [],
      );
    }
  }

  String? get trailerKey {
    return trailers.isNotEmpty ? trailers[0].key : null;
  }
}
