import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class ShowImageView extends StatefulWidget {
  ShowImageView.arguments(ShowImageViewArguments arguments, {super.key})
      : message = arguments.message,
        onTap = arguments.onTap,
        appBarModel = arguments.appBarModel,
        enableAppBar = arguments.enableAppBar,
        onLongPressed = arguments.onLongPressed,
        viewObserver = arguments.viewObserver,
        isCombine = arguments.isCombine,
        attributes = arguments.attributes;

  const ShowImageView({
    required this.message,
    this.onLongPressed,
    this.onTap,
    this.appBarModel,
    this.enableAppBar = true,
    this.attributes,
    this.viewObserver,
    this.isCombine = false,
    super.key,
  });

  final Message message;
  final void Function(BuildContext context, Message message)? onLongPressed;
  final void Function(BuildContext context, Message message)? onTap;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;
  final String? attributes;
  final bool isCombine;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<ShowImageView> createState() => _ShowImageViewState();
}

class _ShowImageViewState extends State<ShowImageView> {
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
    Widget content = ChatUIKitShowImageWidget(
      message: widget.message,
      onLongPressed: widget.onLongPressed,
      onTap: widget.onTap,
      isCombine: widget.isCombine,
    );

    content = Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          content,
        ],
      ),
    );

    content = Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: content,
    );

    return content;
  }
}
