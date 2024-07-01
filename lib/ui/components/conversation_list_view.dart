import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class ConversationListView extends StatefulWidget {
  const ConversationListView({
    this.controller,
    this.itemBuilder,
    this.beforeWidgets,
    this.afterWidgets,
    this.onSearchTap,
    this.searchBarHideText,
    this.background,
    this.errorMessage,
    this.reloadMessage,
    this.onTap,
    this.onLongPress,
    this.enableLongPress = true,
    this.enableSearchBar = true,
    super.key,
  });

  final void Function(List<ConversationItemModel> data)? onSearchTap;
  final ConversationItemBuilder? itemBuilder;
  final void Function(BuildContext context, ConversationItemModel info)? onTap;
  final void Function(BuildContext context, ConversationItemModel info)?
      onLongPress;
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;

  final String? searchBarHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final ConversationListViewController? controller;
  final bool enableLongPress;
  final bool enableSearchBar;

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView> {
  late ConversationListViewController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? ConversationListViewController();
    controller.fetchItemList();
    controller.loadingType.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return ChatUIKitListView(
      type: controller.loadingType.value,
      list: controller.list,
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
        List<ConversationItemModel> list = [];
        for (var item in data) {
          if (item is ConversationItemModel) {
            list.add(item);
          }
        }
        widget.onSearchTap?.call(list);
      },
      searchBarHideText: widget.searchBarHideText,
      findChildIndexCallback: (key) {
        int index = -1;
        if (key is ValueKey<String>) {
          final ValueKey<String> valueKey = key;
          index = controller.list.indexWhere((info) {
            if (info is ConversationItemModel) {
              return info.profile.id == valueKey.value;
            } else {
              return false;
            }
          });
        }

        return index > -1 ? index : null;
      },
      itemBuilder: (context, model) {
        if (model is ConversationItemModel) {
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
              if (widget.enableLongPress) {
                widget.onLongPress?.call(context, model);
              }
            },
            child: ChatUIKitConversationListViewItem(
              model,
            ),
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
  }
}
