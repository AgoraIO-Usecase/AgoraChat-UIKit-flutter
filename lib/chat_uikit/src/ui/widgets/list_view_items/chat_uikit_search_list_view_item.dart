import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:agora_chat_uikit/chat_uikit/src/tools/chat_uikit_highlight_tool.dart';
import 'package:agora_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';

import 'package:flutter/material.dart';

class ChatUIKitSearchListViewItem extends StatelessWidget {
  final ChatUIKitProfile profile;
  final String? highlightWord;

  const ChatUIKitSearchListViewItem({
    required this.profile,
    this.highlightWord,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;

    Widget name = HighlightTool.highlightWidget(
      context,
      profile.contactShowName,
      searchKey: highlightWord,
    );

    Widget avatar = ChatUIKitAvatar(
      avatarUrl: profile.avatarUrl,
      isGroup: profile.type == ChatUIKitProfileType.group,
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
      height: 60 - 0.5,
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
