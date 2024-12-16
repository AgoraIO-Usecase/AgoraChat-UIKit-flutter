import '../../../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitCombineBubbleWidget extends StatelessWidget {
  const ChatUIKitCombineBubbleWidget({
    required this.model,
    this.forceLeft,
    this.style,
    this.summaryBuilder,
    super.key,
  });
  final MessageModel model;
  final TextStyle? style;
  final bool? forceLeft;
  final String? Function(BuildContext context, String summary)? summaryBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;
    bool left =
        forceLeft ?? model.message.direction == MessageDirection.RECEIVE;

    Widget topWidget = ChatUIKitEmojiRichText(
      emojiSize: const Size(14, 14),
      text: summary(context),
      textScaler: TextScaler.noScaling,
      textAlign: TextAlign.left,
      maxLines: 4,
      style: style ??
          (left
              ? TextStyle(
                  fontWeight: theme.font.bodySmall.fontWeight,
                  fontSize: theme.font.bodySmall.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
                )
              : TextStyle(
                  fontWeight: theme.font.bodySmall.fontWeight,
                  fontSize: theme.font.bodySmall.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                )),
    );

    topWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [topWidget],
    );

    Widget bottomWidget = RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
              child: ChatUIKitImageLoader.messageHistory(
            width: 16,
            height: 16,
            color: left
                ? theme.color.isDark
                    ? theme.color.neutralSpecialColor7
                    : theme.color.neutralSpecialColor5
                : theme.color.isDark
                    ? theme.color.neutralSpecialColor3
                    : theme.color.neutralSpecialColor98,
          )),
          TextSpan(
            text: ChatUIKitLocal.historyMessages.localString(context),
            style: TextStyle(
              fontWeight: theme.font.labelSmall.fontWeight,
              fontSize: theme.font.labelSmall.fontSize,
              color: left
                  ? theme.color.isDark
                      ? theme.color.neutralSpecialColor7
                      : theme.color.neutralSpecialColor5
                  : theme.color.isDark
                      ? theme.color.neutralSpecialColor3
                      : theme.color.neutralSpecialColor98,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.right,
      textScaler: TextScaler.noScaling,
      overflow: TextOverflow.ellipsis,
    );

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [Expanded(child: topWidget)],
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Expanded(child: bottomWidget)],
        ),
      ],
    );

    return content;
  }

  String summary(BuildContext context) {
    List<String> summaries = [];
    List<String> tmpList = model.message.summary?.split('\n') ?? [];
    for (var str in tmpList) {
      String? summaryTmp = summaryBuilder?.call(context, str);
      if (summaryTmp?.isNotEmpty == true) {
        summaries.add(summaryTmp!);
        continue;
      }
      int begin = str.indexOf('[');
      if (begin == -1) {
        summaries.add(str);
        continue;
      }
      int end = str.indexOf(']');
      if (end == -1) {
        summaries.add(str);
        continue;
      }

      if (begin > end) {
        summaries.add(str);
        continue;
      }

      String typeStr = str.substring(begin, end + 1);

      bool hasCatch = false;
      if (typeStr == '[Image]') {
        typeStr = ChatUIKitLocal.messageCellCombineImage.localString(context);
        hasCatch = true;
      }
      if (typeStr == '[Voice]') {
        typeStr = ChatUIKitLocal.messageCellCombineVoice.localString(context);
        hasCatch = true;
      }
      if (typeStr == '[Location]') {
        typeStr =
            ChatUIKitLocal.messageCellCombineLocation.localString(context);
        hasCatch = true;
      }
      if (typeStr == '[Video]') {
        typeStr = ChatUIKitLocal.messageCellCombineVideo.localString(context);
        hasCatch = true;
      }
      if (typeStr == '[File]') {
        typeStr = ChatUIKitLocal.messageCellCombineFile.localString(context);
        hasCatch = true;
      }
      if (typeStr == '[Combine]') {
        typeStr = ChatUIKitLocal.messageCellCombineCombine.localString(context);
        hasCatch = true;
      }
      if (hasCatch == true) {
        String tmp = str.substring(0, begin + 1) + typeStr + str.substring(end);
        summaries.add(tmp);
      } else {
        summaries.add(str);
      }
    }
    return summaries.join('\n');
  }
}
