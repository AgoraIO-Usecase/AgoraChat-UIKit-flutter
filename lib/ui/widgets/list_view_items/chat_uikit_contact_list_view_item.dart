import '../../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitContactListViewItem extends StatelessWidget {
  const ChatUIKitContactListViewItem(this.model, {super.key});

  final ContactItemModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;

    TextStyle normalStyle = TextStyle(
      color: theme.color.isDark
          ? theme.color.neutralColor98
          : theme.color.neutralColor1,
      fontSize: theme.font.titleMedium.fontSize,
      fontWeight: theme.font.titleMedium.fontWeight,
    );

    Widget name = Text(
      model.showName,
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.noScaling,
      style: normalStyle,
    );

    Widget avatar = ChatUIKitAvatar(
      avatarUrl: model.avatarUrl,
      size: 40,
    );

    Widget content = Row(
      children: [
        avatar,
        const SizedBox(width: 12),
        name,
      ],
    );
    content = Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      height: model.itemHeight - 0.5,
      color: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          bottom: 0,
          left: 68,
          right: 0,
          height: 0.5,
          child: Divider(
            height: borderHeight,
            thickness: borderHeight,
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9,
          ),
        )
      ],
    );
    return content;
  }
}
