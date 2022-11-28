import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/Video.dart';
const CHAVE_API_YOUTUBE = "AIzaSyBJc3sfq7_xW-_ZrTRuQVm1Zk6-FUAGfhE";
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
}