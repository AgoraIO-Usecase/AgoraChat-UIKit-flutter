import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class ShowVideoView extends StatefulWidget {
  ShowVideoView.arguments(ShowVideoViewArguments arguments, {super.key})
      : message = arguments.message,
        onLongPressed = arguments.onLongPressed,
        appBarModel = arguments.appBarModel,
        enableAppBar = arguments.enableAppBar,
        playIcon = arguments.playIcon,
        viewObserver = arguments.viewObserver,
        isCombine = arguments.isCombine,
        attributes = arguments.attributes;

  const ShowVideoView({
    required this.message,
    this.onLongPressed,
    this.playIcon,
    this.appBarModel,
    this.enableAppBar = true,
    this.attributes,
    this.viewObserver,
    this.isCombine = false,
    super.key,
  });

  final Message message;
  final void Function(BuildContext context, Message message)? onLongPressed;
  final Widget? playIcon;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;
  final String? attributes;
  final bool isCombine;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<ShowVideoView> createState() => _ShowVideoViewState();
}

class _ShowVideoViewState extends State<ShowVideoView> {
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
      backgroundColor:
          widget.appBarModel?.backgroundColor ?? Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    updateAppBarModel(theme);
    Widget content = ChatUIKitShowVideoWidget(
      message: widget.message,
      onLongPressed: widget.onLongPressed,
      playIcon: widget.playIcon,
      isCombine: widget.isCombine,
    );

    content = Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: content,
    );

    return content;
  }
}
