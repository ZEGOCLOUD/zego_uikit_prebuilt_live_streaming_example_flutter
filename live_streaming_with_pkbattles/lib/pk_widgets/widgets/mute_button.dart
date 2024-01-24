import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class PKMuteButton extends StatefulWidget {
  final String userID;

  const PKMuteButton({
    Key? key,
    required this.userID,
  }) : super(key: key);

  @override
  State<PKMuteButton> createState() => _PKMuteButtonState();
}

class _PKMuteButtonState extends State<PKMuteButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable:
          ZegoUIKitPrebuiltLiveStreamingController().pk.mutedUsersNotifier,
      builder: (context, muteUsers, _) {
        return GestureDetector(
          onTap: () {
            ZegoUIKitPrebuiltLiveStreamingController().pk.muteAudios(
              targetHostIDs: [widget.userID],
              isMute: !muteUsers.contains(widget.userID),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.6),
            ),
            child: Icon(
              muteUsers.contains(widget.userID)
                  ? Icons.volume_off
                  : Icons.volume_up,
              color: Colors.black,
              // size: 25,
            ),
          ),
        );
      },
    );
  }
}
