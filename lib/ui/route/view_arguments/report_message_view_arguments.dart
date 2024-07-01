import '../../../chat_uikit.dart';

class ReportMessageViewArguments implements ChatUIKitViewArguments {
  ReportMessageViewArguments({
    required this.messageId,
    required this.reportReasons,
    this.appBarModel,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
  });
  final String messageId;
  final List<String> reportReasons;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;

  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  ReportMessageViewArguments copyWith({
    String? messageId,
    List<String>? reportReasons,
    bool? enableAppBar,
    ChatUIKitAppBarModel? appBarModel,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return ReportMessageViewArguments(
      messageId: messageId ?? this.messageId,
      reportReasons: reportReasons ?? this.reportReasons,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBarModel: appBarModel ?? this.appBarModel,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
