import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ShowImageViewArguments implements ChatUIKitViewArguments {
  ShowImageViewArguments({
    required this.message,
    this.onLongPressed,
    this.onTap,
    this.appBarModel,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
    this.isCombine = false,
  });

  final Message message;
  final void Function(BuildContext context, Message message)? onLongPressed;
  final void Function(BuildContext context, Message message)? onTap;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;
  final bool isCombine;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  ShowImageViewArguments copyWith(
      {Message? message,
      void Function(BuildContext context, Message message)? onLongPressed,
      void Function(BuildContext context, Message message)? onTap,
      ChatUIKitAppBarModel? appBarModel,
      bool? enableAppBar,
      ChatUIKitViewObserver? viewObserver,
      String? attributes,
      ChatUIKitAppBarActionsBuilder? appBarTrailingActionsBuilder}) {
    return ShowImageViewArguments(
      message: message ?? this.message,
      onLongPressed: onLongPressed ?? this.onLongPressed,
      onTap: onTap ?? this.onTap,
      appBarModel: appBarModel ?? this.appBarModel,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
