import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class MessagesViewArguments implements ChatUIKitViewArguments {
  MessagesViewArguments({
    required this.profile,
    this.controller,
    ChatUIKitAppBarModel? appBarModel,
    this.inputBar,
    this.showMessageItemAvatar,
    this.showMessageItemNickname,
    this.onItemTap,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onAvatarLongPress,
    this.onNicknameTap,
    this.emojiWidget,
    this.itemBuilder,
    this.alertItemBuilder,
    this.morePressActions,
    this.replyBarBuilder,
    this.quoteBuilder,
    this.onErrorBtnTapHandler,
    this.bubbleBuilder,
    this.enableAppBar = true,
    this.bubbleContentBuilder,
    this.onMoreActionsItemsHandler,
    this.onItemLongPressHandler,
    this.inputBarTextEditingController,
    this.forceLeft,
    this.multiSelectBottomBar,
    this.viewObserver,
    this.attributes,
    this.onReactionItemTap,
    this.onReactionInfoTap,
    this.reactionItemsBuilder,
    this.onThreadItemTap,
    this.threadItemBuilder,
  }) {
    this.appBarModel = appBarModel ?? ChatUIKitAppBarModel(centerTitle: false);
  }

  /// 用户信息对象，用于设置对方信息。详细参考 [ChatUIKitProfile]。
  ChatUIKitProfile profile;

  /// 消息列表控制器，用于控制消息列表和收发消息等，如果不设置将会自动创建。详细参考 [MessagesViewController]。
  MessagesViewController? controller;

  late ChatUIKitAppBarModel appBarModel;

  /// 是否显示AppBar, 默认为 `true`。 当为 `false` 时将不会显示AppBar。同时也会影响到是否显示标题。
  final bool enableAppBar;

  /// 自定义输入框, 如果设置后将会替换默认的输入框。详细参考 [ChatUIKitInputBar]。
  final Widget? inputBar;

  /// 是否显示头像, 默认为 `true`。 如果设置为 `false` 将不会显示头像。
  final MessageItemShowHandler? showMessageItemAvatar;

  /// 是否显示昵称, 默认为 `true`。如果设置为 `false` 将不会显示昵称。
  final MessageItemShowHandler? showMessageItemNickname;

  /// 消息点击事件, 如果设置后消息点击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onItemTap;

  /// 消息双击事件,如果设置后消息双击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onDoubleTap;

  /// 头像点击事件，如果设置后头像点击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onAvatarTap;

  /// 头像长按事件，如果设置后头像长按事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onAvatarLongPress;

  /// 昵称点击事件， 如果设置后昵称点击事件将直接回调，如果不处理可以返回 `false`。
  final MessageItemTapHandler? onNicknameTap;

  /// 消息 `item` 构建器, 如果设置后需要显示消息时会直接回调，如果不处理可以返回 `null`。
  final MessageItemBuilder? itemBuilder;

  /// 提示消息构建器， 如果设置后需要显示提示消息时会直接回调，如果不处理可以返回 `null`。
  final MessageItemBuilder? alertItemBuilder;

  /// 更多按钮点击事件列表，如果设置后将会替换默认的更多按钮点击事件列表。详细参考 [ChatUIKitBottomSheetAction]。
  final List<ChatUIKitBottomSheetAction>? morePressActions;

  /// 更多按钮点击事件， 如果设置后将会替换默认的更多按钮点击事件。详细参考 [ChatUIKitBottomSheetAction]。
  final MessagesViewMorePressHandler? onMoreActionsItemsHandler;

  /// 消息长按事件回调， 如果设置后将会替换默认的消息长按事件回调。
  final MessagesViewItemLongPressHandler? onItemLongPressHandler;

  /// 强制消息靠左，默认为 `false`， 设置后自己发的消息也会在左侧显示。
  final bool? forceLeft;

  /// 表情控件，如果设置后将会替换默认的表情控件。详细参考 [ChatUIKitInputEmojiBar]。
  final Widget? emojiWidget;

  /// 回复消息输入控件构建器，如果设置后将会替换默认的回复消息输入控件构建器。详细参考 [ChatUIKitReplyBar]。
  final MessageItemBuilder? replyBarBuilder;

  /// 引用消息构建器，如果设置后将会替换默认的引用消息样式。
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;

  /// 错误消息点击事件，如果设置后将会替换默认的错误消息点击事件。如果不处理可以返回 `false`。默认行为为重新发送消息。
  final MessageItemTapHandler? onErrorBtnTapHandler;

  /// 气泡构建器，如果设置后将会替换默认的气泡构建器。详细参考 [MessageItemBubbleBuilder]。
  final MessageItemBubbleBuilder? bubbleBuilder;

  /// 气泡内容构建器，如果设置后将会替换默认的气泡内容构建器。详细参考 [MessageItemBuilder]。
  final MessageItemBuilder? bubbleContentBuilder;

  /// 输入框控制器，如果设置后将会替换默认的输入框控制器。详细参考 [CustomTextEditingController]。
  final ChatUIKitInputBarController? inputBarTextEditingController;

  /// 多选消息时显示的bottom bar.
  final Widget? multiSelectBottomBar;

  final MessageReactionItemTapHandler? onReactionItemTap;

  final MessageItemTapHandler? onReactionInfoTap;

  final MessageItemBuilder? reactionItemsBuilder;

  final MessageItemTapHandler? onThreadItemTap;

  final MessageItemBuilder? threadItemBuilder;

  /// View 附加属性，设置后的内容将会带入到下一个页面。
  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  MessagesViewArguments copyWith({
    /// 用户信息对象，用于设置对方信息。详细参考 [ChatUIKitProfile]。
    ChatUIKitProfile? profile,

    /// 消息列表控制器，用于控制消息列表和收发消息等，如果不设置将会自动创建。详细参考 [MessagesViewController]。
    MessagesViewController? controller,
    ChatUIKitAppBarModel? appBarModel,

    /// 自定义输入框, 如果设置后将会替换默认的输入框。详细参考 [ChatUIKitInputBar]。
    Widget? inputBar,

    /// 是否显示头像, 默认为 `true`。 如果设置为 `false` 将不会显示头像。 默认为 `true`。
    MessageItemShowHandler? showMessageItemAvatar,

    /// 是否显示昵称, 默认为 `true`。如果设置为 `false` 将不会显示昵称。 默认为 `true`。
    MessageItemShowHandler? showMessageItemNickname,

    /// 消息点击事件, 如果设置后消息点击事件将直接回调，如果不处理可以返回 `false`。
    MessageItemTapHandler? onItemTap,

    /// 消息双击事件,如果设置后消息双击事件将直接回调，如果不处理可以返回 `false`。
    MessageItemTapHandler? onDoubleTap,

    /// 头像点击事件，如果设置后头像点击事件将直接回调，如果不处理可以返回 `false`。
    MessageItemTapHandler? onAvatarTap,

    /// 头像长按事件，如果设置后头像长按事件将直接回调，如果不处理可以返回 `false`。
    MessageItemTapHandler? onAvatarLongPress,

    /// 昵称点击事件， 如果设置后昵称点击事件将直接回调，如果不处理可以返回 `false`。
    MessageItemTapHandler? onNicknameTap,

    /// 更多按钮点击事件列表，如果设置后将会替换默认的更多按钮点击事件列表。详细参考 [ChatUIKitBottomSheetAction]。
    List<ChatUIKitBottomSheetAction>? morePressActions,
    MessageItemBuilder? itemBuilder,
    MessageItemBuilder? alertItemBuilder,
    FocusNode? focusNode,
    Widget? emojiWidget,
    Widget? Function(BuildContext context, MessageModel model)? replyBarBuilder,
    Widget Function(BuildContext context, QuoteModel model)? quoteBuilder,
    bool Function(BuildContext context, MessageModel message)?
        onErrorBtnTapHandler,
    MessageItemBubbleBuilder? bubbleBuilder,
    MessageItemBuilder? bubbleContentBuilder,
    MessagesViewMorePressHandler? onMoreActionsItemsHandler,
    MessagesViewItemLongPressHandler? onItemLongPressHandler,
    ChatUIKitInputBarController? inputBarTextEditingController,
    bool? enableAppBar,
    bool? forceLeft,
    Widget? multiSelectBottomBar,
    ChatUIKitViewObserver? viewObserver,
    String? attributes,
    MessageReactionItemTapHandler? onReactionItemTap,
    MessageItemTapHandler? onReactionInfoTap,
    MessageItemBuilder? reactionItemsBuilder,
    MessageItemTapHandler? onThreadItemTap,
    MessageItemBuilder? threadItemBuilder,
  }) {
    return MessagesViewArguments(
      profile: profile ?? this.profile,
      controller: controller ?? this.controller,
      appBarModel: appBarModel ?? this.appBarModel,
      inputBar: inputBar ?? this.inputBar,
      showMessageItemAvatar:
          showMessageItemAvatar ?? this.showMessageItemAvatar,
      showMessageItemNickname:
          showMessageItemNickname ?? this.showMessageItemNickname,
      onItemTap: onItemTap ?? this.onItemTap,
      onDoubleTap: onDoubleTap ?? this.onDoubleTap,
      onAvatarTap: onAvatarTap ?? this.onAvatarTap,
      onAvatarLongPress: onAvatarLongPress ?? this.onAvatarLongPress,
      onNicknameTap: onNicknameTap ?? this.onNicknameTap,
      morePressActions: morePressActions ?? this.morePressActions,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      alertItemBuilder: alertItemBuilder ?? this.alertItemBuilder,
      emojiWidget: emojiWidget ?? this.emojiWidget,
      replyBarBuilder: replyBarBuilder ?? this.replyBarBuilder,
      quoteBuilder: quoteBuilder ?? this.quoteBuilder,
      onErrorBtnTapHandler: onErrorBtnTapHandler ?? this.onErrorBtnTapHandler,
      bubbleBuilder: bubbleBuilder ?? this.bubbleBuilder,
      bubbleContentBuilder: bubbleContentBuilder ?? this.bubbleContentBuilder,
      onMoreActionsItemsHandler:
          onMoreActionsItemsHandler ?? this.onMoreActionsItemsHandler,
      onItemLongPressHandler:
          onItemLongPressHandler ?? this.onItemLongPressHandler,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      inputBarTextEditingController:
          inputBarTextEditingController ?? this.inputBarTextEditingController,
      forceLeft: forceLeft ?? this.forceLeft,
      multiSelectBottomBar: multiSelectBottomBar ?? this.multiSelectBottomBar,
      viewObserver: viewObserver ?? this.viewObserver,
      attributes: attributes ?? this.attributes,
      onReactionItemTap: onReactionItemTap ?? this.onReactionItemTap,
      onReactionInfoTap: onReactionInfoTap ?? this.onReactionInfoTap,
      reactionItemsBuilder: reactionItemsBuilder ?? this.reactionItemsBuilder,
      onThreadItemTap: onThreadItemTap ?? this.onThreadItemTap,
      threadItemBuilder: threadItemBuilder ?? this.threadItemBuilder,
    );
  }
}
