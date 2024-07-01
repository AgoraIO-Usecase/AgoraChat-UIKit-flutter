import '../../../../../chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitCardBubbleWidget extends StatelessWidget {
  const ChatUIKitCardBubbleWidget({
    required this.model,
    this.forceLeft,
    super.key,
  });

  final MessageModel model;
  final bool? forceLeft;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    bool left =
        forceLeft ?? model.message.direction == MessageDirection.RECEIVE;

    Widget content = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 12, 12, 12),
          child: ChatUIKitAvatar(
            avatarUrl: model.message.cardUserAvatar,
            size: 44,
          ),
        ),
        Expanded(
          child: Text(
            () {
              if (model.message.cardUserNickname?.isNotEmpty == true) {
                return model.message.cardUserNickname!;
              } else {
                return model.message.cardUserId!;
              }
            }(),
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              fontWeight: theme.font.titleMedium.fontWeight,
              fontSize: theme.font.titleMedium.fontSize,
              color: left
                  ? theme.color.isDark
                      ? theme.color.neutralColor98
                      : theme.color.neutralColor1
                  : theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
            ),
          ),
        )
      ],
    );

    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        content,
        Divider(
          height: 1,
          thickness: 0,
          color: left
              ? theme.color.isDark
                  ? theme.color.neutralSpecialColor5
                  : theme.color.neutralSpecialColor8
              : theme.color.isDark
                  ? theme.color.primaryColor9
                  : theme.color.primaryColor8,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            ChatUIKitLocal.messageListItemContactCard.localString(context),
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: theme.font.bodyExtraSmall.fontWeight,
              fontSize: theme.font.bodyExtraSmall.fontSize,
              color: left
                  ? theme.color.isDark
                      ? theme.color.neutralSpecialColor7
                      : theme.color.neutralSpecialColor5
                  : theme.color.isDark
                      ? theme.color.neutralSpecialColor3
                      : theme.color.neutralSpecialColor98,
            ),
          ),
        )
      ],
    );
    return content;
  }
}
