import '../../../../chat_uikit.dart';
import 'package:flutter/material.dart';

class ChatUIKitConversationListViewItem extends StatelessWidget {
  const ChatUIKitConversationListViewItem(
    this.info, {
    this.titleWidget,
    this.showAvatar = true,
    this.unreadCount,
    this.showNewMessageTime = true,
    this.showTitle = true,
    this.showSubTitle = true,
    this.showUnreadCount = true,
    this.showNoDisturb = true,
    this.timestamp,
    super.key,
    this.subTitleLabel,
    this.beforeSubtitle,
    this.afterSubtitle,
  });

  final ConversationItemModel info;
  final bool showAvatar;
  final bool showNewMessageTime;
  final bool showTitle;
  final bool showSubTitle;
  final bool showUnreadCount;
  final bool showNoDisturb;
  final String? subTitleLabel;
  final String? unreadCount;
  final int? timestamp;
  final Widget? titleWidget;
  final Widget? beforeSubtitle;
  final Widget? afterSubtitle;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;

    Widget avatar = (showAvatar && ChatUIKitSettings.showConversationListAvatar)
        ? Container(
            margin: const EdgeInsets.only(right: 12),
            child: ChatUIKitAvatar(
              avatarUrl: info.avatarUrl,
              size: 50,
            ),
          )
        : const SizedBox();

    Widget title = titleWidget ??
        (showTitle
            ? Text(
                info.showName,
                textScaler: TextScaler.noScaling,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  color: theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1,
                  fontSize: theme.font.titleLarge.fontSize,
                  fontWeight: theme.font.titleLarge.fontWeight,
                ),
              )
            : const SizedBox());

    Widget muteType = showNoDisturb && info.noDisturb
        ? Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.fromLTRB(2, 1, 0, 1),
            alignment: Alignment.center,
            child: ChatUIKitSettings.conversationListMuteImage != null
                ? Image(image: ChatUIKitSettings.conversationListMuteImage!)
                : ChatUIKitImageLoader.noDisturb(
                    color: theme.color.isDark
                        ? theme.color.neutralColor5
                        : theme.color.neutralColor6),
          )
        : const SizedBox();

    Widget timeLabel = showNewMessageTime
        ? Text(
            ChatUIKitTimeFormatter.instance.formatterHandler?.call(
                    context,
                    ChatUIKitTimeType.conversation,
                    timestamp ?? info.lastMessage?.serverTime ?? 0) ??
                ChatUIKitTimeTool.getChatTimeStr(
                    timestamp ?? info.lastMessage?.serverTime ?? 0),
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
              fontSize: theme.font.bodySmall.fontSize,
              fontWeight: theme.font.bodySmall.fontWeight,
            ),
          )
        : const SizedBox();

    Widget titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(flex: 1, fit: FlexFit.loose, child: title),
        muteType,
      ],
    );

    titleRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Flexible(flex: 1, fit: FlexFit.tight, child: titleRow),
        const SizedBox(width: 8),
        timeLabel,
      ],
    );

    final style = TextStyle(
      color: theme.color.isDark
          ? theme.color.neutralColor6
          : theme.color.neutralColor5,
      fontSize: theme.font.labelMedium.fontSize,
      fontWeight: theme.font.labelMedium.fontWeight,
    );

    Widget? subTitle;
    if (!showSubTitle) {
      subTitle = const SizedBox();
    } else {
      subTitle = subTitleLabel?.isNotEmpty == true
          ? Text(
              subTitleLabel!,
              style: style,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.noScaling,
            )
          : Row(
              children: [
                RichText(
                  textScaler: TextScaler.noScaling,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    style: style,
                    children: [
                      if (info.hasMention)
                        TextSpan(
                            text:
                                '[${ChatUIKitLocal.conversationListItemMention.localString(context)}]',
                            style: () {
                              final style = TextStyle(
                                color: theme.color.isDark
                                    ? theme.color.primaryColor6
                                    : theme.color.primaryColor5,
                                fontSize: theme.font.labelMedium.fontSize,
                                fontWeight: theme.font.labelMedium.fontWeight,
                              );
                              return style;
                            }()),
                    ],
                  ),
                ),
                Expanded(
                  child: ChatUIKitEmojiRichText(
                    textScaler: TextScaler.noScaling,
                    text: info.lastMessage?.showInfoTranslate(
                          context,
                          needShowName: true,
                        ) ??
                        '',
                    emojiSize: const Size(16, 16),
                    style: style,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            );
    }
    subTitle = Row(
      children: [
        beforeSubtitle ?? const SizedBox(),
        Expanded(
          child: subTitle,
        ),
        afterSubtitle ?? const SizedBox()
      ],
    );

    Widget unreadCount;
    if (info.noDisturb) {
      unreadCount = showUnreadCount && info.unreadCount > 0
          ? Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.color.isDark
                    ? theme.color.primaryColor6
                    : theme.color.primaryColor5,
                borderRadius: BorderRadius.circular(4),
              ),
            )
          : const SizedBox();
      unreadCount = Center(
        child: unreadCount,
      );
    } else {
      unreadCount = showUnreadCount &&
              info.unreadCount > 0 &&
              ChatUIKitSettings.showConversationListUnreadCount == true
          ? ChatUIKitBadge(info.unreadCount)
          : const SizedBox();
    }

    unreadCount = SizedBox(
      height: 20,
      child: unreadCount,
    );

    Widget subTitleRow = Row(
      children: [
        Expanded(child: subTitle),
        unreadCount,
      ],
    );

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        avatar,
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              titleRow,
              subTitleRow,
            ],
          ),
        )
      ],
    );
    content = Container(
      padding: EdgeInsets.fromLTRB(
          (ChatUIKitSettings.showConversationListAvatar && showAvatar) ? 16 : 0,
          13,
          16,
          13),
      child: content,
    );

    content = Stack(
      children: [
        content,
        Positioned(
          bottom: 0,
          left: (ChatUIKitSettings.showConversationListAvatar && showAvatar)
              ? 16
              : 0 -
                  ((ChatUIKitSettings.showConversationListAvatar || showAvatar)
                      ? 60
                      : 0),
          right: 0,
          height: 0.5,
          child: Divider(
            height: borderHeight,
            thickness: borderHeight,
            color: theme.color.isDark
                ? theme.color.neutralColor2
                : theme.color.neutralColor9,
          ),
        )
      ],
    );

    return content;
  }
}
