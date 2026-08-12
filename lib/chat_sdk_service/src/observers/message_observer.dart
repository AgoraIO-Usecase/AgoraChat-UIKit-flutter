import '../../chat_sdk_service.dart';

abstract mixin class MessageObserver implements ChatUIKitObserverBase {
  void onMessageSendSuccess(String msgId, Message msg) {}
  void onMessageSendError(String msgId, Message msg, ChatError error) {}
  void onMessageSendProgress(String msgId, int progress) {}
  void onMessageWillSend(Message msg) {}
}
