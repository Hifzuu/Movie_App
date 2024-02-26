import 'package:flutter/material.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/models/movie.dart';

class MovieImageWidget extends StatelessWidget {
  final Movie movie;

  const MovieImageWidget({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        _getImageUrl(movie),
        filterQuality: FilterQuality.high,
        fit: BoxFit.cover,
        height: 450,
        width: 80,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) {
          // Handle the error, e.g., by providing a fallback image
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'lib/assets/images/image_not_found.jpg',
              filterQuality: FilterQuality.high,
              fit: BoxFit.cover,
              height: 100,
              width: 80,
            ),
          );
        },
      ),
    );
  }

  String _getImageUrl(Movie movie) {
    if (movie.backdropPath != null && movie.backdropPath!.isNotEmpty) {
      return '${api.imagePath}${movie.backdropPath}';
    } else if (movie.posterPath != null && movie.posterPath!.isNotEmpty) {
      return '${api.imagePath}${movie.posterPath}';
    } else {
      // Return the fallback image if both paths are empty
      return 'fallback_image_url';
    }
  }
}
