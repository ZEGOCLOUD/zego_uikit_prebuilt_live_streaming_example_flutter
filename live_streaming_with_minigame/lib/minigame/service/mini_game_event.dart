part of 'mini_game.dart';

extension ZegoMiniGameEvent on ZegoMiniGame {
  Future<void> _addJavaScriptHandler(
      InAppWebViewController webViewController) async {
    webViewController
      ..addJavaScriptHandler(
          handlerName: 'initHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, initHandler: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'getGameListHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, getGameListHandler: $args');
            gameListNotifier.value = args[0]['list'];
          })
      ..addJavaScriptHandler(
          handlerName: 'getGameInfoHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, getGameInfoHandler: $args');
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
          handlerName: 'loadGameHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, loadGameHandler: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'startGameHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, startGameHandler: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'unloadGameHandler',
          callback: (args) {
            debugPrint('$logTag$eventTag, unloadGameHandler: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'handleTokenWillExpire',
          callback: (args) {
            debugPrint('$logTag$eventTag, handleTokenWillExpire: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'handleGameLoadStateUpdate',
          callback: (args) {
            debugPrint('$logTag$eventTag, handleGameLoadStateUpdate: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'handleGameError',
          callback: (args) {
            debugPrint('$logTag$eventTag, handleGameError: $args');
          })
      ..addJavaScriptHandler(
          handlerName: 'handleRobotConfigRequire',
          callback: (args) {
            debugPrint('$logTag$eventTag, handleRobotConfigRequire: $args');
          });
  }

  Future<void> _removeJavaScriptHandler(
      InAppWebViewController webViewController) async {
    webViewController
      ..removeJavaScriptHandler(handlerName: 'initHandler')
      ..removeJavaScriptHandler(handlerName: 'getGameListHandler')
      ..removeJavaScriptHandler(handlerName: 'getGameInfoHandler')
      ..removeJavaScriptHandler(handlerName: 'createGameRoomHandler')
      ..removeJavaScriptHandler(handlerName: 'closeGameRoomHandler')
      ..removeJavaScriptHandler(handlerName: 'loadGameHandler')
      ..removeJavaScriptHandler(handlerName: 'startGameHandler')
      ..removeJavaScriptHandler(handlerName: 'unloadGameHandler')
      ..removeJavaScriptHandler(handlerName: 'handleTokenWillExpire')
      ..removeJavaScriptHandler(handlerName: 'handleGameLoadStateUpdate')
      ..removeJavaScriptHandler(handlerName: 'handleGameError')
      ..removeJavaScriptHandler(handlerName: 'handleRobotConfigRequire');
  }
}
