import 'package:flutter/material.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/services/movie_api.dart';
import 'package:movie_assignment/views/details_view.dart';

class ShakeDetectionProvider with ChangeNotifier {
  bool _isShakeDetectionEnabled = false;

  bool get isShakeDetectionEnabled => _isShakeDetectionEnabled;

  set isShakeDetectionEnabled(bool value) {
    _isShakeDetectionEnabled = value;
    notifyListeners();
  }

  Future<void> handleShake(BuildContext context) async {
    if (isShakeDetectionEnabled) {
      try {
        Movie movie = await api().getRandomMovie();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsView(movie: movie),
          ),
        );
      } catch (e) {
        print('Error fetching and navigating to random movie: $e');
      }
    }
  }
}
