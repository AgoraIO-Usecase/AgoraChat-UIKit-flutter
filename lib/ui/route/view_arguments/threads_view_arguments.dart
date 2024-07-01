import '../../../chat_uikit.dart';

class ThreadsViewArguments implements ChatUIKitViewArguments {
  ThreadsViewArguments({
    required this.profile,
    this.enableAppBar = true,
    this.appBarModel,
    this.attributes,
    this.viewObserver,
  });

  final ChatUIKitProfile profile;
  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  final bool enableAppBar;
  final ChatUIKitAppBarModel? appBarModel;

  ThreadsViewArguments copyWith({
    ChatUIKitProfile? profile,
    bool? enableAppBar,
    ChatUIKitAppBarModel? appBarModel,
    String? attributes,
    ChatUIKitViewObserver? viewObserver,
    ChatUIKitAppBarActionsBuilder? appBarTrailingActionsBuilder,
  }) {
    return ThreadsViewArguments(
      profile: profile ?? this.profile,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBarModel: appBarModel ?? this.appBarModel,
      attributes: attributes ?? this.attributes,
      viewObserver: viewObserver ?? this.viewObserver,
    );
  }
}
