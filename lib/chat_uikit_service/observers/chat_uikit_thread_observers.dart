import '../../chat_uikit.dart';

mixin ChatUIKitThreadObservers on ChatSDKWrapper {
  @override
  void onChatThreadCreate(ChatThreadEvent event) {
    ChatUIKitInsertTools.insertCreateThreadEventMessage(event: event);
    super.onChatThreadCreate(event);
  }
}
