import 'package:agora_chat_uikit/chat_uikit.dart';

import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

/*
class _ConversationPageState extends State<ConversationPage> {
  @override
  Widget build(BuildContext context) {
    return const ConversationsView();
  }
}
*/

class _ConversationPageState extends State<ConversationPage> {
  late ConversationListViewController controller;

  @override
  void initState() {
    super.initState();
    controller = ConversationListViewController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    return ConversationsView(
      controller: controller,
      enablePinHighlight: false,
      onLongPressHandler: (context, model, defaultActions) {
        return defaultActions
            .where((element) => element.actionType == ChatUIKitActionType.mute)
            .toList();
      },
      listViewItemBuilder: (context, model) {
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            controller.deleteConversation(conversationId: model.profile.id);
          },
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.startToEnd) {
              controller.pinConversation(
                  conversationId: model.profile.id, isPinned: !model.pinned);
              return false;
            }
            return true;
          },
          background: Container(
            color: Colors.green,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 20),
            child: Icon(
                model.pinned
                    ? Icons.vertical_align_bottom
                    : Icons.vertical_align_top,
                color: Colors.white),
          ),
          secondaryBackground: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            color: model.pinned
                ? (theme.color.isDark
                    ? theme.color.neutralColor2
                    : theme.color.neutralColor95)
                : (theme.color.isDark
                    ? theme.color.neutralColor1
                    : theme.color.neutralColor98),
            child: Row(
              children: [
                Stack(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 18, right: 3, top: 3),
                      child: ChatUIKitAvatar(
                        cornerRadius: CornerRadius.large,
                        avatarUrl: model.avatarUrl,
                        size: 50,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: model.noDisturb && model.unreadCount > 0
                          ? Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ))
                          : Center(
                              child: ChatUIKitBadge(model.unreadCount,
                                  backgroundColor: Colors.red),
                            ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ChatUIKitConversationListViewItem(
                    model,
                    showUnreadCount: false,
                    showAvatar: false,
                    showNoDisturb: true,
                    titleWidget: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: Text(
                            model.showName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset('assets/images/secret.png', width: 20),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
