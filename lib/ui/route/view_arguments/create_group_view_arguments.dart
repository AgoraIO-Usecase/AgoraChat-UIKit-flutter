import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class CreateGroupViewArguments implements ChatUIKitViewArguments {
  CreateGroupViewArguments({
    this.itemBuilder,
    this.onSearchTap,
    this.searchBarHideText,
    this.listViewBackground,
    this.onItemTap,
    this.onItemLongPress,
    this.appBarModel,
    this.controller,
    this.enableAppBar = true,
    this.createGroupHandler,
    this.createGroupInfo,
    this.title,
    this.viewObserver,
    this.attributes,
  });

  final ContactListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(ContactItemModel model)? onItemTap;
  final void Function(ContactItemModel model)? onItemLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final CreateGroupHandler? createGroupHandler;
  final CreateGroupInfo? createGroupInfo;
  final String? title;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  CreateGroupViewArguments copyWith({
    ContactListViewController? controller,
    ChatUIKitAppBarModel? appBarModel,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? itemBuilder,
    void Function(ContactItemModel model)? onItemTap,
    void Function(ContactItemModel model)? onItemLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    bool? enableAppBar,
    CreateGroupHandler? createGroupHandler,
    CreateGroupInfo? createGroupInfo,
    void Function(Group? group, ChatError? error)? onCreateGroup,
    String? title,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return CreateGroupViewArguments(
      controller: controller ?? this.controller,
      appBarModel: appBarModel ?? this.appBarModel,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      onItemTap: onItemTap ?? this.onItemTap,
      onItemLongPress: onItemLongPress ?? this.onItemLongPress,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      createGroupHandler: createGroupHandler ?? this.createGroupHandler,
      createGroupInfo: createGroupInfo ?? this.createGroupInfo,
      title: title ?? this.title,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
