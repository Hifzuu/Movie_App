import 'package:flutter/material.dart';
import 'package:movie_assignment/local_storage_service/watchedList_local.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/api_service/api.dart';

class WatchedMoviesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Movie>>(
        future: LocalStorage.getWatchedListLocally(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While data is being fetched, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error, show an error message
            return Center(child: Text('Error loading watched movies'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If no data or data is empty, show a message
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('No movies added to Watched List yet.')],
              ),
            );
          } else {
            // If data is available, build the ListView
            List<Movie> watchedMovies = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: watchedMovies.length,
                    itemBuilder: (context, index) {
                      Movie movie = watchedMovies[index];
                      return ListTile(
                        contentPadding: EdgeInsets.only(left: 16, top: 8),
                        title: Text(
                          movie.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Release Date: ${movie.releaseDate}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            '${api.imagePath}${snapshot.data![index].backdropPath}',
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.cover,
                            height: 80,
                            width: 80,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            // Show confirmation dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Remove Movie'),
                                  content: Text(
                                      'Are you sure you want to remove this movie from the watched list?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        LocalStorage
                                            .removeFromWatchedListLocally(
                                                movie);
                                        // Reload watched movies
                                        Navigator.pop(
                                            context); // Close the dialog
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) =>
                                        //         WatchedMoviesView(),
                                        //   ),
                                        // );
                                      },
                                      child: Text('Remove'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        });
  }
}
