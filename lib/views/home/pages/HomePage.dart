import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/Api.dart';
import 'package:youtube_flutter_mobile/models/Channel.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:youtube_flutter_mobile/models/VideoStatistic.dart';
import 'package:youtube_flutter_mobile/views/home/widgets/SearchedVideosListWidget.dart';
import 'package:youtube_flutter_mobile/views/video_player/pages/VideoPlayerPage.dart';

class HomePage extends StatefulWidget {
  String pesquisa;
  HomePage( this.pesquisa );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // construção da interface
  @override
  Widget build(BuildContext context) {
      return SearchedVideosListWidget(searchText: "Android");
  }
}
