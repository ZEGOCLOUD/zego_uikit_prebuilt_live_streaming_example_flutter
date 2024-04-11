import 'package:flutter/material.dart';

import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

ZegoLiveStreamingPKBattleConfig pkConfig() {
  return ZegoLiveStreamingPKBattleConfig(
    // mixerLayout: PKGridLayout(),
    // pKBattleViewTopPadding: 100,
    // hostReconnectingBuilder: (
    //   BuildContext context,
    //   ZegoUIKitUser? host,
    //   Map<String, dynamic> extraInfo,
    // ) {
    //   return const CircularProgressIndicator(
    //     backgroundColor: Colors.red,
    //     color: Colors.purple,
    //   );
    // },
    foregroundBuilder: (
      BuildContext context,
      List<ZegoUIKitUser?> hosts,
      Map<String, dynamic> extraInfo,
    ) {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
        child: const Center(
          child: Text('pkBattleViewForegroundBuilder'),
        ),
      );
    },
    topBuilder: (
      BuildContext context,
      List<ZegoUIKitUser?> hosts,
      Map<String, dynamic> extraInfo,
    ) {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),
        child: const Center(
          child: Text('pkBattleViewTopBuilder'),
        ),
      );
    },
    bottomBuilder: (
      BuildContext context,
      List<ZegoUIKitUser?> hosts,
      Map<String, dynamic> extraInfo,
    ) {
      return Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),
        child: const Center(
          child: Text('pkBattleViewBottomBuilder'),
        ),
      );
    },
  );
}

/// two:
/// ┌───┬────┐
/// │😄 │ 😄 │
/// └───┴────┘
/// four:
/// ┌───┬───┐
/// │😄 │😄 │
/// ├───┼───┤
/// │😄 │   │
/// └───┴───┘
/// nine:
/// ┌───┬───┬───┐
/// │😄 │😄 │😄 │
/// ├───┼───┼───┤
/// │😄 │😄 │😄 │
/// ├───┼───┼───┤
/// │😄 │😄 │   │
/// └───┴───┴───┘
class PKGridLayout extends ZegoLiveStreamingPKMixerLayout {
  @override
  Size getResolution() => const Size(1080, 960);

  @override
  List<Rect> getRectList(
    int hostCount, {
    double scale = 1.0,
  }) {
    final resolution = getResolution();
    final rowCount = getRowCount(hostCount);
    final columnCount = getColumnCount(hostCount);
    final itemWidth = resolution.width / columnCount;
    final itemHeight = resolution.height / rowCount;

    final rectList = <Rect>[];
    var hostRowIndex = 0;
    var hostColumnIndex = 0;
    for (var hostIndex = 0; hostIndex < hostCount; ++hostIndex) {
      if (hostColumnIndex == columnCount) {
        hostColumnIndex = 0;
        hostRowIndex++;
      }

      rectList.add(
        Rect.fromLTWH(
          itemWidth * hostColumnIndex * scale,
          itemHeight * hostRowIndex * scale,
          itemWidth * scale,
          itemHeight * scale,
        ),
      );

      ++hostColumnIndex;
    }

    return rectList;
  }

  int getRowCount(int hostCount) {
    if (hostCount > 6) {
      return 3;
    }
    if (hostCount > 2) {
      return 2;
    }
    return 1;
  }

  int getColumnCount(int hostCount) {
    if (hostCount > 4) {
      return 3;
    }
    return 2;
  }
}
