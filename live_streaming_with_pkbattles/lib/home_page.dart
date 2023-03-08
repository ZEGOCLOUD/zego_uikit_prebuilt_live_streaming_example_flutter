// Dart imports:
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:live_streaming_with_pkbattles/live_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  /// Users who use the same liveID can join the same live streaming.
  final liveTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());

  final userIDTextCtrl =
      TextEditingController(text: Random().nextInt(100000).toString());

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(120, 60),
      backgroundColor: const Color(0xff2C2F3E).withOpacity(0.6),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please test with two or more devices'),
            TextFormField(
              controller: userIDTextCtrl,
              decoration: const InputDecoration(labelText: 'your userID'),
            ),
            TextFormField(
              controller: liveTextCtrl,
              decoration:
                  const InputDecoration(labelText: 'join a live by liveID'),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Start a live'),
              onPressed: () => jumpToLivePage(
                context,
                localUserID: userIDTextCtrl.text,
                liveID: liveTextCtrl.text,
                isHost: true,
              ),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Watch a live'),
              onPressed: () => jumpToLivePage(
                context,
                localUserID: userIDTextCtrl.text,
                liveID: liveTextCtrl.text,
                isHost: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void jumpToLivePage(BuildContext context,
      {required String liveID,
      required String localUserID,
      required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          localUserID: localUserID,
          liveID: liveID,
          isHost: isHost,
        ),
      ),
    );
  }
}
