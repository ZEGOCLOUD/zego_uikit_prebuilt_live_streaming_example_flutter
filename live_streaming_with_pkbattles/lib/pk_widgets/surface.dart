import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import 'package:live_streaming_with_pkbattles/pk_widgets/widgets/join_widget.dart';
import 'package:live_streaming_with_pkbattles/pk_widgets/widgets/quit_button.dart';
import 'package:live_streaming_with_pkbattles/pk_widgets/widgets/request_widget.dart';
import 'package:live_streaming_with_pkbattles/pk_widgets/widgets/requesting_id.dart';
import 'package:live_streaming_with_pkbattles/pk_widgets/widgets/requesting_list.dart';
import 'package:live_streaming_with_pkbattles/pk_widgets/widgets/stop_button.dart';

class PKV2Surface extends StatefulWidget {
  final ZegoUIKitPrebuiltLiveStreamingController liveController;
  final ValueNotifier<Map<String, List<String>>>
      requestingHostsMapRequestIDNotifier;
  final ValueNotifier<String> requestIDNotifier;
  final ValueNotifier<ZegoLiveStreamingState> liveStateNotifier;

  const PKV2Surface({
    Key? key,
    required this.liveController,
    required this.requestIDNotifier,
    required this.liveStateNotifier,
    required this.requestingHostsMapRequestIDNotifier,
  }) : super(key: key);

  @override
  State<PKV2Surface> createState() => _PKV2SurfaceState();
}

class _PKV2SurfaceState extends State<PKV2Surface> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ZegoLiveStreamingState>(
      valueListenable: widget.liveStateNotifier,
      builder: (context, state, _) {
        const baseYPos = 50;

        final canPK = state != ZegoLiveStreamingState.idle;
        return canPK
            ? Stack(children: [
                Positioned(
                  bottom: baseYPos + 3 * 30 + 3 * 5,
                  right: 1,
                  child: PKQuitButton(
                    liveController: widget.liveController,
                    liveStateNotifier: widget.liveStateNotifier,
                    requestingHostsMapRequestIDNotifier:
                        widget.requestingHostsMapRequestIDNotifier,
                  ),
                ),
                Positioned(
                  bottom: baseYPos + 2 * 30 + 2 * 5,
                  right: 1,
                  child: PKStopButton(
                    liveController: widget.liveController,
                    liveStateNotifier: widget.liveStateNotifier,
                    requestingHostsMapRequestIDNotifier:
                        widget.requestingHostsMapRequestIDNotifier,
                  ),
                ),
                Positioned(
                  bottom: baseYPos + 30 + 5,
                  right: 1,
                  child: PKRequestWidget(
                    liveController: widget.liveController,
                    requestIDNotifier: widget.requestIDNotifier,
                    requestingHostsMapRequestIDNotifier:
                        widget.requestingHostsMapRequestIDNotifier,
                  ),
                ),
                // Positioned(
                //   bottom: baseYPos,
                //   right: 1,
                //   child: PKJoinWidget(
                //     liveController: widget.liveController,
                //     requestingHostsMapRequestIDNotifier:
                //         widget.requestingHostsMapRequestIDNotifier,
                //   ),
                // ),
                Positioned(
                  left: 1,
                  bottom: baseYPos + 150 + 60,
                  child: PKRequestingID(
                    requestIDNotifier: widget.requestIDNotifier,
                  ),
                ),
                Positioned(
                  left: 1,
                  bottom: baseYPos + 60,
                  child: PKRequestingList(
                    liveController: widget.liveController,
                    requestingHostsMapRequestIDNotifier:
                        widget.requestingHostsMapRequestIDNotifier,
                  ),
                ),
              ])
            : Container();
      },
    );
  }
}
