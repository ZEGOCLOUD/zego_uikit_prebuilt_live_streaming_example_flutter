// ignore_for_file: unused_import, sized_box_for_whitespace, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import 'service/mini_game.dart';
import 'your_game_server.dart';

Future<dynamic> showGameListView(BuildContext context, String userID) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GameList',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                ValueListenableBuilder(
                  valueListenable: ZegoMiniGame().getAllGameList(),
                  builder: (BuildContext context, List<dynamic> gameList,
                      Widget? child) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 200,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: gameList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              final gameID = gameList[index]['miniGameId'];
                              final loadGameResult =
                                  await ZegoMiniGame().loadGame(
                                gameID: gameID,
                                gameMode: ZegoGameMode.fullScreen,
                                loadGameConfig:
                                    ZegoLoadGameConfig(minGameCoin: 100),
                              );
                              debugPrint(
                                  '[APP]loadGameResult: $loadGameResult');
                              Navigator.pop(context, gameID);

                              debugPrint('[APP]enter game: $gameID');
                              final exchangeUserCurrencyResult =
                                  await YourGameServer().exchangeUserCurrency(
                                appID: YourSecret.appID,
                                gameID: gameID,
                                userID: userID,
                                exchangeValue: 10000,
                                outOrderId: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                              );
                              debugPrint(
                                  '[APP]exchangeUserCurrencyResult: $exchangeUserCurrencyResult');

                              final getUserCurrencyResult =
                                  await YourGameServer().getUserCurrency(
                                appID: YourSecret.appID,
                                userID: userID,
                                gameID: gameID,
                              );
                              debugPrint(
                                  '[APP]getUserCurrencyResult: $getUserCurrencyResult');

                              final getGameInfoResult = await ZegoMiniGame()
                                  .getGameInfo(gameID: gameID);
                              debugPrint(
                                  '[APP]getGameInfoResult: $getGameInfoResult');
                            },
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Image.network(
                                    gameList[index]['thumbnail'],
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    gameList[index]['mgName'],
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      });
}
