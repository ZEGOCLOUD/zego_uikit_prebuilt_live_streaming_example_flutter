import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class CancelPKBattleRequestButton extends StatelessWidget {
  const CancelPKBattleRequestButton({
    Key? key,
  }) : super(key: key);

  void cancelPKBattleRequest(context) {
    ZegoUIKitPrebuiltLiveStreamingPKService()
        .cancelPKBattleRequest()
        .then((ret) {
      if (ret.error != null) {
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('cancelPKBattleRequest failed'),
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
      onPressed: () => cancelPKBattleRequest(context),
      child: Row(
        children: const [
          CupertinoActivityIndicator(),
          Text('Cancel'),
        ],
      ),
    );
  }
}
