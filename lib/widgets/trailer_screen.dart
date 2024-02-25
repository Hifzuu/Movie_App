import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:movie_assignment/api_service/api.dart';
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
    _controller = null; // Set the controller to null initially
    _loadTrailerKey();
  }

  void _loadTrailerKey() async {
    try {
      print('Fetching trailer key for movieId: ${widget.movieId}');
      final trailerKey = await api().getMovieTrailerKey(widget.movieId);

      print('Fetched trailer key: $trailerKey');

      if (trailerKey != null && trailerKey.isNotEmpty) {
        _controller = YoutubePlayerController(
          initialVideoId: trailerKey,
          flags: YoutubePlayerFlags(
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
      // Handle the error accordingly
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
                    // Additional widgets as needed
                  ],
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
