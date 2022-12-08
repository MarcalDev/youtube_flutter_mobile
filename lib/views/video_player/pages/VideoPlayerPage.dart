import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPage extends StatefulWidget {
  final String videoId;
  const YoutubePlayerPage({super.key, required this.videoId});

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  // final videoURL = "https://www.youtube.com/watch?v=YMx8Bbev6T4&ab_channel=FlutterUIDev";

  late YoutubePlayerController _controller;

  @override
  void initState() {
    // final videoId = YoutubePlayer.convertUrlToId(videoURL);

    _controller = YoutubePlayerController(
        initialVideoId: widget.videoId!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
              controller: _controller,
            showVideoProgressIndicator: true,
          )
        ],
      ),
    );
  }
}

