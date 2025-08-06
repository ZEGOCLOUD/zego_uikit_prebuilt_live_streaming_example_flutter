import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

import '../service/mini_game_api.dart';

Future<List<String>?> showStartGameDialog(context, String gameID,
    ValueNotifier<Map<String, String>> userListNotifier) async {
  final selectUsers = <String>[ZegoUIKit().getLocalUser().id];
  final gameInfo = ZegoMiniGame()
      .getAllGameList()
      .value
      .firstWhere((e) => e.miniGameId == gameID);
  final maxPlayers = gameInfo.detail!.player.reduce(max);
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return CupertinoAlertDialog(
        title: const Text('Select Users'),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              const SizedBox(height: 4),
              Text(
                  "Support Players Count: ${gameInfo.detail!.player.map((i) => ' $i ').toList()}"),
              const SizedBox(height: 4),
              const Text(
                  'Tips: When there are not enough players, robots will be used to fill the gap.',
                  style: TextStyle(fontSize: 10)),
              const SizedBox(height: 10),
              ValueListenableBuilder(
                  valueListenable: userListNotifier,
                  builder: (context, Map<String, String> userList, _) {
                    final users = userList.entries
                        .map((e) => ZegoUIKit().getUser(e.value))
                        .toList();

                    return SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: (users.length / 3.0).ceil() * 80.0,
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 3,
                        children: List.generate(users.length, (index) {
                          final itemUserID = users[index].id;
                          final clickUserIsSelected =
                              selectUsers.contains(itemUserID);
                          return GestureDetector(
                            onTap: index == 0
                                ? null
                                : () {
                                    if (clickUserIsSelected) {
                                      setState(
                                          () => selectUsers.remove(itemUserID));
                                    } else {
                                      if (selectUsers.length >= maxPlayers)
                                        return;
                                      setState(
                                          () => selectUsers.add(itemUserID));
                                    }
                                  },
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      border: clickUserIsSelected
                                          ? Border.all(
                                              color: Colors.blue, width: 2)
                                          : null),
                                  child: ZegoAvatar(
                                      avatarSize: const Size(100, 100),
                                      user: ZegoUIKit().getUser(itemUserID))),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
            ],
          );
        }),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.pop(context, null);
            },
          ),
          CupertinoDialogAction(
            child: const Text('Start'),
            onPressed: () async {
              Navigator.pop(context, selectUsers);
            },
          ),
        ],
      );
    },
  );
}
