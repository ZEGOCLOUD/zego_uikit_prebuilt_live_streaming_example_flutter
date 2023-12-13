import 'dart:async';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import 'common.dart';
import 'constants.dart';
import 'main.dart';
import 'minigame/service/mini_game_api.dart';
import 'minigame/ui/show_game_list_view.dart';
import 'minigame/ui/start_game_dialog.dart';
import 'minigame/your_game_server.dart';

part 'live_audio_room_game.dart';

class LiveAudioRoomPage extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final String userID;
  final String userName;

  const LiveAudioRoomPage({
    Key? key,
    required this.roomID,
    required this.userID,
    required this.userName,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LiveAudioRoomPageState();
}

class LiveAudioRoomPageState extends State<LiveAudioRoomPage> {
  late final InRoomGameController _gameCtrl = InRoomGameController(
    userID: widget.userID,
    userName: widget.userName,
    roomID: widget.roomID,
    roomController: liveAudioRoomZegoController,
    isHost: widget.isHost,
  );
  final liveAudioRoomZegoController = ZegoLiveAudioRoomController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _gameCtrl.init(); // you need uninit _gameCtrl in the onWillPop block
    });
  }

  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveAudioRoomConfig.host();
    final audienceConfig = ZegoUIKitPrebuiltLiveAudioRoomConfig.audience();

    return PopScope(
      onPopInvoked: (bool didPop) async {
        if (didPop) await _gameCtrl.uninit();
      },
      child: SafeArea(
        child: Stack(
          children: [
            ZegoUIKitPrebuiltLiveAudioRoom(
              appID: yourAppID /*input your AppID*/,
              appSign: yourAppSign /*input your AppSign*/,
              userID: widget.userID,
              userName: widget.userName,
              roomID: widget.roomID,
              controller: liveAudioRoomZegoController,
              config: (widget.isHost ? hostConfig : audienceConfig)
                ..userAvatarUrl = 'https://robohash.org/$localUserID.png?set=set4'
                ..bottomMenuBarConfig.hostExtendButtons = [_gameCtrl.gameButton()]
                ..closeSeatsWhenJoining = false
                ..bottomMenuBarConfig.hostButtons = [
                  ZegoMenuBarButtonName.toggleMicrophoneButton,
                  ZegoMenuBarButtonName.showMemberListButton,
                ]
                ..emptyAreaBuilder = ((_) => _gameCtrl.gameView())
                ..background = background(),
            ),
          ],
        ),
      ),
    );
  }

  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.asset('assets/images/background.png').image,
            ),
          ),
        ),
        const Positioned(
            top: 10,
            left: 10,
            child: Text(
              'Live Audio Room',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xff1B1B1B),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            )),
        Positioned(
          top: 10 + 20,
          left: 10,
          child: Text(
            'ID: ${widget.roomID}',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xff606060),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
