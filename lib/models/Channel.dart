class Channel{
  String id = "";
  String title = "";
  String profilePicture = "";

  Channel({required this.id, required this.title, required this.profilePicture});

  factory Channel.fromJson(Map<String, dynamic> json){
    return Channel(
      id: json["id"],
      title: json["snippet"]["title"],
      profilePicture: json["snippet"]["thumbnails"]["default"]["url"],
    );
  }
}