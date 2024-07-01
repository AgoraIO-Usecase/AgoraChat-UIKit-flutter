import '../../../chat_uikit.dart';

class ThreadMembersViewArguments implements ChatUIKitViewArguments {
  ThreadMembersViewArguments({
    required this.thread,
    this.enableAppBar = true,
    this.appBarModel,
    this.controller,
    this.attributes,
    this.viewObserver,
    this.appBarTrailingActionsBuilder,
  });

  final ChatThread thread;
  final ThreadMembersViewController? controller;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarActionsBuilder? appBarTrailingActionsBuilder;
  final bool enableAppBar;
  final ChatUIKitAppBarModel? appBarModel;

  ThreadMembersViewArguments copyWith({
    ChatThread? thread,
    ThreadMembersViewController? controller,
    String? attributes,
    bool? enableAppBar,
    ChatUIKitAppBarModel? appBarModel,
    ChatUIKitViewObserver? viewObserver,
  }) {
    return ThreadMembersViewArguments(
      thread: thread ?? this.thread,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBarModel: appBarModel ?? this.appBarModel,
      controller: controller ?? this.controller,
      attributes: attributes ?? this.attributes,
      viewObserver: viewObserver ?? this.viewObserver,
    );
  }
}
