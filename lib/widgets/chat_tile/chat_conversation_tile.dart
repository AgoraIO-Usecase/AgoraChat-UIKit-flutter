import 'package:flutter/material.dart';

import '../../agora_chat_uikit.dart';

class ChatConversationListTile extends StatelessWidget {
  const ChatConversationListTile({
    super.key,
    this.avatar,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.conversation,
  });

  final Widget? avatar;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final void Function(ChatConversation conversation)? onTap;
  final ChatConversation conversation;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: conversation.latestMessage(),
      builder: (context, snapshot) {
        ChatMessage? msg;
        if (snapshot.hasData) {
          msg = snapshot.data!;
        }

        return ListTile(
          leading: avatar,
          title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: title ??
                      Text(
                        conversation.id,
                        style: ChatUIKit.of(context)
                            .theme
                            .conversationListItemTitleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                ),
                Text(
                  msg?.createTs ?? "",
                  style:
                      ChatUIKit.of(context).theme.conversationListItemTsStyle,
                ),
              ]),
          subtitle: subtitle ??
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Builder(
                  builder: (context) {
                    return Text(
                      msg?.summary(context) ?? "",
                      style: ChatUIKit.of(context)
                          .theme
                          .conversationListItemTitleStyle,
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                )),
                FutureBuilder<int>(
                  future: conversation.unreadCount(),
                  builder: (context, snapshot) {
                    return ChatBadgeWidget(snapshot.data ?? 0);
                  },
                )
              ]),
          trailing: trailing,
          onTap: () => onTap?.call(conversation),
        );
      },
    );
  }
}
