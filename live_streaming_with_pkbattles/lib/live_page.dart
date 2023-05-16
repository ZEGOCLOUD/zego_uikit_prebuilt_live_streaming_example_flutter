import 'package:flutter/material.dart';

import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'package:live_streaming_with_pkbattles/cancel_pk_battle_request_button.dart';
import 'package:live_streaming_with_pkbattles/constants.dart';
import 'package:live_streaming_with_pkbattles/mute_another_host_button.dart';
import 'package:live_streaming_with_pkbattles/send_pk_bttle_request_button.dart';
import 'package:live_streaming_with_pkbattles/stop_pk_battle_button.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LivePage extends StatefulWidget {
  final String liveID;
  final String localUserID;
  final bool isHost;

  const LivePage({
    Key? key,
    required this.liveID,
    required this.localUserID,
    this.isHost = false,
  }) : super(key: key);

  @override
  State<LivePage> createState() => _LivePageState();
}

class _LivePageState extends State<LivePage> {
  ValueNotifier<ZegoLiveStreamingState> liveStreamingState =
      ValueNotifier(ZegoLiveStreamingState.idle);

  @override
  Widget build(BuildContext context) {
    late ZegoUIKitPrebuiltLiveStreamingConfig config;
    if (widget.isHost) {
      config = ZegoUIKitPrebuiltLiveStreamingConfig.host(
        plugins: [ZegoUIKitSignalingPlugin()],
      );
      config.audioVideoViewConfig.foregroundBuilder = pkBattleForegroundBuilder;
    } else {
      config = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
        plugins: [ZegoUIKitSignalingPlugin()],
      );
    }

    config.onLiveStreamingStateUpdate = (state) {
      liveStreamingState.value = state;
    };

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ZegoUIKitPrebuiltLiveStreaming(
              appID: yourAppID /*input your AppID*/,
              appSign: yourAppSign /*input your AppSign*/,
              userID: widget.localUserID,
              userName: 'user_${widget.localUserID}',
              liveID: widget.liveID,
              config: config,
            ),
            if (widget.isHost) pkBattleButton(),
          ],
        ),
      ),
    );
  }

  Widget pkBattleButton() {
    return ValueListenableBuilder(
      valueListenable: liveStreamingState,
      builder: (context, value, Widget? child) {
        if ((value == ZegoLiveStreamingState.idle) ||
            (value == ZegoLiveStreamingState.ended)) {
          return const SizedBox.shrink();
        }
        return Positioned(
          bottom: 80,
          right: 10,
          child: ValueListenableBuilder(
            valueListenable:
                ZegoUIKitPrebuiltLiveStreamingService().pkBattleState,
            builder:
                (context, ZegoLiveStreamingPKBattleState pkBattleState, _) {
              switch (pkBattleState) {
                case ZegoLiveStreamingPKBattleState.idle:
                  return const SendPKBattleRequestButton();
                case ZegoLiveStreamingPKBattleState.waitingAnotherHostResponse:
                  return const CancelPKBattleRequestButton();
                case ZegoLiveStreamingPKBattleState.waitingMyResponse:
                case ZegoLiveStreamingPKBattleState.loading:
                  return const CircularProgressIndicator();
                case ZegoLiveStreamingPKBattleState.inPKBattle:
                  return const StopPKBattleButton();
              }
            },
          ),
        );
      },
    );
  }

  Widget pkBattleForegroundBuilder(context, size, ZegoUIKitUser? user, _) {
    if (user != null && user.id != widget.localUserID) {
      return const Positioned(
        top: 5,
        left: 5,
        child: SizedBox(
          width: 40,
          height: 40,
          child: MuteAnotherHostButton(),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
