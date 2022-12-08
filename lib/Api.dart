import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/Video.dart';
const CHAVE_API_YOUTUBE = "AIzaSyApbyc2q5JlFRto1CfegE4Gwk2ZXYGu3EU";
const ID_CANAL = "";
const URL_BASE = "https://www.googleapis.com/youtube/v3/";

class Api{
  Future<List<Video>?> pesquisar(String pesquisa) async{
    http.Response response = await http.get(
        Uri.parse(URL_BASE + "search"
          "?part=snippet"
          "&type=video"
          "&maxResults=20"
          "&order=date"
          "&key=$CHAVE_API_YOUTUBE"
          //"&channelId=$ID_CANAL"
          "&q=$pesquisa")
    );
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