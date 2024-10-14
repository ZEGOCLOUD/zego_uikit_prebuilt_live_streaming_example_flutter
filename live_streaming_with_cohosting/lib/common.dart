// Flutter imports:
// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

Widget customAvatarBuilder(
  BuildContext context,
  Size size,
  ZegoUIKitUser? user,
  Map<String, dynamic> extraInfo,
) {
  return Stack(children: [
    CachedNetworkImage(
      imageUrl: 'https://robohash.org/${user?.id}.png',
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          CircularProgressIndicator(value: downloadProgress.progress),
      errorWidget: (context, url, error) {
        return ZegoAvatar(user: user, avatarSize: size);
      },
    ),
    // Lottie.asset('assets/avatars/4338 400-320.json'),
    // const SVGASimpleImage(assetsName: 'assets/avatars/1746.svga'),
  ]);
}
