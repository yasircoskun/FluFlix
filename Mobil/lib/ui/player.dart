import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:fluflix/scripts/PlayerController.dart';
import 'package:fluflix/ui/widgets/player_controller.dart';
import 'package:flutter/material.dart';

import 'package:fluflix/ui/widgets/episode_item.dart';
import 'package:fluflix/scripts/dizigom_scarper.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wakelock/wakelock.dart';

class Player extends StatefulWidget {
  final globalKey = GlobalKey<ScaffoldState>();
  @override
  PlayerState createState() => PlayerState();
}

class PlayerState extends State<Player> {
  GlobalKey _betterPlayerKey = GlobalKey();

  PlayerState();
  String diziLink = '';

  List<EpisodeItem> episodeList = [];
  late StreamController<List<EpisodeItem>> _episodeStream;
  int selectedIndex = 0;
  String _currentLink = '';
  late BetterPlayerController _betterPlayerController;
  late Future episodeFuture;

  bool _hideStuff = false;

  int numberOfEpisodes = 0;
  String selectedText = "";

  changeVideo(String videoLink, String text) {
    setState(() {
      _currentLink = videoLink;
      selectedText = text;
      episodeList.forEach((e) => {
            if (e.text != text) {e.selected = false}
          });
      Navigator.pop(context);
    });
  }

  nextVideo() async {
    episodeList[selectedIndex % episodeList.length].selected = false;
    selectedIndex += 1;
    if (selectedIndex <= episodeList.length) {
      _currentLink =
          await getVideo(episodeList[selectedIndex % episodeList.length].link);
      episodeList[selectedIndex % episodeList.length].selected = true;
      _betterPlayerController.setupDataSource(BetterPlayerDataSource(
          BetterPlayerDataSourceType.network, _currentLink));

      //await _videoPlayerController.setMediaFromNetwork(_currentLink);
    }

    setState(() {
      episodeFuture = getEpisodes(
          diziLink, changeVideo, _betterPlayerController, episodeList);
      numberOfEpisodes = episodeList.length;
    });
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    selectedIndex = 0;
    // _videoPlayerController = PlayerController.network(_currentLink);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    _betterPlayerController = BetterPlayerController(
      BetterPlayerConfiguration(
        //allowedScreenSleep: false,
        //fullScreenByDefault: true,

        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ],
        controlsConfiguration: BetterPlayerControlsConfiguration(
          overflowModalColor: Colors.black,
          overflowModalTextColor: Colors.white,
          overflowMenuIconsColor: Colors.white,
          enableFullscreen: false,
        ),
        autoPlay: true,
        eventListener: (event) {
          print(event);
          if (event.betterPlayerEventType == BetterPlayerEventType.finished) {
            nextVideo();
          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.controlsVisible) {
            _hideStuff = true;
            setState(() {});
          } else if (event.betterPlayerEventType ==
              BetterPlayerEventType.controlsHidden) {
            _hideStuff = false;
            setState(() {});
          }
        },
      ),
    );

    _episodeStream = new BehaviorSubject();
    _episodeStream.add(episodeList);
  }

  @override
  void dispose() async {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _betterPlayerController.dispose();
    //_betterPlayerController.videoPlayerController.position
    _episodeStream.close();
  }

  prevVideo() {
    setState(() {
      selectedIndex -= 1;
      _currentLink = episodeList[selectedIndex].link;
    });
  }

  @override
  Widget build(BuildContext context) {
    diziLink = ModalRoute.of(context)!.settings.arguments.toString();

    episodeFuture = getEpisodes(
        diziLink, changeVideo, _betterPlayerController, episodeList);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIOverlays([]);
    episodeFuture.whenComplete(() async {
      if (this.numberOfEpisodes == 0 && episodeList.length != 0) {
        episodeList[selectedIndex].selected = true;
        _currentLink = await getVideo(episodeList[selectedIndex].link);
        _betterPlayerController.setupDataSource(BetterPlayerDataSource(
            BetterPlayerDataSourceType.network, _currentLink));

        //_betterPlayerController.enablePictureInPicture(_betterPlayerKey);
        setState(() {
          numberOfEpisodes = episodeList.length;
        });
      }
    });
    return Scaffold(
      key: widget.globalKey,
      backgroundColor: Colors.black,
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: Container(
          color: Colors.black,
          child: StreamBuilder(
            builder: (context, AsyncSnapshot<List<EpisodeItem>> episodeSnap) {
              return episodeSnap.hasData
                  ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: episodeSnap.data!.length,
                      itemBuilder: (context, index) {
                        print(episodeSnap.data![index]);
                        if (selectedText == episodeSnap.data![index].text) {
                          selectedIndex = index;
                          selectedText = episodeSnap.data![selectedIndex].text;
                        }
                        return Container(
                          child: episodeSnap.data![index],
                          color: episodeSnap.data![index].selected
                              ? Colors.orange
                              : Colors.black,
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
            stream: _episodeStream.stream,
          ),
        ),
      ),
      body: Stack(children: [
        BetterPlayer(
          controller: _betterPlayerController,
          key: _betterPlayerKey,
        ),
        Positioned(
          left: 10.0,
          top: 10.0,
          child: Visibility(
            visible: _hideStuff,
            child: Container(
              child: InkWell(
                child: Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                onTap: () {
                  widget.globalKey.currentState!.openDrawer();
                },
              ),
            ),
          ),
        ),
      ] /*
                   
        VlcPlayerWithControls(
          key: _key,
          controller: _videoPlayerController,
          onEnd: nextVideo,
          numberOfEpisodes: numberOfEpisodes,
        ),
         */
          ),
    );
  }
}
