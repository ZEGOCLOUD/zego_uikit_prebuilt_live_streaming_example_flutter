// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import 'constants.dart';
import 'game_page.dart';
// Project imports:
import 'live_audio_room_page.dart';
import 'live_streaming_page.dart';

class HomePage extends StatelessWidget {
  /// Users who use the same liveID can join the same live streaming.
  final liveStreamingTextCtrl = TextEditingController(text: Random().nextInt(1000000).toString());
  final liveAudioRoomTextCtrl = TextEditingController(text: Random().nextInt(1000000).toString());

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(children: [const SizedBox(width: 20), Text('User ID:$localUserID')]),
            const Divider(height: 40),
            IntrinsicHeight(
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, children: [
                const SizedBox(width: 20),
                liveStreamingEntry(context),
                const VerticalDivider(width: 30),
                liveAudioRoomEntry(context),
                const SizedBox(width: 20),
                // live streaming
              ]),
            ),
            const Divider(height: 40),
            // click me to navigate to GamePage
            ElevatedButton(
              style: ElevatedButton.styleFrom(fixedSize: const Size(300, 50)),
              child: const Text('Start a game without Live'),
              onPressed: () {
                jumpToGamePage(
                  context,
                  roomID: liveStreamingTextCtrl.text.trim(),
                  isHost: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget liveStreamingEntry(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text('LiveStreaming', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          const SizedBox(height: 20),
          TextFormField(
            controller: liveStreamingTextCtrl,
            decoration: const InputDecoration(
              labelText: 'live streaming id',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          // click me to navigate to LiveStreamingPage
          ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: const Size(140, 50)),
            child: const Text('Start a Live'),
            onPressed: () {
              if (ZegoUIKitPrebuiltLiveStreamingMiniOverlayMachine().isMinimizing) {
                /// when the application is minimized (in a minimized state),
                /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                return;
              }

              jumpToLiveStreamingPage(
                context,
                liveID: liveStreamingTextCtrl.text.trim(),
                isHost: true,
              );
            },
          ),
          const SizedBox(height: 20),
          // click me to navigate to LiveStreamingPage
          ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: const Size(140, 50)),
            child: const Text('Watch a live'),
            onPressed: () {
              if (ZegoUIKitPrebuiltLiveStreamingMiniOverlayMachine().isMinimizing) {
                /// when the application is minimized (in a minimized state),
                /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                return;
              }

              jumpToLiveStreamingPage(
                context,
                liveID: liveStreamingTextCtrl.text.trim(),
                isHost: false,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget liveAudioRoomEntry(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text('LiveAudioRoom', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          const SizedBox(height: 20),
          TextFormField(
            controller: liveAudioRoomTextCtrl,
            decoration: const InputDecoration(
              labelText: 'live audio room id',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          // click me to navigate to LiveAudioRoomPage
          ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: const Size(140, 50)),
            child: const Text('Start a live'),
            onPressed: () {
              if (ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().isMinimizing) {
                /// when the application is minimized (in a minimized state),
                /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                return;
              }

              jumpToLiveAudioRoomPage(
                context,
                roomID: liveAudioRoomTextCtrl.text.trim(),
                isHost: true,
              );
            },
          ),
          const SizedBox(height: 20),
          // click me to navigate to LiveAudioRoomPage
          ElevatedButton(
            style: ElevatedButton.styleFrom(fixedSize: const Size(140, 50)),
            child: const Text('Watch a live'),
            onPressed: () {
              if (ZegoUIKitPrebuiltLiveAudioRoomMiniOverlayMachine().isMinimizing) {
                /// when the application is minimized (in a minimized state),
                /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                return;
              }

              jumpToLiveAudioRoomPage(
                context,
                roomID: liveAudioRoomTextCtrl.text.trim(),
                isHost: false,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void jumpToLiveStreamingPage(BuildContext context, {required String liveID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveStreamingPage(
          liveID: liveID,
          isHost: isHost,
          userID: localUserID,
          userName: 'user_$localUserID',
        ),
      ),
    );
  }

  void jumpToLiveAudioRoomPage(BuildContext context, {required String roomID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveAudioRoomPage(
          roomID: roomID,
          isHost: isHost,
          userID: localUserID,
          userName: 'user_$localUserID',
        ),
      ),
    );
  }

  void jumpToGamePage(BuildContext context, {required String roomID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ZegoMiniGamePage(
          userID: localUserID,
          userName: 'user_$localUserID',
          roomID: roomID,
        ),
      ),
    );
  }
}
