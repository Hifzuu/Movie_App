import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/local_storage_service/watchedList_local.dart'
    as watched;
import 'package:movie_assignment/local_storage_service/to_watch_list.dart'
    as toWatch;
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/views/watched_movies_view.dart';
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
                      '${api.imagePath}${movie.posterPath}' ??
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
                  // Play button overlay
                  Positioned.fill(
                    child: InkWell(
                      onTap: () {
                        String? videoKey = movie.trailerKey;

                        if (videoKey != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  TrailerScreen(videoKey: videoKey),
                            ),
                          );
                        } else {
                          print('No trailer available for this movie');
                        }
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.5),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
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
                    '${movie.title} (${DateTime.parse(movie.releaseDate).year})',
                    style: GoogleFonts.amiko(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoBox(
                        label: 'Release Date:',
                        value: movie.releaseDate,
                      ),
                      InfoBox(
                        label: 'Rating:',
                        value: '${movie.voteAverage.toStringAsFixed(1)}/10',
                        icon: Icons.star,
                        iconColor: Colors.amber,
                      ),
                      DurationInfoBox(
                        label: 'Duration:',
                        durationInMinutes: movie.duration,
                        icon: Icons.timer_outlined,
                        iconColor: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: GoogleFonts.aBeeZee(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Check if the movie is already in the watched list
                          List<Movie> toWatchMovies = await toWatch.LocalStorage
                              .getToWatchListLocally();
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
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Check if the movie is already in the watched list
                          List<Movie> watchedMovies = await watched.LocalStorage
                              .getWatchedListLocally();
                          bool isAlreadyAdded = watchedMovies
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
                                    'This movie is already in your Watched List',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  actions: <Widget>[
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 5,
                                );
                              },
                            );
                          } else {
                            // Movie is not in the watched list, proceed to add it
                            await watched.LocalStorage.addToWatchedListLocally(
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
                                      'Movie added to Watched List Successfuly!'),
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
                            // Icon(
                            //   Icons.check,
                            //   size: 20,
                            //   color: Colors.white,
                            // ),
                            SizedBox(width: 8),
                            Text(
                              'Add to Watched',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
