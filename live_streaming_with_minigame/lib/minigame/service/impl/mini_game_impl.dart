part of '../mini_game_api.dart';

extension ZegoMiniGameInner on ZegoMiniGame {
  void _initWebViewController(InAppWebViewController controller) {
    if (initWebViewCompleter.isCompleted) {
      debugPrint('$logTag$apiTag, warn: initWebViewController, isCompleted!');
      initWebViewCompleter = Completer();
    }
    debugPrint('$logTag$apiTag, initWebViewController, ${controller.hashCode}');

    initWebViewCompleter.complete(controller);
    _addJavaScriptHandler(controller);
  }

  Future<void> _uninitWebViewController() async {
    if (initWebViewCompleter.isCompleted) {
      _removeJavaScriptHandler(await initWebViewCompleter.future);
    }
    initWebViewCompleter = Completer();
  }

  Future<CallAsyncJavaScriptResult> _initGameSDK({
    required String userID,
    required String userName,
    required String avatarUrl,
    required int appID,
    required String token,
    GameLanguage language = GameLanguage.english,
  }) async {
    final jsonParams = jsonEncode({
      'appID': appID,
      'token': token,
      'userInfo': {'userId': userID, 'userName': userName, 'avatar': avatarUrl}
    });
    currentUserID = userID;
    final jsCode = 'await init(JSON.stringify($jsonParams));';
    final result = await _miniGameChannel(jsCode);
    debugPrint('$logTag$apiTag, initGameSDK, result: $result');
    await ZegoMiniGame()._setLanguage(language);
    _getVersion();
    _getAllGameList();
    return result;
  }

  Future<CallAsyncJavaScriptResult> _uninitGameSDK() async {
    loadedStateNotifier.value = false;
    gameStateNotifier.value = ZegoGameState.idel;
    const jsCode = 'unInit();';
    return _miniGameChannel(jsCode);
  }

  ValueNotifier<List<ZegoGameInfo>> _getAllGameList() {
    if (gameListNotifier.value.isEmpty) {
      const jsCode = 'await getAllGameList();';
      _miniGameChannel(jsCode);
    }
    return gameListNotifier;
  }

  Future<String> _getVersion() async {
    const jsCode = 'getVersion();';
    final result = await _miniGameChannel(jsCode);
    debugPrint('$logTag$apiTag, getVersion, result: $result');
    return result.value ?? 'unknown';
  }

  Future<void> _getGameDetails({required String gameID}) async {
    if (gameListNotifier.value
            .where((e) => e.miniGameId == gameID)
            .first
            .detail ==
        null) {
      final jsCode = "await getGameInfo('$gameID');";
      final result = await _miniGameChannel(jsCode);
      debugPrint('$logTag$apiTag, getGameInfo, result: $result');
    }
  }

  Future _setLanguage(GameLanguage language) async {
    final jsonParams = language.languageCode;
    final jsCode = "setLanguage('$jsonParams');";
    return _miniGameChannel(jsCode);
  }

  Future _updateToken(String token) async {
    debugPrint('$logTag$apiTag, updateToken');
    final jsCode = "updateToken('$token');";
    return _miniGameChannel(jsCode);
  }

  Future<CallAsyncJavaScriptResult> _loadGame({
    required String gameID,
    required ZegoGameMode gameMode,
    ZegoLoadGameConfig? loadGameConfig,
  }) async {
    await _setGameContainer();
    final loadGameParam = LoadGameParam(
        gameID: gameID, gameMode: gameMode, loadGameConfig: loadGameConfig);
    debugPrint('$logTag$apiTag, loadGame, loadGameParam:$loadGameParam');
    final jsonParams = loadGameParam.toJson();
    final jsCode = 'await loadGame(JSON.stringify($jsonParams));';
    final result = await _miniGameChannel(jsCode);
    debugPrint('$logTag$apiTag, loadGame, result: $result');
    return result;
  }

  // unloadGame
  Future<CallAsyncJavaScriptResult> _unloadGame() async {
    const jsCode = 'await unloadGame();';
    final result = await _miniGameChannel(jsCode);
    debugPrint('$logTag$apiTag, unloadGame, result: $result');
    return result;
  }

  Future<CallAsyncJavaScriptResult> _startGame({
    required List<ZegoPlayer> playerList,
    required ZegoStartGameConfig gameConfig,
    List<ZegoGameRobot> robotList = const [],
  }) async {
    await _setGameContainer();
    final startGameParam = StartGameParam(
        gameConfig: gameConfig, playerList: playerList, robotList: robotList);
    debugPrint('$logTag$apiTag, startGame, startGameParam:$startGameParam');
    final jsonParams = startGameParam.toJson();
    final jsCode = 'await startGame(JSON.stringify($jsonParams));';
    final result = await _miniGameChannel(jsCode);
    debugPrint('$logTag$apiTag, startGame, result:$result');
    return result;
  }

  Future<CallAsyncJavaScriptResult> _miniGameChannel(String jsCode) async {
    if (jsCode.contains('await')) {
      debugPrint('$logTag[channel] callAsyncJS.jsCode: $jsCode');
      return (await webViewController)
          .callAsyncJavaScript(functionBody: jsCode)
          .then((result) {
        debugPrint('$logTag[channel] callAsyncJS.then: $result');
        return result ??
            CallAsyncJavaScriptResult(error: 'result is null', value: null);
      }).catchError((error) {
        debugPrint('$logTag[channel] callAsyncJS.catchError: $error');
        return CallAsyncJavaScriptResult(error: error.toString(), value: null);
      });
    } else {
      debugPrint('$logTag[channel] evaluateJS.jsCode: $jsCode');
      return (await webViewController)
          .evaluateJavascript(source: jsCode)
          .then((result) {
        debugPrint('$logTag[channel] evaluateJS.then: $result');
        return CallAsyncJavaScriptResult(error: null, value: result);
      }).catchError((error) {
        debugPrint('$logTag[channel] evaluateJS.catchError: $error');
        return CallAsyncJavaScriptResult(error: error.toString(), value: null);
      });
    }
  }

  Future<InAppWebViewController> _ensureInited() async {
    if (!initWebViewCompleter.isCompleted) {
      debugPrint('$logTag$apiTag, wait initWebViewController start');
      await initWebViewCompleter.future;
      debugPrint('$logTag$apiTag, wait initWebViewController done');
    }
    return initWebViewCompleter.future;
  }

  Future _setGameContainer() async => _miniGameChannel('setGameContainer();');
}
