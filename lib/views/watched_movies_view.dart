import 'package:flutter/material.dart';

class WatchedMoviesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the list of watched movies (replace with your data fetching logic)
    List<String> watchedMovies = ['Movie 1', 'Movie 2', 'Movie 3'];

    return Scaffold(
      body: ListView.builder(
        itemCount: watchedMovies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(watchedMovies[index]),
            // Add more details like movie poster, release date, etc.
          );
        },
      ),
    );
  }
}
