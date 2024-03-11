import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movie_assignment/services/movie_api.dart';
import 'package:movie_assignment/widgets/back_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerScreen extends StatefulWidget {
  final int movieId;

  const TrailerScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = null;
    _loadTrailerKey();
  }

  void _loadTrailerKey() async {
    try {
      print('Fetching trailer key for movieId: ${widget.movieId}');
      final trailerKey = await api().getMovieTrailerKey(widget.movieId);

      print('Fetched trailer key: $trailerKey');

      if (trailerKey.isNotEmpty) {
        _controller = YoutubePlayerController(
          initialVideoId: trailerKey,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
          ),
        );
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading trailer key: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _controller != null
          ? YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.blueAccent,
              ),
              builder: (context, player) {
                return Stack(
                  children: [
                    Positioned.fill(child: player),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: AppBar(
                        leading: const backButton(),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                  ],
                );
              },
            )
          : Center(
              child: SpinKitCircle(
                color: Theme.of(context).colorScheme.primary,
                size: 50.0,
              ),
            ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
