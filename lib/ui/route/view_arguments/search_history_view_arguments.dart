import '../../../chat_uikit.dart';

class SearchHistoryViewArguments implements ChatUIKitViewArguments {
  SearchHistoryViewArguments({
    required this.profile,
    this.attributes,
    this.viewObserver,
  });

  final ChatUIKitProfile profile;

  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  SearchHistoryViewArguments copyWith({
    ChatUIKitProfile? profile,
    String? attributes,
    ChatUIKitViewObserver? viewObserver,
  }) {
    return SearchHistoryViewArguments(
      profile: profile ?? this.profile,
      attributes: attributes ?? this.attributes,
      viewObserver: viewObserver ?? this.viewObserver,
    );
  }
}
