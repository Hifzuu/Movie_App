import 'dart:ffi';

class Movie {
  int id;
  String title;
  String backdropPath;
  String originalTitle;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;
  int duration;

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
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
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
    );
  }

  String toString() {
    // Convert the Movie object to a string representation
    return '$id|$title|$backdropPath|$originalTitle|$overview|$posterPath|$releaseDate|$voteAverage|$duration';
  }

  factory Movie.fromString(String string) {
    // Create a Movie object from a string representation
    List<String> parts = string.split('|');
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
    );
  }
}
