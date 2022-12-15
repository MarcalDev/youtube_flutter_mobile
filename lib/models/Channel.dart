class Channel{
  String id = "";
  String Title = "";
  String ProfilePicture = "";

  Channel({required this.id, required this.Title, required this.ProfilePicture});

  factory Channel.fromJson(Map<String, dynamic> json){
    return Channel(
      id: json["id"]["channelId"],
      Title: json["snippet"]["title"],
      ProfilePicture: json["snippet"]["thumbnails"]["high"]["url"],
    );
  }
}