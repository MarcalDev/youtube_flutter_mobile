import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/Api.dart';
import 'package:youtube_flutter_mobile/models/Channel.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:youtube_flutter_mobile/models/VideoStatistic.dart';
import 'package:youtube_flutter_mobile/views/video_player/pages/VideoPlayerPage.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RelatedVideosWidget extends StatefulWidget {
  const RelatedVideosWidget({
    Key? key,
    required this.actualVideo,
    required this.homeVideosList
  }) : super(key: key);
  final Video actualVideo;
  final List<Video> homeVideosList;

  @override
  State<RelatedVideosWidget> createState() => _RelatedVideosWidgetState();
}

class _RelatedVideosWidgetState extends State<RelatedVideosWidget> {

  late List<Channel?> _relatedChannelList;
  late List<VideoStatistic?> _relatedVideoStatistic;
  late YoutubePlayerController _controller;

  Future<List<Video>?> _getRelatedVideos(Video actualVideo) async{
    Api api = Api();
    //var videoList = await api.getRelatedVideos(actualVideo.id,actualVideo.channel);
    var videoList = widget.homeVideosList;
    _relatedChannelList = <Channel>[];
    _relatedVideoStatistic = <VideoStatistic>[];

    videoList.removeWhere((element) => element.id == widget.actualVideo.id);
    for(var video in videoList!){
      _relatedChannelList.add(await api.getChannel(video.channel));
      _relatedVideoStatistic.add(await api.getVideoStatistic(video.id));
    }
    return videoList;
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

  _dateFormatter(String data){
    var parsedDate = DateTime.parse(data);
    var timeBetween = DateTime.now().difference(parsedDate);
    if(timeBetween.inDays >= 30 ){
      var months = timeBetween.inDays/30;
      if(months > 12){
        if(months>1){
          return(months/12).toStringAsFixed(0) + ' years ago';
        }else{
          return(months/12).toStringAsFixed(0) + ' year ago';
        }
      } else{
        if(months>1){
          return months.toStringAsFixed(0) + ' months ago';
        }else{
          return months.toStringAsFixed(0) + ' month ago';
        }
      }
    } else if(timeBetween.inDays > 1){
      return (timeBetween.inDays).toString() + ' days ago';
    } else{
      return '1 day ago';
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
    try{
      return FutureBuilder<List<Video>?>(
          future: _getRelatedVideos(widget.actualVideo),
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
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data!.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      List<Video>? relatedVideos = snapshot!.data;
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePlayerPage(actualVideo: relatedVideos![index], homeVideosList: widget.homeVideosList )));
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.zero,
                              height: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(relatedVideos![index].thumbnail),
                                  )
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(12,8,12,0),
                                height: 60,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CircleAvatar(backgroundImage: NetworkImage(_relatedChannelList[index]!.profilePicture),radius: 15,),
                                    Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(left: 12),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Flexible(
                                                  child: Container(
                                                    child: Text(
                                                      relatedVideos![index].title,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize:  15
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(top:1, right: 15),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Flexible(
                                                          child: Text(
                                                            _relatedChannelList[index]!.title, overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                fontSize: 12
                                                            ),
                                                          )),
                                                      Text(
                                                        '  •  ' + _numberFormatter(_relatedVideoStatistic[index]!.viewCount) + ' views',
                                                        style: TextStyle(
                                                            fontSize: 12
                                                        ),
                                                      ),
                                                      Text(
                                                        '  •  ' + _dateFormatter(relatedVideos![index].publishDate),
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              )
                                            ],
                                          )
                                      ),
                                    )
                                  ],
                                )
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                      child: Padding(padding: EdgeInsets.only(left: 25, right: 25) ,child: Center(child: Text("Server Is Currently Down For Maintenance, Please Try Again Later", textAlign: TextAlign.center))
                      ));
                }
                break;
            }
          }
      );
    } catch(ex){
      return Container(
          child: Padding(padding: EdgeInsets.only(left: 25, right: 25) ,child: Center(child: Text("Server Is Currently Down For Maintenance, Please Try Again Later", textAlign: TextAlign.center))
          ));
    }

  }
}
