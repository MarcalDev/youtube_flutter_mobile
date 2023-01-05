import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_flutter_mobile/models/Channel.dart';
import 'package:youtube_flutter_mobile/models/Video.dart';
import 'package:youtube_flutter_mobile/models/VideoStatistic.dart';

class ChannelInfoWidget extends StatefulWidget {
  const ChannelInfoWidget({
    Key? key,
    required this.actualChannel,
    required this.actualVideoStatistic,
    required this.actualVideo,
  }) : super(key: key);
  final Channel actualChannel;
  final VideoStatistic actualVideoStatistic;
  final Video actualVideo;
  @override
  State<ChannelInfoWidget> createState() => _ChannelInfoWidgetState();
}

class _ChannelInfoWidgetState extends State<ChannelInfoWidget> {
  _numberFormatter(String number){
    double doubleNumber = double.parse(number);
    if(doubleNumber >= 1000 && doubleNumber<1000000){
      doubleNumber = (doubleNumber/1000);
      return doubleNumber.toStringAsFixed(1) + 'K';
    }else if(doubleNumber>=1000000){
      doubleNumber = (doubleNumber/1000000);
      return doubleNumber.toStringAsFixed(1) + 'M';
    } else{
      return number;
    }
  }
  _dateFormatter(String data){
    var parsedDate = DateTime.parse(data);
    var timeBetween = DateTime.now().difference(parsedDate);
    if(timeBetween.inDays >= 30 ){
      var months = timeBetween.inDays/30;
      if(months > 12){
        if(months>1){
          return(months/12).toStringAsFixed(0) + ' years ago';
        }else{
          return(months/12).toStringAsFixed(0) + ' year ago';
        }
      } else{
        if(months>1){
          return months.toStringAsFixed(0) + ' months ago';
        }else{
          return months.toStringAsFixed(0) + ' month ago';
        }
      }
    } else if(timeBetween.inDays > 1){
      return (timeBetween.inDays).toString() + ' days ago';
    } else{
      return '1 day ago';
    }

  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.actualVideo.title,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                ),
              ),
              Row(
                children: [
                  Text(
                    _numberFormatter(widget.actualVideoStatistic!.viewCount) + ' views',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '  •  ' + _dateFormatter(widget.actualVideo!.publishDate),
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        //Row de reações de video
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Icon(Icons.thumb_up_outlined),
                  Text(_numberFormatter(widget.actualVideoStatistic!.likeCount),style: TextStyle(fontSize: 14)
                  )
                ],
              ),
              Icon(Icons.thumb_down_outlined),
              Column(
                children: [
                  Icon(CupertinoIcons.arrowshape_turn_up_right),
                  Text("Share",style: TextStyle(fontSize: 14))
                ],
              ),
              Column(
                children: [
                  Icon(CupertinoIcons.arrow_down_to_line),
                  Text("Download",style: TextStyle(fontSize: 14)
                  )
                ],
              ),
              Column(
                children: [
                  Icon(CupertinoIcons.plus_rectangle_on_rectangle),
                  Text("Save",style: TextStyle(fontSize: 14))
                ],
              ),
            ]),
        Container(
          margin: EdgeInsets.fromLTRB(0, 15, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  margin: EdgeInsets.only(left:12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius:15,
                        backgroundImage: NetworkImage(widget.actualChannel!.profilePicture),
                      ),
                      Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               Container(
                                    padding: EdgeInsets.only(right: 25),
                                    child: Text(widget.actualChannel!.title, overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16)),
                                  ),
                                  Text("2.21M subscribers",style: TextStyle(fontSize: 14))
                            ],
                          )
                      ),
                    ],
                  )
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("SUBSCRIBE",style: TextStyle(fontSize: 17,color: Colors.red,fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 12, 0),
                      child: Icon(CupertinoIcons.bell),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
