import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class GroupMemberListView extends StatefulWidget {
  const GroupMemberListView({
    required this.groupId,
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
    this.enableSearchBar = false,
    this.onSelectLetterChanged,
    this.sortAlphabetical,
    this.universalAlphabeticalLetter = '#',
    super.key,
  });

  final void Function(List<ContactItemModel> data)? onSearchTap;
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;
  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final GroupMemberListViewController? controller;
  final String groupId;
  final bool enableSearchBar;
  final void Function(BuildContext context, String? letter)?
      onSelectLetterChanged;

  /// 通讯录列表的字母排序默认字，默认为 '#'
  final String universalAlphabeticalLetter;

  /// 字母排序
  final String? sortAlphabetical;

  @override
  State<GroupMemberListView> createState() => _GroupMemberListViewState();
}

class _GroupMemberListViewState extends State<GroupMemberListView> {
  ScrollController scrollController = ScrollController();
  late final GroupMemberListViewController controller;
  bool enableSearchBar = true;

  @override
  void initState() {
    super.initState();

    controller = widget.controller ??
        GroupMemberListViewController(
          groupId: widget.groupId,
        );
    controller.fetchItemList();
  }

  @override
  void dispose() {
    controller.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = ValueListenableBuilder<ChatUIKitListViewType>(
      valueListenable: controller.loadingType,
      builder: (context, type, child) {
        return ChatUIKitAlphabeticalWidget(
          groupId: widget.groupId,
          onSelectLetterChanged: widget.onSelectLetterChanged,
          universalAlphabeticalLetter: widget.universalAlphabeticalLetter,
          sortAlphabetical: widget.sortAlphabetical,
          beforeWidgets: widget.beforeWidgets,
          listViewHasSearchBar: enableSearchBar,
          list: controller.list,
          scrollController: scrollController,
          builder: (context, list) {
            return ChatUIKitListView(
              scrollController: scrollController,
              type: type,
              list: list,
              refresh: () {
                controller.fetchItemList();
              },
              enableSearchBar: enableSearchBar,
              errorMessage: widget.errorMessage,
              reloadMessage: widget.reloadMessage,
              beforeWidgets: widget.beforeWidgets,
              afterWidgets: widget.afterWidgets,
              background: widget.background,
              onSearchTap: (data) {
                List<ContactItemModel> list = [];
                for (var item in data) {
                  if (item is ContactItemModel) {
                    list.add(item);
                  }
                }
                widget.onSearchTap?.call(list);
              },
              searchBarHideText: widget.searchHideText,
              itemBuilder: (context, model) {
                if (model is ContactItemModel) {
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
                    child: ChatUIKitContactListViewItem(model),
                  );

                  return item;
                } else {
                  return const SizedBox();
                }
              },
            );
          },
        );
      },
    );

    return content;
  }
}
