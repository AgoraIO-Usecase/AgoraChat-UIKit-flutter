import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupMentionViewArguments implements ChatUIKitViewArguments {
  GroupMentionViewArguments({
    required this.groupId,
    this.controller,
    this.appBarModel,
    this.onSearchTap,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchBarHideText,
    this.listViewBackground,
    this.enableAppBar = true,
    this.title,
    this.viewObserver,
    this.attributes,
    this.appBarTrailingActionsBuilder,
  });

  final String groupId;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? listViewItemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final bool enableAppBar;
  final String? title;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;
  final ChatUIKitAppBarActionsBuilder? appBarTrailingActionsBuilder;
  GroupMentionViewArguments copyWith(
      {String? groupId,
      GroupMemberListViewController? controller,
      ChatUIKitAppBarModel? appBarModel,
      void Function(List<ContactItemModel> data)? onSearchTap,
      ChatUIKitContactItemBuilder? listViewItemBuilder,
      void Function(BuildContext context, ContactItemModel model)? onTap,
      void Function(BuildContext context, ContactItemModel model)? onLongPress,
      String? searchBarHideText,
      Widget? listViewBackground,
      bool? enableAppBar,
      String? title,
      ChatUIKitViewObserver? viewObserver,
      String? attributes,
      ChatUIKitAppBarActionsBuilder? appBarTrailingActionsBuilder}) {
    return GroupMentionViewArguments(
      groupId: groupId ?? this.groupId,
      controller: controller ?? this.controller,
      appBarModel: appBarModel ?? this.appBarModel,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      title: title ?? this.title,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
      appBarTrailingActionsBuilder:
          appBarTrailingActionsBuilder ?? this.appBarTrailingActionsBuilder,
    );
  }
}
