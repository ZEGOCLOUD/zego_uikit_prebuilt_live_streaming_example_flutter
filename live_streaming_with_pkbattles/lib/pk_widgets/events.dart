import 'package:flutter/cupertino.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class PKEvents {
  const PKEvents({
    required this.requestIDNotifier,
    required this.requestingHostsMapRequestIDNotifier,
  });

  final ValueNotifier<String> requestIDNotifier;
  final ValueNotifier<Map<String, List<String>>>
      requestingHostsMapRequestIDNotifier;

  ZegoUIKitPrebuiltLiveStreamingPKV2Events get event =>
      ZegoUIKitPrebuiltLiveStreamingPKV2Events(
        onIncomingPKBattleRequestReceived: (event, defaultAction) {
          debugPrint(
              'custom event, onIncomingPKBattleRequestReceived, event:$event');
          defaultAction.call();
        },
        onIncomingPKBattleRequestCancelled: (event, defaultAction) {
          debugPrint(
              'custom event, onIncomingPKBattleRequestCancelled, event:$event');
          defaultAction.call();

          requestIDNotifier.value = '';

          removeRequestingHostsMap(event.requestID);
        },
        onIncomingPKBattleRequestTimeout: (event, defaultAction) {
          debugPrint(
              'custom event, onIncomingPKBattleRequestTimeout, event:$event');
          defaultAction.call();

          requestIDNotifier.value = '';

          removeRequestingHostsMap(event.requestID);
        },
        onOutgoingPKBattleRequestAccepted: (event, defaultAction) {
          debugPrint(
              'custom event, onOutgoingPKBattleRequestAccepted, event:$event');
          defaultAction.call();

          removeRequestingHostsMapWhenRemoteHostDone(
            event.requestID,
            event.fromHost.id,
          );
        },
        onOutgoingPKBattleRequestRejected: (event, defaultAction) {
          debugPrint(
              'custom event, onOutgoingPKBattleRequestRejected, event:$event');
          defaultAction.call();

          removeRequestingHostsMapWhenRemoteHostDone(
            event.requestID,
            event.fromHost.id,
          );
        },
        onOutgoingPKBattleRequestTimeout: (event, defaultAction) {
          debugPrint(
              'custom event, onOutgoingPKBattleRequestTimeout, event:$event');

          removeRequestingHostsMapWhenRemoteHostDone(
            event.requestID,
            event.fromHost.id,
          );

          defaultAction.call();
        },
        onPKBattleEnded: (event, defaultAction) {
          debugPrint('custom event, onPKBattleEnded, event:$event');
          defaultAction.call();

          requestIDNotifier.value = '';

          removeRequestingHostsMapWhenRemoteHostDone(
            event.requestID,
            event.fromHost.id,
          );
        },
        onUserOffline: (event, defaultAction) {
          debugPrint('custom event, onUserOffline, event:$event');
          defaultAction.call();

          removeRequestingHostsMapWhenRemoteHostDone(
            event.requestID,
            event.fromHost.id,
          );
        },
        onUserQuited: (event, defaultAction) {
          debugPrint('custom event, onUserQuited, event:$event');
          defaultAction.call();

          if (event.fromHost.id == ZegoUIKit().getLocalUser().id) {
            requestIDNotifier.value = '';
          }

          removeRequestingHostsMapWhenRemoteHostDone(
            event.requestID,
            event.fromHost.id,
          );
        },
        onUserJoined: (ZegoUIKitUser user) {
          debugPrint('custom event, onUserJoined:$user');
        },
        onUserDisconnected: (ZegoUIKitUser user) {
          debugPrint('custom event, onUserDisconnected:$user');
        },
        onUserReconnecting: (ZegoUIKitUser user) {
          debugPrint('custom event, onUserReconnecting:$user');
        },
        onUserReconnected: (ZegoUIKitUser user) {
          debugPrint('custom event, onUserReconnected:$user');
        },
      );

  void removeRequestingHostsMap(String requestID) {
    requestingHostsMapRequestIDNotifier.value.remove(requestID);

    requestingHostsMapRequestIDNotifier.notifyListeners();
  }

  void removeRequestingHostsMapWhenRemoteHostDone(
    String requestID,
    String fromHostID,
  ) {
    requestingHostsMapRequestIDNotifier.value[requestID]
        ?.removeWhere((requestHostID) => fromHostID == requestHostID);
    if (requestingHostsMapRequestIDNotifier.value[requestID]?.isEmpty ??
        false) {
      removeRequestingHostsMap(requestID);
    }

    requestingHostsMapRequestIDNotifier.notifyListeners();
  }
}
