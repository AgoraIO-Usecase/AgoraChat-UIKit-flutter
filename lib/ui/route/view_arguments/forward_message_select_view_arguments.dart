import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ForwardMessageSelectViewArguments implements ChatUIKitViewArguments {
  final List<Message> messages;
  final bool enableAppBar;
  final ChatUIKitAppBarModel? appBarModel;
  final String? Function(BuildContext context, Message message)? summaryBuilder;

  final bool isMulti;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  ForwardMessageSelectViewArguments({
    required this.messages,
    this.enableAppBar = true,
    this.appBarModel,
    this.viewObserver,
    this.summaryBuilder,
    this.isMulti = true,
    this.attributes,
  });

  ForwardMessageSelectViewArguments copyWith({
    List<Message>? messages,
    bool? enableAppBar,
    ChatUIKitAppBarModel? appBarModel,
    List<Widget>? pages,
    List<String>? pageTitles,
    ChatUIKitViewObserver? viewObserver,
    String? Function(BuildContext context, Message message)? summaryBuilder,
    bool? isMulti,
    String? attributes,
  }) {
    return ForwardMessageSelectViewArguments(
      messages: messages ?? this.messages,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBarModel: appBarModel ?? this.appBarModel,
      summaryBuilder: summaryBuilder ?? this.summaryBuilder,
      viewObserver: viewObserver ?? this.viewObserver,
      isMulti: isMulti ?? this.isMulti,
      attributes: attributes ?? this.attributes,
    );
  }
}
