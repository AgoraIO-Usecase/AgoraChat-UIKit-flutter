import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ShowVideoViewArguments implements ChatUIKitViewArguments {
  ShowVideoViewArguments({
    required this.message,
    this.onLongPressed,
    this.attributes,
    this.playIcon,
    this.appBarModel,
    this.enableAppBar = true,
    this.viewObserver,
    this.isCombine = false,
  });

  final Message message;
  final void Function(BuildContext context, Message message)? onLongPressed;
  final Widget? playIcon;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;
  final bool isCombine;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  ShowVideoViewArguments copyWith({
    Message? message,
    void Function(BuildContext context, Message message)? onLongPressed,
    Widget? playIcon,
    ChatUIKitAppBarModel? appBarModel,
    bool? enableAppBar,
    String? attributes,
    ChatUIKitViewObserver? viewObserver,
  }) {
    return ShowVideoViewArguments(
      message: message ?? this.message,
      onLongPressed: onLongPressed ?? this.onLongPressed,
      playIcon: playIcon ?? this.playIcon,
      appBarModel: appBarModel ?? this.appBarModel,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
