class Channel{
  String id = "";
  String title = "";
  String profilePicture = "";
  String subscriberCount = "";

  Channel({required this.id, required this.title, required this.profilePicture, required this.subscriberCount});

  factory Channel.fromJson(Map<String, dynamic> json){
    return Channel(
      id: json["id"],
      title: json["snippet"]["title"],
      profilePicture: json["snippet"]["thumbnails"]["default"]["url"],
      subscriberCount: json["statistics"]["subscriberCount"],
    );
  }
}