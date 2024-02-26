import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_assignment/local_storage_service/to_watch_list.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/views/details_view.dart';
import 'package:movie_assignment/widgets/get_movie_image.dart';
import 'package:movie_assignment/widgets/movie_title_year.dart';

class ToWatchMoviesView extends StatefulWidget {
  @override
  _ToWatchMoviesView createState() => _ToWatchMoviesView();
}

class _ToWatchMoviesView extends State<ToWatchMoviesView> {
  List<Movie>? toWatchMovies;

  @override
  void initState() {
    super.initState();
    loadToWatchMovies();
  }

  Future<void> loadToWatchMovies() async {
    List<Movie>? movies = await LocalStorage.getToWatchListLocally();
    setState(() {
      toWatchMovies = movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To - Watch Movies'),
        automaticallyImplyLeading: false,
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (toWatchMovies == null) {
      return Center(
        child: SpinKitCircle(
          color: Theme.of(context).colorScheme.primary,
          size: 50.0,
        ),
      );
    } else if (toWatchMovies!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No movies added to watch List yet. Start adding movies from the home page.',
              textAlign: TextAlign.center,
            ),
          ],
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
            itemCount: toWatchMovies!.length,
            itemBuilder: (context, index) {
              Movie movie = toWatchMovies![index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsView(
                        movie: movie,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  contentPadding: EdgeInsets.all(16),
                  title: Text(
                    getMovieTitleWithYear(movie),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 2), // Adjust the top padding as needed
                            child: const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rating: ${movie.voteAverage.toStringAsFixed(1)}/10',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(
                                top: 2), // Adjust the top padding as needed
                            child: const Icon(
                              Icons.timer,
                              size: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Duration: ${movie.duration} minutes',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  leading: MovieImageWidget(movie: movie),
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
                                  'Are you sure you want to remove this movie from your to-watch list?',
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
                                        LocalStorage.removeToWatchListLocally(
                                            movie.id);
                                        // Reload watched movies
                                        loadToWatchMovies();
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
