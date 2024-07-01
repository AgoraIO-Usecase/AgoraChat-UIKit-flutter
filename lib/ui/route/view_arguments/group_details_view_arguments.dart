import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class GroupDetailsViewArguments implements ChatUIKitViewArguments {
  GroupDetailsViewArguments({
    required this.profile,
    this.actionsBuilder,
    this.appBarModel,
    this.enableAppBar = true,
    this.onMessageDidClear,
    this.viewObserver,
    this.detailsListViewItemsBuilder,
    this.moreActionsBuilder,
    this.attributes,
  });
  final ChatUIKitProfile profile;
  final ChatUIKitDetailContentActionsBuilder? actionsBuilder;
  final ChatUIKitAppBarModel? appBarModel;
  final bool enableAppBar;
  final VoidCallback? onMessageDidClear;
  final ChatUIKitDetailItemBuilder? detailsListViewItemsBuilder;

  /// 更多操作构建器，用于构建更多操作的菜单，如果不设置将会使用默认的菜单。
  final ChatUIKitMoreActionsBuilder? moreActionsBuilder;

  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  GroupDetailsViewArguments copyWith(
      {ChatUIKitProfile? profile,
      ChatUIKitDetailContentActionsBuilder? actionsBuilder,
      bool? enableAppBar,
      ChatUIKitAppBarModel? appBarModel,
      ChatUIKitDetailItemBuilder? detailsListViewItemsBuilder,
      ChatUIKitViewObserver? viewObserver,
      VoidCallback? onMessageDidClear,
      String? attributes,
      ChatUIKitMoreActionsBuilder? moreActionsBuilder}) {
    return GroupDetailsViewArguments(
      profile: profile ?? this.profile,
      actionsBuilder: actionsBuilder ?? this.actionsBuilder,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      appBarModel: appBarModel ?? this.appBarModel,
      onMessageDidClear: onMessageDidClear ?? this.onMessageDidClear,
      viewObserver: viewObserver ?? this.viewObserver,
      detailsListViewItemsBuilder:
          detailsListViewItemsBuilder ?? this.detailsListViewItemsBuilder,
      moreActionsBuilder: moreActionsBuilder ?? this.moreActionsBuilder,
      attributes: attributes ?? this.attributes,
    );
  }
}
