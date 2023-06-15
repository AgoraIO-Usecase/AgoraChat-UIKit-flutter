import '../agora_chat_uikit.dart';

class ChatMessageListCallback {
  void onMessagesReceived(List<ChatMessage> messages) {}

  void onMessagesRead(List<ChatMessage> messages) {}

  void onMessagesDelivered(List<ChatMessage> messages) {}

  void onMessagesRecalled(List<ChatMessage> messages) {}

  void onGroupMessageRead(List<ChatGroupMessageAck> acks) {}

  void onReadAckForGroupMessageUpdated() {}

  void onCmdMessagesReceived(List<ChatMessage> messages) {}

  void onConversationsUpdate() {}

  void onConversationRead(String from, String to) {}

  void onMessageReactionDidChange(List<ChatMessageReactionEvent> events) {}

  void onSendMessageSuccess(String preSendId, ChatMessage message) {}

  void onSendProgress(String preSendId, int progress) {}

  void onSendMessageError(String preSendId, ChatMessage message, ChatError err) {}
}
