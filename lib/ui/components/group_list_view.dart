import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupListView extends StatefulWidget {
  const GroupListView({
    this.controller,
    this.itemBuilder,
    this.beforeWidgets,
    this.afterWidgets,
    this.onSearchTap,
    this.searchHideText,
    this.background,
    this.errorMessage,
    this.reloadMessage,
    this.onTap,
    this.onLongPress,
    this.enableSearch = false,
    super.key,
  });
  final void Function(List<GroupItemModel> data)? onSearchTap;
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;
  final ChatUIKitGroupItemBuilder? itemBuilder;
  final void Function(BuildContext context, GroupItemModel model)? onTap;
  final void Function(BuildContext context, GroupItemModel model)? onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final GroupListViewController? controller;
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
    controller.fetchItemList();
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
          background: widget.background,
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
