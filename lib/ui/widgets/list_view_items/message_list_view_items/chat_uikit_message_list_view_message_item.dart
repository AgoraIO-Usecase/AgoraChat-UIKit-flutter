import '../../../../chat_uikit.dart';
import '../../../../universal/inner_headers.dart';
import 'package:flutter/material.dart';

class ChatUIKitMessageListViewMessageItem extends StatelessWidget {
  const ChatUIKitMessageListViewMessageItem({
    required this.model,
    this.showAvatar,
    this.showNickname,
    this.messageWidget,
    this.avatarWidget,
    this.avatarSize = 32,
    this.nicknameWidget,
    this.onNicknameTap,
    this.onAvatarTap,
    this.onAvatarLongPressed,
    this.onBubbleTap,
    this.onBubbleLongPressed,
    this.onBubbleDoubleTap,
    this.forceLeft,
    this.isPlaying = false,
    this.quoteBuilder,
    this.onErrorBtnTap,
    this.bubbleBuilder,
    this.bubbleContentBuilder,
    this.reactionItemsBuilder,
    this.onReactionItemTap,
    this.onReactionInfoTap,
    this.onThreadItemTap,
    this.threadItemBuilder,
    this.enableSelected,
    this.reactions,
    this.enableThread = true,
    this.enableReaction = true,
    this.enableVoiceUnreadIcon = true,
    super.key,
  });

  final MessageModel model;
  final List<MessageReaction>? reactions;
  final MessageItemShowHandler? showAvatar;
  final MessageItemShowHandler? showNickname;
  final bool? forceLeft;
  final Widget? messageWidget;
  final Widget? avatarWidget;
  final double avatarSize;
  final Widget? nicknameWidget;
  final bool isPlaying;
  final bool enableThread;
  final bool enableReaction;
  final bool enableVoiceUnreadIcon;

