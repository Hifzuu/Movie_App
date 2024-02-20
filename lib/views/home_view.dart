import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie App'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              // Add logic to log out the user and navigate to the login page
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What\'s on at the cinema?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add functionality for cinema planning here

            SizedBox(height: 20),

            Text(
              'Trivia: Best movies this year',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add functionality for best movies this year trivia here

            SizedBox(height: 20),

            Text(
              'Matching Actors',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add functionality for matching actors here

            SizedBox(height: 20),

            Text(
              'Information: Find movies by actor',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add functionality for finding movies by actor here

            SizedBox(height: 20),

            Text(
              'Information: Find movies by title',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Add functionality for finding movies by title here

            // Add more sections for other functionalities as needed
          ],
        ),
      ),
    );
  }
}
