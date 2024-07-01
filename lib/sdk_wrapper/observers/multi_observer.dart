import '../chat_sdk_wrapper.dart';

abstract mixin class MultiObserver implements ChatUIKitObserverBase {
  void onContactEvent(
    MultiDevicesEvent event,
    String userId,
    String? ext,
  ) {}

  void onGroupEvent(
    MultiDevicesEvent event,
    String groupId,
    List<String>? userIds,
  ) {}

  void onChatThreadEvent(
    MultiDevicesEvent event,
    String chatThreadId,
    List<String> userIds,
  ) {}

  void onRemoteMessagesRemoved(
    String conversationId,
    String deviceId,
  ) {}

  void onConversationEvent(
    MultiDevicesEvent event,
    String conversationId,
    ConversationType type,
  ) {}
}
