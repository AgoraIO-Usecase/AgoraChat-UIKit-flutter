import '../../chat_uikit.dart';

mixin ChatUIKitChatActions on ChatSDKWrapper {
  @override
  Future<int> getUnreadMessageCount({List<String>? withoutIds}) async {
    int unreadCount = 0;
    List<Conversation> list = await ChatUIKit.instance.getAllConversations();
    if (list.isEmpty) return unreadCount;
    for (var conversation in list) {
      if (conversation.isChatThread) continue;
      if (withoutIds?.isNotEmpty == true) {
        if (withoutIds!.contains(conversation.id)) continue;
      }

      if (!ChatUIKitContext.instance.conversationIsMute(conversation.id)) {
        int count = await conversation.unreadCount();
        unreadCount += count;
      }
    }
    return unreadCount;
  }

  @override
  Future<void> pinMessage({required String messageId}) async {
    await super.pinMessage(messageId: messageId);
    await ChatUIKitInsertTools.insertPinEventMessage(messageId: messageId);
  }

  @override
  Future<void> unpinMessage({required String messageId}) async {
    await super.unpinMessage(messageId: messageId);
    await ChatUIKitInsertTools.insertUnPinEventMessage(messageId: messageId);
  }
}
