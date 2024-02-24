import 'package:flutter/material.dart';
import 'package:movie_assignment/local_storage_service/watchedList_local.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/api_service/api.dart';

class WatchedMoviesView extends StatefulWidget {
  @override
  _WatchedMoviesViewState createState() => _WatchedMoviesViewState();
}

class _WatchedMoviesViewState extends State<WatchedMoviesView> {
  List<Movie>? watchedMovies;

  @override
  void initState() {
    super.initState();
    loadWatchedMovies();
  }

  Future<void> loadWatchedMovies() async {
    List<Movie>? movies = await LocalStorage.getWatchedListLocally();
    setState(() {
      watchedMovies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watched Movies'),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (watchedMovies == null) {
      return Center(child: CircularProgressIndicator());
    } else if (watchedMovies!.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('No movies added to Watched List yet.')],
        ),
      );
    } else {
      return buildMovieList();
    }
  }

  Widget buildMovieList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: watchedMovies!.length,
            itemBuilder: (context, index) {
              Movie movie = watchedMovies![index];
              return ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(
                  '${movie.title} (${DateTime.parse(movie.releaseDate).year})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rating: ${movie.voteAverage.toStringAsFixed(1)}/10',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Duration: ${movie.duration} minutes',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${api.imagePath}${movie.backdropPath}',
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fill,
                    height: 100,
                    width: 80,
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.remove_circle_outline),
                  color: Colors.red,
                  onPressed: () {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Remove Movie',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Are you sure you want to remove this movie from your watched list?',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      LocalStorage.removeFromWatchedListLocally(
                                          movie);
                                      // Reload watched movies
                                      loadWatchedMovies();
                                      Navigator.pop(
                                          context); // Close the dialog
                                    },
                                    child: const Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
}
