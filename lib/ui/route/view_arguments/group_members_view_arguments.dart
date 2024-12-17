import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupMembersViewArguments implements ChatUIKitViewArguments {
  GroupMembersViewArguments({
    required this.profile,
    this.controller,
    this.appBarModel,
    this.onSearchTap,
    this.itemBuilder,
    this.onTap,
    this.onLongPress,
    this.searchBarHideText,
    this.listViewBackground,
    this.loadErrorMessage,
    this.enableAppBar = true,
    this.viewObserver,
    this.attributes,
    this.onSelectLetterChanged,
    this.sortAlphabetical,
    this.universalAlphabeticalLetter = '#',
  });

  final ChatUIKitProfile profile;
  final GroupMemberListViewController? controller;
  final ChatUIKitAppBarModel? appBarModel;
  final void Function(List<ContactItemModel> data)? onSearchTap;

  final ChatUIKitContactItemBuilder? itemBuilder;
  final void Function(BuildContext context, ContactItemModel model)? onTap;
  final void Function(BuildContext context, ContactItemModel model)?
      onLongPress;
  final String? searchBarHideText;
  final Widget? listViewBackground;
  final String? loadErrorMessage;
  final bool enableAppBar;
  final void Function(BuildContext context, String? letter)?
      onSelectLetterChanged;

  /// 通讯录列表的字母排序默认字，默认为 '#'
  final String universalAlphabeticalLetter;

  /// 字母排序
  final String? sortAlphabetical;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  GroupMembersViewArguments copyWith({
    ChatUIKitProfile? profile,
    GroupMemberListViewController? controller,
    ChatUIKitAppBarModel? appBarModel,
    void Function(List<ContactItemModel> data)? onSearchTap,
    ChatUIKitContactItemBuilder? itemBuilder,
    void Function(BuildContext context, ContactItemModel model)? onTap,
    void Function(BuildContext context, ContactItemModel model)? onLongPress,
    String? searchBarHideText,
    Widget? listViewBackground,
    String? loadErrorMessage,
    bool? enableMemberOperation,
    bool? enableAppBar,
    ChatUIKitViewObserver? viewObserver,
    String? universalAlphabeticalLetter,
    String? sortAlphabetical,
    Function(BuildContext context, String? letter)? onSelectLetterChanged,
    String? attributes,
  }) {
    return GroupMembersViewArguments(
      profile: profile ?? this.profile,
      controller: controller ?? this.controller,
      appBarModel: appBarModel ?? this.appBarModel,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      loadErrorMessage: loadErrorMessage ?? this.loadErrorMessage,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      onSelectLetterChanged:
          onSelectLetterChanged ?? this.onSelectLetterChanged,
      universalAlphabeticalLetter:
          universalAlphabeticalLetter ?? this.universalAlphabeticalLetter,
      sortAlphabetical: sortAlphabetical ?? this.sortAlphabetical,
      attributes: attributes ?? this.attributes,
    );
  }
}
