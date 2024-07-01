import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class NewRequestsViewArguments implements ChatUIKitViewArguments {
  NewRequestsViewArguments({
    this.controller,
    this.appBarModel,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchBarHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
  });

  final NewRequestListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<NewRequestItemModel> data)? onSearchTap;
  final ChatUIKitNewRequestItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, NewRequestItemModel model)? onTap;
  final void Function(BuildContext context, NewRequestItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  NewRequestsViewArguments copyWith({
    NewRequestListViewController? controller,
    ChatUIKitAppBarModel? appBarModel,
    void Function(List<NewRequestItemModel> data)? onSearchTap,
    ChatUIKitNewRequestItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, NewRequestItemModel model)? onTap,
    void Function(BuildContext context, NewRequestItemModel model)? onLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    String? loadErrorMessage,
    bool? enableAppBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return NewRequestsViewArguments(
      controller: controller ?? this.controller,
      appBarModel: appBarModel ?? this.appBarModel,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      loadErrorMessage: loadErrorMessage ?? this.loadErrorMessage,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
