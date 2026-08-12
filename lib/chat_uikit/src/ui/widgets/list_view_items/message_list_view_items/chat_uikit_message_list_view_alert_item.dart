import 'package:chat_uikit_theme/chat_uikit_theme.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

enum MessageAlertActionType {
  heightLight,
  normal,
}

class MessageAlertAction {
  final String text;
  final MessageAlertActionType type;
  final VoidCallback? onTap;

  MessageAlertAction({
    required this.text,
    this.type = MessageAlertActionType.normal,
    this.onTap,
  });
}

class ChatUIKitMessageListViewAlertItem extends StatelessWidget {
  const ChatUIKitMessageListViewAlertItem({
    required this.actions,
    this.textAlign = TextAlign.center,
    this.style,
    super.key,
  });

  final List<MessageAlertAction> actions;
  final TextAlign textAlign;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;
    final defaultStyle = style ??
        TextStyle(
          fontSize: theme.font.labelSmall.fontSize,
          fontWeight: theme.font.labelSmall.fontWeight,
          color: theme.color.isDark
              ? theme.color.neutralColor6
              : theme.color.neutralColor7,
        );

    final hightLightStyle = TextStyle(
      fontSize: theme.font.labelSmall.fontSize,
      fontWeight: theme.font.labelSmall.fontWeight,
      color: theme.color.isDark
          ? theme.color.neutralColor6
          : theme.color.neutralColor5,
    );

    final actionTextStyle = TextStyle(
      fontSize: theme.font.labelSmall.fontSize,
      fontWeight: theme.font.labelSmall.fontWeight,
      color: theme.color.isDark
          ? theme.color.primaryColor6
          : theme.color.primaryColor5,
    );

    List<InlineSpan> list = [];

    for (var info in actions) {
      bool normal = info.type == MessageAlertActionType.normal;

      if (!normal && info != actions.first) {
        list.add(
          const WidgetSpan(child: SizedBox(width: 2)),
        );
      }

      list.add(
        TextSpan(
            text: info.text,
            style: normal
                ? null
                : (info.onTap == null ? hightLightStyle : actionTextStyle),
            recognizer: TapGestureRecognizer()..onTap = info.onTap),
      );

      if (!normal && info != actions.last) {
        list.add(
          const WidgetSpan(child: SizedBox(width: 2)),
        );
      }
    }

    Widget content = RichText(
      textScaler: TextScaler.noScaling,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: defaultStyle,
        children: list,
      ),
      textAlign: textAlign,
    );

    content = SizedBox(height: 30, child: Center(child: content));

    return content;
  }
}
