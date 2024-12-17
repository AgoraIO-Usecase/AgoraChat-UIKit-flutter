import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

/// The group list view.
/// This widget is used to display the list of groups.
class GroupListView extends StatefulWidget {
  const GroupListView({
    this.controller,
    this.itemBuilder,
    this.beforeWidgets,
    this.afterWidgets,
    this.onSearchTap,
    this.searchBarHideText,
    this.emptyBackground,
    this.errorMessage,
    this.reloadMessage,
    this.onTap,
    this.onLongPress,
    this.enableSearch = false,
    super.key,
  });

  /// Callback when the search bar is clicked, the parameter is the search data source list.
  final void Function(List<GroupItemModel> data)? onSearchTap;

  /// The widget list displayed before the list.
  final List<Widget>? beforeWidgets;

  /// The widget list displayed after the list.
  final List<Widget>? afterWidgets;

  /// The builder of the list item.
  final ChatUIKitGroupItemBuilder? itemBuilder;

  /// Callback when the list item is clicked.
  final void Function(BuildContext context, GroupItemModel model)? onTap;

  /// Callback when the list item is long pressed.
  final void Function(BuildContext context, GroupItemModel model)? onLongPress;

  /// The text displayed when the search bar is hidden.
  final String? searchBarHideText;

  /// The widget displayed when the list is empty.
  final Widget? emptyBackground;

  /// The error message displayed when the list fails to load.
  final String? errorMessage;

  /// The message displayed when the list fails to load.
  final String? reloadMessage;

  /// The controller of the list.
  final GroupListViewController? controller;

  /// Whether to enable search bar, the default is false.
  final bool enableSearch;

  @override
  State<GroupListView> createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView>
    with MultiObserver, GroupObserver, ChatUIKitProviderObserver {
  late final GroupListViewController controller;

  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ?? GroupListViewController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.fetchItemList();
    });
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    ChatUIKit.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (controller.list.any((element) =>
        map.keys.contains((element as GroupItemModel).profile.id))) {
      for (var element in map.keys) {
        int index = controller.list
            .indexWhere((e) => (e as GroupItemModel).profile.id == element);
        if (index != -1) {
          controller.list[index] = (controller.list[index] as GroupItemModel)
              .copyWith(profile: map[element]!);
        }
      }
      setState(() {});
    }
  }

  @override
  void onAutoAcceptInvitationFromGroup(
    String groupId,
    String inviter,
    String? inviteMessage,
  ) {
    controller.addNewGroup(groupId);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ValueListenableBuilder<ChatUIKitListViewType>(
      valueListenable: controller.loadingType,
      builder: (context, type, child) {
        return ChatUIKitListView(
          type: type,
          list: controller.list,
          refresh: () {
            controller.fetchItemList();
          },
          loadMore: () {
            controller.fetchMoreItemList();
          },
          enableSearchBar: widget.enableSearch,
          onSearchTap: (data) {
            List<GroupItemModel> list = [];
            for (var item in data) {
              if (item is GroupItemModel) {
                list.add(item);
              }
            }
            widget.onSearchTap?.call(list);
          },
          errorMessage: widget.errorMessage,
          reloadMessage: widget.reloadMessage,
          background: widget.emptyBackground,
          itemBuilder: (context, model) {
            if (model is GroupItemModel) {
              Widget? item;
              if (widget.itemBuilder != null) {
                item = widget.itemBuilder!(context, model);
              }
              item ??= InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  widget.onTap?.call(context, model);
                },
                onLongPress: () {
                  widget.onLongPress?.call(context, model);
                },
                child: ChatUIKitGroupListViewItem(model),
              );

              return item;
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );

    return content;
  }
}
