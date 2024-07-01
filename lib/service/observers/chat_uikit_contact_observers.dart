import '../../chat_uikit.dart';

mixin ChatUIKitContactObservers on ChatSDKWrapper {
  @override
  void onContactRequestReceived(String userId, String? reason) {
    // 回调好友通知之前需要先存储好友请求数据
    if (ChatUIKitContext.instance.addRequest(userId, reason)) {
      super.onContactRequestReceived(userId, reason);
    }
  }

  @override
  void onContactAdded(String userId) {
    ChatUIKitContext.instance.removeRequest(userId);
    super.onContactAdded(userId);
  }
}
