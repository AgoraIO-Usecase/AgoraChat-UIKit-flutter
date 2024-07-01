import '../chat_sdk_wrapper.dart';

mixin ChatActions on ChatWrapper {
  Future<Message> sendMessage({required Message message}) {
    return checkResult(ChatSDKEvent.sendMessage, () async {
      return Client.getInstance.chatManager.sendMessage(message);
    });
  }

  /// 只支持单聊
  Future<void> sendTyping({
    required String userId,
  }) {
    return checkResult(ChatSDKEvent.sendTypingMessage, () async {
      Message msg = Message.createCmdSendMessage(
        targetId: userId,
        action: 'TypingBegin',
        deliverOnlineOnly: true,
      );
      await Client.getInstance.chatManager.sendMessage(msg);
    });
  }

  Future<Message> resendMessage({required Message message}) {
    return checkResult(ChatSDKEvent.sendMessage, () {
      return Client.getInstance.chatManager.resendMessage(message);
    });
  }

  Future<bool> sendMessageReadAck({required Message message}) {
    return checkResult(ChatSDKEvent.sendMessageReadAck, () {
      return Client.getInstance.chatManager.sendMessageReadAck(message);
    });
  }

  Future<void> sendGroupMessageReadAck({
    required String msgId,
    required String groupId,
    String? content,
  }) {
    return checkResult(ChatSDKEvent.sendGroupMessageReadAck, () {
      return Client.getInstance.chatManager.sendGroupMessageReadAck(
        msgId,
        groupId,
        content: content,
      );
    });
  }

  Future<void> sendConversationReadAck({required String conversationId}) {
    return checkResult(ChatSDKEvent.sendConversationReadAck, () async {
      return await Client.getInstance.chatManager.sendConversationReadAck(
        conversationId,
      );
    });
  }

  Future<void> recallMessage({required Message message}) {
    return checkResult(ChatSDKEvent.recallMessage, () async {
      await Client.getInstance.chatManager.recallMessage(message.msgId);
      onMessagesRecalled([message]);
    });
  }

  Future<Message?> loadMessage({required String messageId}) {
    return checkResult(ChatSDKEvent.loadMessage, () {
      return Client.getInstance.chatManager.loadMessage(messageId);
    });
  }

  Future<Conversation> createConversation({
    required String conversationId,
    ConversationType type = ConversationType.Chat,
  }) {
    return checkResult(ChatSDKEvent.createConversation, () async {
      Conversation? conv = await Client.getInstance.chatManager
          .getConversation(conversationId, type: type, createIfNeed: true);
      return conv!;
    });
  }

  Future<Conversation?> getConversation({
    required String conversationId,
    ConversationType type = ConversationType.Chat,
  }) {
    return checkResult(ChatSDKEvent.getConversation, () {
      return Client.getInstance.chatManager
          .getConversation(conversationId, type: type, createIfNeed: false);
    });
  }

  Future<Conversation?> getThreadConversation({
    required String conversationId,
  }) {
    return checkResult(ChatSDKEvent.getThreadConversation, () {
      return Client.getInstance.chatManager.getThreadConversation(
        conversationId,
      );
    });
  }

  Future<void> markAllConversationsAsRead() async {
    return checkResult(ChatSDKEvent.markAllConversationsAsRead, () async {
      Future<void> ret =
          Client.getInstance.chatManager.markAllConversationsAsRead();
      super.onConversationsUpdate();
      return ret;
    });
  }

  Future<void> markConversationAsRead({
    required String conversationId,
  }) {
    return checkResult(ChatSDKEvent.markConversationAsRead, () async {
      Conversation? conv = await Client.getInstance.chatManager.getConversation(
        conversationId,
      );
      Future<void>? ret = conv?.markAllMessagesAsRead();
      super.onConversationsUpdate();
      return ret;
    });
  }

  Future<int> getUnreadMessageCount() async {
    return checkResult(ChatSDKEvent.getUnreadMessageCount, () {
      return Client.getInstance.chatManager.getUnreadMessageCount();
    });
  }

  Future<int> getAppointUnreadCount({required List<String> appointIds}) {
    return checkResult(ChatSDKEvent.getAppointUnreadCount, () async {
      int unreadCount = 0;
      List<Conversation>? list =
          await Client.getInstance.chatManager.loadAllConversations();
      for (var conversation in list) {
        if (appointIds.contains(conversation.id)) {
          unreadCount += await conversation.unreadCount();
        }
      }
      return unreadCount;
    });
  }

  Future<int> appointNewMessageConversationCount({
    required List<String> appointIds,
  }) {
    return checkResult(ChatSDKEvent.haveNewMessageConversationCount, () async {
      int unreadConversationCount = 0;
      List<Conversation>? list =
          await Client.getInstance.chatManager.loadAllConversations();

      for (var conversation in list) {
        if (appointIds.contains(conversation.id)) {
          if (await conversation.unreadCount() > 0) {
            unreadConversationCount += 1;
          }
        }
      }

      return unreadConversationCount;
    });
  }

  Future<void> updateMessage({required Message message}) {
    return checkResult(ChatSDKEvent.updateMessage, () {
      return Client.getInstance.chatManager.updateMessage(message);
    });
  }

  Future<void> importMessages({required List<Message> messages}) {
    return checkResult(ChatSDKEvent.importMessages, () {
      return Client.getInstance.chatManager.importMessages(messages);
    });
  }

  Future<void> insertMessage({required Message message}) {
    return checkResult(ChatSDKEvent.importMessages, () async {
      Conversation? conversation =
          await Client.getInstance.chatManager.getConversation(
        message.conversationId ?? message.from!,
        type: ConversationType.values[message.chatType.index],
        createIfNeed: true,
      );
      await conversation!.insertMessage(message);
    });
  }

  Future<void> downloadAttachment({required Message message}) {
    return checkResult(ChatSDKEvent.downloadAttachment, () {
      return Client.getInstance.chatManager.downloadAttachment(message);
    });
  }

  Future<void> downloadThumbnail({required Message message}) {
    return checkResult(ChatSDKEvent.downloadThumbnail, () {
      return Client.getInstance.chatManager.downloadThumbnail(message);
    });
  }

  Future<void> downloadMessageAttachmentInCombine({required Message message}) {
    return checkResult(ChatSDKEvent.downloadMessageAttachmentInCombine, () {
      return Client.getInstance.chatManager
          .downloadMessageAttachmentInCombine(message);
    });
  }

  Future<void> downloadMessageThumbnailInCombine({required Message message}) {
    return checkResult(ChatSDKEvent.downloadMessageThumbnailInCombine, () {
      return Client.getInstance.chatManager
          .downloadMessageThumbnailInCombine(message);
    });
  }

  Future<List<Conversation>> getAllConversations() async {
    return checkResult(ChatSDKEvent.loadAllConversations, () {
      return Client.getInstance.chatManager.loadAllConversations();
    });
  }

  Future<CursorResult<Conversation>> fetchConversations({
    String? cursor,
    int pageSize = 20,
  }) {
    return checkResult(ChatSDKEvent.fetchConversations, () {
      // ignore: deprecated_member_use
      return Client.getInstance.chatManager.fetchConversation(
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<void> deleteRemoteMessagesWithIds({
    required String conversationId,
    required ConversationType type,
    required List<String> msgIds,
  }) {
    return checkResult(ChatSDKEvent.deleteRemoteMessagesWithIds, () {
      return Client.getInstance.chatManager.deleteRemoteMessagesWithIds(
        conversationId: conversationId,
        type: type,
        msgIds: msgIds,
      );
    });
  }

  Future<void> deleteRemoteMessagesBefore({
    required String conversationId,
    required ConversationType type,
    required int timestamp,
  }) {
    return checkResult(ChatSDKEvent.deleteRemoteMessagesBefore, () {
      return Client.getInstance.chatManager.deleteRemoteMessagesBefore(
        conversationId: conversationId,
        type: type,
        timestamp: timestamp,
      );
    });
  }

  Future<void> deleteLocalConversation({
    required String conversationId,
    bool deleteMessages = true,
  }) {
    return checkResult(ChatSDKEvent.deleteLocalConversation, () {
      return Client.getInstance.chatManager.deleteConversation(
        conversationId,
        deleteMessages: deleteMessages,
      );
    });
  }

  Future<CursorResult<Message>> fetchHistoryMessages({
    required String conversationId,
    ConversationType type = ConversationType.Chat,
    int pageSize = 20,
    SearchDirection direction = SearchDirection.Up,
    String startMsgId = '',
  }) {
    return checkResult(ChatSDKEvent.fetchHistoryMessages, () {
      // ignore: deprecated_member_use
      return Client.getInstance.chatManager.fetchHistoryMessages(
        conversationId: conversationId,
        type: type,
        startMsgId: startMsgId,
        pageSize: pageSize,
        direction: direction,
      );
    });
  }

  Future<CursorResult<Message>> fetchHistoryMessagesByOptions({
    required String conversationId,
    required ConversationType type,
    FetchMessageOptions? options,
    String? cursor,
    int pageSize = 50,
  }) {
    return checkResult(ChatSDKEvent.fetchHistoryMessagesByOptions, () {
      return Client.getInstance.chatManager.fetchHistoryMessagesByOption(
        conversationId,
        type,
        options: options,
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<List<Message>> searchConversationLocalMessage({
    required String keywords,
    required String conversationId,
    ConversationType type = ConversationType.Chat,
    int timestamp = -1,
    int maxCount = 20,
    String? sender,
    SearchDirection direction = SearchDirection.Up,
  }) {
    return checkResult(ChatSDKEvent.searchConversationLocalMessage, () async {
      final conversation = await createConversation(
        conversationId: conversationId,
        type: type,
      );
      return await conversation.loadMessagesWithKeyword(
        keywords,
        count: maxCount,
        timestamp: timestamp,
        sender: sender,
        searchScope: MessageSearchScope.Content,
        direction: direction,
      );
    });
  }

  Future<List<Message>> searchLocalMessage({
    required String keywords,
    int timestamp = -1,
    int maxCount = 20,
    String? from,
    SearchDirection direction = SearchDirection.Up,
  }) {
    return checkResult(ChatSDKEvent.searchLocalMessage, () {
      // ignore: deprecated_member_use
      return Client.getInstance.chatManager.searchMsgFromDB(
        keywords,
        timestamp: timestamp,
        maxCount: maxCount,
        from: from ?? '',
        direction: direction,
      );
    });
  }

  Future<CursorResult<GroupMessageAck>> fetchGroupAckList({
    required String msgId,
    required String groupId,
    String? startAckId,
    int pageSize = 20,
  }) {
    return checkResult(ChatSDKEvent.fetchGroupAckList, () {
      return Client.getInstance.chatManager.fetchGroupAcks(
        msgId,
        groupId,
        startAckId: startAckId,
        pageSize: pageSize,
      );
    });
  }

  Future<void> deleteRemoteConversation({
    required String conversationId,
    required ConversationType type,
    bool isDeleteMessage = true,
  }) {
    return checkResult(ChatSDKEvent.deleteRemoteConversation, () {
      return Client.getInstance.chatManager.deleteRemoteConversation(
        conversationId,
        conversationType: type,
        isDeleteMessage: isDeleteMessage,
      );
    });
  }

  Future<void> deleteLocalMessages({required int beforeTime}) {
    return checkResult(ChatSDKEvent.deleteLocalMessages, () {
      return Client.getInstance.chatManager.deleteMessagesBefore(
        beforeTime,
      );
    });
  }

  Future<void> reportMessage({
    required String messageId,
    required String tag,
    required String reason,
  }) {
    return checkResult(ChatSDKEvent.reportMessage, () {
      return Client.getInstance.chatManager.reportMessage(
        messageId: messageId,
        tag: tag,
        reason: reason,
      );
    });
  }

  Future<void> addReaction({
    required String messageId,
    required String reaction,
  }) {
    return checkResult(ChatSDKEvent.addReaction, () async {
      return Client.getInstance.chatManager.addReaction(
        messageId: messageId,
        reaction: reaction,
      );
    });
  }

  Future<void> deleteReaction({
    required String messageId,
    required String reaction,
  }) {
    return checkResult(ChatSDKEvent.deleteReaction, () {
      return Client.getInstance.chatManager.removeReaction(
        messageId: messageId,
        reaction: reaction,
      );
    });
  }

  Future<Map<String, List<MessageReaction>>> fetchReactionList({
    required List<String> messageIds,
    required ChatType type,
    String? groupId,
  }) {
    return checkResult(ChatSDKEvent.fetchReactionList, () {
      return Client.getInstance.chatManager.fetchReactionList(
        messageIds: messageIds,
        chatType: type,
        groupId: groupId,
      );
    });
  }

  Future<CursorResult<MessageReaction>> fetchReactionDetail({
    required String messageId,
    required String reaction,
    String? cursor,
    int pageSize = 20,
  }) {
    return checkResult(ChatSDKEvent.fetchReactionDetail, () {
      return Client.getInstance.chatManager.fetchReactionDetail(
        messageId: messageId,
        reaction: reaction,
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<Message> translateMessage({
    required Message msg,
    required List<String> languages,
  }) {
    return checkResult(ChatSDKEvent.translateMessage, () {
      return Client.getInstance.chatManager.translateMessage(
        msg: msg,
        languages: languages,
      );
    });
  }

  Future<List<TranslateLanguage>> fetchSupportedLanguages() {
    return checkResult(ChatSDKEvent.fetchSupportedLanguages, () {
      return Client.getInstance.chatManager.fetchSupportedLanguages();
    });
  }

  Future<CursorResult<Conversation>> fetchPinnedConversations({
    String? cursor,
    int pageSize = 20,
  }) {
    return checkResult(ChatSDKEvent.fetchPinnedConversations, () {
      // ignore: deprecated_member_use
      return Client.getInstance.chatManager.fetchPinnedConversations(
        cursor: cursor,
        pageSize: pageSize,
      );
    });
  }

  Future<void> pinConversation({
    required String conversationId,
    required bool isPinned,
  }) {
    return checkResult(ChatSDKEvent.pinConversation, () async {
      await Client.getInstance.chatManager.pinConversation(
        conversationId: conversationId,
        isPinned: isPinned,
      );
      super.onConversationsUpdate();
    });
  }

  Future<Message> modifyMessage({
    required String messageId,
    required TextMessageBody msgBody,
  }) {
    return checkResult(ChatSDKEvent.modifyMessage, () {
      return Client.getInstance.chatManager.modifyMessage(
        messageId: messageId,
        msgBody: msgBody,
      );
    });
  }

  Future<List<Message>> fetchCombineMessageDetail({
    required Message message,
  }) {
    return checkResult(ChatSDKEvent.fetchCombineMessageDetail, () {
      return Client.getInstance.chatManager.fetchCombineMessageDetail(
        message: message,
      );
    });
  }

  Future<List<Message>> loadLocalMessages({
    required String conversationId,
    required ConversationType type,
    SearchDirection direction = SearchDirection.Up,
    String? startId,
    int count = 30,
  }) {
    return checkResult(ChatSDKEvent.getMessages, () async {
      final conversation = await createConversation(
        conversationId: conversationId,
        type: type,
      );
      return conversation.loadMessages(
        startMsgId: startId ?? '',
        loadCount: count,
        direction: direction,
      );
    });
  }

  Future<List<Message>> loadLocalMessagesByTimestamp({
    required String conversationId,
    required ConversationType type,
    required int startTime,
    required int endTime,
    int count = 30,
  }) {
    return checkResult(ChatSDKEvent.getMessages, () async {
      final conversation = await createConversation(
        conversationId: conversationId,
        type: type,
      );
      return conversation.loadMessagesFromTime(
        startTime: startTime,
        endTime: endTime,
        count: count,
      );
    });
  }

  Future<void> deleteLocalMessageById({
    required String conversationId,
    required ConversationType type,
    required String messageId,
  }) {
    return checkResult(ChatSDKEvent.deleteLocalMessageById, () async {
      final conversation = await getConversation(
        conversationId: conversationId,
        type: type,
      );
      return await conversation!.deleteMessage(messageId);
    });
  }

  Future<void> deleteLocalThreadMessageById({
    required String threadId,
    required String messageId,
  }) {
    return checkResult(ChatSDKEvent.deleteLocalThreadMessageById, () async {
      final conversation = await getThreadConversation(
        conversationId: threadId,
      );
      return await conversation!.deleteMessage(messageId);
    });
  }

  Future<void> deleteLocalMessageByIds({
    required String conversationId,
    required ConversationType type,
    required List<String> messageIds,
  }) {
    return checkResult(ChatSDKEvent.deleteLocalMessageByIds, () async {
      final conversation = await getConversation(
        conversationId: conversationId,
        type: type,
      );
      return await conversation!.deleteMessageByIds(messageIds);
    });
  }

  Future<List<Message>> loadPinnedMessages({
    required String conversationId,
    required ConversationType type,
  }) {
    return checkResult(ChatSDKEvent.loadPinnedMessages, () async {
      final conversation = await getConversation(
        conversationId: conversationId,
        type: type,
      );
      return await conversation!.loadPinnedMessages();
    });
  }

  Future<List<Message>> fetchPinnedMessages({
    required String conversationId,
  }) {
    return checkResult(ChatSDKEvent.fetchPinnedMessages, () async {
      return Client.getInstance.chatManager
          .fetchPinnedMessages(conversationId: conversationId);
    });
  }

  Future<void> pinMessage({required String messageId}) {
    return checkResult(ChatSDKEvent.pinMessage, () async {
      return Client.getInstance.chatManager.pinMessage(messageId: messageId);
    });
  }

  Future<void> unpinMessage({required String messageId}) {
    return checkResult(ChatSDKEvent.unpinMessage, () async {
      return Client.getInstance.chatManager.unpinMessage(messageId: messageId);
    });
  }
}
