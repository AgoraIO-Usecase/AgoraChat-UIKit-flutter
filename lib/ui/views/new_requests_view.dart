import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class NewRequestsView extends StatefulWidget {
  NewRequestsView.arguments(NewRequestsViewArguments arguments, {super.key})
      : controller = arguments.controller,
        appBarModel = arguments.appBarModel,
        onSearchTap = arguments.onSearchTap,
        itemBuilder = arguments.itemBuilder,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        enableAppBar = arguments.enableAppBar,
        loadErrorMessage = arguments.loadErrorMessage,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const NewRequestsView({
    this.controller,
    this.appBarModel,
    this.onSearchTap,
    this.itemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchBarHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.attributes,
    this.viewObserver,
    super.key,
  });

  final NewRequestListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<NewRequestItemModel> data)? onSearchTap;
  final ChatUIKitNewRequestItemBuilder? itemBuilder;
  final void Function(BuildContext context, NewRequestItemModel model)? onTap;
  final void Function(BuildContext context, NewRequestItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;

  final ChatUIKitViewObserver? viewObserver;

  final String? attributes;

  @override
  State<NewRequestsView> createState() => _NewRequestsViewState();
}

class _NewRequestsViewState extends State<NewRequestsView>
    with ContactObserver, ChatSDKEventsObserver, ChatUIKitThemeMixin {
  late final NewRequestListViewController controller;
  ChatUIKitAppBarModel? appBarModel;
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ?? NewRequestListViewController();
    widget.viewObserver?.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.viewObserver?.dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  void updateAppBarModel(ChatUIKitTheme theme) {
    appBarModel = ChatUIKitAppBarModel(
      title: widget.appBarModel?.title ??
          ChatUIKitLocal.newRequestsViewTitle.localString(context),
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
      bottomLine: widget.appBarModel?.bottomLine,
      bottomLineColor: widget.appBarModel?.bottomLineColor,
    );
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Future(() => {ChatUIKitContext.instance.markAllRequestsAsRead()});

    updateAppBarModel(theme);
    Widget content = Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: theme.color.isDark
            ? theme.color.neutralColor1
            : theme.color.neutralColor98,
        appBar:
            widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
        body: SafeArea(
          child: NewRequestsListView(
            controller: controller,
            itemBuilder: widget.itemBuilder,
            searchBarHideText: widget.searchBarHideText,
            emptyBackground: widget.listViewBackground,
            errorMessage: widget.loadErrorMessage,
            // onTap: widget.onTap ?? onItemTap,
            onTap: widget.onTap,
            onLongPress: widget.onLongPress,
          ),
        ));

    return content;
  }

  // 暂定不需要跳进详情页面
  void onItemTap(BuildContext context, NewRequestItemModel model) {
    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.newRequestDetailsView,
      NewRequestDetailsViewArguments(
        profile: model.profile,
        isReceivedRequest: true,
        attributes: widget.attributes,
      ),
    ).then((value) {
      if (value == true) {
        if (mounted && value == true) {
          controller.reload();
        }
      }
    });
  }

  @override
  void onContactRequestReceived(String userId, String? reason) {
    if (mounted) {
      controller.reload();
    }
  }
}
