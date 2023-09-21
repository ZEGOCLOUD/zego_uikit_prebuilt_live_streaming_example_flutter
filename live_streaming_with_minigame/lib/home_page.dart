// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import 'constants.dart';
import 'game_page.dart';
// Project imports:
import 'live_page.dart';

class HomePage extends StatelessWidget {
  /// Users who use the same liveID can join the same live streaming.
  final liveTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(120, 60),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID:$localUserID'),
            TextFormField(
              controller: liveTextCtrl,
              decoration: const InputDecoration(labelText: 'join a live by id'),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Start a live'),
              onPressed: () {
                if (ZegoUIKitPrebuiltLiveStreamingMiniOverlayMachine()
                    .isMinimizing) {
                  /// when the application is minimized (in a minimized state),
                  /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                  return;
                }

                jumpToLivePage(
                  context,
                  liveID: liveTextCtrl.text.trim(),
                  isHost: true,
                );
              },
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Watch a live'),
              onPressed: () {
                if (ZegoUIKitPrebuiltLiveStreamingMiniOverlayMachine()
                    .isMinimizing) {
                  /// when the application is minimized (in a minimized state),
                  /// disable button clicks to prevent multiple PrebuiltLiveStreaming components from being created.
                  return;
                }

                jumpToLivePage(
                  context,
                  liveID: liveTextCtrl.text.trim(),
                  isHost: false,
                );
              },
            ),
            const SizedBox(height: 20),
            // click me to navigate to GamePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Start a game'),
              onPressed: () {
                jumpToGamePage(
                  context,
                  roomID: liveTextCtrl.text.trim(),
                  isHost: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void jumpToLivePage(BuildContext context,
      {required String liveID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          liveID: liveID,
          isHost: isHost,
          userID: localUserID,
          userName: 'user_$localUserID',
        ),
      ),
    );
  }

  void jumpToGamePage(BuildContext context,
      {required String roomID, required bool isHost}) {
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
