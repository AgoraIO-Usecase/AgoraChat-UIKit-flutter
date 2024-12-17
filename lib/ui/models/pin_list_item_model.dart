import '../../../chat_uikit.dart';
import 'package:flutter/foundation.dart';

class PinListItemModel {
  final Message message;
  final MessagePinInfo pinInfo;

  const PinListItemModel({
    required this.message,
    required this.pinInfo,
  });

  PinListItemModel copyWith({
    Message? message,
    MessagePinInfo? pinInfo,
    VoidCallback? onTap,
    bool? isConfirming,
  }) {
    return PinListItemModel(
      message: message ?? this.message,
      pinInfo: pinInfo ?? this.pinInfo,
    );
  }

  String get senderShowName {
    return message.nickname ?? message.from!;
  }

  String get operatorShowName {
    return ChatUIKitProvider.instance
        .getProfile(ChatUIKitProfile.contact(id: pinInfo.operatorId))
        .contactShowName;
  }
}
