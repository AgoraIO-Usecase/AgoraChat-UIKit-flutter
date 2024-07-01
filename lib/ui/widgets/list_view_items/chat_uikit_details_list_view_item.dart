import '../../../../chat_uikit.dart';
import 'package:flutter/material.dart';

enum ChatUIKitDetailsListViewItemModelType {
  normal,
  space,
}

class ChatUIKitDetailsListViewItemModel {
  ChatUIKitDetailsListViewItemModel({
    required this.title,
    this.trailing,
    this.onTap,
  }) : type = ChatUIKitDetailsListViewItemModelType.normal;

  ChatUIKitDetailsListViewItemModel.space()
      : type = ChatUIKitDetailsListViewItemModelType.space,
        title = null,
        trailing = null,
        onTap = null;

  final String? title;
  final Widget? trailing;
  final VoidCallback? onTap;
  final ChatUIKitDetailsListViewItemModelType type;
}

class ChatUIKitDetailsListViewItem extends StatelessWidget {
  const ChatUIKitDetailsListViewItem(
      {required this.title, this.trailing, super.key});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    Widget content = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: theme.font.headlineSmall.fontWeight,
            fontSize: theme.font.headlineSmall.fontSize,
            color: theme.color.isDark
                ? theme.color.neutralColor100
                : theme.color.neutralColor1,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: trailing ?? const SizedBox(),
          ),
        )
      ],
    );

    content = Stack(
      children: [
        content,
        Positioned(
          bottom: 0,
          left: 16,
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

    content = SizedBox(height: 54, child: content);

    return content;
  }
}
