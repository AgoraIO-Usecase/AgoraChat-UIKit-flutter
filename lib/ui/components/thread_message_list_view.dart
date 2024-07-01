import '../../chat_uikit.dart';
import '../../universal/inner_headers.dart';

import 'package:flutter/material.dart';

class ThreadMessageListView extends StatefulWidget {
  const ThreadMessageListView({
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
    this.header,
    super.key,
  });

  final ThreadMessagesViewController controller;
  final MessageItemTapHandler? onItemTap;
  final MessageItemTapHandler? onItemLongPress;
  final MessageItemTapHandler? onItemDoubleTap;
  final MessageItemTapHandler? onAvatarTap;
  final MessageItemTapHandler? onAvatarLongPressed;
  final MessageItemTapHandler? onNicknameTap;

  final MessageItemBuilder? itemBuilder;
  final MessageItemBuilder? alertItemBuilder;
  final MessageItemShowHandler? showAvatar;
  final MessageItemShowHandler? showNickname;
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;
  final void Function(MessageModel model)? onErrorBtnTap;
  final MessageItemBubbleBuilder? bubbleBuilder;
  final MessageItemBuilder? bubbleContentBuilder;
  final bool? forceLeft;
  final void Function(MessageModel model, MessageReaction reaction)?
      onReactionItemTap;
  final MessageItemTapHandler? onReactionInfoTap;
  final MessageItemBuilder? reactionItemsBuilder;
  final MessageItemTapHandler? onThreadItemTap;
  final MessageItemBuilder? threadItemBuilder;
  final AutoScrollController? scrollController;
  final Widget? header;

  @override
  State<ThreadMessageListView> createState() => _ThreadMessageListViewState();
}

class _ThreadMessageListViewState extends State<ThreadMessageListView> {
  late final ThreadMessagesViewController controller;
  late final AutoScrollController _scrollController;
  ChatUIKitTheme? theme;
  Size? size;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? AutoScrollController();
    controller = widget.controller;
    controller.addListener(() {
      setState(() {});
      // 滚动到最底部，暂时注释掉，因为如果首次load也会导致滚动到最底部，实际上首次获取时不应该滚动到最底部
      // if (controller.loadFinished) {
      //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      //     _scrollController.animateTo(
      //       _scrollController.position.maxScrollExtent,
      //       duration: const Duration(milliseconds: 100),
      //       curve: Curves.linear,
      //     );
      //   });
      // }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    theme ??= ChatUIKitTheme.of(context);
    size ??= MediaQuery.of(context).size;
    Widget content = CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      controller: _scrollController,
      cacheExtent: 1500,
      slivers: [
        if (widget.header != null)
          SliverToBoxAdapter(
            child: widget.header!,
          ),
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

    content = NotificationListener(
        child: content,
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            if (_scrollController.position.pixels -
                    _scrollController.position.maxScrollExtent >
                -1500) {
              controller.fetchItemList();
            }
          }
          return false;
        });

    content = Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      child: content,
    );

    return content;
  }

  Widget _item(MessageModel model, int index) {
    if (model.message.isTimeMessageAlert) {
      Widget? content = widget.alertItemBuilder?.call(
        context,
        model,
      );
      content ??= ChatUIKitMessageListViewAlertItem(
        infos: [
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
        model.message.isLeaveGroupAlert) {
      if (widget.alertItemBuilder != null) {
        return widget.alertItemBuilder!.call(context, model)!;
      }
    }

    Widget? content = widget.itemBuilder?.call(context, model);
    content ??= ChatUIKitMessageListViewMessageItem(
      enableThread: false,
      enableSelected: controller.isMultiSelectMode
          ? () {
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
            }
          : null,
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
        if (widget.onAvatarTap != null) {
          widget.onAvatarTap?.call(context, model);
        }
      },
      onAvatarLongPressed: () {
        widget.onAvatarLongPressed?.call(context, model);
      },
      onBubbleDoubleTap: () {
        widget.onItemDoubleTap?.call(context, model);
      },
      onBubbleLongPressed: () {
        widget.onItemLongPress?.call(context, model);
      },
      onBubbleTap: () {
        widget.onItemTap?.call(context, model);
      },
      onNicknameTap: () {
        widget.onNicknameTap?.call(context, model);
      },
      model: model,
      reactions: model.reactions,
      onReactionItemTap: (reaction) {
        widget.onReactionItemTap?.call(model, reaction);
      },
      onReactionInfoTap: () {
        widget.onReactionInfoTap?.call(context, model);
      },
      reactionItemsBuilder: widget.reactionItemsBuilder,
      threadItemBuilder: widget.threadItemBuilder,
      onThreadItemTap: () {
        widget.onThreadItemTap?.call(context, model);
      },
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
                      color: theme!.color.isDark
                          ? theme!.color.primaryColor6
                          : theme!.color.primaryColor5,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      size: 28,
                      color: theme!.color.isDark
                          ? theme!.color.neutralColor4
                          : theme!.color.neutralColor7,
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
      highlightColor: theme!.color.isDark
          ? theme!.color.neutralColor2
          : theme!.color.neutralColor95,
      child: content,
    );

    return content;
  }

  Widget quoteWidget(QuoteModel model, bool left) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        jumpToQuoteModel(model);
      },
      child: ChatUIKitQuoteWidget(
        model: model,
      ),
    );
  }

  void jumpToQuoteModel(QuoteModel model) async {
    int index = controller.msgModelList
        .indexWhere((element) => element.message.msgId == model.msgId);

    if (index != -1) {
      _scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.end,
        duration: const Duration(milliseconds: 10),
      );
      await _scrollController.scrollToIndex(
        index,
        preferPosition: AutoScrollPosition.end,
        duration: const Duration(milliseconds: 100),
      );

      await _scrollController.highlight(
        index,
        highlightDuration: const Duration(milliseconds: 500),
      );
    }
  }
}
