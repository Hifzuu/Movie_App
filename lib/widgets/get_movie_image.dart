import 'package:flutter/material.dart';
import 'package:movie_assignment/services/movie_api.dart';
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
          //fallback image
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
    if (movie.posterPath.isNotEmpty) {
      return '${api.imagePath}${movie.posterPath}';
    } else if (movie.backdropPath.isNotEmpty) {
      return '${api.imagePath}${movie.backdropPath}';
    } else {
      //fallback image if both paths are empty
      return 'lib/assets/images/image_not_found.jpg';
    }
  }
}
