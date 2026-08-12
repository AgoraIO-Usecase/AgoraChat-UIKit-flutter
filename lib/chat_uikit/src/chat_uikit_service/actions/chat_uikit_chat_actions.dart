import 'package:agora_chat_uikit/chat_sdk_context/chat_sdk_context.dart';
import 'package:agora_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';

mixin ChatUIKitChatActions on ChatSDKService {
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

      if (!ChatSDKContext.instance.conversationIsMute(conversation.id)) {
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
