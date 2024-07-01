import '../../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitAlphabeticalListViewItem extends StatelessWidget {
  const ChatUIKitAlphabeticalListViewItem({
    required this.model,
    super.key,
  });

  final AlphabeticalItemModel model;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 6, top: 6),
      color: model.backgroundColor ??
          (theme.color.isDark
              ? theme.color.neutralColor1
              : theme.color.neutralColor98),
      height: model.height,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          model.alphabetical,
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: model.textStyle ??
              TextStyle(
                fontWeight: theme.font.titleSmall.fontWeight,
                fontSize: theme.font.titleSmall.fontSize,
                color: theme.color.isDark
                    ? theme.color.neutralColor6
                    : theme.color.neutralColor5,
              ),
        ),
      ),
    );
  }
}
