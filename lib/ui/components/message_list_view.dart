import '../../chat_uikit.dart';

import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

/// The list view of the message.
/// This widget is used to display the list of messages.
class MessageListView extends StatefulWidget {
  const MessageListView({
    required this.controller,
    this.onItemLongPress,
    this.onItemDoubleTap,
    this.onItemTap,
    this.onAvatarTap,
    this.onAvatarLongPressed,
    this.onNicknameTap,
    this.showAvatar,
    this.showNickname,
    this.itemBuilder,
    this.alertItemBuilder,
    this.quoteBuilder,
    this.onErrorBtnTap,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.forceLeft,
    this.onReactionItemTap,
    this.onReactionInfoTap,
    this.reactionItemsBuilder,
    this.onThreadItemTap,
    this.threadItemBuilder,
    this.scrollController,
    super.key,
  });

  /// The controller of the list.
  final MessagesViewController controller;

  /// Callback when the list item is clicked.
  final MessageItemGlobalPositionTapHandler? onItemTap;

  /// Callback when the list item is long pressed.
  final MessageItemGlobalPositionTapHandler? onItemLongPress;

  /// Callback when the list item is double clicked.
  final MessageItemGlobalPositionTapHandler? onItemDoubleTap;

  /// Callback when the avatar is clicked.
  final MessageItemTapHandler? onAvatarTap;

  /// Callback when the avatar is long pressed.
  final MessageItemTapHandler? onAvatarLongPressed;

  /// Callback when the nickname is clicked.
  final MessageItemTapHandler? onNicknameTap;

  /// The builder of the list item.
  final MessageItemBuilder? itemBuilder;

  /// The builder of the alert item.
  final MessageItemBuilder? alertItemBuilder;

  /// The builder of need show avatar.
  final MessageItemShowHandler? showAvatar;

  /// The builder of need show nickname.
  final MessageItemShowHandler? showNickname;

  /// The builder of the quote item.
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;

  /// Callback when the error button is clicked.
  final void Function(MessageModel model)? onErrorBtnTap;

  /// The builder of the bubble.
  final MessageItemBubbleBuilder? bubbleBuilder;

  /// The builder of the bubble content.
  final MessageItemBuilder? bubbleContentBuilder;

  /// Whether to force the message to the left.
  final bool? forceLeft;

  /// Callback when the reaction item is clicked.
  final void Function(MessageModel model, MessageReaction reaction)?
      onReactionItemTap;

  /// Callback when the reaction info is clicked.
  final MessageItemTapHandler? onReactionInfoTap;

  /// The builder of the reaction items.
  final MessageItemBuilder? reactionItemsBuilder;

  /// Callback when the thread item is clicked.
  final MessageItemTapHandler? onThreadItemTap;

  /// The builder of the thread item.
  final MessageItemBuilder? threadItemBuilder;

  /// The scroll controller of the list.
  final AutoScrollController? scrollController;

