import '../../../../chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitMessageReactionsRow extends StatefulWidget {
  const ChatUIKitMessageReactionsRow({
    required this.reactions,
    required this.isLeft,
    required this.onReactionTap,
    this.onReactionInfoTap,
    super.key,
  });

  final List<MessageReaction> reactions;
  final Function(MessageReaction reaction)? onReactionTap;
  final VoidCallback? onReactionInfoTap;
  final bool isLeft;

  @override
  State<ChatUIKitMessageReactionsRow> createState() =>
      _ChatUIKitMessageReactionsRowState();
}

class _ChatUIKitMessageReactionsRowState
    extends State<ChatUIKitMessageReactionsRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reactions.isEmpty) return const SizedBox();
    ChatUIKitTheme theme = ChatUIKitTheme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        List<Widget> reactionWidgets = [];
        List<Widget> children = [];
        for (final reaction in widget.reactions) {
          if (reactionWidgets.length >= 3) {
            break;
          }
          reactionWidgets.add(
            InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                widget.onReactionTap?.call(reaction);
              },
              child: Container(
                margin: const EdgeInsets.only(right: 4),
                child: ChatUIkitReactionWidget(
                  reaction,
                  theme: theme,
                ),
              ),
            ),
          );
        }

        Widget reactionsWidget = Row(
          children: reactionWidgets,
        );

        children.add(reactionsWidget);
        // 添加"更多"按钮
        children.add(
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: widget.onReactionInfoTap,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 2),
              decoration: BoxDecoration(
                color: theme.color.isDark
                    ? theme.color.neutralColor2
                    : theme.color.neutralColor95,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: ChatUIKitImageLoader.more(height: 20, width: 22),
              ),
            ),
          ),
        );
        return Row(
            mainAxisAlignment:
                widget.isLeft ? MainAxisAlignment.start : MainAxisAlignment.end,
            children: children);
      },
    );
  }
}
