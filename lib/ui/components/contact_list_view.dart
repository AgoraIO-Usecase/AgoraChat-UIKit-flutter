import '../../chat_uikit.dart';

import 'package:flutter/material.dart';

/// The contact list view.
/// This widget is used to display the list of contacts.
class ContactListView extends StatefulWidget {
  const ContactListView({
    this.controller,
    this.itemBuilder,
    this.beforeWidgets,
    this.afterWidgets,
    this.onSearchTap,
    this.searchBarHideText,
    this.emptyBackground,
    this.errorMessage,
    this.reloadMessage,
    this.enableSearchBar = true,
    this.enableSorting = true,
    this.showAlphabeticalIndicator = true,
    this.onTap,
    this.onLongPress,
    this.sortAlphabetical,
    this.specialAlphabeticalLetter = '#',
    this.onSelectLetterChanged,
    super.key,
  });

  /// Whether to enable the search bar, the default is true
  final bool enableSearchBar;

  /// Callback when the search bar is clicked, the parameter is the search data source list.
  final void Function(List<ContactItemModel> data)? onSearchTap;

  /// The widget list displayed before the list.
  final List<Widget>? beforeWidgets;

  /// The widget list displayed after the list.
  final List<Widget>? afterWidgets;

  /// The builder of the list item.
  final ChatUIKitContactItemBuilder? itemBuilder;

  /// Callback when the list item is clicked.
  final void Function(BuildContext context, ContactItemModel model)? onTap;

  /// Callback when the list item is long pressed.
  final void Function(BuildContext context, ContactItemModel model)?
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
  final ContactListViewController? controller;

  /// Callback when the letter is selected.
  final void Function(BuildContext context, String? letter)?
      onSelectLetterChanged;

  /// Whether to enable sorting, the default is true
  final bool enableSorting;

  /// Whether to display the alphabetical indicator, the default is true
  final bool showAlphabeticalIndicator;

  /// The special alphabetical letter, the default is '#'
  final String specialAlphabeticalLetter;

  /// The alphabetical order of the list, the default is 'A-Z'.
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
      enableSorting: widget.enableSorting,
      showAlphabeticalIndicator: widget.showAlphabeticalIndicator,
      onSelectLetterChanged: widget.onSelectLetterChanged,
      beforeWidgets: widget.beforeWidgets,
      listViewHasSearchBar: widget.enableSearchBar,
      specialAlphabeticalLetter: widget.specialAlphabeticalLetter,
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
          background: widget.emptyBackground,
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
          searchBarHideText: widget.searchBarHideText,
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
