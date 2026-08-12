import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with ChatUIKitThemeMixin, MessageObserver, ChatObserver {
  @override
  void dispose() {
    super.dispose();
    ChatUIKit.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
  }

  Message getWarningMessage(String targetId, ChatType type, int time) {
    final msg = ChatUIKitMessage.createAlertMessage(
      targetId,
      type,
      params: {
        'alert': 'warning',
      },
    );
    msg.serverTime = time;
    msg.localTime = time;

    return msg;
  }

  @override
  void onMessageSendSuccess(String msgId, Message msg) {
    // ChatUIKit.instance.insertMessage(
    //   message: getWarningMessage(
    //       msg.conversationId!, msg.chatType, msg.serverTime + 1),
    //   runMessageReceived: true,
    // );
  }

  @override
  void onMessagesReceived(List<Message> messages) {
    for (var msg in messages) {
      if (msg.isAlertCustomMessage == true ||
          msg.from == ChatUIKit.instance.currentUserId) {
        continue;
      }
      // ChatUIKit.instance.insertMessage(
      //   message: getWarningMessage(
      //       msg.conversationId!, msg.chatType, msg.serverTime + 1),
      //   runMessageReceived: true,
      // );
    }
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return ConversationsView(
      itemBuilder: (context, model) {
        if (model.lastMessage?.isAlertCustomMessage == true) {
          return ChatUIKitConversationListViewItem(
            model,
            subTitleLabel:
                model.lastMessage?.customBodyParams?['alert'] ?? '默认提醒消息内容',
          );
        }
        return null;
      },
    );
  }
}
