import '../../chat_uikit.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewRequestDetailsView extends StatefulWidget {
  NewRequestDetailsView.arguments(NewRequestDetailsViewArguments arguments,
      {super.key})
      : profile = arguments.profile,
        btnText = arguments.btnText,
        appBarModel = arguments.appBarModel,
        enableAppBar = arguments.enableAppBar,
        isReceivedRequest = arguments.isReceivedRequest,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const NewRequestDetailsView({
    required this.profile,
    this.isReceivedRequest = false,
    this.btnText,
    this.appBarModel,
    this.enableAppBar = true,
    this.attributes,
    this.viewObserver,
    super.key,
  });

  final ChatUIKitProfile profile;
  final String? btnText;
  final bool isReceivedRequest;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;

  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<NewRequestDetailsView> createState() => _NewRequestDetailsViewState();
}

class _NewRequestDetailsViewState extends State<NewRequestDetailsView> {
  bool hasSend = false;
  ChatUIKitAppBarModel? appBarModel;

  @override
  void initState() {
    super.initState();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    super.dispose();
  }

  void updateAppBarModel(ChatUIKitTheme theme) {
    appBarModel = ChatUIKitAppBarModel(
      title: widget.appBarModel?.title,
      centerWidget: widget.appBarModel?.centerWidget,
      titleTextStyle: widget.appBarModel?.titleTextStyle,
      subtitle: widget.appBarModel?.subtitle,
      subTitleTextStyle: widget.appBarModel?.subTitleTextStyle,
      leadingActions: widget.appBarModel?.leadingActions ??
          widget.appBarModel?.leadingActionsBuilder?.call(context, null),
      trailingActions: widget.appBarModel?.trailingActions ??
          widget.appBarModel?.trailingActionsBuilder?.call(context, null),
      showBackButton: widget.appBarModel?.showBackButton ?? true,
      onBackButtonPressed: widget.appBarModel?.onBackButtonPressed,
      centerTitle: widget.appBarModel?.centerTitle ?? false,
      systemOverlayStyle: widget.appBarModel?.systemOverlayStyle,
      backgroundColor: widget.appBarModel?.backgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    updateAppBarModel(theme);
    Widget content = Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: _buildContent(),
    );

    return content;
  }

  Widget _buildContent() {
    final theme = ChatUIKitTheme.of(context);
    Widget avatar = ChatUIKitAvatar(
      avatarUrl: widget.profile.avatarUrl,
      size: 100,
    );

    Widget name = Text(
      widget.profile.showName,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      textScaler: TextScaler.noScaling,
      style: TextStyle(
        fontSize: theme.font.headlineLarge.fontSize,
        fontWeight: theme.font.headlineLarge.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor100
            : theme.color.neutralColor1,
      ),
    );

    Widget easeId = Text(
      'ID: ${widget.profile.id}',
      overflow: TextOverflow.ellipsis,
      textScaler: TextScaler.noScaling,
      maxLines: 1,
      style: TextStyle(
        fontSize: theme.font.bodySmall.fontSize,
        fontWeight: theme.font.bodySmall.fontWeight,
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
      ),
    );

    Widget row = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        easeId,
        const SizedBox(width: 2),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            Clipboard.setData(ClipboardData(text: widget.profile.id));
            ChatUIKit.instance.sendChatUIKitEvent(ChatUIKitEvent.userIdCopied);
          },
          child: Icon(
            Icons.file_copy_sharp,
            size: 16,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        ),
      ],
    );

    Widget button = Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        color: hasSend
            ? (theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9)
            : (theme.color.isDark
                ? theme.color.primaryColor6
                : theme.color.primaryColor5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          widget.btnText ??
              ChatUIKitLocal.newRequestDetailsViewAddContact
                  .localString(context),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: theme.font.headlineSmall.fontSize,
            fontWeight: theme.font.headlineSmall.fontWeight,
            color: theme.color.isDark
                ? theme.color.neutralColor1
                : theme.color.neutralColor98,
          ),
        ),
      ),
    );

    button = InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: addAction,
      child: button,
    );

    Widget content = Column(
      children: [
        const SizedBox(height: 20),
        avatar,
        const SizedBox(height: 12),
        name,
        const SizedBox(height: 4),
        row,
        const SizedBox(height: 20),
        button,
      ],
    );

    return content;
  }

  void addAction() async {
    if (hasSend) return;
    bool needSetState = false;
    try {
      if (widget.isReceivedRequest) {
        await ChatUIKit.instance
            .acceptContactRequest(userId: widget.profile.id)
            .then((value) {
          if (mounted) {
            Navigator.of(context).pop();
          }
        });
      } else {
        try {
          await ChatUIKit.instance
              .sendContactRequest(userId: widget.profile.id);
          needSetState = true;
          // ignore: empty_catches
        } catch (e) {}
      }
      if (needSetState) {
        safeSetState(() {
          hasSend = true;
        });
      }

      // ignore: empty_catches
    } on ChatError {}
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