  final VoidCallback? onAvatarTap;
  final VoidCallback? onAvatarLongPressed;
  final VoidCallback? onNicknameTap;
  final VoidCallback? onBubbleTap;
  final VoidCallback? onBubbleLongPressed;
  final VoidCallback? onBubbleDoubleTap;
  final VoidCallback? enableSelected;
  final Widget Function(BuildContext context, QuoteModel model)? quoteBuilder;
  final VoidCallback? onErrorBtnTap;
  final MessageItemBubbleBuilder? bubbleBuilder;
  final MessageItemBuilder? bubbleContentBuilder;
  final MessageItemBuilder? reactionItemsBuilder;
  final void Function(MessageReaction reaction)? onReactionItemTap;
  final VoidCallback? onReactionInfoTap;
  final VoidCallback? onThreadItemTap;
  final MessageItemBuilder? threadItemBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);

    bool left =
        forceLeft ?? model.message.direction == MessageDirection.RECEIVE;

    Widget? msgWidget = messageWidget;

    if (model.message.bodyType == MessageType.TXT) {
      Widget textWidget = _buildTextMessage(context, model, left);
      if (model.message.textContent.hasURL() &&
          ChatUIKitURLHelper().isFetching(model.message.msgId)) {
        textWidget = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWidget,
            Text(
              ChatUIKitLocal.messageTextWidgetURLPreviewParsing
                  .getString(context),
              style: TextStyle(
                  color: theme.color.isDark
                      ? theme.color.neutralColor7
                      : theme.color.neutralColor5),
            ),
          ],
        );
      }
      msgWidget = textWidget;
    } else if (model.message.bodyType == MessageType.IMAGE) {
      msgWidget = _buildImageMessage(context, model, left);
    } else if (model.message.bodyType == MessageType.VOICE) {
      msgWidget = _buildVoiceMessage(context, model, left);
    } else if (model.message.bodyType == MessageType.VIDEO) {
      msgWidget = _buildVideoMessage(context, model, left);
    } else if (model.message.bodyType == MessageType.FILE) {
      msgWidget = _buildFileMessage(context, model, left);
    } else if (model.message.bodyType == MessageType.COMBINE) {
      msgWidget = _buildCombineMessage(context, model, left);
    } else if (model.message.bodyType == MessageType.CUSTOM) {
      if (model.message.isCardMessage) {
        msgWidget = _buildCardMessage(context, model, left);
      }
    }
    msgWidget ??= _buildNonsupportMessage(context, model, left);

    Widget bubbleWidget;

    if (model.message.bodyType == MessageType.VIDEO ||
        model.message.bodyType == MessageType.IMAGE) {
      bubbleWidget =
          bubbleBuilder?.call(context, msgWidget, model) ?? msgWidget;
    } else {
      bubbleWidget = bubbleBuilder?.call(context, msgWidget, model) ??
          ChatUIKitMessageBubbleWidget(
            key: ValueKey(model.message.localTime),
            needSmallCorner: model.message.getQuote == null,
            isLeft: left,
            child: msgWidget,
          );
    }

    if (model.message.bodyType == MessageType.VOICE) {
      bubbleWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          bubbleWidget,
          if (model.message.direction == MessageDirection.RECEIVE &&
              !(model.message.attributes?[voiceHasReadKey] == true) &&
              enableVoiceUnreadIcon)
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            )
        ],
      );
    }
    bubbleWidget = InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: enableSelected != null ? null : onBubbleTap,
      onDoubleTap: enableSelected != null ? null : onBubbleDoubleTap,
      onLongPress: enableSelected != null ? null : onBubbleLongPressed,
      child: bubbleWidget,
    );
    bool showAvatar = this.showAvatar?.call(model) ?? true;
    Widget avatar = _avatarWidget(theme, context, showAvatar);

    if (left == false ||
        (left == true && model.message.direction == MessageDirection.SEND)) {
      bubbleWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: left ? TextDirection.rtl : TextDirection.ltr,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: ChatUIKitMessageStatusWidget(
              onErrorBtnTap: onErrorBtnTap,
              size: 16,
              statusType: () {
                if (model.message.status == MessageStatus.PROGRESS) {
                  return MessageStatusType.loading;
                } else if (model.message.status == MessageStatus.CREATE ||
                    model.message.status == MessageStatus.FAIL) {
                  return MessageStatusType.fail;
                } else {
                  if (model.message.hasDeliverAck) {
                    return MessageStatusType.deliver;
                  } else if (model.message.hasReadAck) {
                    return MessageStatusType.read;
                  }
                  return MessageStatusType.succeed;
                }
              }(),
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            fit: FlexFit.loose,
            child: bubbleWidget,
          ),
        ],
      );
    }

    Widget avatarAndBubble = Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      textDirection: left ? TextDirection.ltr : TextDirection.rtl,
      children: [
        avatar,
        const SizedBox(width: 8),
        Flexible(
          fit: FlexFit.loose,
          child: bubbleWidget,
        ),
      ],
    );

    Widget item = Column(
      crossAxisAlignment:
          left ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        showNickname?.call(model) ?? true
            ? _nickname(theme, context, showAvatar, isLeft: left)
            : const SizedBox(),
        quoteWidget(context, model: model.message.getQuote, isLeft: left),
        Flexible(
          fit: FlexFit.loose,
          child: avatarAndBubble,
        ),
        if (model.reactions?.isNotEmpty == true) const SizedBox(height: 4),
        if (enableThread) threadWidget(context, theme, left),
        if (enableReaction) reactionsWidget(context, theme, left),
        timeWidget(context, theme, left),
      ],
    );

    item = Container(
      margin: const EdgeInsets.only(top: 16, bottom: 2),
      child: item,
    );

    if (enableSelected != null) {
      item = InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: enableSelected,
        child: item,
      );
    }

    return item;
  }

  Widget _buildTextMessage(
      BuildContext context, MessageModel model, bool isLeft) {
    return bubbleContentBuilder?.call(context, model) ??
        ChatUIKitTextBubbleWidget(model: model, forceLeft: isLeft);
  }

  Widget _buildImageMessage(
      BuildContext context, MessageModel model, bool isLeft) {
    return bubbleContentBuilder?.call(context, model) ??
        ChatUIKitImageBubbleWidget(
          model: model,
          isLeft: isLeft,
        );
  }

  Widget _buildVoiceMessage(
    BuildContext context,
    MessageModel model,
    bool isLeft,
  ) {
    Widget? content = bubbleContentBuilder?.call(context, model);
    content ??= ChatUIKitVoiceBubbleWidget(
      model: model,
      playing: isPlaying,
      forceLeft: isLeft,
    );

    return content;
  }

  Widget _buildVideoMessage(
      BuildContext context, MessageModel model, bool isLeft) {
    return bubbleContentBuilder?.call(context, model) ??
        ChatUIKitVideoBubbleWidget(
          model: model,
          forceLeft: isLeft,
        );
  }

  Widget _buildFileMessage(
      BuildContext context, MessageModel model, bool isLeft) {
    return bubbleContentBuilder?.call(context, model) ??
        ChatUIKitFileBubbleWidget(
          model: model,
          forceLeft: isLeft,
        );
  }

  Widget _buildCombineMessage(
      BuildContext context, MessageModel model, bool isLeft) {
    return bubbleContentBuilder?.call(context, model) ??
        ChatUIKitCombineBubbleWidget(
          model: model,
          forceLeft: isLeft,
        );
  }

  Widget _buildCardMessage(
      BuildContext context, MessageModel model, bool isLeft) {
    return bubbleContentBuilder?.call(context, model) ??
        ChatUIKitCardBubbleWidget(
          model: model,
          forceLeft: isLeft,
        );
  }

  Widget _buildNonsupportMessage(
      BuildContext context, MessageModel model, bool isLeft) {
    return bubbleContentBuilder?.call(context, model) ??
        ChatUIKitNonsupportMessageWidget(
          model: model,
          forceLeft: isLeft,
        );
  }

  Widget _avatarWidget(
      ChatUIKitTheme theme, BuildContext context, bool showAvatar) {
    Widget? content;
    if (showAvatar) {
      content = avatarWidget;
      if (content == null) {
        String? avatarUrl =
            ShareUserData.of(context)?.showAvatar(model.message.from!) ??
                model.message.avatarUrl;
        content = ChatUIKitAvatar(
          avatarUrl: avatarUrl,
          size: avatarSize,
        );
      }

      content = InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: enableSelected != null ? null : onAvatarTap,
        onLongPress: enableSelected != null ? null : onAvatarLongPressed,
        child: content,
      );
    } else {
      content = const SizedBox(width: 0, height: 0);
    }
    return content;
  }

  Widget _nickname(ChatUIKitTheme theme, BuildContext context, bool showAvatar,
      {bool isLeft = false}) {
    Widget content;
    if (showNickname?.call(model) ?? true) {
      String nickname =
          ShareUserData.of(context)?.showName(model.message.from!) ??
              model.message.from!;
      content = nicknameWidget ??
          Text(
            nickname,
            textScaler: TextScaler.noScaling,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: theme.font.labelSmall.fontWeight,
                fontSize: theme.font.labelSmall.fontSize,
                color: theme.color.isDark
                    ? theme.color.neutralSpecialColor6
                    : theme.color.neutralSpecialColor5),
          );

      content = InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: enableSelected != null ? null : onNicknameTap,
        child: content,
      );
      double padding =
          getArrowWidth + arrowPadding + (showAvatar ? avatarSize : 0);
      content = Padding(
        padding: EdgeInsets.only(
          left: isLeft ? padding : 0,
          right: !isLeft ? padding : 0,
        ),
        child: content,
      );
    } else {
      content = const SizedBox();
    }

    return content;
  }

  Widget quoteWidget(BuildContext context,
      {QuoteModel? model, bool isLeft = false}) {
    if (model == null) return const SizedBox();
    Widget? content = quoteBuilder?.call(context, model);
    double padding = getArrowWidth + avatarSize + arrowPadding;
    content = Padding(
      padding: EdgeInsets.only(
        left: isLeft ? padding : 0,
        right: !isLeft ? padding : 0,
      ),
      child: content,
    );

    return content;
  }

  Widget threadWidget(BuildContext context, ChatUIKitTheme theme, bool left) {
    if (model.thread == null) {
      return const SizedBox();
    } else {
      double arrowWidth = 0;
      if (model.message.bodyType != MessageType.IMAGE &&
          model.message.bodyType != MessageType.VIDEO) {
        arrowWidth = getArrowWidth;
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            left ? MainAxisAlignment.start : MainAxisAlignment.end,
        textDirection: left ? TextDirection.ltr : TextDirection.rtl,
        children: [
          SizedBox(width: arrowWidth + avatarSize + arrowPadding),
          Expanded(
            child: threadItemBuilder?.call(context, model) ??
                ChatUIKitMessageThreadWidget(
                  chatThread: model.thread!,
                  onTap: enableSelected != null ? null : onThreadItemTap,
                ),
          ),
        ],
      );
    }
  }

  Widget reactionsWidget(
    BuildContext context,
    ChatUIKitTheme theme,
    bool left,
  ) {
    if (reactions == null) {
      return const SizedBox();
    } else {
      double arrowWidth = 0;
      if (model.message.bodyType != MessageType.IMAGE &&
          model.message.bodyType != MessageType.VIDEO) {
        arrowWidth = getArrowWidth;
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment:
            left ? MainAxisAlignment.start : MainAxisAlignment.end,
        textDirection: left ? TextDirection.ltr : TextDirection.rtl,
        children: [
          SizedBox(width: arrowWidth + avatarSize + arrowPadding),
          Expanded(
            child: reactionItemsBuilder?.call(context, model) ??
                ChatUIKitMessageReactionsRow(
                  reactions: reactions!,
                  isLeft: left,
                  onReactionTap:
                      enableSelected != null ? null : onReactionItemTap,
                  onReactionInfoTap:
                      enableSelected != null ? null : onReactionInfoTap,
                ),
          ),
        ],
      );
    }
  }

  Widget timeWidget(BuildContext context, ChatUIKitTheme theme, bool left) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: left ? MainAxisAlignment.start : MainAxisAlignment.end,
      textDirection: left ? TextDirection.ltr : TextDirection.rtl,
      children: [
        SizedBox(width: getArrowWidth + avatarSize + arrowPadding),
        Text(
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                context,
                ChatUIKitTimeType.message,
                model.message.serverTime,
              ) ??
              ChatUIKitTimeTool.getChatTimeStr(model.message.serverTime,
                  needTime: true),
          style: TextStyle(
              fontWeight: theme.font.bodySmall.fontWeight,
              fontSize: theme.font.bodySmall.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor5
                  : theme.color.neutralColor7),
        ),
      ],
    );
  }

  double get getArrowWidth => ChatUIKitSettings.messageBubbleStyle ==
          ChatUIKitMessageListViewBubbleStyle.arrow
      ? arrowWidth
      : 0;
}
