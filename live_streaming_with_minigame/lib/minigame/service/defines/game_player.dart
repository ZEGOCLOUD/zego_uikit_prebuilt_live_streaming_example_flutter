part of 'game_defines.dart';

class ZegoPlayer {
  String userID;
  int seatIndex;

  ZegoPlayer({required this.userID, required this.seatIndex});

  Map<String, dynamic> toMap() {
    final _data = <String, dynamic>{};
    _data['userId'] = userID;
    _data['seatIndex'] = seatIndex;
    return _data;
  }

  String toJson() => json.encode(toMap());
}
