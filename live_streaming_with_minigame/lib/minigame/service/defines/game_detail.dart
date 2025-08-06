part of 'game_defines.dart';

class ZegoGameDetail {
  List<int>? spin;
  List<int> player = [];
  String? thumbnail;
  int? cloudType;
  String? miniGameId;
  String? mgName;
  String? mgUrl;
  int? gameOrientation;
  List<int>? gameMode;
  int? designWidth;
  int? designHeight;
  int? safeHeight;

  ZegoGameDetail.fromJson(Map<String, dynamic> json) {
    spin = json['spin'] == null ? null : List<int>.from(json['spin']);
    player = List<int>.from(json['player']);
    thumbnail = json['thumbnail'];
    cloudType = json['CloudType'];
    miniGameId = json['miniGameId'];
    mgName = json['mgName'];
    mgUrl = json['mgUrl'];
    gameOrientation = json['gameOrientation'];
    gameMode =
        json['gameMode'] == null ? null : List<int>.from(json['gameMode']);
    designWidth = json['designWidth'];
    designHeight = json['designHeight'];
    safeHeight = json['safeHeight'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    if (spin != null) {
      _data['spin'] = spin;
    }
    _data['player'] = player;
    _data['thumbnail'] = thumbnail;
    _data['CloudType'] = cloudType;
    _data['miniGameId'] = miniGameId;
    _data['mgName'] = mgName;
    _data['mgUrl'] = mgUrl;
    _data['gameOrientation'] = gameOrientation;
    if (gameMode != null) {
      _data['gameMode'] = gameMode;
    }
    _data['designWidth'] = designWidth;
    _data['designHeight'] = designHeight;
    _data['safeHeight'] = safeHeight;
    return _data;
  }

  @override
  String toString() =>
      'ZegoGameDetail(spin: $spin, player: $player, thumbnail: $thumbnail, CloudType: $cloudType, miniGameId: $miniGameId, mgName: $mgName, mgUrl: $mgUrl, gameOrientation: $gameOrientation, gameMode: $gameMode, designWidth: $designWidth, designHeight: $designHeight, safeHeight: $safeHeight)';
}
