import '../chat_sdk_service.dart';

abstract mixin class MessageObserver implements ChatUIKitObserverBase {
  void onSuccess(String msgId, Message msg) {}
  void onError(String msgId, Message msg, ChatError error) {}
  void onProgress(String msgId, int progress) {}
}
