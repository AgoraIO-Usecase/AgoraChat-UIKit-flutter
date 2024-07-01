import '../../../chat_uikit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ChatUIKitRegExpText extends StatelessWidget {
  const ChatUIKitRegExpText({
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
    this.exp,
    this.expHighlightColor,
    this.enableExpUnderline = true,
    this.onExpTap,
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
  final RegExp? exp;
  final Color? expHighlightColor;
  final bool enableExpUnderline;
  final Function(String expStr)? onExpTap;

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];
    List<String> characters = text.characters.toList();

    String string = '';

    RegExp exp = this.exp ?? ChatUIKitSettings.defaultUrlRegExp;

    for (var i = 0; i < characters.length; i++) {
      if (!ChatUIKitEmojiData.emojiList.contains(characters[i])) {
        string += characters[i];
      } else {
        Iterable<RegExpMatch> allMatches = exp.allMatches(string);
        int index = 0;
        for (var match in allMatches) {
          spans.add(TextSpan(
            text: string.substring(index, match.start),
          ));
          String matched = string.substring(match.start, match.end);

          spans.add(
            TextSpan(
              text: matched,
              style: TextStyle(
                  color: expHighlightColor,
                  decoration: enableExpUnderline
                      ? TextDecoration.underline
                      : TextDecoration.none),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  onExpTap?.call(matched);
                },
            ),
          );
          index = match.end;
        }
        if (index < string.length) {
          spans.add(TextSpan(text: string.substring(index)));
        }

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
      Iterable<RegExpMatch> allMatches = exp.allMatches(string);
      int index = 0;
      for (var match in allMatches) {
        spans.add(TextSpan(text: string.substring(index, match.start)));
        String matched = string.substring(match.start, match.end);
        spans.add(
          TextSpan(
            text: matched,
            style: TextStyle(
                color: expHighlightColor,
                decoration: enableExpUnderline
                    ? TextDecoration.underline
                    : TextDecoration.none),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                onExpTap?.call(matched);
              },
          ),
        );
        index = match.end;
      }
      if (index < string.length) {
        spans.add(TextSpan(text: string.substring(index)));
      }
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
        textScaler: TextScaler.noScaling,
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
