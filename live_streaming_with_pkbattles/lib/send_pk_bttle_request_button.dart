import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class SendPKBattleRequestButton extends StatelessWidget {
  const SendPKBattleRequestButton({
    Key? key,
  }) : super(key: key);

  void sendPKBattleRequest(context, anotherHostUserID) {
    ZegoUIKitPrebuiltLiveStreamingPKService()
        .sendPKBattleRequest(anotherHostUserID)
        .then((ret) {
      if (ret.error != null) {
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('sendPKBattleRequest failed'),
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
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final controller = TextEditingController();
            return CupertinoAlertDialog(
              title: const Text('Input a user id'),
              content: CupertinoTextField(controller: controller),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: const Text('OK'),
                  onPressed: () {
                    sendPKBattleRequest(context, controller.text);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      },
      child: const Text('PK Battle Request'),
    );
  }
}
