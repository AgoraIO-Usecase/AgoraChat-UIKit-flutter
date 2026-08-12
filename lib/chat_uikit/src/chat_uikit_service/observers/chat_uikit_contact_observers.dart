import 'package:agora_chat_uikit/chat_sdk_context/chat_sdk_context.dart';
import 'package:agora_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';

mixin ChatUIKitContactObservers on ChatSDKService {
  @override
  void onContactRequestReceived(String userId, String? reason) {
    // 回调好友通知之前需要先存储好友请求数据
    if (ChatSDKContext.instance.addRequest(userId, reason)) {
      super.onContactRequestReceived(userId, reason);
    }
  }

  @override
  void onContactAdded(String userId) async {
    await ChatUIKitInsertTools.insertAddContactMessage(userId);
    ChatSDKContext.instance.removeRequest(userId);
    super.onContactAdded(userId);
  }
}
