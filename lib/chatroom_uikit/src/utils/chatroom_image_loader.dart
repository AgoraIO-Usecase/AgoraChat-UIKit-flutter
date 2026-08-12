import 'package:flutter/material.dart';

const String packageName = 'agora_chat_uikit';

class ChatRoomImageLoader {
  static Widget roomEmoji(String imageName, {double size = 36}) {
    String name = imageName.substring(0, imageName.length);
    return Image.asset(
      'assets/images/chatroom/emojis/$name.png',
      package: packageName,
      width: size,
      height: size,
    );
  }

  static Widget roomSend({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/airplane.png',
      package: packageName,
      width: size,
      height: size,
    );
  }

  static Widget roomPinMsg({double size = 18, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/pin.png',
      package: packageName,
      width: size,
      height: size,
    );
  }

  static Widget roomKeyboard({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/textKeyboard.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomFace({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/face.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomAvatar({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/avatar.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomChatRaise({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/chatRaise.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomMore({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/more.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomSearch({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/search.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomSelected({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/selected.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomSuccess({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/success.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomUnselected({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/unselected.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomInputChat({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/chat.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomDelete({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/delete.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomEmpty({double size = 140, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/empty.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomDefaultGift({double size = 30, Color? color}) {
    return Image.asset(
      'assets/images/chatroom/default_gift.png',
      package: packageName,
      width: size,
      height: size,
      color: color,
    );
  }

  static Widget roomDefaultAvatar({double size = 30, Color? color}) {
    return Icon(Icons.perm_identity, size: size, color: color);
  }

  static Widget roomNetworkImage({
    String? image,
    Widget? placeholderWidget,
    double? size,
    BoxFit fit = BoxFit.fill,
  }) {
    if (image == null) {
      return placeholderWidget ?? Container();
    }

    return FadeInImage(
      width: size,
      height: size,
      placeholder: const NetworkImage(''),
      placeholderFit: fit,
      placeholderErrorBuilder: (context, error, stackTrace) {
        return placeholderWidget ?? Container();
      },
      image: NetworkImage(image),
      fit: fit,
      imageErrorBuilder: (context, error, stackTrace) {
        return placeholderWidget ?? Container();
      },
    );
  }
}
