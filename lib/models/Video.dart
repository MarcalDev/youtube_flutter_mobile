class Video{
  String id = "";
  String title = "";
  String description = "";
  String thumbnail = "";
  String channel = "";

  Video({required this.id, required this.title, required this.description, required this.thumbnail, required this.channel});

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
    );
  }

}