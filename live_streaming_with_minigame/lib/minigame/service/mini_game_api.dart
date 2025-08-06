import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../constants.dart';
import '../your_game_server.dart';
import 'defines/game_defines.dart';

export 'defines/game_defines.dart';

part 'impl/mini_game_impl.dart';
part 'mini_game_event.dart';

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

  ValueNotifier<List<ZegoGameInfo>> getAllGameList() {
    return _getAllGameList();
  }

  Future setLanguage(GameLanguage language) async {
    return _setLanguage(language);
  }

  Future updateToken(String token) async {
    return _updateToken(token);
  }

  Future<CallAsyncJavaScriptResult> loadGame({
    required String gameID,
    required ZegoGameMode gameMode,
    ZegoLoadGameConfig? loadGameConfig,
  }) async {
    return _loadGame(
        gameID: gameID, gameMode: gameMode, loadGameConfig: loadGameConfig);
  }

  Future<CallAsyncJavaScriptResult> unloadGame() async {
    return _unloadGame();
  }

  Future<CallAsyncJavaScriptResult> startGame({
    required List<ZegoPlayer> playerList,
    required ZegoStartGameConfig gameConfig,
    List<ZegoGameRobot> robotList = const [],
  }) async {
    return _startGame(
        playerList: playerList, gameConfig: gameConfig, robotList: robotList);
  }
}

class ZegoMiniGame {
  ListNotifier<ZegoGameInfo> gameListNotifier = ListNotifier([]);
  String logTag = '[ZegoMiniGame]';
  String apiTag = '[API]';
  String eventTag = '[jsEvent]';
  factory ZegoMiniGame() => instance;
  static final ZegoMiniGame instance = ZegoMiniGame._internal();
  ZegoMiniGame._internal();
  Completer<InAppWebViewController> initWebViewCompleter = Completer();
  Future<InAppWebViewController> get webViewController async => _ensureInited();
  final ValueNotifier<bool> loadedStateNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<ZegoGameState> gameStateNotifier =
      ValueNotifier<ZegoGameState>(ZegoGameState.idel);
  String currentUserID = '';
}
