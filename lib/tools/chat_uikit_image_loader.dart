import '../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitImageLoader {
  static String packageName = 'agora_chat_uikit';
  static Widget chatIcon(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/chat.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget bubbleVoice(int frame,
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/voice_$frame.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget file({double width = 30, double height = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/file_icon.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget card({double width = 30, double height = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/person.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget search({double width = 30, double height = 30, Color? color}) {
    return Image(
      width: width,
      height: height,
      color: color,
      image: AssetImage('assets/images/search.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget listEmpty(
      {double width = 105, double height = 105, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/list_empty.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget noDisturb(
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/no_disturb.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget defaultAvatar(
      {double width = 30, double height = 30, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: ChatUIKitSettings.avatarPlaceholder ??
          AssetImage('assets/images/avatar.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget emojiDelete({double size = 20, Color? color}) {
    return Icon(
      Icons.arrow_back,
      size: size,
      color: color,
      weight: 3,
    );
  }

  static Widget textKeyboard(
      {double width = 30, double height = 30, Color? color}) {
    return Image(
      width: width,
      height: height,
      color: color,
      image: AssetImage('assets/images/input_bar_keyboard.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceKeyboard(
      {double width = 30, double height = 30, Color? color}) {
    return Image(
      color: color,
      width: width,
      height: height,
      image:
          AssetImage('assets/images/input_bar_voice.png', package: packageName),
      // fit: BoxFit.fill,
    );
  }

  static Widget messageEdit(
      {double width = 16, double height = 16, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      image: AssetImage('assets/images/edit_bar.png', package: packageName),
      width: width,
      height: height,
      fit: BoxFit.fill,
    );
  }

  static Widget moreKeyboard(
      {double width = 28, double height = 30, Color? color}) {
    return Image(
      color: color,
      width: width,
      height: height,
      gaplessPlayback: true,
      image:
          AssetImage('assets/images/input_bar_more.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget faceKeyboard(
      {double width = 30, double height = 30, Color? color}) {
    return Image(
      color: color,
      width: width,
      height: height,
      gaplessPlayback: true,
      image:
          AssetImage('assets/images/input_bar_face.png', package: packageName),
      // fit: BoxFit.fill,
    );
  }

  static Widget sendKeyboard(
      {double width = 30, double height = 30, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image:
          AssetImage('assets/images/input_bar_send.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceDelete(
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image:
          AssetImage('assets/images/record_delete.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceSend(
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/record_send.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget voiceMic(
      {double width = 20, double height = 20, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/record_mic.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget imageDefault(
      {double width = 44, double height = 44, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image:
          AssetImage('assets/images/image_default.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget videoDefault(
      {double width = 44, double height = 44, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image:
          AssetImage('assets/images/video_default.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget networkImage({
    required String image,
    required ImageProvider placeholder,
    Widget? placeholderWidget,
    double? size,
    BoxFit fit = BoxFit.fill,
  }) {
    return FadeInImage(
      key: ValueKey(image),
      width: size,
      height: size,
      placeholder: placeholder,
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

  static Widget messageViewMoreAlbum(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/image.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageViewMoreVideo(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/video.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageViewMoreCamera(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/camera.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageViewMoreFile(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/folder.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageViewMoreCard(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/person.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressCopy(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_copy.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressReply(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_reply.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressEdit(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_edit.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressTranslate(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_translate.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressMultiSelected(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_multi_selected.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressForward(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_forward.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressThread(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_thread.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressReport(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      gaplessPlayback: true,
      color: color,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_report.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressDelete(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_report.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageLongPressRecall(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/message_long_press_recall.png',
          package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageTrash(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/trash.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget messageHistory(
      {double width = 16, double height = 16, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/history.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget moreReactions(
      {double width = 36, double height = 36, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image:
          AssetImage('assets/images/more_reactions.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget more({double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/more.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget contacts(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/contacts.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget leaveThread(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/leave_thread.png', package: packageName),
      fit: BoxFit.fill,
    );
  }

  static Widget pinMessage(
      {double width = 24, double height = 24, Color? color}) {
    return Image(
      color: color,
      gaplessPlayback: true,
      width: width,
      height: height,
      image: AssetImage('assets/images/pin.png', package: packageName),
      fit: BoxFit.fill,
    );
  }
}
