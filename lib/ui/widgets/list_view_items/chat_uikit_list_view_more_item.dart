import '../../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitListViewMoreItem extends StatelessWidget
    with NeedAlphabeticalWidget {
  const ChatUIKitListViewMoreItem({
    required this.title,
    this.trailing,
    this.enableMoreArrow = true,
    this.onTap,
    this.height = 58,
    super.key,
  });
  final String title;

  final Widget? trailing;

  final bool enableMoreArrow;

  final VoidCallback? onTap;

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;

    Widget content = Row(
      children: [
        Text(
          title,
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor98
                : theme.color.neutralColor1,
            fontSize: theme.font.titleMedium.fontSize,
            fontWeight: theme.font.titleMedium.fontWeight,
          ),
        )
      ],
    );

    if (enableMoreArrow) {
      content = Row(
        children: [
          Expanded(
            child: content,
          ),
          trailing ?? const SizedBox(),
          Icon(
            Icons.arrow_forward_ios,
            size: 13,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor3,
          ),
        ],
      );
    }

    content = Container(
      height: itemHeight - borderHeight,
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
      ),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: content,
    );

    content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        content,
        Container(
          height: borderHeight,
          color: theme.color.isDark
              ? theme.color.neutralColor2
              : theme.color.neutralColor9,
          margin: const EdgeInsets.only(left: 16),
        )
      ],
    );

    content = InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: content,
    );

    return content;
  }

  @override
  double get itemHeight => height;
}
