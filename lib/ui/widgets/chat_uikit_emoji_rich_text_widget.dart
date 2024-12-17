import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitEmojiRichText extends StatelessWidget {
  const ChatUIKitEmojiRichText({
    required this.text,
    this.style,
    this.strutStyle,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.locale,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.emojiSize = const Size(18, 18),
    this.textScaler = TextScaler.noScaling,
    this.maxLines,
    this.selectable = false,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final Size emojiSize;
  final StrutStyle? strutStyle;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool softWrap;
  final TextOverflow overflow;
  final TextScaler textScaler;
  final int? maxLines;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];
    List<String> characters = text.characters.toList();

    String string = '';

    for (var i = 0; i < characters.length; i++) {
      if (!ChatUIKitEmojiData.emojiList.contains(characters[i])) {
        string += characters[i];
      } else {
        spans.add(TextSpan(text: string));
        spans.add(WidgetSpan(
          child: Padding(
            padding: EdgeInsets.only(
              left: string.isNotEmpty ? 2.0 : 0,
              right: (i == characters.length) ? 0 : 2.0,
            ),
            child: Image.asset(
              ChatUIKitEmojiData.getEmojiImagePath(characters[i])!,
              package: ChatUIKitEmojiData.packageName,
              width: emojiSize.width,
              height: emojiSize.height,
            ),
          ),
        ));
        string = '';
      }
    }

    if (string.isNotEmpty) {
      spans.add(TextSpan(text: string));
    }

    if (selectable) {
      return SelectableText.rich(
        TextSpan(children: spans, style: style),
        textAlign: textAlign,
        textDirection: textDirection,
        maxLines: maxLines,
        textScaler: TextScaler.noScaling,
      );
    } else {
      return RichText(
        textAlign: textAlign,
        textDirection: textDirection,
        locale: locale,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        text: TextSpan(children: spans, style: style),
        textScaler: textScaler,
      );
    }
  }
}

class EmojiIndex {
  int index;
  int length;
  String emoji;
  EmojiIndex({
    required this.index,
    required this.length,
    required this.emoji,
  });
}
