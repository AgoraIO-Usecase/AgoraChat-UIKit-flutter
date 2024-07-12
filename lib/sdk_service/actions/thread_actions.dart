import '../chat_sdk_wrapper.dart';

mixin ThreadActions on ThreadWrapper {
  Future<ChatThread?> fetchChatThread({
    required String chatThreadId,
  }) {
    return checkResult(ChatSDKEvent.fetchChatThread, () {
      return Client.getInstance.chatThreadManager
          .fetchChatThread(chatThreadId: chatThreadId);
    });
  }

  Future<CursorResult<ChatThread>> fetchJoinedChatThreads({
    String? cursor,
    int limit = 20,
  }) {
    return checkResult(ChatSDKEvent.fetchJoinedChatThreads, () {
      return Client.getInstance.chatThreadManager
          .fetchJoinedChatThreads(cursor: cursor, limit: limit);
    });
  }

  Future<CursorResult<ChatThread>> fetchChatThreadsWithParentId({
    required String parentId,
    String? cursor,
    int limit = 20,
  }) {
    return checkResult(ChatSDKEvent.fetchChatThreadsWithParentId, () {
      return Client.getInstance.chatThreadManager.fetchChatThreadsWithParentId(
          parentId: parentId, cursor: cursor, limit: limit);
    });
  }

  Future<CursorResult<ChatThread>> fetchJoinedChatThreadsWithParentId({
    required String parentId,
    String? cursor,
    int limit = 20,
  }) {
    return checkResult(ChatSDKEvent.fetchJoinedChatThreadsWithParentId, () {
      return Client.getInstance.chatThreadManager
          .fetchJoinedChatThreadsWithParentId(
              parentId: parentId, cursor: cursor, limit: limit);
    });
  }

  Future<CursorResult<String>> fetchChatThreadMembers({
    required String chatThreadId,
    String? cursor,
    int limit = 20,
  }) {
    return checkResult(ChatSDKEvent.fetchChatThreadMembers, () {
      return Client.getInstance.chatThreadManager.fetchChatThreadMembers(
          chatThreadId: chatThreadId, cursor: cursor, limit: limit);
    });
  }

  Future<Map<String, Message>> fetchLatestMessageWithChatThreads({
    required List<String> chatThreadIds,
  }) {
    return checkResult(ChatSDKEvent.fetchLatestMessageWithChatThreads, () {
      return Client.getInstance.chatThreadManager
          .fetchLatestMessageWithChatThreads(chatThreadIds: chatThreadIds);
    });
  }

  Future<void> removeMemberFromChatThread({
    required String memberId,
    required String chatThreadId,
  }) {
    return checkResult(ChatSDKEvent.removeMemberFromChatThread, () {
      return Client.getInstance.chatThreadManager.removeMemberFromChatThread(
          memberId: memberId, chatThreadId: chatThreadId);
    });
  }

  Future<void> updateChatThreadName({
    required String chatThreadId,
    required String newName,
  }) {
    return checkResult(ChatSDKEvent.updateChatThreadName, () {
      return Client.getInstance.chatThreadManager
          .updateChatThreadName(chatThreadId: chatThreadId, newName: newName);
    });
  }

  Future<ChatThread> createChatThread({
    required String threadName,
    required String messageId,
    required String parentId,
  }) {
    return checkResult(ChatSDKEvent.createChatThread, () {
      return Client.getInstance.chatThreadManager.createChatThread(
          name: threadName, messageId: messageId, parentId: parentId);
    });
  }

  Future<ChatThread> joinChatThread({
    required String chatThreadId,
  }) {
    return checkResult(ChatSDKEvent.joinChatThread, () {
      return Client.getInstance.chatThreadManager
          .joinChatThread(chatThreadId: chatThreadId);
    });
  }

  Future<void> leaveChatThread({
    required String chatThreadId,
  }) {
    return checkResult(ChatSDKEvent.leaveChatThread, () {
      return Client.getInstance.chatThreadManager
          .leaveChatThread(chatThreadId: chatThreadId);
    });
  }

  Future<void> destroyChatThread({
    required String chatThreadId,
  }) {
    return checkResult(ChatSDKEvent.destroyChatThread, () {
      return Client.getInstance.chatThreadManager
          .destroyChatThread(chatThreadId: chatThreadId);
    });
  }
}
