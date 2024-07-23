import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

class NewRequestsListView extends StatefulWidget {
  const NewRequestsListView({
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
    super.key,
  });

  final void Function(List<NewRequestItemModel> data)? onSearchTap;
  final List<Widget>? beforeWidgets;
  final List<Widget>? afterWidgets;
  final ChatUIKitNewRequestItemBuilder? itemBuilder;
  final void Function(BuildContext context, NewRequestItemModel model)? onTap;
  final void Function(BuildContext context, NewRequestItemModel model)?
      onLongPress;
  final String? searchHideText;
  final Widget? background;
  final String? errorMessage;
  final String? reloadMessage;
  final NewRequestListViewController? controller;

  @override
  State<NewRequestsListView> createState() => _NewRequestsListViewState();
}

class _NewRequestsListViewState extends State<NewRequestsListView>
    with ContactObserver, ChatUIKitProviderObserver {
  late final NewRequestListViewController controller;

  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    ChatUIKit.instance.addObserver(this);
    controller = widget.controller ?? NewRequestListViewController();
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
        map.keys.contains((element as NewRequestItemModel).profile.id))) {
      for (var element in map.keys) {
        int index = controller.list.indexWhere(
            (e) => (e as NewRequestItemModel).profile.id == element);
        if (index != -1) {
          controller.list[index] =
              (controller.list[index] as NewRequestItemModel)
                  .copyWith(profile: map[element]!);
        }
      }
      setState(() {});
    }
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
          enableSearchBar: false,
          errorMessage: widget.errorMessage,
          reloadMessage: widget.reloadMessage,
          background: widget.background,
          itemBuilder: (context, model) {
            if (model is NewRequestItemModel) {
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
                child: ChatUIKitNewRequestListViewItem(
                  model,
                  onAcceptTap: () {
                    controller.acceptRequest(model.profile.id);
                  },
                ),
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

  @override
  void onContactRequestReceived(String userId, String? reason) {
    controller.fetchItemList();
  }

  @override
  void onContactAdded(String userId) {
    controller.fetchItemList();

    // Message.createCustomSendMessage(targetId: userId, event: );
    // ChatUIKit.instance.insertMessage(message: message);
  }
}
