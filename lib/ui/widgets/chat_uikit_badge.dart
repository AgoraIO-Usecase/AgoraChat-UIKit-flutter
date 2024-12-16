import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitBadge extends StatelessWidget {
  const ChatUIKitBadge(
    this.count, {
    this.backgroundColor,
    this.textColor,
    this.boarderColor,
    super.key,
  });

  final int count;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? boarderColor;

  @override
  Widget build(BuildContext context) {
    if (count <= 0) {
      return const SizedBox();
    }

    final theme = ChatUIKitTheme.instance;
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 1, 4, 2),
      constraints: const BoxConstraints(
        minWidth: 20,
        maxHeight: 20,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ??
            (theme.color.isDark
                ? theme.color.primaryColor6
                : theme.color.primaryColor5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count > 99 ? '99+' : count.toString(),
        textScaler: TextScaler.noScaling,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor ??
              (theme.color.isDark
                  ? theme.color.neutralColor1
                  : theme.color.neutralColor98),
          fontSize: theme.font.labelSmall.fontSize,
          fontWeight: theme.font.labelSmall.fontWeight,
        ),
      ),
    );
  }
}
