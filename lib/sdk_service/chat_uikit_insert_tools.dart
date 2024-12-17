import '../chat_uikit.dart';

class ChatUIKitInsertTools {
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

    ChatSDKService.instance.insertMessage(message: alertMsg);
    return alertMsg;
  }

  static Future<void> insertGroupDestroyMessage(String groupId) async {
    if (Client.getInstance.options?.deleteMessagesAsExitGroup == true) {
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

    await ChatSDKService.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static Future<void> insertGroupLeaveMessage(String groupId) async {
    if (Client.getInstance.options?.deleteMessagesAsExitGroup == true) {
      return;
    }

    String userId = ChatSDKService.instance.currentUserId!;
    Message alertMsg = Message.createCustomSendMessage(
      targetId: groupId,
      event: alertGroupLeaveKey,
      chatType: ChatType.GroupChat,
      params: {
        alertOperatorIdKey: userId,
      },
    );
    alertMsg.conversationId = groupId;
    alertMsg.serverTime = DateTime.now().millisecondsSinceEpoch;
    alertMsg.localTime = alertMsg.serverTime;
    alertMsg.status = MessageStatus.SUCCESS;

    await ChatSDKService.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static Future<void> insertAddContactMessage(String userId) async {
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

    await ChatSDKService.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static Future<void> insertGroupKickedMessage(String groupId) async {
    if (Client.getInstance.options?.deleteMessagesAsExitGroup == true) {
      return;
    }
    String userId = ChatSDKService.instance.currentUserId!;
    Message alertMsg = Message.createCustomSendMessage(
      targetId: groupId,
      event: alertGroupKickedKey,
      chatType: ChatType.GroupChat,
      params: {
        alertOperatorIdKey: userId,
      },
    );
    alertMsg.conversationId = groupId;
    alertMsg.serverTime = DateTime.now().millisecondsSinceEpoch;
    alertMsg.localTime = alertMsg.serverTime;
    alertMsg.status = MessageStatus.SUCCESS;

    await ChatSDKService.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static Future<void> insertCreateGroupMessage({
    required Group group,
    String? creator,
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

    await ChatSDKService.instance.insertMessage(
      message: timeMsg,
    );

    Message alertMsg = Message.createCustomSendMessage(
      targetId: group.groupId,
      event: alertGroupCreateKey,
      chatType: ChatType.GroupChat,
      params: {
        alertOperatorIdKey: group.owner ?? creator ?? '',
        alertOperatorNameKey: creator ?? group.owner ?? '',
        alertTargetIdKey: group.groupId,
        alertTargetNameKey: group.name ?? '',
      },
    );

    alertMsg.conversationId = group.groupId;
    alertMsg.serverTime = time + 1;
    alertMsg.localTime = time + 1;
    alertMsg.status = MessageStatus.SUCCESS;

    await ChatSDKService.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: false,
      needUpdateConversationList: true,
    );
  }

  static Future<void> insertCreateThreadEventMessage({
    required ChatThreadEvent event,
    String? creator,
    int? timestamp,
  }) async {
    ChatThread thread = event.chatThread!;

    int time = timestamp ??
        event.chatThread?.createAt ??
        DateTime.now().millisecondsSinceEpoch - 1;
    Message timeMsg = Message.createCustomSendMessage(
      targetId: thread.parentId,
      event: alertTimeKey,
      chatType: ChatType.GroupChat,
    );
    timeMsg.serverTime = time;
    timeMsg.localTime = time;

    timeMsg.status = MessageStatus.SUCCESS;

    await ChatSDKService.instance.insertMessage(
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

    await ChatSDKService.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static Future<void> insertPinEventMessage({
    required String messageId,
    String? conversationId,
    String? creator,
    int? timestamp,
  }) async {
    String? localConversationId = conversationId;
    String? localCreator = creator;

    if (localConversationId == null || localCreator == null) {
      Message? pinedMsg = await ChatSDKService.instance.loadMessage(
        messageId: messageId,
      );

      if (pinedMsg == null) {
        return;
      }

      localConversationId = pinedMsg.conversationId!;
      localCreator = ChatSDKService.instance.currentUserId!;
    }

    Message alertMsg = Message.createCustomSendMessage(
      targetId: localConversationId,
      event: alertPinMessageKey,
      chatType: ChatType.GroupChat,
      params: {
        alertOperatorIdKey: localCreator,
      },
    );
    int time = timestamp ?? DateTime.now().millisecondsSinceEpoch - 1;
    alertMsg.conversationId = localConversationId;
    alertMsg.serverTime = time + 1;
    alertMsg.localTime = time + 1;
    alertMsg.status = MessageStatus.SUCCESS;

    await ChatSDKService.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }

  static Future<void> insertUnPinEventMessage({
    required String messageId,
    String? conversationId,
    String? creator,
    int? timestamp,
  }) async {
    String? localConversationId = conversationId;
    String? localCreator = creator;

    if (localConversationId == null || localCreator == null) {
      Message? pinedMsg = await ChatSDKService.instance.loadMessage(
        messageId: messageId,
      );

      if (pinedMsg == null) {
        return;
      }

      localConversationId = pinedMsg.conversationId!;
      localCreator = ChatSDKService.instance.currentUserId!;
    }

    Message alertMsg = Message.createCustomSendMessage(
      targetId: localConversationId,
      event: alertUnPinMessageKey,
      chatType: ChatType.GroupChat,
      params: {
        alertOperatorIdKey: localCreator,
      },
    );
    int time = timestamp ?? DateTime.now().millisecondsSinceEpoch - 1;
    alertMsg.conversationId = localConversationId;
    alertMsg.serverTime = time + 1;
    alertMsg.localTime = time + 1;
    alertMsg.status = MessageStatus.SUCCESS;

    await ChatSDKService.instance.insertMessage(
      message: alertMsg,
      runMessageReceived: true,
      needUpdateConversationList: true,
    );
  }
}

const String userGroupName = 'chatUIKit_group_member_nick_name';
const String msgUserInfoKey = "ease_chat_uikit_user_info";
const String msgPreviewKey = "ease_chat_uikit_text_url_preview";
const String userAvatarKey = "avatarURL";
const String userNicknameKey = "nickname";
const String cardMessageKey = "userCard";
const String cardNicknameKey = "nickname";
const String cardUserIdKey = "uid";
const String cardAvatarKey = "avatar";

const String quoteKey = 'msgQuote';
const String quoteMsgIdKey = 'msgID';
const String quoteMsgTypeKey = 'msgType';
const String quoteMsgPreviewKey = 'msgPreview';
const String quoteMsgSenderKey = 'msgSender';

const String alertTimeKey = 'timeMessageKey';

const String alertRecalledKey = 'alertRecalledKey';
const String alertCreateThreadKey = 'createThreadKey';
const String alertUpdateThreadKey = 'updateThreadKey';
const String alertDeleteThreadKey = 'deleteThreadKey';
// 操作人id
const String alertOperatorIdKey = 'alertOperatorIdKey';
// 操作人名称
const String alertOperatorNameKey = 'alertOperatorNameKey';
// 被操作id
const String alertTargetIdKey = 'alertTargetIdKey';
// 被操作名称
const String alertTargetNameKey = 'alertTargetNameKey';
// 被操作所属，主要用于thread的所属msgId
const String alertTargetParentIdKey = 'alertTargetParentIdKey';

const String alertGroupCreateKey = 'createGroupKey';
const String alertGroupDestroyKey = 'alertGroupDestroyKey';
const String alertGroupLeaveKey = 'alertGroupLeaveKey';
const String alertGroupKickedKey = 'alertGroupKickedKey';
const String alertContactAddKey = 'alertContactAddKey';
const String alertPinMessageKey = 'alertPinMessageKey';
const String alertUnPinMessageKey = 'alertUnPinMessageKey';

const String mentionKey = 'em_at_list';
const String mentionAllValue = 'ALL';
const String hasMentionKey = 'mention';
const String hasMentionValue = 'mention';

const String voiceHasReadKey = 'voiceHasRead';
const String hasTranslatedKey = 'hasTranslatedKey';
