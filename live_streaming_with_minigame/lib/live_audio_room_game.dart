part of 'live_audio_room_page.dart';

String get attributeKeyRoomGame => 'AppRomeGame';

class InRoomGameController {
  final String userID;
  final String userName;
  final String roomID;
  final bool isHost;

  InRoomGameController({
    required this.userID,
    required this.userName,
    required this.roomID,
    required this.isHost,
  });
  StreamSubscription<dynamic>? _subscription;

  void init() {
    _subscription = ZegoUIKit().getSignalingPlugin().getRoomPropertiesStream().listen(onGameRoomAttributesUpdated);
    ZegoMiniGame().loadedStateNotifier.addListener(onloadedStateUpdated);
  }

  Future<void> uninit() async {
    ZegoMiniGame().loadedStateNotifier.removeListener(onloadedStateUpdated);
    await ZegoMiniGame().unloadGame();
    await ZegoMiniGame().uninitGameSDK();
    await ZegoMiniGame().uninitWebViewController();
    _subscription?.cancel();
  }

  void onloadedStateUpdated() {
    if (!ZegoMiniGame().loadedStateNotifier.value) {
      if (isHost) {
        deleteGameRoomAttributes();
      } else {
        ZegoUIKit()
            .getSignalingPlugin()
            .queryRoomProperties(roomID: roomID)
            .then((ZegoSignalingPluginQueryRoomPropertiesResult result) {
          if (result.error == null && result.properties.containsKey(attributeKeyRoomGame)) {
            final gameID = result.properties[attributeKeyRoomGame]!;
            // If a player or audience clicks the close button in the game and unloads the game,
            // but the game is still ongoing in the room, the game will automatically reload here.
            loadGame(gameID);
          }
        });
      }
    }
  }

  String? currentGameID;

  Widget gameView() {
    return ValueListenableBuilder(
      valueListenable: ZegoMiniGame().loadedStateNotifier,
      builder: (context, bool loaded, child) => Offstage(offstage: !loaded, child: child),
      child: InAppWebView(
        initialFile: 'assets/minigame/index.html',
        onWebViewCreated: (InAppWebViewController controller) async {
          ZegoMiniGame().initWebViewController(controller);
        },
        onLoadStop: (controller, url) async {
          final token = await YourGameServer().getToken(
            appID: yourAppID,
            userID: userID,
            serverSecret: yourServerSecret,
          );

          await ZegoMiniGame().initGameSDK(
            appID: yourAppID,
            token: token,
            userID: userID,
            userName: userName,
            avatarUrl: Uri.encodeComponent('https://robohash.org/$userID.png?set=set4'),
            language: GameLanguage.english,
          );
        },
        onConsoleMessage: (controller, ConsoleMessage msg) async {
          debugPrint('[InAppWebView][${msg.messageLevel}]${msg.message}');
        },
      ),
    );
  }

