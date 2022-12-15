import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../Api.dart';
import '../../../models/Channel.dart';

class YoutubePlayerPage extends StatefulWidget {
  final Video actualVideo;
  const YoutubePlayerPage({super.key, required this.actualVideo});

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {

  late YoutubePlayerController _controller;

  _getChannel(String channelId){
    Api api = Api();
    return api.getChannel(channelId);
  }

  @override
  void initState() {

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
    return FutureBuilder(
        future: _getChannel(widget.actualVideo.channelTitle),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
            if(snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.fromLTRB(0, 32, 0, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                    ),
                    Text(widget.actualVideo.title),
                    Text("1.5M views 2 years ago"),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Icon(Icons.thumb_up_outlined),
                              Text("29K")
                            ],
                          ),
                          Column(
                            children: [
                              Icon(Icons.thumb_down_outlined),
                              Text("1.3K")
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(widget.actualVideo.channelTitle),
                            Text("2.21M Subscribers")
                          ],
                        ),
                        Text("SUBSCRIBED"),
                        Icon(CupertinoIcons.bell)
                      ],
                    )
                  ],
                ),
              );
            } else{
              return Center(
                child: Text("Nenhum dado a ser exibido"),
              );
            }
        }
    }
    );
  }
}

