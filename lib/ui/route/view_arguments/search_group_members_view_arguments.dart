import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class SearchGroupMembersViewArguments implements ChatUIKitViewArguments {
  SearchGroupMembersViewArguments({
    required this.searchData,
    required this.searchHideText,
    this.onTap,
    this.itemBuilder,
    this.appBarModel,
    this.enableAppBar = false,
    this.viewObserver,
    this.attributes,
  });

  final List<NeedSearch> searchData;
  final String searchHideText;
  final void Function(BuildContext context, ChatUIKitProfile profile)? onTap;
  final Widget Function(BuildContext context, ChatUIKitProfile profile,
      String? searchKeyword)? itemBuilder;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  SearchGroupMembersViewArguments copyWith(
      {List<NeedSearch>? searchData,
      String? searchHideText,
      void Function(BuildContext context, ChatUIKitProfile profile)? onTap,
      Widget Function(BuildContext context, ChatUIKitProfile profile,
              String? searchKeyword)?
          itemBuilder,
      ChatUIKitAppBarModel? appBarModel,
      bool? enableAppBar,
      ChatUIKitViewObserver? viewObserver,
      String? attributes,
      ChatUIKitAppBarActionsBuilder? appBarTrailingActionsBuilder}) {
    return SearchGroupMembersViewArguments(
      searchData: searchData ?? this.searchData,
      searchHideText: searchHideText ?? this.searchHideText,
      onTap: onTap ?? this.onTap,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      appBarModel: appBarModel ?? this.appBarModel,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
    );
  }
}
