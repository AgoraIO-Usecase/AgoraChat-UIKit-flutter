import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupAddMembersViewArguments implements ChatUIKitViewArguments {
  GroupAddMembersViewArguments({
    required this.groupId,
    this.controller,
    this.appBarModel,
    this.onSearchTap,
    this.itemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchBarHideText,
    this.listViewBackground,
    this.inGroupMembers,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
  });

  final String groupId;
  final List<ChatUIKitProfile>? inGroupMembers;
  final ContactListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  GroupAddMembersViewArguments copyWith({
    String? groupId,
    List<ChatUIKitProfile>? inGroupMembers,
    ContactListViewController? controller,
    ChatUIKitAppBarModel? appBarModel,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? itemBuilder,
    void Function(BuildContext context, ContactItemModel model)? onTap,
    void Function(BuildContext context, ContactItemModel model)? onLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    bool? enableAppBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return GroupAddMembersViewArguments(
      groupId: groupId ?? this.groupId,
      inGroupMembers: inGroupMembers ?? this.inGroupMembers,
      controller: controller ?? this.controller,
      appBarModel: appBarModel ?? this.appBarModel,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
