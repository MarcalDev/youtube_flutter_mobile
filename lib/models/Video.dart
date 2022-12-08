class Video{
  String id = "";
  String title = "";
  String description = "";
  String thumbnail = "";
  String channel = "";
  DateTime publishDate;
  String channelTitle = "";
  String likeCount = "";
  String dislikeCount = "";
  String viewCount = "";

  Video({required this.id, required this.title, required this.description, required this.thumbnail, required this.channel, required this.publishDate, required this.channelTitle, required this.likeCount, required this.dislikeCount, required this.viewCount});

  /*
  static converterJson(Map<String, dynamic> json){
    return Video(
      id: json["id"]["videoId"],
      title: json["snippet"]["title"],
      thumbnail: json["snippet"]["thumbnails"]["high"]["url"],
      channel: json["snippet"]["channelId"],
    );
  }

   */


  factory Video.fromJson(Map<String, dynamic> json){
    return Video(
      id: json["id"]["videoId"],
      title: json["snippet"]["title"],
      thumbnail: json["snippet"]["thumbnails"]["high"]["url"],
      channel: json["snippet"]["channelId"],
      description: json["snippet"]["description"],
      channelTitle: json["snippet"]["channelTitle"],
      publishDate: json["snippet"]["publishedAt"],
      likeCount: json["statistics"]["likeCount"],
      dislikeCount: json["statistics"]["dislikeCount"],
      viewCount: json["statistics"]["viewCount"],
    );
  }

}