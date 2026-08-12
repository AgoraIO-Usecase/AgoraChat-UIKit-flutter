import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:agora_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';

class CurrentUserInfoViewArguments implements ChatUIKitViewArguments {
  CurrentUserInfoViewArguments({
    required this.profile,
    this.attributes,
    this.appBarModel,
    this.enableAppBar = true,
    this.viewObserver,
  });

  final ChatUIKitProfile profile;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  CurrentUserInfoViewArguments copyWith({
    ChatUIKitProfile? profile,
    ChatUIKitAppBarModel? appBarModel,
    bool? enableAppBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return CurrentUserInfoViewArguments(
      profile: profile ?? this.profile,
      appBarModel: appBarModel ?? this.appBarModel,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
