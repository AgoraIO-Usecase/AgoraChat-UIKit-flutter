import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ThreadMessagesViewArguments implements ChatUIKitViewArguments {
  ThreadMessagesViewArguments({
    this.inputBar,
    this.showMessageItemAvatar,
    this.showMessageItemNickname,
    this.onItemTap,
    this.onItemLongPress,
    this.onDoubleTap,
    this.onAvatarTap,
    this.onAvatarLongPress,
    this.onNicknameTap,
    this.itemBuilder,
    this.alertItemBuilder,
    this.onErrorBtnTapHandler,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.inputBarTextEditingController,
    this.multiSelectBottomBar,
    this.onReactionItemTap,
    this.onReactionInfoTap,
    this.reactionItemsBuilder,
    required this.controller,
    this.attributes,
    this.viewObserver,
    this.appBarModel,
    this.enableAppBar = true,
    this.inputBarController,
    this.morePressActions,
    this.onMoreActionsItemsHandler,
    this.longPressActions,
    this.onItemLongPressHandler,
    this.forceLeft,
    this.emojiWidget,
    this.replyBarBuilder,
    this.quoteBuilder,
    this.rightTopMoreActionsBuilder,
  });

  @override
  String? attributes;

  @override
  ChatUIKitViewObserver? viewObserver;

  final ChatUIKitInputBarController? inputBarController;

  final ThreadMessagesViewController controller;

  final ChatUIKitAppBarModel? appBarModel;

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

  /// 消息长按事件, 如果设置后消息长按事件将直接回调，返回 `true` 表示处理你需要处理，返回 `false` 则会执行默认的长按事件。
  final MessageItemTapHandler? onItemLongPress;

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

  /// 消息长按事件列表，如果设置后将会替换默认的消息长按事件列表。详细参考 [ChatUIKitBottomSheetAction]。
  final List<ChatUIKitBottomSheetAction>? longPressActions;

  /// 消息长按事件回调， 如果设置后将会替换默认的消息长按事件回调。当长按时会回调 [longPressActions] 中设置的事件，需要返回一个列表用于替换，如果不返回则不会显示长按。
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

  /// 多选时显示的 bottom bar
  final Widget? multiSelectBottomBar;

  final MessageReactionItemTapHandler? onReactionItemTap;

  final MessageItemTapHandler? onReactionInfoTap;

  final MessageItemBuilder? reactionItemsBuilder;

  /// 更多操作构建器，用于构建更多操作的菜单，如果不设置将会使用默认的菜单。
  final ChatUIKitMoreActionsBuilder? rightTopMoreActionsBuilder;

  ThreadMessagesViewArguments copyWith({
    ChatUIKitInputBarController? inputBarController,
    ThreadMessagesViewController? controller,
    ChatUIKitAppBarModel? appBarModel,
    bool? enableAppBar,
    Widget? inputBar,
    MessageItemShowHandler? showMessageItemAvatar,
    MessageItemShowHandler? showMessageItemNickname,
    MessageItemTapHandler? onItemTap,
    MessageItemTapHandler? onItemLongPress,
    MessageItemTapHandler? onDoubleTap,
    MessageItemTapHandler? onAvatarTap,
    MessageItemTapHandler? onAvatarLongPress,
    MessageItemTapHandler? onNicknameTap,
    MessageItemBuilder? itemBuilder,
    MessageItemBuilder? alertItemBuilder,
    List<ChatUIKitBottomSheetAction>? morePressActions,
    MessagesViewMorePressHandler? onMoreActionsItemsHandler,
    List<ChatUIKitBottomSheetAction>? longPressActions,
    MessagesViewItemLongPressHandler? onItemLongPressHandler,
    bool? forceLeft,
    Widget? emojiWidget,
    MessageItemBuilder? replyBarBuilder,
    Widget Function(BuildContext context, QuoteModel model)? quoteBuilder,
    MessageItemTapHandler? onErrorBtnTapHandler,
    MessageItemBubbleBuilder? bubbleBuilder,
    MessageItemBuilder? bubbleContentBuilder,
    ChatUIKitInputBarController? inputBarTextEditingController,
    Widget? multiSelectBottomBar,
    MessageReactionItemTapHandler? onReactionItemTap,
    MessageItemTapHandler? onReactionInfoTap,
    MessageItemBuilder? reactionItemsBuilder,
    String? attributes,
    ChatUIKitViewObserver? viewObserver,
    ChatUIKitMoreActionsBuilder? rightTopMoreActionsBuilder,
  }) {
    return ThreadMessagesViewArguments(
      inputBarController: inputBarController ?? this.inputBarController,
      controller: controller ?? this.controller,
      appBarModel: appBarModel ?? this.appBarModel,
      enableAppBar: enableAppBar ?? this.enableAppBar,
      inputBar: inputBar ?? this.inputBar,
      showMessageItemAvatar:
          showMessageItemAvatar ?? this.showMessageItemAvatar,
      showMessageItemNickname:
          showMessageItemNickname ?? this.showMessageItemNickname,
      onItemTap: onItemTap ?? this.onItemTap,
      onItemLongPress: onItemLongPress ?? this.onItemLongPress,
      onDoubleTap: onDoubleTap ?? this.onDoubleTap,
      onAvatarTap: onAvatarTap ?? this.onAvatarTap,
      onAvatarLongPress: onAvatarLongPress ?? this.onAvatarLongPress,
      onNicknameTap: onNicknameTap ?? this.onNicknameTap,
      itemBuilder: itemBuilder ?? this.itemBuilder,
      alertItemBuilder: alertItemBuilder ?? this.alertItemBuilder,
      morePressActions: morePressActions ?? this.morePressActions,
      onMoreActionsItemsHandler:
          onMoreActionsItemsHandler ?? this.onMoreActionsItemsHandler,
      longPressActions: longPressActions ?? this.longPressActions,
      onItemLongPressHandler:
          onItemLongPressHandler ?? this.onItemLongPressHandler,
      forceLeft: forceLeft ?? this.forceLeft,
      emojiWidget: emojiWidget ?? this.emojiWidget,
      replyBarBuilder: replyBarBuilder ?? this.replyBarBuilder,
      quoteBuilder: quoteBuilder ?? this.quoteBuilder,
      onErrorBtnTapHandler: onErrorBtnTapHandler ?? this.onErrorBtnTapHandler,
      bubbleBuilder: bubbleBuilder ?? this.bubbleBuilder,
      bubbleContentBuilder: bubbleContentBuilder ?? this.bubbleContentBuilder,
      inputBarTextEditingController:
          inputBarTextEditingController ?? this.inputBarTextEditingController,
      multiSelectBottomBar: multiSelectBottomBar ?? this.multiSelectBottomBar,
      onReactionItemTap: onReactionItemTap ?? this.onReactionItemTap,
      onReactionInfoTap: onReactionInfoTap ?? this.onReactionInfoTap,
      reactionItemsBuilder: reactionItemsBuilder ?? this.reactionItemsBuilder,
      attributes: attributes ?? this.attributes,
      viewObserver: viewObserver ?? this.viewObserver,
      rightTopMoreActionsBuilder:
          rightTopMoreActionsBuilder ?? this.rightTopMoreActionsBuilder,
    );
  }
}
