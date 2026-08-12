import 'package:agora_chat_uikit/chat_sdk_context/chat_sdk_context.dart';
import 'package:agora_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';

mixin ChatUIKitContactActions on ChatSDKService {
  @override
  Future<void> acceptContactRequest({required String userId}) async {
    await super.acceptContactRequest(userId: userId);
    ChatSDKContext.instance.removeRequest(userId);
  }

  @override
  Future<void> declineContactRequest({required String userId}) async {
    await super.declineContactRequest(userId: userId);
    ChatSDKContext.instance.removeRequest(userId);
  }

  @override
  Future<List<String>> getAllContactIds() async {
    List<String> ret = await super.getAllContactIds();
    ChatSDKContext.instance.removeRequests(ret);
    return ret;
  }

  @override
  Future<List<String>> fetchAllContactIds() async {
    List<String> ret = await super.fetchAllContactIds();
    for (var userId in ret) {
      ChatSDKContext.instance.removeRequest(userId);
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

  int contactRequestCount() {
    return ChatSDKContext.instance.newRequestCount();
  }
}
