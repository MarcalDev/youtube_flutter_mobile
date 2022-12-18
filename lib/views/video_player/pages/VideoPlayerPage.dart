import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:youtube_flutter_mobile/models/VideoStatistic.dart';
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

  _getChannel(String channelId) {
    Api api = Api();
    return api.getChannel(channelId);
  }

  _getVideoStatistic(String videoId) {
    Api api = Api();
    return api.getVideoStatistic(videoId);
  }

  _getRelatedVideos(String videoId) {
    Api api = Api();
    return api.getRelatedVideos(videoId);
  }

  _numberFormatter(String number){
    double doubleNumber = double.parse(number);
    if(doubleNumber >= 1000 && doubleNumber<1000000){
      doubleNumber = (doubleNumber/1000);
      return doubleNumber.toStringAsFixed(1) + 'K';
    }else if(doubleNumber>=1000000){
      doubleNumber = (doubleNumber/1000000);
      return doubleNumber.toStringAsFixed(1) + 'M';
    } else{
      return number;
    }
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
        future: _getChannel(widget.actualVideo.channel),
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
                return FutureBuilder<VideoStatistic?>(
                    future: _getVideoStatistic(widget.actualVideo.id),
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
                            VideoStatistic? videoStatistics = snapshot.data;
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
                                    // Container de informações do video
                                    Container(
                                      padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.actualVideo.title,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            _numberFormatter(videoStatistics!.viewCount) + ' views',
                                            style: TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    //Row de reações de video
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(Icons.thumb_up_outlined),
                                              Text(_numberFormatter(videoStatistics!.likeCount),style: TextStyle(fontSize: 14)
                                              )
                                            ],
                                          ),
                                          Icon(Icons.thumb_down_outlined),
                                          Column(
                                            children: [
                                              Icon(CupertinoIcons.arrowshape_turn_up_right),
                                              Text("Share",style: TextStyle(fontSize: 14))
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(CupertinoIcons.arrow_down_to_line),
                                              Text("Download",style: TextStyle(fontSize: 14)
                                              )
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(CupertinoIcons.plus_rectangle_on_rectangle),
                                              Text("Save",style: TextStyle(fontSize: 14))
                                            ],
                                          ),
                                        ]),
                                    //Container de informações do canal
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                              margin: EdgeInsets.only(left:12),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    radius:15,
                                                    backgroundImage: NetworkImage(channel!.profilePicture),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(left: 15),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(channel!.title, style: TextStyle(fontSize: 16)),
                                                          Text("2.21M subscribers",style: TextStyle(fontSize: 14))
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              )
                                          ),
                                          Container(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Text("SUBSCRIBE",style: TextStyle(fontSize: 17,color: Colors.red,fontWeight: FontWeight.bold)),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(15, 0, 12, 0),
                                                  child: Icon(CupertinoIcons.bell),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    // Lista videos recomendados
                                    FutureBuilder<List<Video>?>(
                                        future: _getRelatedVideos(widget.actualVideo.id),
                                        builder: (context, AsyncSnapshot snapshot){
                                          switch (snapshot.connectionState) {
                                            case ConnectionState.none:
                                            case ConnectionState.waiting:
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            case ConnectionState.active:
                                            case ConnectionState.done:
                                              if (snapshot.hasData) {
                                                return Expanded(

                                                    child: ListView.separated(
                                                      padding: EdgeInsets.zero,
                                                        itemBuilder: (context, index) {
                                                          List<Video>? recommendedVideos = snapshot.data;
                                                          Video recommendedVideo = recommendedVideos![index];
                                                          return FutureBuilder<Channel?>(
                                                              future: _getChannel(recommendedVideo.channel),
                                                              builder: (context, snapshot){
                                                                switch(snapshot.connectionState){
                                                                  case ConnectionState.waiting: return Text('');
                                                                  default:
                                                                    if(snapshot.hasData){
                                                                      Channel? relatedChannel = snapshot.data;
                                                                      return GestureDetector(
                                                                        onTap: (){
                                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePlayerPage(actualVideo: recommendedVideo)));
                                                                        },
                                                                        child: Column(
                                                                          children: <Widget>[
                                                                            Container(
                                                                              padding: EdgeInsets.zero,
                                                                              height: 200,
                                                                              decoration: BoxDecoration(
                                                                                  image: DecorationImage(
                                                                                    fit: BoxFit.cover,
                                                                                    image: NetworkImage(recommendedVideo.thumbnail),
                                                                                  )
                                                                              ),
                                                                            ),
                                                                            FutureBuilder<VideoStatistic?>(
                                                                              future: _getVideoStatistic(recommendedVideo.id),
                                                                              builder: (context, snapshot){
                                                                                switch(snapshot.connectionState){
                                                                                case ConnectionState.waiting: return Text('');
                                                                                default:
                                                                                if(snapshot.hasData) {
                                                                                  VideoStatistic? relatedVideoStatistics = snapshot.data;
                                                                                  return Container(
                                                                                    padding: EdgeInsets.fromLTRB(12,8,12,0),
                                                                                    height: 60,
                                                                                    child: Row(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        CircleAvatar(
                                                                                          backgroundImage: NetworkImage(relatedChannel!.profilePicture),
                                                                                          radius: 15,
                                                                                        ),
                                                                                        Expanded(
                                                                                            child: Container(
                                                                                              margin: EdgeInsets.only(left: 12),
                                                                                              child: Column(
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  Flexible(
                                                                                                      child: Container(
                                                                                                        child: Text(
                                                                                                          recommendedVideo.title,
                                                                                                          overflow: TextOverflow.ellipsis,
                                                                                                          style: TextStyle(
                                                                                                              fontWeight: FontWeight.w500,
                                                                                                              fontSize:  15
                                                                                                          ),
                                                                                                        ),
                                                                                                      )
                                                                                                  ),
                                                                                                  Container(
                                                                                                    margin: EdgeInsets.only(top:1),
                                                                                                    child: Row(
                                                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                                                      children: [
                                                                                                        Text(
                                                                                                          relatedChannel!.title,
                                                                                                          style: TextStyle(
                                                                                                              fontSize: 12
                                                                                                          ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          '  •  ' + _numberFormatter(relatedVideoStatistics!.viewCount) + ' views',
                                                                                                          style: TextStyle(
                                                                                                              fontSize: 12
                                                                                                          ),
                                                                                                        )
                                                                                                      ],
                                                                                                    )
                                                                                                  )
                                                                                                ],
                                                                                              )
                                                                                            ),
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                  );
                                                                                } else{
                                                                                  return Text('Estatistica dos videos não carregada');
                                                                                }
                                                                                }
                                                                              },
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }else{
                                                                      return Text('Canal dos videos não carregado');
                                                                    }
                                                                }

                                                              });
                                                        },
                                                        itemCount: snapshot.data!.length,
                                                        separatorBuilder: (context, index)=> Divider(
                                                          height: 3,
                                                          color: Colors.red,
                                                        )
                                                    ));
                                              } else {
                                                return Text('Videos recomendados não carregados');
                                              }
                                              break;
                                          }
                                        }
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text("Estatistica do video não carregada");
                          }
                          break;
                      }
                    });
              } else {
                return Center( child: Text("Nenhum dado a ser exibido"));
              }
              break;
          }
        });
  }
}
