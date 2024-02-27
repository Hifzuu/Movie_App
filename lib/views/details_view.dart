import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/local_storage_service/watchedList_local.dart'
    as watched;
import 'package:movie_assignment/local_storage_service/to_watch_list.dart'
    as toWatch;
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/views/watched_movies_view.dart';
import 'package:movie_assignment/widgets/get_movie_image.dart';
import 'package:movie_assignment/widgets/movie_title_year.dart';
import 'package:movie_assignment/widgets/trailer_screen.dart';
import 'package:movie_assignment/widgets/back_button.dart';
import 'package:movie_assignment/widgets/info_box.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailsView extends StatelessWidget {
  const DetailsView({
    super.key,
    required this.movie,
  });

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: const backButton(),
            backgroundColor: Theme.of(context).colorScheme.background,
            expandedHeight: 350,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Movie poster image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: Image.network(
                      '${api.imagePath}${movie.posterPath}',
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
                  // Play button overlay
                  Positioned.fill(
                    child: InkWell(
                      onTap: () {
                        String? videoKey = movie.trailerKey;

                        if (videoKey != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => TrailerScreen(
                                movieId: movie.id,
                              ),
                            ),
                          );
                        } else {
                          print('No trailer available for this movie');
                        }
                      },
                      child:
                          movie.trailers != null && movie.trailers!.isNotEmpty
                              ? Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary, // Adjust background color
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                              0.3), // Add a subtle shadow
                                          spreadRadius: 2,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(16),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      size: 50,
                                      color: Colors.white, // Adjust icon color
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getMovieTitleWithYear(movie),
                    style: GoogleFonts.amiko(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 0),
                  Row(
                    children: [
                      Text(movie.genres,
                          style: const TextStyle(
                            color: Colors.grey,
                          ))
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 2),
                          child: InfoBox(
                            label: 'Release Date:',
                            value: movie.releaseDate,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 2),
                          child: InfoBox(
                            label: 'Rating:',
                            value: '${movie.voteAverage.toStringAsFixed(1)}/10',
                            icon: Icons.star,
                            iconColor: Colors.amber,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 2),
                          child: DurationInfoBox(
                            label: 'Duration:',
                            durationInMinutes: movie.duration,
                            icon: Icons.timer_outlined,
                            iconColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    movie.overview,
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (movie.trailers != null && movie.trailers!.isNotEmpty)
                        ElevatedButton(
                          onPressed: () async {
                            // Check if the movie is already in the watched list
                            List<Movie> toWatchMovies = await toWatch
                                .LocalStorage.getToWatchListLocally();
                            bool isAlreadyAdded = toWatchMovies
                                .any((element) => element.id == movie.id);

                            if (isAlreadyAdded) {
                              // Show a message indicating that the movie is already in the watched list
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Movie already added',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    ),
                                    content: const Text(
                                      'This movie is already in your Watch List',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                    ],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    elevation: 5,
                                  );
                                },
                              );
                            } else {
                              // Movie is not in the watched list, proceed to add it
                              await toWatch.LocalStorage.addToWatchListLocally(
                                  movie);

                              // Show a success pop-up message
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Success',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: const Text(
                                        'Movie added to Watch List Successfuly!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.background,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'To - Watch',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      if (movie.trailers != null && movie.trailers!.isNotEmpty)
                        ElevatedButton(
                          onPressed: () async {
                            // Check if the movie is already in the watched list
                            List<Movie> watchedMovies = await watched
                                .LocalStorage.getWatchedListLocally();
                            bool isAlreadyAdded = watchedMovies
                                .any((element) => element.id == movie.id);

                            if (isAlreadyAdded) {
                              // Show a message indicating that the movie is already in the watched list
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Movie already added',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'This movie is already in your Watched List',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: const Text(
                                              'OK',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            } else {
                              // Movie is not in the watched list, proceed to add it
                              await watched.LocalStorage
                                  .addToWatchedListLocally(movie);

                              // Show a success pop-up message
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 5,
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Success',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          const Text(
                                              'Movie added to Watched List Successfully!'),
                                          SizedBox(height: 20),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.background,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 8),
                              Text(
                                'Add to Watched',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  FutureBuilder<List<Movie>>(
                    future: api().getSimilarMovies(movie.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SpinKitCircle(
                            color: Theme.of(context).colorScheme.primary,
                            size: 50.0,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        print(
                            'Error fetching similar movies: ${snapshot.error}');
                        return Text(
                            'Error fetching similar movies: ${snapshot.error}');
                      } else if (snapshot.data == null ||
                          snapshot.data!.isEmpty) {
                        // If the snapshot data is null or empty, return an empty container
                        return SizedBox.shrink();
                      } else if (snapshot.hasData) {
                        List<Movie> similarMovies = snapshot.data!;
                        print('Similar Movies API Response: $similarMovies');
                        return _buildSimilarMoviesList(similarMovies);
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimilarMoviesList(List<Movie> similarMovies) {
    if (similarMovies == null || similarMovies.isEmpty) {
      // Display an error message or return an empty container
      return Text('No similar movies available.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'More like this',
          style: GoogleFonts.amiko(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 15,
            crossAxisSpacing: 5,
            childAspectRatio: 1.5 / 2,
          ),
          itemCount: similarMovies.length,
          itemBuilder: (context, index) {
            if (index < similarMovies.length) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsView(
                        movie: similarMovies[index],
                      ),
                    ),
                  );
                },
                child: MovieImageWidget(movie: similarMovies[index]),
              );
            } else {
              return Container(); // Return an empty container or handle it based on your use case
            }
          },
        ),
      ],
    );
  }
}
