import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class PKRequestWidget extends StatefulWidget {
  final ValueNotifier<Map<String, List<String>>>
      requestingHostsMapRequestIDNotifier;
  final ValueNotifier<String> requestIDNotifier;

  const PKRequestWidget({
    Key? key,
    required this.requestIDNotifier,
    required this.requestingHostsMapRequestIDNotifier,
  }) : super(key: key);

  @override
  State<PKRequestWidget> createState() => _PKRequestWidgetState();
}

class _PKRequestWidgetState extends State<PKRequestWidget> {
  final isAutoAcceptedNotifier = ValueNotifier<bool>(false);
  final hostIDTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: const Text(
            'Auto Accept:',
            style: TextStyle(fontSize: 15),
          ),
        ),
        SizedBox(
          width: 30,
          height: 30,
          child: ValueListenableBuilder<bool>(
            valueListenable: isAutoAcceptedNotifier,
            builder: (context, isAutoAccepted, _) {
              return Checkbox(
                value: isAutoAccepted,
                onChanged: (value) {
                  isAutoAcceptedNotifier.value = value ?? false;
                },
              );
            },
          ),
        ),
        SizedBox(
          width: 100,
          height: 30,
          child: TextFormField(
            controller: hostIDTextController,
            decoration: const InputDecoration(
              hintText: 'Host ID',
              // prefixIcon: Icon(Icons.person),
              // border: Border.all(color: Colors.white),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 30,
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: hostIDTextController,
            builder: (context, value, _) {
              return SizedBox(
                width: 110,
                child: ElevatedButton(
                  onPressed: value.text.isEmpty
                      ? null
                      : () async {
                          FocusScope.of(context).unfocus();
                          await sendPKBattleRequest(
                            context,
                            hostIDTextController.text.trim(),
                          );
                        },
                  child: const Text(
                    'Request',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> sendPKBattleRequest(
    BuildContext context,
    String anotherHostUserID,
  ) async {
    await ZegoUIKitPrebuiltLiveStreamingController().pk.sendRequest(
      targetHostIDs: [anotherHostUserID],
      isAutoAccept: isAutoAcceptedNotifier.value,
    ).then((ret) {
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
      } else {
        widget.requestIDNotifier.value = ret.requestID;

        if (widget.requestingHostsMapRequestIDNotifier.value
            .containsKey(ret.requestID)) {
          widget.requestingHostsMapRequestIDNotifier.value[ret.requestID]!
              .add(anotherHostUserID);
        } else {
          widget.requestingHostsMapRequestIDNotifier.value[ret.requestID] = [
            anotherHostUserID
          ];
        }
        widget.requestingHostsMapRequestIDNotifier.notifyListeners();
      }
    });
  }
}