  Widget gameButton() {
    return ValueListenableBuilder(
      valueListenable: ZegoMiniGame().loadedStateNotifier,
      builder: (context, bool loaded, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (loaded) ...[startGameButton(), const SizedBox(width: 10)],
            if (!loaded) loadGameButton(context) else quitGameButton(context),
          ],
        );
      },
    );
  }

  Widget startGameButton() {
    return ValueListenableBuilder(
      valueListenable: ZegoMiniGame().gameStateNotifier,
      builder: (context, ZegoGameState gameState, _) {
        if (gameState != ZegoGameState.playing) {
          return ElevatedButton(
            onPressed: () async {
              final userListNotifier =
                  ZegoUIKitPrebuiltLiveAudioRoomController()
                      .seat
                      .userMapNotifier!;
              showStartGameDialog(context, currentGameID!, userListNotifier)
                  .then((playWithUserID) {
                if (playWithUserID != null) {
                  startGame(playWithUserID);
                }
              });
            },
            child: const Text('Start'),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget loadGameButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        showGameListView(context).then((ZegoGameInfo? gameInfo) async {
          if (gameInfo != null) {
            updateGameRoomAttributes(gameInfo.miniGameId!).then((result) async {
              if (result.error != null) {
                ZegoLoggerService.logError('updateRoomProperty failed, ${result.error} ',
                    tag: 'APP', subTag: 'minigame');
                showSnackBar('updateRoomProperty failed, ${result.error} ');
              } else {
                ZegoLoggerService.logInfo('updateRoomProperty success ', tag: 'APP', subTag: 'minigame');
              }
            });
          }
        });
      },
      child: const Text('Game List'),
    );
  }

  Future<void> loadGame(String gameID) async {
    try {
      await ZegoMiniGame().loadGame(
        gameID: gameID,
        gameMode: ZegoGameMode.inroom,
        loadGameConfig: ZegoLoadGameConfig(
          minGameCoin: 0,
          roomID: roomID,
          useRobot: true,
        ),
      );
      debugPrint('[APP]loadGame: $gameID');
      currentGameID = gameID;
    } catch (e) {
      showSnackBar('loadGame:$e');
    }
    try {
      final exchangeUserCurrencyResult = await YourGameServer().exchangeUserCurrency(
        appID: yourAppID,
        gameID: gameID,
        userID: userID,
        exchangeValue: 100,
        outOrderId: DateTime.now().millisecondsSinceEpoch.toString(),
      );
      debugPrint('[APP]exchangeUserCurrencyResult: $exchangeUserCurrencyResult');
    } catch (e) {
      showSnackBar('exchangeUserCurrency:$e');
    }
    try {
      final getUserCurrencyResult = await YourGameServer().getUserCurrency(
        appID: yourAppID,
        userID: userID,
        gameID: gameID,
      );
      debugPrint('[APP]getUserCurrencyResult: $getUserCurrencyResult');
    } catch (e) {
      showSnackBar('getUserCurrency:$e');
    }
  }

  Widget quitGameButton(BuildContext context) {
    return ElevatedButton(
      onPressed: deleteGameRoomAttributes,
      child: const Text('Quit'),
    );
  }

  Future<void> unloadGame() async {
    await ZegoMiniGame().unloadGame();
  }

  Future<void> startGame(List<String> playWithUserID) async {
    final gameInfo = ZegoMiniGame().getAllGameList().value.firstWhere((e) => e.miniGameId == currentGameID!);
    final gameMaxPlayer = gameInfo.detail!.player.reduce(max);
    await ZegoMiniGame().startGame(
      playerList: [
        ...playWithUserID.asMap().entries.map((e) => ZegoPlayer(seatIndex: e.key, userID: e.value)),
      ],
      robotList: playWithUserID.length < gameMaxPlayer
          ? List.generate(
              gameMaxPlayer - playWithUserID.length,
              (index) => ZegoGameRobot(
                robotAvatar: 'https://robohash.org/${Random().nextInt(1000000)}.png',
                seatIndex: playWithUserID.length + index,
                robotName: faker.person.name(),
                robotCoin: 1000,
              ),
            )
          : [],
      gameConfig: ZegoStartGameConfig(
        taxRate: 0,
        minGameCoin: 0,
        timeout: 60,
        taxType: ZegoTaxType.winnerDeduction,
      ),
    );
  }

  void onGameRoomAttributesUpdated(
    ZegoSignalingPluginRoomPropertiesUpdatedEvent propertiesData,
  ) {
    if (propertiesData.setProperties.containsKey(attributeKeyRoomGame)) {
      final gameID = propertiesData.setProperties[attributeKeyRoomGame]!;
      ZegoLoggerService.logInfo('onGameRoomAttributesUpdated, loadGame: $gameID', tag: 'APP', subTag: 'minigame');

      final gameList = ZegoMiniGame().getAllGameList();

      // If the gameList has not been loaded successfully at this time,
      // wait here for the game list to be loaded and then proceed to load the game.
      if (gameList.value.where((e) => e.miniGameId == gameID).isEmpty) {
        void onGameListUpdate() {
          if (gameList.value.where((e) => e.miniGameId == gameID).isNotEmpty) {
            gameList.removeListener(onGameListUpdate);
            loadGame(gameID);
          }
        }

        gameList.addListener(onGameListUpdate);
      } else {
        loadGame(gameID);
      }
    }
    if (propertiesData.deleteProperties.containsKey(attributeKeyRoomGame)) {
      ZegoLoggerService.logInfo('onGameRoomAttributesUpdated, unloadGame', tag: 'APP', subTag: 'minigame');
      unloadGame();
    }
  }

  Future<ZegoSignalingPluginRoomPropertiesOperationResult> updateGameRoomAttributes(String gameID) async {
    ZegoLoggerService.logInfo('updateGameRoomAttributes $attributeKeyRoomGame:$gameID', tag: 'APP', subTag: 'minigame');
    return ZegoUIKit().getSignalingPlugin().updateRoomProperty(
          roomID: roomID,
          key: attributeKeyRoomGame,
          value: gameID,
          isForce: true,
          isDeleteAfterOwnerLeft: true,
          isUpdateOwner: true,
        );
  }

  Future<ZegoSignalingPluginRoomPropertiesOperationResult> deleteGameRoomAttributes() async {
    ZegoLoggerService.logInfo('deleteGameRoomAttributes $attributeKeyRoomGame', tag: 'APP', subTag: 'minigame');
    return ZegoUIKit().getSignalingPlugin().deleteRoomProperties(
          roomID: roomID,
          keys: [attributeKeyRoomGame],
          isForce: true,
        );
  }
}
