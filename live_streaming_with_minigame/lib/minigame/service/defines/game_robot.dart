part of 'game_defines.dart';

class ZegoGameRobot {
  int robotLevel;
  int seatIndex;
  String robotName;
  String robotAvatar;
  int robotCoin;

  ZegoGameRobot({
    this.robotLevel = 0,
    required this.seatIndex,
    required this.robotName,
    required this.robotAvatar,
    required this.robotCoin,
  });

  Map<String, dynamic> toMap() {
    final _data = <String, dynamic>{};
    _data['robotLevel'] = robotLevel;
    _data['seatIndex'] = seatIndex;
    _data['robotName'] = robotName;
    _data['robotAvatar'] = robotAvatar;
    _data['robotCoin'] = robotCoin;
    return _data;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ZegoGameRobot: robotLevel: $robotLevel, seatIndex: $seatIndex, robotName: $robotName, robotAvatar: $robotAvatar, robotCoin: $robotCoin';
}
