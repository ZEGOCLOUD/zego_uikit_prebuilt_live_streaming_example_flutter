// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

/// Note that the userID needs to be globally unique,
final String localUserID = Random().nextInt(10000).toString();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  /// Users who use the same liveID can join the same live streaming.
  final liveTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());
  final useVideoViewAspectFillNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    var buttonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(120, 60),
      primary: const Color(0xff2C2F3E).withOpacity(0.6),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID:$localUserID'),
            const Text('Please test with two or more devices'),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Layout : "),
                  switchDropList<bool>(
                    useVideoViewAspectFillNotifier,
                    [
                      true,
                      false,
                    ],
                    (bool isUseVideoViewAspectFill) {
                      return Text(isUseVideoViewAspectFill
                          ? "AspectFill"
                          : "AspectFit");
                    },
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: liveTextCtrl,
              decoration: const InputDecoration(labelText: "join a live by id"),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Start a live'),
              onPressed: () => jumpToLivePage(
                context,
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
                liveID: liveTextCtrl.text,
                isHost: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  jumpToLivePage(BuildContext context,
      {required String liveID, required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          liveID: liveID,
          isHost: isHost,
          useVideoViewAspectFill: useVideoViewAspectFillNotifier.value,
        ),
      ),
    );
  }
}

// integrate code :
class LivePage extends StatelessWidget {
  final String liveID;
  final bool isHost;
  final bool useVideoViewAspectFill;

  const LivePage({
    Key? key,
    required this.liveID,
    this.isHost = false,
    this.useVideoViewAspectFill = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: /*input your AppID*/,
        appSign: /*input your AppSign*/,
        userID: localUserID,
        userName: 'user_$localUserID',
        liveID: liveID,
        config: (isHost
            ? ZegoUIKitPrebuiltLiveStreamingConfig.host(
                plugins: [ZegoUIKitSignalingPlugin()],
              )
            : ZegoUIKitPrebuiltLiveStreamingConfig.audience(
                plugins: [ZegoUIKitSignalingPlugin()],
              ))
          ..audioVideoViewConfig.useVideoViewAspectFill =
              useVideoViewAspectFill,
      ),
    );
  }
}

Widget switchDropList<T>(
  ValueNotifier<T> notifier,
  List<T> itemValues,
  Widget Function(T value) widgetBuilder,
) {
  return ValueListenableBuilder<T>(
      valueListenable: notifier,
      builder: (context, value, _) {
        return DropdownButton<T>(
          value: value,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: itemValues.map((T itemValue) {
            return DropdownMenuItem(
              value: itemValue,
              child: widgetBuilder(itemValue),
            );
          }).toList(),
          onChanged: (T? newValue) {
            if (newValue != null) {
              notifier.value = newValue;
            }
          },
        );
      });
}
