import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ForwardMessagesViewArguments implements ChatUIKitViewArguments {
  final Message message;
  final bool enableAppBar;
  final ChatUIKitAppBarModel? appBarModel;
  final String? Function(BuildContext context, Message message)? summaryBuilder;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  ForwardMessagesViewArguments({
    required this.message,
    this.enableAppBar = true,
    this.appBarModel,
    this.viewObserver,
    this.summaryBuilder,
    this.attributes,
  });

  ForwardMessagesViewArguments copyWith({
    Message? message,
    bool? enableAppBar,
    ChatUIKitAppBarModel? appBarModel,
    String? title,
    List<Widget>? pages,
    List<String>? pageTitles,
    ChatUIKitViewObserver? viewObserver,
    String? Function(BuildContext context, Message message)? summaryBuilder,
    String? attributes,
  }) {
    return ForwardMessagesViewArguments(
      message: message ?? this.message,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBarModel: appBarModel ?? this.appBarModel,
      summaryBuilder: summaryBuilder ?? this.summaryBuilder,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
