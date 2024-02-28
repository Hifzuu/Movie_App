import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/views/details_view.dart';
import 'package:movie_assignment/widgets/get_movie_image.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar with TextField
            CupertinoSearchTextField(
              onChanged: (value) {
                // Rebuild the UI on each keystroke
                setState(() {
                  _searchQuery = value;
                });
              },
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),

            const SizedBox(height: 16),

            // Display searched movies or top searches
            FutureBuilder<List<Movie>>(
              future: _searchQuery.isEmpty
                  ? api()
                      .getPopularMovies() // Display top searches if no search query
                  : api().searchMovies(_searchQuery),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(
                      color: Theme.of(context).colorScheme.primary,
                      size: 50.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Movie> searchResults = snapshot.data!;
                  return _buildSearchResults(searchResults);
                } else {
                  return const SizedBox.shrink();
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_searchQuery
              .isEmpty) // Show "Top Searches" text only if no search query
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Top Searches',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          if (_searchQuery.isEmpty) // Show top searches in a ListView
            searchResults.isEmpty
                ? Center(
                    child: Text(
                      'No results found for: "$_searchQuery"',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        Movie movie = searchResults[index];
                        return ListTile(
                          contentPadding: EdgeInsets.all(8),
                          leading: SizedBox(
                            width: 50,
                            height: 50,
                            child: MovieImageWidget(movie: movie),
                          ),
                          title: Text(
                            getMovieTitleWithYear(movie) ?? 'Unknown Title',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsView(movie: movie),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          if (_searchQuery.isNotEmpty) // Show searched movies in a GridView
            searchResults.isEmpty
                ? Center(
                    child: Text(
                      'No results found for: "$_searchQuery"',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                : Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        Movie movie = searchResults[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailsView(movie: movie),
                              ),
                            );
                          },
                          child: GridTile(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: MovieImageWidget(movie: movie),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    getMovieTitleWithYear(movie) ??
                                        'Unknown Title',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
        ],
      ),
    );
  }
}
