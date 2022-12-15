class Video{
  String id = "";
  String title = "";
  String description = "";
  String thumbnail = "";
  String channel = "";
  String channelTitle = "";
  String publishDate = "";

  Video({required this.id, required this.title, required this.description, required this.thumbnail, required this.channel, required this.channelTitle, required this.publishDate});



  factory Video.fromJson(Map<String, dynamic> json){
    return Video(
      id: json["id"]["videoId"],
      title: json["snippet"]["title"],
      thumbnail: json["snippet"]["thumbnails"]["high"]["url"],
      channel: json["snippet"]["channelId"],
      description: json["snippet"]["description"],
      channelTitle: json["snippet"]["channelTitle"],
      publishDate: json["snippet"]["publishedAt"],
    );
  }

}