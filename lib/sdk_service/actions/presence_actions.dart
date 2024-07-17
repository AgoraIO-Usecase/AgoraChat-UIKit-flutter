import '../chat_sdk_service.dart';

mixin PresenceActions on PresenceWrapper {
  Future<void> publishPresence(
    String description,
  ) {
    return checkResult(ChatSDKEvent.getGroupId, () {
      return Client.getInstance.presenceManager.publishPresence(description);
    });
  }

  Future<List<Presence>> subscribe({
    required List<String> members,
    required int expiry,
  }) {
    return checkResult(ChatSDKEvent.subscribe, () {
      return Client.getInstance.presenceManager.subscribe(
        members: members,
        expiry: expiry,
      );
    });
  }

  Future<void> unsubscribe({
    required List<String> members,
  }) {
    return checkResult(ChatSDKEvent.unsubscribe, () {
      return Client.getInstance.presenceManager.unsubscribe(members: members);
    });
  }

  Future<List<String>> fetchSubscribedMembers({
    int pageNum = 1,
    int pageSize = 20,
  }) {
    return checkResult(ChatSDKEvent.fetchSubscribedMembers, () {
      return Client.getInstance.presenceManager.fetchSubscribedMembers(
        pageNum: pageNum,
        pageSize: pageSize,
      );
    });
  }

  Future<List<Presence>> fetchPresenceStatus({
    required List<String> members,
  }) {
    return checkResult(ChatSDKEvent.fetchPresenceStatus, () {
      return Client.getInstance.presenceManager.fetchPresenceStatus(
        members: members,
      );
    });
  }
}
