import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_assignment/widgets/back_button.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TrailerScreen extends StatefulWidget {
  final String videoKey;

  const TrailerScreen({Key? key, required this.videoKey}) : super(key: key);

  @override
  _TrailerScreenState createState() => _TrailerScreenState();
}

class _TrailerScreenState extends State<TrailerScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoKey,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
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
              // Positioned(
              //   bottom: 16.0,
              //   right: 16.0,
              //   child: GestureDetector(
              //     onTap: () {
              //       _toggleFullscreen();
              //     },
              //     child: CircleAvatar(
              //       backgroundColor: Colors.blue,
              //       radius: 24.0,
              //       child: Icon(
              //         Icons.fullscreen,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          );
        },
      ),
    );
  }

  void _toggleFullscreen() {
    if (_controller.value.isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }

    _controller.toggleFullScreenMode();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
