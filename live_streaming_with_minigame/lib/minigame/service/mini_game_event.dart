part of 'mini_game_api.dart';

extension ZegoMiniGameEvent on ZegoMiniGame {
  Future<void> _addJavaScriptHandler(InAppWebViewController webViewController) async {
    webViewController
      ..addJavaScriptHandler(
          handlerName: 'initHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, initHandler: $args');
            ZegoMiniGame().getAllGameList();
          })
      ..addJavaScriptHandler(
          handlerName: 'getGameListHandler',
          callback: (args) async {
            debugPrint('$logTag$eventTag, getGameListHandler: $args');
            gameListNotifier.value = ((args[0] as Map)['list'] as List).map((e) => ZegoGameInfo.fromJson(e)).toList();
            for (final game in gameListNotifier.value) {
              _getGameDetails(gameID: game.miniGameId!);
            }
          })
      ..addJavaScriptHandler(
          handlerName: 'getGameInfoHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, getGameInfoHandler: $args');
            final detail = ZegoGameDetail.fromJson(args[0]);
            gameListNotifier.value.firstWhere((game) => game.miniGameId == detail.miniGameId).detail = detail;
          })
      ..addJavaScriptHandler(
          handlerName: 'gameOverDetailUpdate',
          callback: (args) {
            debugPrint('$logTag$eventTag, gameOverDetailUpdate: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'actionEventUpdate',
          callback: (args) {
            debugPrint('$logTag$eventTag, actionEventUpdate: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'createGameRoomHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, createGameRoomHandler: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'closeGameRoomHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, closeGameRoomHandler: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'gameLoaded',
          callback: (args) {
            debugPrint('$logTag$eventTag, gameLoaded: $args');
            loadedStateNotifier.value = true;
          })
      ..addJavaScriptHandler(
          handlerName: 'startGameHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, startGameHandler: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'unloaded',
          callback: (args) {
            debugPrint('$logTag$eventTag, unloaded: $args');
            gameStateNotifier.value = ZegoGameState.idel;
            loadedStateNotifier.value = false;
          })
      ..addJavaScriptHandler(
          handlerName: 'tokenWillExpire',
          callback: (args) async {
            final token = await YourGameServer().getToken(appID: yourAppID, userID: currentUserID);
            updateToken(token);
            debugPrint('$logTag$eventTag, tokenWillExpire: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'loadStateUpdate',
          callback: (args) {
            debugPrint('$logTag$eventTag, loadStateUpdate: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'gameError',
          callback: (args) {
            debugPrint('$logTag$eventTag, gameError: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'gameResult',
          callback: (args) {
            debugPrint('$logTag$eventTag, gameResult: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'robotConfigRequire',
          callback: (args) {
            debugPrint('$logTag$eventTag, robotConfigRequire: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'chargeRequire',
          callback: (args) {
            debugPrint('$logTag$eventTag, chargeRequire: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'playerStateUpdate',
          callback: (args) {
            debugPrint('$logTag$eventTag, playerStateUpdate: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'gameStateUpdate',
          callback: (args) {
            gameStateNotifier.value = ZegoGameState.values.firstWhere((e) => e.value == (args[0]['state'] as int));
            final reasonCode = args[0]['reasonCode'];
            debugPrint('$logTag$eventTag, gameStateUpdate: ${gameStateNotifier.value.name}, reasonCode: $reasonCode');
          })
      ..addJavaScriptHandler(
          handlerName: 'gameSoundPlay',
          callback: (args) {
            debugPrint('$logTag$eventTag, gameSoundPlay: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'languageChanged',
          callback: (args) {
            debugPrint('$logTag$eventTag, languageChanged: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'gameSoundVolumeChange',
          callback: (args) {
            debugPrint('$logTag$eventTag, gameSoundVolumeChange: $args');
          });
  }

  Future<void> _removeJavaScriptHandler(InAppWebViewController webViewController) async {
    webViewController
      ..removeJavaScriptHandler(handlerName: 'initHandler')
      ..removeJavaScriptHandler(handlerName: 'getGameListHandler')
      ..removeJavaScriptHandler(handlerName: 'getGameInfoHandler')
      ..removeJavaScriptHandler(handlerName: 'createGameRoomHandler')
      ..removeJavaScriptHandler(handlerName: 'closeGameRoomHandler')
      ..removeJavaScriptHandler(handlerName: 'gameLoaded')
      ..removeJavaScriptHandler(handlerName: 'startGameHandler')
      ..removeJavaScriptHandler(handlerName: 'unloaded')
      ..removeJavaScriptHandler(handlerName: 'tokenWillExpire')
      ..removeJavaScriptHandler(handlerName: 'gameOverDetailUpdate')
      ..removeJavaScriptHandler(handlerName: 'loadStateUpdate')
      ..removeJavaScriptHandler(handlerName: 'gameError')
      ..removeJavaScriptHandler(handlerName: 'gameResult')
      ..removeJavaScriptHandler(handlerName: 'robotConfigRequire')
      ..removeJavaScriptHandler(handlerName: 'chargeRequire')
      ..removeJavaScriptHandler(handlerName: 'playerStateUpdate')
      ..removeJavaScriptHandler(handlerName: 'gameStateUpdate')
      ..removeJavaScriptHandler(handlerName: 'gameSoundPlay')
      ..removeJavaScriptHandler(handlerName: 'languageChanged')
      ..removeJavaScriptHandler(handlerName: 'actionEventUpdate')
      ..removeJavaScriptHandler(handlerName: 'gameSoundVolumeChange');
  }
}
