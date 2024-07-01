import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupMembersViewArguments implements ChatUIKitViewArguments {
  GroupMembersViewArguments({
    required this.profile,
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

  final ChatUIKitProfile profile;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  GroupMembersViewArguments copyWith({
    ChatUIKitProfile? profile,
    GroupMemberListViewController? controller,
    ChatUIKitAppBarModel? appBarModel,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ContactItemModel model)? onTap,
    void Function(BuildContext context, ContactItemModel model)? onLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    String? loadErrorMessage,
    bool? enableMemberOperation,
    bool? enableAppBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
  }) {
    return GroupMembersViewArguments(
      profile: profile ?? this.profile,
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
