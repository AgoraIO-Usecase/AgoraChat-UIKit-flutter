import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class SearchGroupMembersView extends StatefulWidget {
  SearchGroupMembersView.arguments(
    SearchGroupMembersViewArguments arguments, {
    super.key,
  })  : searchData = arguments.searchData,
        searchHideText = arguments.searchHideText,
        itemBuilder = arguments.itemBuilder,
        enableAppBar = arguments.enableAppBar,
        appBarModel = arguments.appBarModel,
        onTap = arguments.onTap,
        viewObserver = arguments.viewObserver,
        attributes = arguments.attributes;

  const SearchGroupMembersView({
    required this.searchData,
    required this.searchHideText,
    this.itemBuilder,
    this.onTap,
    this.appBarModel,
    this.enableAppBar = false,
    this.attributes,
    this.viewObserver,
    super.key,
  });

  final List<NeedSearch> searchData;
  final String searchHideText;
  final void Function(BuildContext context, ChatUIKitProfile profile)? onTap;
  final Widget Function(BuildContext context, ChatUIKitProfile profile,
      String? searchKeyword)? itemBuilder;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;
  final String? attributes;

  /// 用于刷新页面的Observer
  final ChatUIKitViewObserver? viewObserver;

  @override
  State<SearchGroupMembersView> createState() => _SearchGroupMembersViewState();
}

class _SearchGroupMembersViewState extends State<SearchGroupMembersView> {
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
      showBackButton: widget.appBarModel?.showBackButton ?? false,
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
    Widget content = ChatUIKitSearchWidget(
      searchHideText: widget.searchHideText,
      list: widget.searchData,
      autoFocus: true,
      builder: (context, searchKeyword, list) {
        return ChatUIKitListView(
          list: list,
          type: list.isEmpty
              ? ChatUIKitListViewType.empty
              : ChatUIKitListViewType.normal,
          enableSearchBar: false,
          itemBuilder: (context, model) {
            if (model is NeedSearch) {
              if (widget.itemBuilder != null) {
                return widget.itemBuilder!
                    .call(context, model.profile, searchKeyword);
              }

              return InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  widget.onTap?.call(context, model.profile);
                },
                child: ChatUIKitSearchListViewItem(
                  profile: model.profile,
                  highlightWord: searchKeyword,
                ),
              );
            }
            return const SizedBox();
          },
        );
      },
    );

    content = NotificationListener(
      child: content,
      onNotification: (notification) {
        if (notification is SearchNotification) {
          if (!notification.isSearch) {
            Navigator.of(context).pop();
          }
        }
        return false;
      },
    );

    content = Scaffold(
      backgroundColor: theme.color.isDark
          ? theme.color.neutralColor1
          : theme.color.neutralColor98,
      appBar: widget.enableAppBar ? ChatUIKitAppBar.model(appBarModel!) : null,
      body: SafeArea(child: content),
    );

    return content;
  }
}
