import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

/// 会话列表构建参数
class ConversationsViewArguments implements ChatUIKitViewArguments {
  ConversationsViewArguments({
    this.controller,
    this.appBarModel,
    this.onSearchTap,
    this.beforeWidgets,
    this.afterWidgets,
    this.listViewItemBuilder,
    this.onTap,
    this.onLongPressHandler,
    this.searchBarHideText,
    this.listViewBackground,
    this.enableAppBar = true,
    this.enableSearchBar = true,
    this.viewObserver,
    this.moreActionsBuilder,
    this.attributes,
  });

  /// 会话列表控制器，用户管理会话列表数据，如果不设置将会自动创建。详细参考 [ConversationListViewController]。
  final ConversationListViewController? controller;

  final ChatUIKitAppBarModel? appBarModel;

  /// 点击搜索按钮的回调，点击后会把当前的会话列表数据传递过来。如果不设置默认会跳转到搜索页面。具体参考 [SearchView]。
  final void Function(List<ConversationItemModel> data)? onSearchTap;

  /// 会话列表之前的数据。
  final List<Widget>? beforeWidgets;

  /// 会话列表之后的数据。
  final List<Widget>? afterWidgets;

  /// 会话列表的 `item` 构建器，如果设置后需要显示会话时会直接回调，如果不处理可以返回 `null`。
  final ConversationItemBuilder? listViewItemBuilder;

  /// 点击会话列表的回调，点击后会把当前的会话数据传递过来。具体参考 [ConversationItemModel]。 如果不是设置默认会跳转到消息页面。具体参考 [MessagesView]。
  final void Function(BuildContext context, ConversationItemModel info)? onTap;

  /// 长按会话列表的回调，如果不设置默认会弹出默认的长按菜单。如果设置长按时会把默认的弹出菜单项传给你，你需要调整后返回来，返回来的数据会用于菜单显示，如果返回 `null` 将不会显示菜单。
  final ConversationsViewItemLongPressHandler? onLongPressHandler;

  /// 会话搜索框的隐藏文字。
  final String? searchBarHideText;

  /// 是否开启搜索框，默认为 `true`。如果设置为 `false` 将不会显示搜索框。
  final bool enableSearchBar;

  /// 会话列表的背景，会话为空时会显示，如果设置后将会替换默认的背景。
  final Widget? listViewBackground;

  /// 是否显示AppBar, 默认为 `true`。 当为 `false` 时将不会显示AppBar。同时也会影响到是否显示标题。
  final bool enableAppBar;

  /// View 附加属性，设置后的内容将会带入到下一个页面。
  @override
  String? attributes;
  @override
  ChatUIKitViewObserver? viewObserver;

  final ChatUIKitMoreActionsBuilder? moreActionsBuilder;

  ConversationsViewArguments copyWith({
    ConversationListViewController? controller,
    ChatUIKitAppBarModel? appBarModel,
    void Function(List<ConversationItemModel> data)? onSearchTap,
    List<NeedAlphabeticalWidget>? beforeWidgets,
    List<NeedAlphabeticalWidget>? afterWidgets,
    ChatUIKitListItemBuilder? listViewItemBuilder,
    void Function(BuildContext context, ConversationItemModel model)? onTap,
    ConversationsViewItemLongPressHandler? onLongPressHandler,
    String? searchBarHideText,
    Widget? listViewBackground,
    bool? enableAppBar,
    bool? enableSearchBar,
    ChatUIKitViewObserver? viewObserver,
    ChatUIKitMoreActionsBuilder? moreActionsBuilder,
    String? attributes,
  }) {
    return ConversationsViewArguments(
      controller: controller ?? this.controller,
      appBarModel: appBarModel ?? this.appBarModel,
      onSearchTap: onSearchTap ?? this.onSearchTap,
      beforeWidgets: beforeWidgets ?? this.beforeWidgets,
      afterWidgets: afterWidgets ?? this.afterWidgets,
      listViewItemBuilder: listViewItemBuilder ?? this.listViewItemBuilder,
      onTap: onTap ?? this.onTap,
      enableSearchBar: enableSearchBar ?? this.enableSearchBar,
      onLongPressHandler: onLongPressHandler ?? this.onLongPressHandler,
      searchBarHideText: searchBarHideText ?? this.searchBarHideText,
      listViewBackground: listViewBackground ?? this.listViewBackground,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
      moreActionsBuilder: moreActionsBuilder ?? this.moreActionsBuilder,
    );
  }
}
