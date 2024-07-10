import '../chat_uikit.dart';

class InsertMessageTools {
  static Message insertRecallMessage({
    required Message recalledMessage,
    int? timestamp,
  }) {
    int time = timestamp ?? recalledMessage.serverTime;
    Message alertMsg = Message.createCustomSendMessage(
      targetId: recalledMessage.conversationId!,
      event: alertRecalledKey,
      chatType: recalledMessage.chatType,
      params: {
        alertOperatorIdKey: recalledMessage.from!,
      },
    );
    alertMsg.conversationId = recalledMessage.conversationId;
    alertMsg.serverTime = time;
    alertMsg.localTime = time;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(message: alertMsg);
    return alertMsg;
  }

  static void insertGroupDestroyMessage(String groupId) {
    if (ChatUIKit.instance.options?.deleteMessagesAsExitGroup == true) {
      return;
    }
    Message alertMsg = Message.createCustomSendMessage(
      targetId: groupId,
      event: alertGroupDestroyKey,
      chatType: ChatType.GroupChat,
    );
    alertMsg.conversationId = groupId;
    alertMsg.serverTime = DateTime.now().millisecondsSinceEpoch;
    alertMsg.localTime = alertMsg.serverTime;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static void insertGroupLeaveMessage(String groupId) {
    if (ChatUIKit.instance.options?.deleteMessagesAsExitGroup == true) {
      return;
    }
    Message alertMsg = Message.createCustomSendMessage(
      targetId: groupId,
      event: alertGroupLeaveKey,
      chatType: ChatType.GroupChat,
    );
    alertMsg.conversationId = groupId;
    alertMsg.serverTime = DateTime.now().millisecondsSinceEpoch;
    alertMsg.localTime = alertMsg.serverTime;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static void insertAddContactMessage(String userId) {
    Message alertMsg = Message.createCustomSendMessage(
      targetId: userId,
      event: alertContactAddKey,
      chatType: ChatType.Chat,
      params: {
        alertOperatorIdKey: userId,
      },
    );

    alertMsg.serverTime = DateTime.now().millisecondsSinceEpoch;
    alertMsg.localTime = alertMsg.serverTime;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static void insertGroupKickedMessage(String groupId) {
    if (ChatUIKit.instance.options?.deleteMessagesAsExitGroup == true) {
      return;
    }
    Message alertMsg = Message.createCustomSendMessage(
      targetId: groupId,
      event: alertGroupKickedKey,
      chatType: ChatType.GroupChat,
    );
    alertMsg.conversationId = groupId;
    alertMsg.serverTime = DateTime.now().millisecondsSinceEpoch;
    alertMsg.localTime = alertMsg.serverTime;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static insertCreateGroupMessage({
    required Group group,
    ChatUIKitProfile? creator,
    int? timestamp,
  }) async {
    int time = timestamp ?? DateTime.now().millisecondsSinceEpoch - 1;
    Message timeMsg = Message.createCustomSendMessage(
      targetId: group.groupId,
      event: alertTimeKey,
      chatType: ChatType.GroupChat,
    );
    timeMsg.serverTime = time;
    timeMsg.localTime = time;
    timeMsg.status = MessageStatus.SUCCESS;

    await ChatUIKit.instance.insertMessage(
      message: timeMsg,
      runMessageReceived: true,
    );

    Message alertMsg = Message.createCustomSendMessage(
      targetId: group.groupId,
      event: alertGroupCreateKey,
      chatType: ChatType.GroupChat,
      params: {
        alertOperatorIdKey: group.owner ?? creator?.id ?? '',
        alertOperatorNameKey:
            creator?.showName ?? creator?.id ?? group.owner ?? '',
        alertTargetIdKey: group.groupId,
        alertTargetNameKey: group.name ?? '',
      },
    );

    alertMsg.conversationId = group.groupId;
    alertMsg.serverTime = time + 1;
    alertMsg.localTime = time + 1;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: false,
      needUpdateConversationList: true,
    );
  }

  static insertCreateThreadEventMessage({
    required ChatThreadEvent event,
    ChatUIKitProfile? creator,
    int? timestamp,
  }) {
    ChatThread thread = event.chatThread!;

    int time = timestamp ?? DateTime.now().millisecondsSinceEpoch - 1;
    Message timeMsg = Message.createCustomSendMessage(
      targetId: thread.parentId,
      event: alertTimeKey,
      chatType: ChatType.GroupChat,
    );
    timeMsg.serverTime = time;
    timeMsg.localTime = time;
    timeMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(
      message: timeMsg,
      runMessageReceived: true,
    );

    Message alertMsg = Message.createCustomSendMessage(
      targetId: thread.parentId,
      event: alertCreateThreadKey,
      chatType: ChatType.GroupChat,
      params: {
        alertOperatorIdKey: event.from,
        alertTargetIdKey: thread.threadId,
        alertTargetNameKey: thread.threadName ?? '',
        alertTargetParentIdKey: thread.messageId,
      },
    );

    alertMsg.conversationId = thread.parentId;
    alertMsg.serverTime = time + 1;
    alertMsg.localTime = time + 1;
    alertMsg.status = MessageStatus.SUCCESS;

    ChatUIKit.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }
}
