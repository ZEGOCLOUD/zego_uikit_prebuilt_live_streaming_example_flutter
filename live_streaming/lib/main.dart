// Flutter imports:
import 'package:flutter/material.dart';
import 'package:live_streaming/home_page.dart';

// Package imports:
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ZegoUIKit().initLog().then((value) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: ZegoUIKitPrebuiltLiveStreamingMiniPopScope(
        child: HomePage(),
      ),
    );
  }
}
