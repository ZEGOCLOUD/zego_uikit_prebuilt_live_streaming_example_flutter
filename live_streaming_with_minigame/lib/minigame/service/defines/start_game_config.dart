part of 'game_defines.dart';

enum ZegoTaxType {
  anteDeduction(1), // To impose a tax on all wagered game coins.
  winnerDeduction(2); // Only the winners are subject to taxation.

  const ZegoTaxType(this.value);

  final int value;
}

class ZegoStartGameConfig {
  // The default tax type is WinnerDeduction.
  ZegoTaxType taxType;

  // The tax rate for this game is in the range of [0, 10000), The default value is 0.
  // corresponding to a value of one ten-thousandth of the tax rate.
  int taxRate;

  // The minimum number of coins required to play the game.
  int minGameCoin;

  // After calling [startGame], the game server waits for the players to be ready
  // for a certain amount of time (in seconds). If the players are not fully ready
  // within this time, an error will be reported. The default time is 60 seconds.
  int timeout;

  // Optional. Game configuration custom parameter Map. Use this Map to pass some custom parameters for the game.
  // If you need further information, please contact ZEGO technical support.
  Map customConfig;

  ZegoStartGameConfig({
    required this.minGameCoin,
    required this.timeout,
    required this.taxRate,
    this.taxType = ZegoTaxType.winnerDeduction,
    this.customConfig = const {},
  });

  Map<String, dynamic> toMap() {
    final _data = <String, dynamic>{};
    _data['taxType'] = taxType.value;
    _data['taxRate'] = max(min(taxRate, 0), 9999);
    _data['minGameCoin'] = minGameCoin;
    _data['timeout'] = timeout;
    _data['customConfig'] = customConfig;
    return _data;
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'ZegoStartGameConfig: taxType: ${taxType.name}, taxRate: $taxRate, minGameCoin: $minGameCoin, timeout: $timeout, customConfig: $customConfig';
  }
}
