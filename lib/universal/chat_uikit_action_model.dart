import '../universal/defines.dart';
import 'package:flutter/widgets.dart';

typedef ChatUIKitActionItemOnTap = void Function(BuildContext context);

class ChatUIKitDetailContentAction {
  ChatUIKitDetailContentAction({
    this.title,
    required this.icon,
    this.iconSize,
    this.packageName,
    this.singleLine = false,
    this.onTap,
  });

  final String? title;
  final ChatUIKitActionItemOnTap? onTap;
  final String icon;
  final Size? iconSize;
  final String? packageName;
  // 表示是唯一的按钮，不允许其他按钮存在
  final bool singleLine;
}

class ChatUIKitAppBarAction {
  final Widget child;
  final ChatUIKitActionItemOnTap? onTap;
  final ChatUIKitActionType actionType;

  ChatUIKitAppBarAction({
    required this.child,
    this.actionType = ChatUIKitActionType.custom,
    this.onTap,
  });

  ChatUIKitAppBarAction copyWith({
    ChatUIKitActionItemOnTap? onTap,
    Widget? child,
    ChatUIKitActionType? actionType,
  }) {
    return ChatUIKitAppBarAction(
      child: child ?? this.child,
      actionType: actionType ?? this.actionType,
      onTap: onTap ?? this.onTap,
    );
  }
}
