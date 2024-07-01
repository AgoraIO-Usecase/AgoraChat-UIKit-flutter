import '../../../chat_uikit.dart';

class NewRequestDetailsViewArguments implements ChatUIKitViewArguments {
  NewRequestDetailsViewArguments({
    required this.profile,
    this.isReceivedRequest = false,
    this.btnText,
    this.attributes,
    this.appBarModel,
    this.viewObserver,
    this.enableAppBar = true,
  });
  final ChatUIKitProfile profile;
  final bool isReceivedRequest;
  final String? btnText;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  NewRequestDetailsViewArguments copyWith({
    ChatUIKitProfile? profile,
    bool? isReceivedRequest,
    String? btnText,
    ChatUIKitAppBarModel? appBarModel,
    bool? enableAppBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return NewRequestDetailsViewArguments(
      profile: profile ?? this.profile,
      isReceivedRequest: isReceivedRequest ?? this.isReceivedRequest,
      btnText: btnText ?? this.btnText,
      appBarModel: appBarModel ?? this.appBarModel,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
