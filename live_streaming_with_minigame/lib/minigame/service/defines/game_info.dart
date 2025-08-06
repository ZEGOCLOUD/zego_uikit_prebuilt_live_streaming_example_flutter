part of 'game_defines.dart';

class ZegoGameInfo {
  List<int>? gameMode;
  int? gameOrientation;
  String? desc;
  String? miniGameId;
  String? mgName;
  String? thumbnail;
  ZegoGameDetail? detail;

  ZegoGameInfo.fromJson(Map<String, dynamic> json) {
    desc = json['desc'];
    thumbnail = json['thumbnail'];
    miniGameId = json['miniGameId'];
    mgName = json['mgName'];
    gameOrientation = json['gameOrientation'];
    gameMode =
        json['gameMode'] == null ? null : List<int>.from(json['gameMode']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['thumbnail'] = thumbnail;
    _data['desc'] = desc;
    _data['miniGameId'] = miniGameId;
    _data['mgName'] = mgName;
    _data['gameOrientation'] = gameOrientation;
    if (gameMode != null) {
      _data['gameMode'] = gameMode;
    }
    return _data;
  }

  @override
  String toString() =>
      'ZegoGameInfo(mgName: $mgName, miniGameId: $miniGameId, desc: $desc, thumbnail: $thumbnail, gameOrientation: $gameOrientation, gameMode: $gameMode, detail: $detail)';
}
