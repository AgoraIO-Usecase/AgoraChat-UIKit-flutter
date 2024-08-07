import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class SelectContactView extends StatefulWidget {
  SelectContactView.arguments(SelectContactViewArguments arguments, {super.key})
      : listViewItemBuilder = arguments.listViewItemBuilder,
        onSearchTap = arguments.onSearchTap,
        searchBarHideText = arguments.searchBarHideText,
        listViewBackground = arguments.listViewBackground,
        onTap = arguments.onTap,
        onLongPress = arguments.onLongPress,
        appBarModel = arguments.appBarModel,
        controller = arguments.controller,
        enableAppBar = arguments.enableAppBar,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const SelectContactView({
    this.listViewItemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onTap,
    this.onLongPress,
    this.appBarModel,
    this.enableAppBar = true,
    this.controller,
    this.attributes,
    this.viewObserver,
    super.key,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<SelectContactView> createState() => _SelectContactViewState();
}

class _SelectContactViewState extends State<SelectContactView> {
  late final ContactListViewController controller;
  ChatUIKitAppBarModel? appBarModel;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ContactListViewController();
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
      trailingActions: () {
        List<ChatUIKitAppBarAction> actions = [
          ChatUIKitAppBarAction(
            actionType: ChatUIKitActionType.cancel,
            onTap: (context) {
              Navigator.of(context).pop();
            },
            child: Text(
              ChatUIKitLocal.messagesViewSelectContactCancel
                  .localString(context),
              textScaler: TextScaler.noScaling,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: theme.color.isDark
                    ? theme.color.neutralColor98
                    : theme.color.neutralColor1,
                fontWeight: theme.font.titleMedium.fontWeight,
                fontSize: theme.font.titleMedium.fontSize,
              ),
            ),
          )
        ];
        return widget.appBarModel?.trailingActionsBuilder
                ?.call(context, actions) ??
            actions;
      }(),
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
      body: ContactListView(
        controller: controller,
        itemBuilder: widget.listViewItemBuilder,
        searchHideText: widget.searchBarHideText,
        background: widget.listViewBackground,
        onTap: widget.onTap ?? tapContactInfo,
        onSearchTap: widget.onSearchTap ?? onSearchTap,
      ),
    );

    return content;
  }

  void onSearchTap(List<ContactItemModel> data) async {
    List<NeedSearch> list = [];
    for (var item in data) {
      list.add(item);
    }

    ChatUIKitRoute.pushOrPushNamed(
      context,
      ChatUIKitRouteNames.searchView,
      SearchViewArguments(
        onTap: (ctx, profile) {
          Navigator.of(ctx).pop(profile);
        },
        searchHideText:
            ChatUIKitLocal.selectContactViewSearchHint.localString(context),
        searchData: list,
        attributes: widget.attributes,
      ),
    ).then((value) {
      if (value != null) {
        if (mounted) {
          Navigator.of(context).pop(value);
        }
      }
    });
  }

  void tapContactInfo(BuildContext context, ContactItemModel info) {
    Navigator.of(context).pop(info.profile);
  }
}
