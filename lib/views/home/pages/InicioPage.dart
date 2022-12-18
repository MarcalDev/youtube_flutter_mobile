import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/Api.dart';
import 'package:youtube_flutter_mobile/models/Channel.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_flutter_mobile/models/VideoStatistic.dart';
import 'package:youtube_flutter_mobile/views/video_player/pages/VideoPlayerPage.dart';

class InicioPage extends StatefulWidget {

  String pesquisa;
  InicioPage( this.pesquisa );

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {

  _listarVideos(String pesquisa) {

    Api api = Api();
    return api.pesquisar(pesquisa);

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

  _getVideoStatistic(String videoId) {
    Api api = Api();
    return api.getVideoStatistic(videoId);
  }
  _getChannel(String channelId) {
    Api api = Api();
    return api.getChannel(channelId);
  }

  // construção da interface
  @override
  Widget build(BuildContext context) {

    Api api = Api();
    api.pesquisar("");

    return FutureBuilder<List<Video>?>(
        future: _listarVideos(widget.pesquisa),
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
                return ListView.separated(
                    itemBuilder: (context, index) {
                      List<Video>? videos = snapshot.data;
                      Video video = videos![index];
                      return FutureBuilder<Channel?>(
                        future: _getChannel(video.channel),
                        builder: (context, snapshot){
                        switch(snapshot.connectionState){
                          case ConnectionState.waiting: return Text('');
                          default:
                          if(snapshot.hasData){
                          Channel? channel = snapshot.data;
                          return GestureDetector(
                          onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePlayerPage(actualVideo: video)));
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
                                FutureBuilder<VideoStatistic?>(
                                future: _getVideoStatistic(video.id),
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
                                        backgroundImage: NetworkImage(channel!.profilePicture),
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
                                                      children: [
                                                        Text(
                                                          channel!.title,
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
                          } else {
                          return Text('Videos recomendados não carregados');
                          }
                          break;
                          }
                          });
                    },
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (context, index)=> Divider(
                      height: 3,
                      color: Colors.red,
                    )
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
