import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

/// The conversation list view.
/// This widget is used to display the list of conversations.
class ConversationListView extends StatefulWidget {
  const ConversationListView({
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
    this.enableLongPress = true,
    this.enableSearchBar = true,
    this.enablePinHighlight = true,
    super.key,
  });

  /// Callback when the search bar is clicked, the parameter is the search data source list.
  final void Function(List<ConversationItemModel> data)? onSearchTap;

  /// The builder of the list item.
  final ConversationItemBuilder? itemBuilder;

  /// Callback when the list item is clicked.
  final void Function(BuildContext context, ConversationItemModel info)? onTap;

  /// Callback when the list item is long pressed.
  final void Function(BuildContext context, ConversationItemModel info)?
      onLongPress;

  /// The widget list before the list.
  final List<Widget>? beforeWidgets;

  /// The widget list after the list.
  final List<Widget>? afterWidgets;

  /// The text displayed when the search bar is hidden.
  final String? searchBarHideText;

  /// The widget displayed when the list is empty.
  final Widget? emptyBackground;

  /// The error message displayed when the list fails to load.
  final String? errorMessage;

  /// The message displayed when the list fails to load.
  final String? reloadMessage;

  /// The controller of the list.
  final ConversationListViewController? controller;

  /// Whether to enable long press, the default is true.
  final bool enableLongPress;

  /// Whether to enable the search bar, the default is true.
  final bool enableSearchBar;

  /// Whether to enable the pin highlight, the default is true.
  final bool enablePinHighlight;

  @override
  State<ConversationListView> createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView>
    with ChatUIKitProviderObserver, ChatUIKitThemeMixin {
  late ConversationListViewController controller;

  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    controller = widget.controller ?? ConversationListViewController();
    controller.loadingType.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.fetchItemList();
    });
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) async {
    if (controller.list.any((element) =>
        map.keys.contains((element as ConversationItemModel).profile.id))) {
      for (var element in map.keys) {
        int index = controller.list.indexWhere(
            (e) => (e as ConversationItemModel).profile.id == element);
        if (index != -1) {
          controller.list[index] =
              (controller.list[index] as ConversationItemModel)
                  .copyWith(profile: map[element]!);
        }
      }
      setState(() {});
    }
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
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
      background: widget.emptyBackground,
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

          item ??= ChatUIKitConversationListViewItem(model);

          if (widget.enablePinHighlight) {
            item = Container(
              color: model.pinned
                  ? (theme.color.isDark
                      ? theme.color.neutralColor2
                      : theme.color.neutralColor95)
                  : (theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98),
              child: item,
            );
          }

          item = InkWell(
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
            child: item,
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
