import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_assignment/api_service/api.dart';
import 'package:movie_assignment/models/movie.dart';
import 'package:movie_assignment/widgets/back_button.dart';
import 'package:movie_assignment/widgets/info_box.dart';

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
              background: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                child: Image.network(
                  '${api.imagePath}${movie.posterPath}',
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.cover,
                ),
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
                        iconColor: Colors.white,
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
                        onPressed: () {
                          // Handle adding to watchlist
                          // You can implement your logic here
                        },
                        child: Text('Add to Watchlist'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle adding to watched list
                          // You can implement your logic here
                        },
                        child: Text('Add to Watched List'),
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
