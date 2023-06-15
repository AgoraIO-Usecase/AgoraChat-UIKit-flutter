import '../agora_chat_uikit.dart';

class ChatMessageListItemModel {
  const ChatMessageListItemModel(this.message, [this.needTime = false]);
  final ChatMessage message;
  final bool needTime;

  String get msgId => message.msgId;

  ChatMessageListItemModel copyWithMsg(ChatMessage message) {
    return ChatMessageListItemModel(message, needTime);
  }

  ChatMessageListItemModel copyWithNeedTime(bool needTime) {
    return ChatMessageListItemModel(message, needTime);
  }

  bool isSend() {
    return message.direction == MessageDirection.SEND;
  }
}
