// Flutter imports:
import 'dart:math';

import 'package:flutter/material.dart';
// Project imports:
import 'package:live_streaming_cohost/common.dart';
//
import 'package:live_streaming_cohost/constants.dart';
// Package imports:
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final String localUserID;

  const LivePage({
    Key? key,
    required this.liveID,
    required this.localUserID,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<LivePage> {
  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
      plugins: [ZegoUIKitSignalingPlugin()],
    )..audioVideoView.foregroundBuilder = hostAudioVideoViewForegroundBuilder;

    final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
      plugins: [ZegoUIKitSignalingPlugin()],
    );
    final audienceEvents = ZegoUIKitPrebuiltLiveStreamingEvents(
        onError: (ZegoUIKitError error) {
          debugPrint('onError:$error');
        },
        audioVideo: ZegoLiveStreamingAudioVideoEvents(
          onCameraTurnOnByOthersConfirmation: (BuildContext context) {
            return onTurnOnAudienceDeviceConfirmation(
              context,
              isCameraOrMicrophone: true,
            );
          },
          onMicrophoneTurnOnByOthersConfirmation: (BuildContext context) {
            return onTurnOnAudienceDeviceConfirmation(
              context,
              isCameraOrMicrophone: false,
            );
          },
        ));

    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: yourAppID /*input your AppID*/,
        appSign: yourAppSign /*input your AppSign*/,
        userID: localUserID,
        userName: 'user_$localUserID',
        liveID: widget.liveID,
        events: widget.isHost
            ? ZegoUIKitPrebuiltLiveStreamingEvents(
                onError: (ZegoUIKitError error) {
                  debugPrint('onError:$error');
                },
              )
            : audienceEvents,
        config: (widget.isHost ? hostConfig : audienceConfig)
          ..audioVideoView.useVideoViewAspectFill = true

          /// support minimizing
          ..topMenuBar.buttons = [
            ZegoLiveStreamingMenuBarButtonName.minimizingButton,
          ]

          /// custom avatar
          ..avatarBuilder = customAvatarBuilder

          /// message attributes example
          ..inRoomMessage.attributes = userLevelsAttributes
          ..inRoomMessage.avatarLeadingBuilder = userLevelBuilder,
      ),
    );
  }

  Map<String, String> userLevelsAttributes() {
    return {
      'lv': Random(localUserID.hashCode).nextInt(100).toString(),
    };
  }

  Widget userLevelBuilder(
    BuildContext context,
    ZegoInRoomMessage message,
    Map<String, dynamic> extraInfo,
  ) {
    return Container(
      alignment: Alignment.center,
      height: 15,
      width: 30,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.purple.shade300, Colors.purple.shade400],
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        "LV ${message.attributes['lv']}",
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  Image prebuiltImage(String name) {
    return Image.asset(name, package: 'zego_uikit_prebuilt_live_streaming');
  }

  Widget hostAudioVideoViewForegroundBuilder(
    BuildContext context,
    Size size,
    ZegoUIKitUser? user,
    Map<String, dynamic> extraInfo,
  ) {
    if (user == null || user.id == localUserID) {
      return Container();
    }

    const toolbarCameraNormal = 'assets/icons/toolbar_camera_normal.png';
    const toolbarCameraOff = 'assets/icons/toolbar_camera_off.png';
    const toolbarMicNormal = 'assets/icons/toolbar_mic_normal.png';
    const toolbarMicOff = 'assets/icons/toolbar_mic_off.png';
    return Positioned(
      top: 15,
      right: 0,
      child: Row(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: ZegoUIKit().getCameraStateNotifier(user.id),
            builder: (context, isCameraEnabled, _) {
              return GestureDetector(
                onTap: () {
                  ZegoUIKit().turnCameraOn(!isCameraEnabled, userID: user.id);
                },
                child: SizedBox(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  child: prebuiltImage(
                    isCameraEnabled ? toolbarCameraNormal : toolbarCameraOff,
                  ),
                ),
              );
            },
          ),
          SizedBox(width: size.width * 0.1),
          ValueListenableBuilder<bool>(
            valueListenable: ZegoUIKit().getMicrophoneStateNotifier(user.id),
            builder: (context, isMicrophoneEnabled, _) {
              return GestureDetector(
                onTap: () {
                  ZegoUIKit().turnMicrophoneOn(
                    !isMicrophoneEnabled,
                    userID: user.id,

                    ///  if you don't want to stop co-hosting automatically when both camera and microphone are off,
                    ///  set the [muteMode] parameter to true.
                    ///
                    ///  However, in this case, your [ZegoUIKitPrebuiltLiveStreamingConfig.stopCoHostingWhenMicCameraOff]
                    ///  should also be set to false.
                    muteMode: true,
                  );
                },
                child: SizedBox(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  child: prebuiltImage(
                    isMicrophoneEnabled ? toolbarMicNormal : toolbarMicOff,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<bool> onTurnOnAudienceDeviceConfirmation(
    BuildContext context, {
    required bool isCameraOrMicrophone,
  }) async {
    const textStyle = TextStyle(
      fontSize: 10,
      color: Colors.white70,
    );
    const buttonTextStyle = TextStyle(
      fontSize: 10,
      color: Colors.black,
    );
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900]!.withOpacity(0.9),
          title: Text(
              "You have a request to turn on your ${isCameraOrMicrophone ? "camera" : "microphone"}",
              style: textStyle),
          content: Text(
              "Do you agree to turn on the ${isCameraOrMicrophone ? "camera" : "microphone"}?",
              style: textStyle),
          actions: [
            ElevatedButton(
              child: const Text('Cancel', style: buttonTextStyle),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('OK', style: buttonTextStyle),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
