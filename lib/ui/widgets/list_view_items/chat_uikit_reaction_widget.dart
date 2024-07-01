import '../../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIkitReactionWidget extends StatelessWidget {
  const ChatUIkitReactionWidget(
    this.reaction, {
    required this.theme,
    this.highlightColor,
    this.bgColor,
    this.highlightTextColor,
    this.textColor,
    super.key,
  });
  final MessageReaction reaction;
  final ChatUIKitTheme theme;
  final Color? highlightColor;
  final Color? bgColor;
  final Color? highlightTextColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: bgColor ??
            (reaction.isAddedBySelf
                ? (theme.color.isDark
                    ? Colors.transparent
                    : theme.color.neutralColor95)
                : (theme.color.isDark
                    ? theme.color.neutralColor3
                    : theme.color.neutralColor95)),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          width: 1,
          color: highlightColor ??
              (reaction.isAddedBySelf
                  ? (theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5)
                  : (theme.color.isDark
                      ? theme.color.neutralColor3
                      : theme.color.neutralColor95)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          () {
            if (ChatUIKitEmojiData.emojiList.contains(reaction.reaction)) {
              return Image.asset(
                ChatUIKitEmojiData.getEmojiImagePath(reaction.reaction)!,
                package: ChatUIKitEmojiData.packageName,
                width: 24,
                height: 24,
              );
            } else {
              return Text(
                reaction.reaction,
                textAlign: TextAlign.right,
              );
            }
          }(),
          const SizedBox(width: 2),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 6,
            ),
            child: Center(
                child: Text(
              "${reaction.userCount > 99 ? '99+' : reaction.userCount}",
              style: TextStyle(
                fontWeight: theme.font.labelMedium.fontWeight,
                fontSize: theme.font.labelMedium.fontSize,
                color: reaction.isAddedBySelf
                    ? (highlightTextColor ??
                        (theme.color.isDark
                            ? theme.color.neutralColor7
                            : theme.color.primaryColor5))
                    : (textColor ??
                        (theme.color.isDark
                            ? theme.color.neutralColor7
                            : theme.color.neutralColor3)),
              ),
            )),
          ),
        ],
      ),
    );
  }
}
