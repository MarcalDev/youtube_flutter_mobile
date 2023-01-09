import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:youtube_flutter_mobile/models/VideoStatistic.dart';
import 'package:youtube_flutter_mobile/views/video_player/widgets/ChannelInfoWidget.dart';
import 'package:youtube_flutter_mobile/views/video_player/widgets/RelatedVideosWidget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../Api.dart';
import '../../../models/Channel.dart';

class YoutubePlayerPage extends StatefulWidget {
  final Video actualVideo;
  final List<Video> homeVideosList;
  const YoutubePlayerPage({super.key, required this.actualVideo, required this.homeVideosList});

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late YoutubePlayerController _controller;
  late Channel? _actualChannel;
  late VideoStatistic? _actualVideoStatistic;

  Future<Channel?> _getActualVideoInfo(Video actualVideo) async{
    Api api = Api();
    _actualChannel = await api.getChannel(actualVideo!.channel);
    _actualVideoStatistic = await api.getVideoStatistic(actualVideo!.id);
    return _actualChannel;
  }
  @override
  void initState() {
    _controller = YoutubePlayerController(
        initialVideoId: widget.actualVideo.id!,
        flags: const YoutubePlayerFlags(autoPlay: true));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Channel?>(
        future: _getActualVideoInfo(widget.actualVideo),
        builder: (context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if (snapshot.hasData) {
                Channel? channel = snapshot.data;
                return Scaffold(
                  backgroundColor: Theme.of(context).primaryColor,
                  body: Padding(
                    padding: EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,
                                ),
                                Expanded(
                                    child: ListView(
                                      padding: EdgeInsets.all(0),
                                      children:<Widget>[
                                        Column(
                                          children: [
                                            /// Informações do vídeo e do canal
                                            ChannelInfoWidget(actualChannel: channel!, actualVideo: widget.actualVideo, actualVideoStatistic: _actualVideoStatistic!),
                                            /// Lista videos recomendados
                                            RelatedVideosWidget(actualVideo: widget.actualVideo, homeVideosList: widget.homeVideosList),
                                          ],
                                        )
                                      ],
                                    )
                                )
                              ],
                            )
                  ),
                );
              } else {
                return Center( child: Text("Nenhum dado a ser exibido"));
              }
              break;
          }
        });
  }
}
