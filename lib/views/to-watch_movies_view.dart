import 'package:flutter/material.dart';

class ToWatchMoviesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the list of to-watch movies (replace with your data fetching logic)
    List<String> toWatchMovies = ['Movie A', 'Movie B', 'Movie C'];

    return Scaffold(
      body: ListView.builder(
        itemCount: toWatchMovies.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(toWatchMovies[index]),
            // Add more details like movie poster, release date, etc.
          );
        },
      ),
    );
  }
}
