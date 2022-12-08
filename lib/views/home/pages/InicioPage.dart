import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/Api.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
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

  // // carrega tela, 1 unica vez // construtor
  // @override
  // void initState() {
  //   super.initState();
  // }
  //
  // // carregar dependencias
  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  // }
  //
  // //
  // @override
  // void didUpdateWidget(covariant InicioPage oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  // }
  //
  // // descarte de itens
  // @override
  // void dispose() {
  //
  //   super.dispose();
  // }

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
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => YoutubePlayerPage(actualVideo: video)));
                          // FlutterYoutube.playYoutubeVideoById(
                          //     apiKey: CHAVE_API_YOUTUBE,
                          //     videoId: video.id,
                          //     autoPlay: true,
                          //     fullScreen: true,
                          // );
                        },
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(video.thumbnail),
                                  )
                              ),
                            ),
                            ListTile(
                              title: Text( video.title),
                              subtitle: Text(video.description),
                            )
                          ],
                        ),
                      );
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
