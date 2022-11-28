import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/Api.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({Key? key}) : super(key: key);

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {

  _listarVideos(){

    Api api = Api();
    return api.pesquisar("");
  }

  @override
  Widget build(BuildContext context) {
    
    Api api = Api();
    api.pesquisar("");
    
    return FutureBuilder<List<Video>?>(
        future: _listarVideos(),
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
                      return Column(
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
