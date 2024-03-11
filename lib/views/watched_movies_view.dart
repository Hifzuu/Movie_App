import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_assignment/local_storage_service/watchedList_local.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/views/details_view.dart';
import 'package:movie_assignment/widgets/filter_list.dart';
import 'package:movie_assignment/widgets/get_movie_image.dart';
import 'package:movie_assignment/widgets/movie_title_year.dart';

class WatchedMoviesView extends StatefulWidget {
  const WatchedMoviesView({super.key});

  @override
  _WatchedMoviesViewState createState() => _WatchedMoviesViewState();
}

class _WatchedMoviesViewState extends State<WatchedMoviesView> {
  List<Movie>? watchedMovies;
  String currentSort = 'Alphabetical Ascending (A-Z)';

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
      case 'Alphabetical Order (A-Z)':
        filteredList.sort((a, b) => a.title.compareTo(b.title));
        break;
      case 'Alphabetical Order (Z-A)':
        filteredList.sort((a, b) => b.title.compareTo(a.title));
        break;
      case 'Top Rated First':
        filteredList.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
        break;
      case 'Lowest Rated First':
        filteredList.sort((a, b) => a.voteAverage.compareTo(b.voteAverage));
        break;
      case 'Newest Release First':
        filteredList.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
      case 'Oldest Release First':
        filteredList.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
        break;
      case 'Longest Duration First':
        filteredList.sort((a, b) => b.duration.compareTo(a.duration));
        break;
      case 'Shortest Duration First':
        filteredList.sort((a, b) => a.duration.compareTo(b.duration));
        break;
    }

    return filteredList;
  }

  void _showFilterDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FilterDropdown(
          currentSort: currentSort,
          onSelectFilter: _selectFilter,
        );
      },
    );
  }

  void _selectFilter(String value) {
    setState(() {
      currentSort = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watched Movies'),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () {
              _showFilterDropdown(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.filter_list,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
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
                      const EdgeInsets.only(left: 18, right: 18, bottom: 18),
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
                            padding: const EdgeInsets.only(top: 2),
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
                            padding: const EdgeInsets.only(top: 2),
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
                    icon: const Icon(Icons.remove_circle_outline),
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
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
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
                                        Navigator.pop(context);
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
