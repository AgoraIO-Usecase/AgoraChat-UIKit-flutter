import '../../chat_uikit.dart';

mixin ChatUIKitContactActions on ChatSDKWrapper {
  @override
  Future<void> acceptContactRequest({required String userId}) async {
    await super.acceptContactRequest(userId: userId);
    ChatUIKitContext.instance.removeRequest(userId);
  }

  @override
  Future<void> declineContactRequest({required String userId}) async {
    await super.declineContactRequest(userId: userId);
    ChatUIKitContext.instance.removeRequest(userId);
  }

  @override
  Future<List<String>> getAllContactIds() async {
    List<String> ret = await super.getAllContactIds();
    ChatUIKitContext.instance.removeRequests(ret);
    return ret;
  }

  @override
  Future<List<String>> fetchAllContactIds() async {
    List<String> ret = await super.fetchAllContactIds();
    for (var userId in ret) {
      ChatUIKitContext.instance.removeRequest(userId);
    }
    return ret;
  }

  @override
  Future<void> addBlockedContact({required String userId}) async {
    await super.addBlockedContact(userId: userId);
    ChatUIKit.instance.onBlockedContactAdded(userId);
  }

  @override
  Future<void> deleteBlockedContact({required String userId}) async {
    await super.deleteBlockedContact(userId: userId);
    ChatUIKit.instance.onBlockedContactDeleted(userId);
  }
}