  @override
  State<MessageListView> createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView>
    with ChatUIKitProviderObserver, ChatUIKitThemeMixin {
  late final MessagesViewController controller;
  late final AutoScrollController _scrollController;

  Size? size;

  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    _scrollController = widget.scrollController ?? AutoScrollController();
    controller = widget.controller;
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map) {
    controller.userMap.addAll(map);
    if (map.keys.contains(controller.profile.id)) {
      controller.profile = map[controller.profile.id]!;
    }
    setState(() {});
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    size ??= MediaQuery.of(context).size;
    Widget content = CustomScrollView(
      physics: controller.msgModelList.length > 30
          ? const AlwaysScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      controller: _scrollController,
      reverse: true,
      shrinkWrap: controller.msgModelList.length > 30 ? false : true,
      cacheExtent: 1500,
      slivers: [
        SliverPadding(
          padding: EdgeInsets.zero,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              findChildIndexCallback: (key) {
                if (key is ValueKey<String?> && key.value != null) {
                  final ValueKey<String?> valueKey = key;
                  int index = controller.msgModelList.indexWhere(
                    (model) => model.id == valueKey.value,
                  );
                  return index > -1 ? index : null;
                } else {
                  return null;
                }
              },
              (context, index) {
                return SizedBox(
                  key: ValueKey(controller.msgModelList[index].id),
                  child: _item(controller.msgModelList[index], index),
                );
              },
              childCount: controller.msgModelList.length,
            ),
          ),
        ),
      ],
    );
    content = Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: content,
    );

    // content = Scaffold(
    //   key: ValueKey(controller.profile.id),
    //   resizeToAvoidBottomInset: false,
    //   body: content,
    //   backgroundColor: Colors.red,
    // );

    return content;
  }

  Widget _item(MessageModel model, int index) {
    if (model.message.isTimeMessageAlert) {
      Widget? content = widget.alertItemBuilder?.call(
        context,
        model,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        actions: [
          MessageAlertAction(
            text: ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                    context,
                    ChatUIKitTimeType.message,
                    model.message.serverTime) ??
                ChatUIKitTimeTool.getChatTimeStr(
                  model.message.serverTime,
                  needTime: true,
                ),
          )
        ],
      );
      return content;
    }

    if (model.message.isRecallAlert ||
        model.message.isCreateGroupAlert ||
        model.message.isCreateThreadAlert ||
        model.message.isUpdateThreadAlert ||
        model.message.isDeleteThreadAlert ||
        model.message.isDestroyGroupAlert ||
        model.message.isKickedGroupAlert ||
        model.message.isNewContactAlert ||
        model.message.isPinAlert ||
        model.message.isUnPinAlert ||
        model.message.isLeaveGroupAlert) {
      if (widget.alertItemBuilder != null) {
        return widget.alertItemBuilder!.call(context, model)!;
      }
    }

    Widget? content = widget.itemBuilder?.call(context, model);
    content ??= ChatUIKitMessageListViewMessageItem(
      forceLeft: widget.forceLeft,
      bubbleContentBuilder: widget.bubbleContentBuilder,
      bubbleBuilder: widget.bubbleBuilder,
      onErrorBtnTap: () {
        widget.onErrorBtnTap?.call(model);
      },
      showAvatar: widget.showAvatar,
      quoteBuilder: (context, quoteModel) {
        Widget? content = widget.quoteBuilder?.call(context, quoteModel);
        content ??= quoteWidget(
            quoteModel,
            widget.forceLeft ??
                model.message.direction == MessageDirection.RECEIVE);
        return content;
      },
      showNickname: widget.showNickname,
      onAvatarTap: () {
        if (!controller.isMultiSelectMode) {
          if (widget.onAvatarTap != null) {
            widget.onAvatarTap?.call(context, model);
          }
        }
      },
      onAvatarLongPressed: () {
        if (!controller.isMultiSelectMode) {
          widget.onAvatarLongPressed?.call(context, model);
        }
      },
      onBubbleDoubleTap: (rect) {
        if (!controller.isMultiSelectMode) {
          widget.onItemDoubleTap?.call(context, model, rect);
        }
      },
      onBubbleLongPressed: (rect) {
        if (!controller.isMultiSelectMode) {
          widget.onItemLongPress?.call(context, model, rect);
        }
      },
      onBubbleTap: (rect) {
        if (controller.isMultiSelectMode) {
          if (controller.selectedMessages
              .map((e) => e.msgId)
              .toList()
              .contains(model.message.msgId)) {
            controller.selectedMessages
                .removeWhere((e) => model.message.msgId == e.msgId);
          } else {
            controller.selectedMessages.add(model.message);
          }
          setState(() {});
        } else {
          widget.onItemTap?.call(context, model, rect);
        }
      },
      onNicknameTap: () {
        if (!controller.isMultiSelectMode) {
          widget.onNicknameTap?.call(context, model);
        }
      },
      model: model,
      reactions: model.reactions,
      onReactionItemTap: (reaction) {
        if (!controller.isMultiSelectMode) {
          widget.onReactionItemTap?.call(model, reaction);
        }
      },
      onReactionInfoTap: () {
        if (!controller.isMultiSelectMode) {
          widget.onReactionInfoTap?.call(context, model);
        }
      },
      reactionItemsBuilder: widget.reactionItemsBuilder,
      threadItemBuilder: widget.threadItemBuilder,
      onThreadItemTap: () {
        if (!controller.isMultiSelectMode) {
          widget.onThreadItemTap?.call(context, model);
        }
      },
      // onItemTap: () {
      //   if (controller.isMultiSelectMode) {
      //     if (controller.selectedMessages
      //         .map((e) => e.msgId)
      //         .toList()
      //         .contains(model.message.msgId)) {
      //       controller.selectedMessages
      //           .removeWhere((e) => model.message.msgId == e.msgId);
      //     } else {
      //       controller.selectedMessages.add(model.message);
      //     }
      //     setState(() {});
      //   }
      // },
    );

    double zoom = 0.8;
    if (size!.width > size!.height) {
      zoom = 0.5;
    }

    content = SizedBox(
      width: size!.width * zoom,
      child: content,
    );

    content = Align(
      alignment: widget.forceLeft == true
          ? Alignment.centerLeft
          : model.message.direction == MessageDirection.SEND
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: content,
    );

    if (controller.isMultiSelectMode) {
      content = Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (controller.selectedMessages
                  .map((e) => e.msgId)
                  .toList()
                  .contains(model.message.msgId)) {
                controller.selectedMessages
                    .removeWhere((e) => e.msgId == model.message.msgId);
              } else {
                controller.selectedMessages.add(model.message);
              }
              setState(() {});
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 10, bottom: 20),
              child: controller.selectedMessages
                      .map((e) => e.msgId)
                      .toList()
                      .contains(model.message.msgId)
                  ? Icon(
                      Icons.check_box,
                      size: 28,
                      color: theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      size: 28,
                      color: theme.color.isDark
                          ? theme.color.neutralColor4
                          : theme.color.neutralColor7,
                    ),
            ),
          ),
          Expanded(child: content)
        ],
      );
    }

    content = AutoScrollTag(
      key: ValueKey(model.id),
      controller: _scrollController,
      index: index,
      highlightColor: theme.color.isDark
          ? theme.color.neutralColor2
          : theme.color.neutralColor95,
      child: content,
    );

    return content;
  }

  Widget quoteWidget(QuoteModel model, bool left) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () => jumpToMessage(model.msgId),
      child: ChatUIKitQuoteWidget(
        model: model,
        isLeft: left,
      ),
    );
  }

  void jumpToMessage(String? messageId,
      {AutoScrollPosition position = AutoScrollPosition.end}) async {
    int index = controller.msgModelList
        .indexWhere((element) => element.message.msgId == messageId);
    if (index == -1 || messageId == null) {
      ChatUIKit.instance
          .sendChatUIKitEvent(ChatUIKitEvent.targetMessageNotFound);
      return;
    }

    _scrollController.scrollToIndex(
      index,
      preferPosition: position,
      duration: const Duration(milliseconds: 10),
    );

    await _scrollController.scrollToIndex(
      index,
      preferPosition: position,
      duration: const Duration(milliseconds: 100),
    );

    await _scrollController.highlight(
      index,
      highlightDuration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(covariant MessageListView oldWidget) {
    if (controller != oldWidget.controller) {
      oldWidget.controller.dispose();
      controller.pinedMessages.value = oldWidget.controller.pinedMessages.value;
    }
    super.didUpdateWidget(oldWidget);
  }
}
