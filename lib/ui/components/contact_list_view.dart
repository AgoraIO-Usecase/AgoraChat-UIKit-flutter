import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class ContactListView extends StatefulWidget {
  const ContactListView({
    this.controller,
    this.itemBuilder,
    this.beforeWidgets,
    this.afterWidgets,
    this.onSearchTap,
    this.searchHideText,
    this.background,
    this.errorMessage,
    this.reloadMessage,
    this.enableSearchBar = true,
    this.onTap,
    this.onLongPress,
    this.sortAlphabetical,
    this.universalAlphabetical = '#',
    this.onSelectLetterChanged,
    super.key,
  });
  final bool enableSearchBar;
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
  final ContactListViewController? controller;
  final void Function(BuildContext context, String? letter)?
      onSelectLetterChanged;

  /// 通讯录列表的字母排序默认字，默认为 '#'
  final String universalAlphabetical;

  /// 字母排序
  final String? sortAlphabetical;

  @override
  State<ContactListView> createState() => _ContactListViewState();
}

class _ContactListViewState extends State<ContactListView>
    with ChatUIKitProviderObserver {
  ScrollController scrollController = ScrollController();
  late final ContactListViewController controller;

  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    controller = widget.controller ?? ContactListViewController();
    controller.fetchItemList();
    controller.loadingType.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    if (controller.list.any((element) =>
        map.keys.contains((element as ContactItemModel).profile.id))) {
      for (var element in map.keys) {
        int index = controller.list
            .indexWhere((e) => (e as ContactItemModel).profile.id == element);
        if (index != -1) {
          controller.list[index] = (controller.list[index] as ContactItemModel)
              .copyWith(profile: map[element]!);
        }
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatUIKitAlphabeticalWidget(
      onSelectLetterChanged: widget.onSelectLetterChanged,
      beforeWidgets: widget.beforeWidgets,
      listViewHasSearchBar: widget.enableSearchBar,
      universalAlphabeticalLetter: widget.universalAlphabetical,
      sortAlphabetical: widget.sortAlphabetical,
      list: controller.list,
      scrollController: scrollController,
      builder: (context, list) {
        return ChatUIKitListView(
          onRefresh: controller.enableRefresh
              ? () async {
                  await controller.fetchItemList(reload: true);
                }
              : null,
          scrollController: scrollController,
          type: controller.loadingType.value,
          list: list,
          refresh: () {
            controller.fetchItemList();
          },
          enableSearchBar: widget.enableSearchBar,
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
          findChildIndexCallback: (Key key) {
            int index = -1;
            if (key is ValueKey<String>) {
              final ValueKey<String> valueKey = key;
              index = controller.list.indexWhere((info) {
                if (info is ContactItemModel) {
                  return info.profile.id == valueKey.value;
                } else {
                  return false;
                }
              });
            }
            return index > -1 ? index : null;
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

              item = SizedBox(
                key: ValueKey(model.profile.id),
                child: item,
              );

              return item;
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}
