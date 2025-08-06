part of 'game_defines.dart';

class StartGameParam {
  List<ZegoGameRobot> robotList;
  List<ZegoPlayer> playerList;
  ZegoStartGameConfig gameConfig;

  StartGameParam({
    required this.playerList,
    required this.gameConfig,
    this.robotList = const [],
  });

  Map<String, dynamic> toMap() {
    final _data = <String, dynamic>{};
    _data['robotList'] = robotList.map((e) => e.toMap()).toList();
    _data['playerList'] = playerList.map((e) => e.toMap()).toList();
    _data['gameConfig'] = gameConfig.toMap();
    return _data;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'StartGameParam: robotList: $robotList, playerList: $playerList, gameConfig: $gameConfig';
}

class LoadGameParam {
  String gameID;
  ZegoGameMode gameMode;
  ZegoLoadGameConfig? loadGameConfig;

  LoadGameParam({
    required this.gameID,
    required this.gameMode,
    this.loadGameConfig,
  });

  Map<String, dynamic> toMap() {
    final _data = <String, dynamic>{};
    _data['gameID'] = gameID;
    _data['gameMode'] = gameMode.value;
    if (loadGameConfig != null) _data['config'] = loadGameConfig!.toMap();
    return _data;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'LoadGameParam: gameID: $gameID, gameMode: $gameMode, loadGameConfig: $loadGameConfig';
}
