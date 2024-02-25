import 'package:flutter/material.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/views/details_view.dart';
import 'package:movie_assignment/widgets/back_button.dart';
import 'package:movie_assignment/widgets/movie_title_year.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const backButton(),
      ),
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
    // Your existing code for displaying search results
    return SizedBox(
      height: 267,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          // Build each movie item in the list
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsView(
                      movie: searchResults[index],
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  // Your existing code for displaying the movie poster
                  ClipRRect(
                    child: SizedBox(
                      height: 200,
                      width: 150,
                      child: Image.network(
                        '${api.imagePath}${searchResults[index].posterPath}' ??
                            'fallback_image_url', // Provide a fallback image URL
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          // Handle the error, e.g., by providing a fallback image
                          return Image.asset(
                              'lib/assets/images/image_not_found.jpg');
                        },
                      ),
                    ),
                  ),
                  // Display the movie title
                  Positioned(
                    bottom: -5,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.7),
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        getMovieTitleWithYear(searchResults[index]),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.background,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
