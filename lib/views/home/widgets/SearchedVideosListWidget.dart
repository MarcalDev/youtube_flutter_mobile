import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/Api.dart';
import 'package:youtube_flutter_mobile/models/Channel.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:youtube_flutter_mobile/models/VideoStatistic.dart';
import 'package:youtube_flutter_mobile/views/video_player/pages/VideoPlayerPage.dart';

import 'CustomSearchDelegate.dart';

class SearchedVideosListWidget extends StatefulWidget {
  const SearchedVideosListWidget({
    Key? key,
    required this.searchText
  }) : super(key: key);
  final String searchText;
  
  @override
  State<SearchedVideosListWidget> createState() => _SearchedVideosListWidgetState();
}

class _SearchedVideosListWidgetState extends State<SearchedVideosListWidget> {

  late List<Channel?> _channelsList;
  late List<VideoStatistic?> _videoStatisticList;

  Future<List<Video>?> _listarVideos(String searchText) async{
    Api api = Api();
    var videoList = await api.pesquisar(searchText);
    _channelsList = <Channel?>[];
    _videoStatisticList = <VideoStatistic?>[];

    for (var video in videoList!){
      _channelsList.add(await api.getChannel(video.channel));
      _videoStatisticList.add(await api.getVideoStatistic(video.id));
    }
    return videoList;
  }

  _numberFormatter(String number){
    double doubleNumber = double.parse(number);
    if(doubleNumber >= 1000 && doubleNumber<1000000){
      doubleNumber = (doubleNumber/1000);
      return doubleNumber.toStringAsFixed(1) + 'K';
    }else if(doubleNumber>=1000000 && doubleNumber<1000000000){
      doubleNumber = (doubleNumber/1000000);
      return doubleNumber.toStringAsFixed(1) + 'M';
    } else if(doubleNumber>=1000000000){
      doubleNumber = (doubleNumber/1000000000);
      return doubleNumber.toStringAsFixed(1) + 'B';
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
        if(months>24){
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
  Widget build(BuildContext context) {    
    return FutureBuilder<List<Video>?>(
        future: _listarVideos(widget.searchText),
        builder: (context, snapshot){
          switch(snapshot.connectionState){
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
              if(snapshot.hasData){
                return ListView.builder(
                  itemBuilder: (context, index) {
                    List<Video>? videos = snapshot.data;
                    Video video = videos![index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePlayerPage(actualVideo: video, homeVideosList: videos)));
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.zero,
                            height: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(video.thumbnail),
                                )
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.fromLTRB(12,8,12,0),
                              height: 60,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(_channelsList[index]!.profilePicture),
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
                                                    video.title,
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
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Flexible(
                                                        child: Text(
                                                          _channelsList[index]!.title, overflow: TextOverflow.fade, maxLines: 1,
                                                          softWrap: false,
                                                          style: TextStyle(
                                                              fontSize: 12
                                                          ),
                                                        )
                                                    ),

                                                    Text(
                                                      '  •  ' + _numberFormatter(_videoStatisticList[index]!.viewCount) + ' views',
                                                      style: TextStyle(
                                                          fontSize: 12
                                                      ),
                                                    ),
                                                    Text(
                                                      '  •  ' + _dateFormatter(video!.publishDate),
                                                      style: TextStyle(
                                                        fontSize: 12,
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

                  itemCount: snapshot.data!.length,
                );
              }else{
                return Center(
                  child: Text("Nenhum dado a ser exibido"),
                );

              }
              break;
          }
        }
    );
  }
}
