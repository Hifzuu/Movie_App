import 'package:flutter/material.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/views/details_view.dart';
import 'package:movie_assignment/widgets/back_button.dart';
import 'package:movie_assignment/widgets/movie_title_year.dart';
import 'package:movie_assignment/widgets/get_movie_image.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar with TextField
            TextField(
              onChanged: (value) {
                // Rebuild the UI on each keystroke
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search movies...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(
                height: 16), // Add some space between search bar and results
            // Display searched movies using FutureBuilder
            FutureBuilder<List<Movie>>(
              future: api().searchMovies(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Movie> searchResults = snapshot.data!;
                  return _buildSearchResults(searchResults);
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<Movie> searchResults) {
    return Expanded(
      child: ListView(
        children: searchResults.map((movie) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsView(movie: movie),
                  ),
                );
              },
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  getMovieTitleWithYear(movie),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                          top: 2), // Adjust the top padding as needed
                      child: Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Rating: ${movie.voteAverage.toStringAsFixed(1)}/10',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    // Text(
                    //   'Duration: ${movie.duration} minutes',
                    //   style: const TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.grey,
                    //   ),
                    // ),
                  ],
                ),
                leading: MovieImageWidget(movie: movie),
                trailing: Icon(
                  Icons.more_horiz,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
