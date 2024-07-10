import '../../chat_uikit.dart';

mixin ChatUIKitNotificationActions on ChatSDKWrapper {
  @override
  Future<void> setSilentMode(
      {required String conversationId,
      required ConversationType type,
      required ChatSilentModeParam param}) async {
    await super.setSilentMode(
      conversationId: conversationId,
      type: type,
      param: param,
    );
    ChatUIKitContext.instance.addConversationMute({
      conversationId:
          param.remindType == ChatPushRemindType.MENTION_ONLY ? 1 : 0
    });
    onConversationsUpdate();
  }

  @override
  Future<Map<String, ChatSilentModeResult>> fetchSilentModel({
    required List<Conversation> conversations,
  }) async {
    Map<String, ChatSilentModeResult> map =
        await super.fetchSilentModel(conversations: conversations);

    List<ChatSilentModeResult> list = map.values
        .where(
            (element) => element.remindType != ChatPushRemindType.MENTION_ONLY)
        .toList();

    List<String> needClearIds = list.map((e) => e.conversationId).toList();
    ChatUIKitContext.instance.deleteConversationMute(needClearIds);

    list = map.values
        .where(
            (element) => element.remindType == ChatPushRemindType.MENTION_ONLY)
        .toList();

    List<String> needAddIds = list.map((e) => e.conversationId).toList();
    Map<String, int> addMap = {for (var index in needAddIds) index: 1};

    ChatUIKitContext.instance.addConversationMute(addMap);
    return map;
  }

  @override
  Future<void> clearSilentMode({
    required String conversationId,
    required ConversationType type,
  }) async {
    await super.clearSilentMode(
      conversationId: conversationId,
      type: type,
    );
    ChatUIKitContext.instance.deleteConversationMute([conversationId]);
    onConversationsUpdate();
  }

  @override
  Future<void> setAllSilentMode({required ChatSilentModeParam param}) async {
    await super.setAllSilentMode(param: param);
    onConversationsUpdate();
  }
}
