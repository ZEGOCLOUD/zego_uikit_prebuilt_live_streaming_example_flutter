import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'defines/game_defines.dart';


export 'defines/game_defines.dart';

part 'mini_game_event.dart';
part 'mini_game_impl.dart';

extension ZegoMiniGameAPI on ZegoMiniGame {
  void initWebViewController(InAppWebViewController controller) {
    _initWebViewController(controller);
  }

  Future<void> uninitWebViewController() async {
    return _uninitWebViewController();
  }

  Future<CallAsyncJavaScriptResult> initGameSDK({
    required String userID,
    required String userName,
    required String avatarUrl,
    required int appID,
    required String token,
    GameLanguage language = GameLanguage.english,
  }) async {
    return _initGameSDK(
        userID: userID,
        userName: userName,
        avatarUrl: avatarUrl,
        appID: appID,
        token: token,
        language: language);
  }

  Future<CallAsyncJavaScriptResult> uninitGameSDK() async {
    return _uninitGameSDK();
  }

  ValueNotifier<List<dynamic>> getAllGameList() {
    return _getAllGameList();
  }

  Future<CallAsyncJavaScriptResult> getGameInfo(
          {required String gameID}) async =>
      _getGameInfo(gameID: gameID);
  Future setLanguage(GameLanguage language) async {
    return _setLanguage(language);
  }

  Future<CallAsyncJavaScriptResult> loadGame({
    required String gameID,
    required ZegoGameMode gameMode,
    String? roomID,
    ZegoLoadGameConfig? loadGameConfig,
  }) async {
    return _loadGame(
        gameID: gameID, gameMode: gameMode, loadGameConfig: loadGameConfig);
  }

  Future<CallAsyncJavaScriptResult> unloadGame() async {
    return _unloadGame();
  }

  Future<CallAsyncJavaScriptResult> startGame({
    required List<ZegoRobotAttribute> robotList,
    required List<ZegoPlayer> playerList,
    required ZegoStartGameConfig gameConfig,
  }) async {
    return _startGame(
        robotList: robotList, playerList: playerList, gameConfig: gameConfig);
  }
}

// see also [ZegoMiniGameAPI].
class ZegoMiniGame {
  ListNotifier<dynamic> gameListNotifier = ListNotifier([]);
  String logTag = '[ZegoMiniGame]';
  String apiTag = '[API]';
  String eventTag = '[jsEvent]';
  factory ZegoMiniGame() => instance;
  static final ZegoMiniGame instance = ZegoMiniGame._internal();
  ZegoMiniGame._internal();
  Completer<InAppWebViewController> initWebViewCompleter = Completer();
  Future<InAppWebViewController> get webViewController async => _ensureInited();
}
