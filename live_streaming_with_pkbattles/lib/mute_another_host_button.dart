import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class MuteAnotherHostButton extends StatelessWidget {
  const MuteAnotherHostButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable:
          ZegoUIKitPrebuiltLiveStreamingService().isAnotherHostMuted,
      builder: (context, isMuted, _) {
        return IconButton(
          onPressed: () {
            ZegoUIKitPrebuiltLiveStreamingService()
                .muteAnotherHostAudio(mute: !isMuted);
          },
          icon: Icon(
            isMuted ? Icons.volume_off : Icons.volume_up,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
