import 'package:flutter/material.dart';
import 'package:live_streaming_with_pkbattles/home_page.dart';

import 'package:zego_uikit/zego_uikit.dart';

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
    return MaterialApp(title: 'Flutter Demo', home: HomePage());
  }
}
