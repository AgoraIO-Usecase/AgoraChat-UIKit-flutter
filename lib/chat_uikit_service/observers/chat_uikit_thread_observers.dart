import '../../chat_uikit.dart';

mixin ChatUIKitThreadObservers on ChatSDKService {
  @override
  void onChatThreadCreate(ChatThreadEvent event) {
    ChatUIKitInsertTools.insertCreateThreadEventMessage(event: event);
    super.onChatThreadCreate(event);
  }
}
