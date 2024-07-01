import '../../../chat_uikit.dart';

class ChangeInfoViewArguments implements ChatUIKitViewArguments {
  ChangeInfoViewArguments({
    this.hint,
    this.inputTextCallback,
    this.saveButtonTitle,
    this.appBarModel,
    this.maxLength = 128,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
  });

  final String? hint;
  final String? saveButtonTitle;
  final Future<String?> Function()? inputTextCallback;
  final ChatUIKitAppBarModel? appBarModel;
  final int maxLength;
  final bool enableAppBar;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  ChangeInfoViewArguments copyWith({
    String? title,
    String? hint,
    String? saveButtonTitle,
    Future<String?> Function()? inputTextCallback,
    ChatUIKitAppBarModel? appBarModel,
    int? maxLength,
    bool? enableAppBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return ChangeInfoViewArguments(
      hint: hint ?? this.hint,
      saveButtonTitle: saveButtonTitle ?? this.saveButtonTitle,
      inputTextCallback: inputTextCallback ?? this.inputTextCallback,
      appBarModel: appBarModel ?? this.appBarModel,
      maxLength: maxLength ?? this.maxLength,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
