import 'package:flutter/material.dart';
import 'package:creator_hub/Models/channel.dart';
import 'package:creator_hub/Models/textstyles.dart';

class ChannelAvatar extends StatelessWidget {
  const ChannelAvatar({super.key, required this.channel});
  final Channel channel;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: channel.profilePicture,
          radius: 30,
        ),
        Text(
          channel.channelName,
          style: videoInfoStyle,
        )
      ],
    );
  }
}
