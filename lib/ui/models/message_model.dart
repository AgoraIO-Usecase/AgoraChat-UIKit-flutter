import 'dart:math';

import '../../chat_uikit.dart';

class MessageModel {
  final String id;
  final Message message;
  final List<MessageReaction>? reactions;
  final Message? quoteMessage;
  final ChatThread? thread;
  final MessagePinInfo? pinInfo;

  MessageModel({
    String? modelId,
    required this.message,
    this.reactions,
    this.quoteMessage,
    this.thread,
    this.pinInfo,
  }) : id = modelId ?? randomId(message);

  MessageModel copyWith({
    Message? message,
    List<MessageReaction>? reactions,
    Message? quoteMessage,
    ChatThread? thread,
    MessagePinInfo? pinInfo,
  }) {
    return MessageModel(
      modelId: id,
      message: message ?? this.message,
      reactions: reactions ?? this.reactions,
      quoteMessage: quoteMessage ?? this.quoteMessage,
      thread: thread ?? this.thread,
      pinInfo: pinInfo ?? this.pinInfo,
    );
  }

  MessageModel clearThread() {
    return MessageModel(
      modelId: id,
      message: message,
      reactions: reactions,
      quoteMessage: quoteMessage,
      thread: null,
    );
  }

  MessageModel clearPinInfo() {
    return MessageModel(
      modelId: id,
      message: message,
      reactions: reactions,
      quoteMessage: quoteMessage,
      thread: thread,
      pinInfo: null,
    );
  }

  static String randomId(Message message) {
    return Random().nextInt(999999999).toString() +
        message.localTime.toString();
  }
}
