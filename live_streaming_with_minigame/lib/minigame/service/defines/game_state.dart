part of 'game_defines.dart';

enum ZegoGameState {
  idel(0),
  preparing(1),
  playing(2),
  stopping(3),
  over(4);

  const ZegoGameState(this.value);

  final int value;
}
