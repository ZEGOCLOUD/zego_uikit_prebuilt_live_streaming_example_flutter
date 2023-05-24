import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class StopPKBattleButton extends StatelessWidget {
  const StopPKBattleButton({
    Key? key,
  }) : super(key: key);

  void stopPKBattle(context) {
    ZegoUIKitPrebuiltLiveStreamingPKService().stopPKBattle().then((ret) {
      if (ret.error != null && ret.error!.code != '-1') {
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('stopPKBattle failed'),
              content: Text('Error: ${ret.error}'),
              actions: [
                CupertinoDialogAction(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => stopPKBattle(context),
      child: const Text('Stop PK Battle'),
    );
  }
}
