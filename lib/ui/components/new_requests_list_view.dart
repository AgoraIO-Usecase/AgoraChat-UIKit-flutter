import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

/// The new requests list view.
/// This widget is used to display the list of new requests.
class NewRequestsListView extends StatefulWidget {
  const NewRequestsListView({
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
    super.key,
  });

  /// Callback when the search bar is clicked, the parameter is the search data source list.
  final void Function(List<NewRequestItemModel> data)? onSearchTap;

  /// The widget list displayed before the list.
  final List<Widget>? beforeWidgets;

  /// The widget list displayed after the list.
  final List<Widget>? afterWidgets;

  /// The builder of the list item.
  final ChatUIKitNewRequestItemBuilder? itemBuilder;

  /// Callback when the list item is clicked.
  final void Function(BuildContext context, NewRequestItemModel model)? onTap;

  /// Callback when the list item is long pressed.
  final void Function(BuildContext context, NewRequestItemModel model)?
      onLongPress;

  /// The text displayed when the search bar is hidden.
  final String? searchBarHideText;

  /// The widget displayed when the list is empty.
  final Widget? emptyBackground;

  /// The error message displayed when the list fails to load.
  final String? errorMessage;

  /// The message displayed when the list fails to load.
  final String? reloadMessage;

  /// The controller of the list.
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
          background: widget.emptyBackground,
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
