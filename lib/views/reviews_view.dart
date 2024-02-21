import 'package:flutter/material.dart';

class ReviewsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Fetch the list of to-watch movies (replace with your data fetching logic)
    List<String> reviews = ['rev A', 'rev B', 'rev C'];

    return Scaffold(
      body: ListView.builder(
        itemCount: reviews.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reviews[index]),
            // Add more details like movie poster, release date, etc.
          );
        },
      ),
    );
  }
}
