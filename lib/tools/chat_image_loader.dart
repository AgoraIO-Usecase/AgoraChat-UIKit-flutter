import 'package:flutter/material.dart';

class ChatImageLoader {
  static Image loadImage(
    name, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.fill,
    Color? color,
  }) {
    return Image.asset(
      "images/$name",
      width: width,
      height: height,
      fit: fit,
      package: "agora_chat_uikit",
      color: color,
    );
  }

  static ImageProvider<Object> assetImage(String name) {
    return AssetImage("images/$name", package: "agora_chat_uikit");
  }

  static Widget defaultAvatar({
    double size = 30,
  }) {
    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.hardEdge,
      decoration: const ShapeDecoration(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ),
      child: loadImage("avatar.png"),
    );
  }
}
