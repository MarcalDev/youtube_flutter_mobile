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
                                padding: EdgeInsets.fromLTRB(0, 32, 0, 32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    YoutubePlayer(
                                      controller: _controller,
                                      showVideoProgressIndicator: true,
                                    ),
                                    Text(widget.actualVideo.title),
                                    Text(_numberFormatter(videoStatistics!.viewCount)),
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.network(channel!.profilePicture, height: 30, width: 30),
                                        Column(
                                          children: [
                                            Text(channel!.title, style: TextStyle(fontSize: 14)),
                                            Text("2.21M Subscribers",style: TextStyle(fontSize: 14))
                                          ],
                                        ),
                                        Text("SUBSCRIBED",style: TextStyle(fontSize: 14)),
                                        Icon(CupertinoIcons.bell)
                                      ],
                                    ),
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
                                                                                    height: 50,
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Container(
                                                                                          decoration: BoxDecoration(
                                                                                            shape: BoxShape.circle,
                                                                                            color: Colors.transparent,
                                                                                          ),
                                                                                          child: Image.network(relatedChannel!.profilePicture,height: 30, width: 30),
                                                                                          padding: EdgeInsets.fromLTRB(15,0,15,0),
                                                                                        ),
                                                                                        Expanded(
                                                                                            child: Column(
                                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                                              children: [
                                                                                                Flexible(
                                                                                                    child: Container(
                                                                                                      child: Text(recommendedVideo.title,overflow: TextOverflow.ellipsis),
                                                                                                    )
                                                                                                ),
                                                                                                Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                                  children: [
                                                                                                    Text(relatedChannel!.title),
                                                                                                    Text(_numberFormatter(relatedVideoStatistics!.viewCount))
                                                                                                  ],
                                                                                                )
                                                                                              ],
                                                                                            )
                                                                                        )
                                                                                      ],
                                                                                    )
                                                                                  );
                                                                                } else{
                                                                                  return Text('');
                                                                                }
                                                                                }
                                                                              },
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }else{
                                                                      return Text("Nenhum dado a ser exibido");
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
                                                return Center(child: Text("Nenhum dado a ser exibido"));
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
                            return Center(child: Text("Nenhum dado a ser exibido"));
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
