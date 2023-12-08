part of 'game_defines.dart';

enum ZegoGameMode {
  // The game room needs to be created by a user in the live streaming room (voice chat room), usually the host. Only users in the same game room can participate in this mode of the game.
  inroom(1),

  // randomly matches the half-screen mode. The game screen only occupies half of the user interface or is not full screen. All users can participate in this mode of the game.
  halfScreen(2),

  // The game room randomly matches the full-screen mode. The game screen occupies the entire user interface. All users can participate in this mode of the game. ' ' '
  fullScreen(3);

  const ZegoGameMode(this.value);

  final int value;
}

// Some games support configuration through this parameter during loading.
// Before configuring, please confirm the configurable fields of the game with ZEGO technology.
class ZegoLoadGameConfig {
  // Whether to use a robot in the game in half-screen mode and full-screen mode, true means to use,
  // false means not to use. If set to true, the configuration of the game robot needs to be returned in the
  // [robotConfigRequire] callback. The default value is false.
  bool useRobot;

  // Game room ID, corresponds to the business room ID created by the host,
  // When the game is in 'ZegoGameMode.inroom' mode, it must be passed.
  String? roomID;

  // The minimum number of coins required to play the game.
  // When the game is in ZegoGameMode.inroom mode, it can be omitted.
  int minGameCoin;

  // Whether to customize the sound of playing games. If set to true, you need to play the sound based on the callback
  // notification of [gameSoundPlay]. If set to false, the sound will be automatically played by the webView.
  // The default value is false.
  bool customPlaySound;

  // URL of the gold coin icon in the game. If developers want to use their own gold coin icon, please provide the HTTPS address of the icon resource here. If not provided, the default gold coin icon in the game resources will be used.
  String? coinIconUrl;

  // Optional. Game configuration custom parameter Map. Use this Map to pass some custom parameters for the game.
  // If you need further information, please contact ZEGO technical support.
  Map specificConfig;

  ZegoLoadGameConfig({
    required this.useRobot,
    this.roomID,
    required this.minGameCoin,
    this.coinIconUrl,
    this.customPlaySound = false,
    this.specificConfig = const {},
  }) {
    minGameCoin = max(minGameCoin, 0);
  }

  Map<String, dynamic> toMap() {
    final _data = <String, dynamic>{};
    _data['roomId'] = roomID;
    _data['minGameCoin'] = max(minGameCoin, 0);
    _data['customPlaySound'] = customPlaySound;
    _data['useRobot'] = useRobot;
    _data['specificConfig'] = specificConfig;
    if (coinIconUrl != null) _data['coinIconUrl'] = coinIconUrl;
    return _data;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ZegoLoadGameConfig: roomId: $roomID, minGameCoin: $minGameCoin, coinIconUrl: $coinIconUrl, customPlaySound: $customPlaySound, useRobot: $useRobot, specificConfig: $specificConfig';
  }
}
