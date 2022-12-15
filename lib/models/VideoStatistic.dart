class VideoStatistic{
  String viewCount = "";
  String likeCount = "";

  VideoStatistic ({required this.viewCount, required this.likeCount});

  factory VideoStatistic.fromJson(Map<String, dynamic> json){
    return VideoStatistic(
        viewCount: json["statistics"]["viewCount"],
        likeCount: json["statistics"]["likeCount"]
    );
  }

}