import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerPage extends StatefulWidget {
  final Video actualVideo;
  const YoutubePlayerPage({super.key, required this.actualVideo});

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
        initialVideoId: widget.actualVideo.id!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
      )
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0,32,0,32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            Text(widget.actualVideo.title),
            Text(widget.actualVideo.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(Icons.thumb_up_outlined),
                    Text(widget.actualVideo.likeCount)
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.thumb_down_outlined),
                    Text(widget.actualVideo.dislikeCount)
                  ],
                ),
                Column(
                  children: [
                    Icon(CupertinoIcons.arrowshape_turn_up_right),
                    Text("Share")
                  ],
                ),
                Column(
                  children: [
                    Icon(CupertinoIcons.arrow_down_to_line),
                    Text("Download")
                  ],
                ),
                Column(
                  children: [
                    Icon(CupertinoIcons.plus_rectangle_on_rectangle),
                    Text("Save")
                  ],
                ),
                ]
            ),
            Text(widget.actualVideo.channelTitle)
          ],
        ),
      )
    );
  }
}

