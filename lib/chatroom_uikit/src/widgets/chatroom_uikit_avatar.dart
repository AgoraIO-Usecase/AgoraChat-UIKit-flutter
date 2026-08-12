import 'package:agora_chat_uikit/chat_uikit/src/chat_uikit_settings.dart';
import 'package:agora_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:agora_chat_uikit/chat_uikit_universal/chat_uikit_universal.dart';
import 'package:agora_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class ChatRoomUIKitAvatar extends StatelessWidget {
  const ChatRoomUIKitAvatar({
    required this.width,
    required this.height,
    this.cornerRadius,
    this.margin,
    this.user,
    super.key,
  });

  final ChatUIKitProfile? user;
  final double width;
  final double height;
  final CornerRadius? cornerRadius;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    double circular = 0;
    CornerRadius radius = cornerRadius ?? ChatUIKitSettings.avatarRadius;
    if (radius == CornerRadius.extraSmall) {
      circular = height / 16;
    } else if (radius == CornerRadius.small) {
      circular = height / 8;
    } else if (radius == CornerRadius.medium) {
      circular = height / 4;
    } else {
      circular = height / 2;
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(circular)),
      ),
      margin: margin,
      width: width,
      height: height,
      child: () {
        if (user?.avatarUrl?.isNotEmpty == true) {
          return ChatRoomImageLoader.roomNetworkImage(
            image: user?.avatarUrl ?? '',
            size: width,
            placeholderWidget: (ChatUIKitSettings.roomUserDefaultAvatar == null)
                ? ChatRoomImageLoader.roomDefaultAvatar(size: width)
                : Image.asset(ChatUIKitSettings.roomUserDefaultAvatar!),
          );
        } else {
          return ChatRoomImageLoader.roomAvatar(size: width);
        }
      }(),
    );
  }
}
