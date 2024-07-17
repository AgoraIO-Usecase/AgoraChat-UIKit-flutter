import '../chat_sdk_service.dart';

abstract mixin class ChatSDKEventsObserver implements ChatUIKitObserverBase {
  void onChatSDKEventBegin(ChatSDKEvent event) {}

  void onChatSDKEventEnd(ChatSDKEvent event, ChatError? error) {}
}
