// ignore_for_file: unused_import, sized_box_for_whitespace, depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

import '../../main.dart';
import '../service/mini_game_api.dart';
import '../your_game_server.dart';

Future<ZegoGameInfo?> showGameListView(BuildContext context) {
  return showModalBottomSheet(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('GameList',
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                ValueListenableBuilder(
                  valueListenable: ZegoMiniGame().getAllGameList(),
                  builder: (BuildContext context, List<ZegoGameInfo> gameList,
                      Widget? child) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      height: 200,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        scrollDirection: Axis.vertical,
                        itemCount: gameList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              Navigator.pop(context, gameList[index]);
                            },
                            child: Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: gameList[index].thumbnail!,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, _) =>
                                            const CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  Text(
                                    gameList[index].mgName!,
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      });
}
