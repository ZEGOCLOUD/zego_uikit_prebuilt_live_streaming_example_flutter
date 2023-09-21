// Dart imports:
import 'dart:math' as math;

import 'secret.dart';

const int yourAppID = YourSecret.appID;
const String yourAppSign = YourSecret.appSign;
const String yourServerSecret = YourSecret.serverSecret;

/// Note that the userID needs to be globally unique,
final String localUserID = math.Random().nextInt(10000).toString();
