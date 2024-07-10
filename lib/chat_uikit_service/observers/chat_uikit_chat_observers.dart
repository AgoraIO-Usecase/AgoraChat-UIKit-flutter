import '../../chat_uikit.dart';

mixin ChatUIKitChatObservers on ChatSDKWrapper {
  @override
  void onMessagesReceived(List<Message> messages) async {
    List<Conversation>? needMentionConversations;
    for (var msg in messages) {
      if (msg.hasMention) {
        needMentionConversations ??= [];
        Conversation? conversation = await ChatUIKit.instance.getConversation(
          conversationId: msg.conversationId!,
          type: ConversationType.values[msg.chatType.index],
        );
        needMentionConversations.add(conversation!);
      }
    }
    if (needMentionConversations?.isNotEmpty == true) {
      List<Future> futures = [];
      for (var conversation in needMentionConversations!) {
        futures.add(conversation.addMention());
      }
      Future.wait(futures);
    }

    super.onMessagesReceived(messages);
  }

  @override
  void onMessageContentChanged(
    Message message,
    String operatorId,
    int operationTime,
  ) async {
    for (var observer in List<ChatUIKitObserverBase>.of(observers)) {
      if (observer is ChatObserver) {
        // clear message's preview.
        if (message.bodyType == MessageType.TXT) {
          message.removePreview();
          String? url =
              ChatUIKitURLHelper().getUrlFromText(message.textContent);
          if (url?.isNotEmpty == true) {
            ChatUIKitPreviewObj? obj =
                await ChatUIKitURLHelper().fetchPreview(url!);
            if (obj != null) {
              message.addPreview(obj);
            }
            Future.value({ChatUIKit.instance.updateMessage(message: message)});
          }
        }
        observer.onMessageContentChanged(message, operatorId, operationTime);
      }
    }
  }

  @override
  void onMessagePinChanged(
    String messageId,
    String conversationId,
    MessagePinOperation pinOperation,
    MessagePinInfo pinInfo,
  ) async {
    if (pinOperation == MessagePinOperation.Pin) {
      await ChatUIKitInsertTools.insertPinEventMessage(
        messageId: messageId,
        conversationId: conversationId,
        creator: pinInfo.operatorId,
      );
    } else if (pinOperation == MessagePinOperation.Unpin) {
      await ChatUIKitInsertTools.insertUnPinEventMessage(
        messageId: messageId,
        conversationId: conversationId,
        creator: pinInfo.operatorId,
      );
    }
    super.onMessagePinChanged(messageId, conversationId, pinOperation, pinInfo);
  }
}
