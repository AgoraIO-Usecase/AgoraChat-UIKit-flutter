import '../chat_sdk_service.dart';

abstract mixin class ChatObserver implements ChatUIKitObserverBase {
  void onMessagesReceived(List<Message> messages) {}
  void onCmdMessagesReceived(List<Message> messages) {}
  void onMessagesRead(List<Message> messages) {}
  void onGroupMessageRead(List<GroupMessageAck> groupMessageAcks) {}
  void onReadAckForGroupMessageUpdated() {}
  void onMessagesDelivered(List<Message> messages) {}
  void onMessagesRecalled(List<Message> recalled, List<Message> replaces) {}
  void onConversationsUpdate() {}
  void onConversationRead(String from, String to) {}
  void onMessageReactionDidChange(List<MessageReactionEvent> events) {}
  void onMessageContentChanged(
      Message message, String operatorId, int operationTime) {}
  void onTyping(List<String> fromUsers) {}
  void onMessagePinChanged(
    String messageId,
    String conversationId,
    MessagePinOperation pinOperation,
    MessagePinInfo pinInfo,
  ) {}
  void onMessageUpdate(Message newMessage, [Message? oldMessage]) {}
}
