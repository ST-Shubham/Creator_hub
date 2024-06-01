import 'package:flutter/material.dart';
import 'package:creator_hub/Models/textstyles.dart';
import 'package:creator_hub/Models/video.dart';

class VideoCard extends StatelessWidget {
  const VideoCard({super.key, required this.video});

  final Video video;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: video.thumbnail,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
            child: Row(children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 35,
                    child: CircleAvatar(
                      backgroundImage: video.channel.profilePicture,
                    ),
                  ),
                  Container()
                ],
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(video.getVideoTitle(), style: videoTitleStyle),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text(
                            video.channel.channelName,
                            style: videoInfoStyle,
                          ),
                          Text(
                            " ∙ ",
                            style: videoInfoStyle,
                          ),
                          Text(
                            "${video.getViewCount()} views",
                            style: videoInfoStyle,
                          ),
                          Text(
                            " ∙ ",
                            style: videoInfoStyle,
                          ),
                          Text(
                            "${video.getTimeSinceUpload()} ago",
                            style: videoInfoStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}
