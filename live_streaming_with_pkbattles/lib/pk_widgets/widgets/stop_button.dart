import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class PKStopButton extends StatefulWidget {
  final ValueNotifier<Map<String, List<String>>>
      requestingHostsMapRequestIDNotifier;
  final ValueNotifier<ZegoLiveStreamingState> liveStateNotifier;

  const PKStopButton({
    Key? key,
    required this.liveStateNotifier,
    required this.requestingHostsMapRequestIDNotifier,
  }) : super(key: key);

  @override
  State<PKStopButton> createState() => _PKStopButtonState();
}

class _PKStopButtonState extends State<PKStopButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.liveStateNotifier,
      builder: (context, state, _) {
        return SizedBox(
          height: 30,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // background (button) color
              foregroundColor: Colors.white, // foreground (text) color
            ),
            onPressed: ZegoLiveStreamingState.inPKBattle == state
                ? () => stopPKBattle(context)
                : null,
            child: const Text('Stop'),
          ),
        );
      },
    );
  }

  void stopPKBattle(context) {
    if (!ZegoUIKitPrebuiltLiveStreamingController().pk.isInPK) {
      return;
    }

    ZegoUIKitPrebuiltLiveStreamingController().pk.stop().then((ret) {
      if (ret.error != null) {
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
      } else {
        widget.requestingHostsMapRequestIDNotifier.value = {};
      }
    });
  }
}
