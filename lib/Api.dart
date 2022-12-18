import 'package:http/http.dart' as http;
import 'package:youtube_flutter_mobile/models/Channel.dart';
import 'package:youtube_flutter_mobile/models/VideoStatistic.dart';
import 'dart:convert';

import 'models/Video.dart';
const CHAVE_API_YOUTUBE = "AIzaSyDwSJO3TsmLeqSXqOuRxF9rtadl2SOytBM";
const ID_CANAL = "";
const URL_BASE = "https://www.googleapis.com/youtube/v3/";

class Api{
  Future<List<Video>?> pesquisar(String pesquisa) async{
    http.Response response = await http.get(
        Uri.parse(URL_BASE + "search"
          "?part=snippet"
          "&safeSearch=strict"
          "&type=video"
          "&order=relevance"
          "&maxResults=5"
          "&key=$CHAVE_API_YOUTUBE"
          //"&channelId=$ID_CANAL"
          "&q=$pesquisa")
    );
    if(response.statusCode == 200){

      print("Resultadooo: " + response.body );

      Map<String, dynamic> dadosJson = json.decode( response.body );

      List<Video>? videos = dadosJson["items"].map<Video>(
          (map){
            return Video.fromJson(map);
          }
      ).toList();

      return videos;
    } else{
      return null;
    }

  }

  Future<Channel?> getChannel(String channelId) async{
    http.Response response = await http.get(
        Uri.parse(URL_BASE + "channels"
            "?part=snippet&part=statistics"
            "&id=$channelId"
            "&key=$CHAVE_API_YOUTUBE"
        )
    );

    if(response.statusCode == 200){
      print("Resultado Canal:" + response.body);
      Map<String, dynamic> dadosJson = json.decode(response.body);

      List<Channel>? channels = dadosJson["items"].map<Channel>(
          (map){
            return Channel.fromJson(map);
          }
      ).toList();

      return channels!.first;
    }
    else{
      return null;
    }
  }

  Future<VideoStatistic?> getVideoStatistic(String videoId) async{
    http.Response response = await http.get(
      Uri.parse(URL_BASE + "videos"
          "?id=$videoId"
          "&part=statistics"
          "&key=$CHAVE_API_YOUTUBE"
      )
    );
    print("Resultado Statisticas:" + response.body);
    if(response.statusCode == 200){
      Map<String, dynamic> dadosJson = json.decode(response.body);

      List<VideoStatistic>? videoStatistics = dadosJson["items"].map<VideoStatistic>(
              (map){
            return VideoStatistic.fromJson(map);
          }
      ).toList();
      return videoStatistics!.first;
    }
    else{
      return null;
    }
  }

  Future<List<Video>?> getRelatedVideos(String actualVideoId) async{
    http.Response response = await http.get(
        Uri.parse(URL_BASE + "videos"
            "?part=snippet&part=statistics"
            "&chart=mostPopular"
            "&key=$CHAVE_API_YOUTUBE"
          //"&channelId=$ID_CANAL"
        )

        // Uri.parse(URL_BASE + "search"
        //     "?part=snippet"
        //     "&relatedToVideoId=$actualVideoId"
        //     "&type=video"
        //     "&maxResults=5"
        //     "&order=date"
        //     "&key=$CHAVE_API_YOUTUBE"
        // //"&channelId=$ID_CANAL"
    );
    print("Related: " + response.body);
    if(response.statusCode == 200){

      Map<String, dynamic> dadosJson = json.decode( response.body );

      List<Video>? videos = dadosJson["items"].map<Video>(
              (map){
            return Video.fromJson(map);
          }
      ).toList();

      return videos;
    } else{
      return null;
    }

  }

  Future<List<String>> carregarSugestoes(String pesquisa) async{
    http.Response response = await http.get(
    Uri.parse(
        "https://clients1.google.com/complete/search?client=youtube&gs_ri=youtube&ds=yt&q=$pesquisa"
    ));

    if(response.statusCode == 200){

      List<String> searchSuggestions = [];
      String data = response.body.toString();

      // print("resultado inicial:" + response.body);
      searchSuggestions = data.split('(').toList();
      data = searchSuggestions[1];
      // print("resultado pre:" + data.toString());
       searchSuggestions = data.split(']],').toList();
      for(int i=0;i<searchSuggestions.length;i++){
          searchSuggestions[i] = searchSuggestions[i].split(',')[0];
          searchSuggestions[i] = searchSuggestions[i].replaceAll('[', '');
          searchSuggestions[i] = searchSuggestions[i].replaceAll('"', '');

      }
      searchSuggestions.removeAt(0);
      searchSuggestions.removeAt(searchSuggestions.length - 1);

      for(int i=0;i<searchSuggestions.length;i++){
        print("resultado final:" + searchSuggestions[i]);
      }
      return searchSuggestions;
    }
    else{
      return [''];
      print("Não foi possivel encontrar o resultado");

    }

  }
}