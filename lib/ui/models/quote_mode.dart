import '../../chat_uikit.dart';

class QuoteModel {
  final String msgId;
  final String msgType;
  final String preview;
  final String sender;

  QuoteModel.fromMessage(Message message, this.preview)
      : msgId = message.msgId,
        msgType = message.bodyType.getString,
        sender = message.from!;

  QuoteModel(
    this.msgId,
    this.msgType,
    this.preview,
    this.sender,
  );

  Map<String, dynamic> toJson() {
    return {
      quoteMsgIdKey: msgId,
      quoteMsgTypeKey: msgType,
      quoteMsgPreviewKey: preview,
      quoteMsgSenderKey: sender,
    };
  }
}

extension MessageTypeExt on MessageType {
  String get getString {
    switch (this) {
      case MessageType.TXT:
        return 'txt';
      case MessageType.IMAGE:
        return 'img';
      case MessageType.VIDEO:
        return 'video';
      case MessageType.VOICE:
        return 'audio';
      case MessageType.LOCATION:
        return 'location';
      case MessageType.COMBINE:
        return 'Chat History';
      case MessageType.FILE:
        return 'file';
      case MessageType.CUSTOM:
        return 'custom';
      case MessageType.CMD:
        return 'cmd';
      default:
        return 'txt';
    }
  }
}

extension MessageTypeStr on String {
  MessageType get getMessageType {
    switch (this) {
      case 'txt':
        return MessageType.TXT;
      case 'img':
        return MessageType.IMAGE;
      case 'video':
        return MessageType.VIDEO;
      case 'audio':
        return MessageType.VOICE;
      case 'location':
        return MessageType.LOCATION;
      case 'Chat History':
        return MessageType.COMBINE;
      case 'file':
        return MessageType.FILE;
      case 'custom':
        return MessageType.CUSTOM;
      case 'cmd':
        return MessageType.CMD;
      default:
        return MessageType.TXT;
    }
  }
}
