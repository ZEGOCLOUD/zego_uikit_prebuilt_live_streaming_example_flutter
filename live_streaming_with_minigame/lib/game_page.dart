// ignore_for_file: unused_import, sized_box_for_whitespace, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import 'common.dart';
import 'constants.dart';
import 'main.dart';
import 'minigame/service/mini_game_api.dart';
import 'minigame/ui/show_game_list_view.dart';
import 'minigame/your_game_server.dart';

class ZegoMiniGamePage extends StatefulWidget {
  const ZegoMiniGamePage({super.key, required this.userID, required this.userName, required this.roomID});

  final String roomID;
  final String userID;
  final String userName;

  @override
  State<ZegoMiniGamePage> createState() => ZegoMiniGamePageState();
}

class ZegoMiniGamePageState extends State<ZegoMiniGamePage> {
  bool playing = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await ZegoMiniGame().unloadGame();
        await ZegoMiniGame().uninitGameSDK();
        await ZegoMiniGame().uninitWebViewController();
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: playing ? null : AppBar(title: const Text('ZegoMiniGame')),
          body: Stack(
            children: [
              InAppWebView(
                initialFile: 'assets/minigame/index.html',
                onWebViewCreated: (InAppWebViewController controller) async {
                  ZegoMiniGame().initWebViewController(controller);
                },
                onLoadStop: (controller, url) async {
                  try {
                    final token = await YourGameServer().getToken(
                      appID: yourAppID,
                      userID: widget.userID,
                    );
                    await ZegoMiniGame().initGameSDK(
                      appID: yourAppID,
                      token: token,
                      userID: widget.userID,
                      userName: widget.userName,
                      avatarUrl: Uri.encodeComponent('https://robohash.org/${widget.userID}.png?set=set4'),
                      language: GameLanguage.english,
                    );
                  } catch (e) {
                    debugPrint('$e');
                    showSnackBar('initGameSDK:$e');
                  }
                },
                onConsoleMessage: (controller, ConsoleMessage msg) async {
                  debugPrint('[InAppWebView][${msg.messageLevel}]${msg.message}');
                },
              ),
              Visibility(
                child: Positioned(
                  left: playing ? 10 : null,
                  top: playing ? 10 : null,
                  bottom: playing ? null : 50,
                  right: playing ? null : 10,
                  child: FloatingActionButton.extended(
                    onPressed: () async {
                      if (!playing) {
                        showGameListView(context).then((ZegoGameInfo? gameInfo) async {
                          if (gameInfo != null) {
                            final gameID = gameInfo.miniGameId!;
                            final gameMode = gameInfo.gameMode!;
                            try {
                              final loadGameResult = await ZegoMiniGame().loadGame(
                                gameID: gameID,
                                gameMode: ZegoGameMode.values.where((element) => element.value == gameMode[0]).first,
                                loadGameConfig: ZegoLoadGameConfig(
                                  minGameCoin: 0,
                                  roomID: widget.roomID,
                                  useRobot: true,
                                ),
                              );
                              debugPrint('[APP]loadGameResult: $loadGameResult');
                              setState(() => playing = true);
                            } catch (e) {
                              showSnackBar('loadGameResult:$e');
                            }
                            try {
                              debugPrint('[APP]enter game: $gameID');
                              final exchangeUserCurrencyResult = await YourGameServer().exchangeUserCurrency(
                                appID: yourAppID,
                                gameID: gameID,
                                userID: widget.userID,
                                exchangeValue: 10000,
                                outOrderId: DateTime.now().millisecondsSinceEpoch.toString(),
                              );
                              debugPrint('[APP]exchangeUserCurrencyResult: $exchangeUserCurrencyResult');
                            } catch (e) {
                              showSnackBar('exchangeUserCurrency:$e');
                            }
                            try {
                              final getUserCurrencyResult = await YourGameServer().getUserCurrency(
                                appID: yourAppID,
                                userID: widget.userID,
                                gameID: gameID,
                              );
                              debugPrint('[APP]getUserCurrencyResult: $getUserCurrencyResult');
                            } catch (e) {
                              showSnackBar('getUserCurrency:$e');
                            }
                          }
                        });
                      } else {
                        await ZegoMiniGame().unloadGame();
                        setState(() => playing = false);
                      }
                    },
                    label: playing ? const Text('Quit Game') : const Text('Game List'),
                    icon: playing ? const Icon(Icons.arrow_back) : const Icon(Icons.games),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
