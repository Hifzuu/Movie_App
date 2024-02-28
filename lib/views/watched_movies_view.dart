import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_assignment/local_storage_service/watchedList_local.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/views/details_view.dart';
import 'package:movie_assignment/widgets/get_movie_image.dart';
import 'package:movie_assignment/widgets/movie_title_year.dart';

class WatchedMoviesView extends StatefulWidget {
  const WatchedMoviesView({super.key});

  @override
  _WatchedMoviesViewState createState() => _WatchedMoviesViewState();
}

class _WatchedMoviesViewState extends State<WatchedMoviesView> {
  List<Movie>? watchedMovies;
  String currentSort = 'Title A-Z';

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

  List<Movie> getFilteredMovies() {
    if (watchedMovies == null) {
      return [];
    }

    List<Movie> filteredList = watchedMovies!;

    switch (currentSort) {
      case 'Title A-Z':
        filteredList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Title Z-A':
        filteredList.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Highest Rating':
        filteredList.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
        break;
      case 'Lowest Rating':
        filteredList.sort((a, b) => b.voteAverage.compareTo(b.voteAverage));
        break;
      case 'Newest':
        filteredList.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
      case 'Oldest':
        filteredList.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
        break;
    }

    return filteredList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watched Movies'),
        automaticallyImplyLeading: false,
        actions: [
          DropdownButton<String>(
            value: currentSort,
            items: const [
              DropdownMenuItem<String>(
                value: 'Title A-Z',
                child: Text('Title A-Z'),
              ),
              DropdownMenuItem<String>(
                value: 'Title Z-A',
                child: Text('Title Z-A'),
              ),
              DropdownMenuItem<String>(
                value: 'Highest Rating',
                child: Text('Highest Rating'),
              ),
              DropdownMenuItem<String>(
                value: 'Lowest Rating',
                child: Text('Lowest Rating'),
              ),
              DropdownMenuItem<String>(
                value: 'Newest',
                child: Text('Newest'),
              ),
              DropdownMenuItem<String>(
                value: 'Oldest',
                child: Text('Oldest'),
              ),
            ],
            onChanged: (String? value) {
              if (value != null) {
                setState(() {
                  currentSort = value;
                });
              }
            },
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    if (watchedMovies == null) {
      return Center(
        child: SpinKitCircle(
          color: Theme.of(context).colorScheme.primary,
          size: 50.0,
        ),
      );
    } else if (watchedMovies!.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'No movies added to watched List yet. Start adding movies from the home page.',
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
    List<Movie> filteredMovies = getFilteredMovies();

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: filteredMovies.length,
            itemBuilder: (context, index) {
              Movie movie = filteredMovies[index];
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
                  contentPadding:
                      EdgeInsets.only(left: 18, right: 18, bottom: 18),
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
                            '${movie.voteAverage.toStringAsFixed(1)}/10',
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
                            '${movie.duration} minutes',
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
                                        LocalStorage
                                            .removeFromWatchedListLocally(
                                                movie.id);
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
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
