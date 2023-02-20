import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  /// Users who use the same liveID can join the same live streaming.
  final liveTextCtrl =
      TextEditingController(text: Random().nextInt(10000).toString());

  final userIDTextCtrl =
      TextEditingController(text: Random().nextInt(100000).toString());

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: const Size(120, 60),
      backgroundColor: const Color(0xff2C2F3E).withOpacity(0.6),
    );

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please test with two or more devices'),
            TextFormField(
              controller: userIDTextCtrl,
              decoration: const InputDecoration(labelText: 'your userID'),
            ),
            TextFormField(
              controller: liveTextCtrl,
              decoration:
                  const InputDecoration(labelText: 'join a live by liveID'),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Start a live'),
              onPressed: () => jumpToLivePage(
                context,
                localUserID: userIDTextCtrl.text,
                liveID: liveTextCtrl.text,
                isHost: true,
              ),
            ),
            const SizedBox(height: 20),
            // click me to navigate to LivePage
            ElevatedButton(
              style: buttonStyle,
              child: const Text('Watch a live'),
              onPressed: () => jumpToLivePage(
                context,
                localUserID: userIDTextCtrl.text,
                liveID: liveTextCtrl.text,
                isHost: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void jumpToLivePage(BuildContext context,
      {required String liveID,
      required String localUserID,
      required bool isHost}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LivePage(
          localUserID: localUserID,
          liveID: liveID,
          isHost: isHost,
        ),
      ),
    );
  }
}

// integrate code :
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

    config.onLiveStreamingStateUpdate =
        (state) => liveStreamingState.value = state;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ZegoUIKitPrebuiltLiveStreaming(
              appID: /*input your AppID*/,
              appSign: /*input your AppSign*/,
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
        if (value == ZegoLiveStreamingState.idle) {
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

class StopPKBattleButton extends StatelessWidget {
  const StopPKBattleButton({
    Key? key,
  }) : super(key: key);

  void stopPKBattle(context) {
    ZegoUIKitPrebuiltLiveStreamingService().stopPKBattle().then((ret) {
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

class CancelPKBattleRequestButton extends StatelessWidget {
  const CancelPKBattleRequestButton({
    Key? key,
  }) : super(key: key);

  void cancelPKBattleRequest(context) {
    ZegoUIKitPrebuiltLiveStreamingService().cancelPKBattleRequest().then((ret) {
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

class SendPKBattleRequestButton extends StatelessWidget {
  const SendPKBattleRequestButton({
    Key? key,
  }) : super(key: key);

  void sendPKBattleRequest(context, anotherHostUserID) {
    ZegoUIKitPrebuiltLiveStreamingService()
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
