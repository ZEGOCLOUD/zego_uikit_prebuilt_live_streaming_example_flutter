part of 'game_defines.dart';

class ZegoPlayer {
  String userId;
  int seatIndex;

  ZegoPlayer({required this.userId, required this.seatIndex});

  Map<String, dynamic> toMap() {
    final _data = <String, dynamic>{};
    _data['userId'] = userId;
    _data['seatIndex'] = seatIndex;
    return _data;
  }

  String toJson() => json.encode(toMap());
}
