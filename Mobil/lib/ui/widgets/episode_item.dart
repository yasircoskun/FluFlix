import 'package:better_player/better_player.dart';
import 'package:fluflix/scripts/PlayerController.dart';
import 'package:flutter/material.dart';

import 'package:fluflix/scripts/dizigom_scarper.dart';

class EpisodeItem extends StatefulWidget {
  EpisodeItem(
      {required this.text,
      required this.link,
      selected,
      required this.changeVideo,
      required this.videoPlayerController})
      : super();
  final Function(String, String) changeVideo;
  final String text, link;
  final BetterPlayerController videoPlayerController;
  bool selected = false;
  @override
  _EpisodeItemState createState() => _EpisodeItemState();
}

class _EpisodeItemState extends State<EpisodeItem> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        print("Tapped on ${widget.text} >> ${widget.link}");
        String videoLink = await getVideo(widget.link);
        //await widget.videoPlayerController.stop();
        await widget.videoPlayerController.setupDataSource(
            BetterPlayerDataSource(
                BetterPlayerDataSourceType.network, videoLink));
        print(videoLink);
        widget.selected = true;
        widget.changeVideo(videoLink, widget.text);
      },
      child: Container(
          margin: EdgeInsets.all(7),
          child: Text("${widget.text}", style: TextStyle(color: Colors.white))),
    );
  }
}
