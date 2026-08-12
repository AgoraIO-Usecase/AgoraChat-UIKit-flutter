import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:agora_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:agora_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:agora_chat_uikit/chat_uikit_localizations/chat_uikit_localizations.dart';
import 'package:agora_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:agora_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';

class RoomMessageListItemManager {
  static Widget getMessageListItem(
    Message message,
    ChatUIKitProfile? user, {
    bool showTime = true,
    bool showIdentify = true,
    bool showAvatar = true,
    bool showNickname = true,
  }) {
    if (message.bodyType == MessageType.CUSTOM) {
      if (message.isChatRoomJoinNotify) {
        return RoomUserJoinMessageListItem(message, user,
            showTime: showTime,
            showIdentify: showIdentify,
            showAvatar: showAvatar,
            showNickname: showNickname);
      } else if (message.isChatRoomGift) {
        return RoomGiftMessageListItem(message, user,
            showTime: showTime,
            showIdentify: showIdentify,
            showAvatar: showAvatar,
            showNickname: showNickname);
      }
    } else if (message.bodyType == MessageType.TXT) {
      return RoomTextMessageListItem(message, user,
          showTime: showTime,
          showIdentify: showIdentify,
          showAvatar: showAvatar,
          showNickname: showNickname);
    }
    return RoomMessageListItem(message,
        user: user,
        showTime: showTime,
        showIdentify: showIdentify,
        showAvatar: showAvatar,
        showNickname: showNickname);
  }
}

class RoomMessageListItem extends StatefulWidget {
  const RoomMessageListItem(this.msg,
      {this.inlineSpan,
      this.user,
      this.showTime = true,
      this.showIdentify = true,
      this.showAvatar = true,
      this.showNickname = true,
      super.key});
  final Message msg;
  final ChatUIKitProfile? user;
  final InlineSpan? inlineSpan;
  final bool showTime;
  final bool showIdentify;
  final bool showAvatar;
  final bool showNickname;
  @override
  State<RoomMessageListItem> createState() => _RoomMessageListItemState();
}

class _RoomMessageListItemState extends State<RoomMessageListItem>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    List<InlineSpan> list = [];
    // time
    if (widget.showTime) {
      list.add(TextSpan(text: TimeTool.timeStrByMs(widget.msg.serverTime)));
    }

    ChatUIKitProfile? userProfile = widget.user ?? widget.msg.getUserInfo();
    if (widget.showIdentify) {
      if (userProfile?.identify?.isNotEmpty == true) {
        list.add(WidgetSpan(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7.5))),
            margin: const EdgeInsets.only(left: 4),
            width: 15,
            height: 15,
            child: ChatRoomImageLoader.roomNetworkImage(
              image: userProfile!.identify!,
              size: 15,
              placeholderWidget: (ChatUIKitSettings.roomDefaultIdentify == null)
                  ? Container()
                  : Image.asset(ChatUIKitSettings.roomDefaultIdentify!,
                      width: 15, height: 15),
            ),
          ),
          alignment: PlaceholderAlignment.middle,
        ));
      }
    }

    if (widget.showAvatar) {
      list.add(
        TextSpan(children: [
          WidgetSpan(
            child: ChatRoomUIKitAvatar(
              width: 18,
              height: 18,
              user: userProfile,
              margin: const EdgeInsets.only(left: 4),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
        ]),
      );
    }
    if (widget.showNickname) {
      list.add(
        TextSpan(children: [
          const WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: 4),
            ),
          ),
          TextSpan(
            text: userProfile?.nickname,
            style: TextStyle(
              color: (theme.color.isDark
                  ? theme.color.primaryColor8
                  : theme.color.primaryColor8),
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize,
            ),
          ),
        ]),
      );
    }

    if (widget.inlineSpan != null) {
      list.add(widget.inlineSpan!);
    }

    Widget content = Text.rich(
      TextSpan(
        style: TextStyle(
          height: 1,
          color: Colors.white,
          fontSize: theme.font.bodyMedium.fontSize,
          fontWeight: theme.font.bodyMedium.fontWeight,
        ),
        children: list,
      ),
    );

    content = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: theme.color.isDark
              ? theme.color.barrageColor1
              : theme.color.barrageColor2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: content,
    );

    content = Align(
      alignment: Alignment.centerLeft,
      child: content,
    );

    return content;
  }
}

class RoomUserJoinMessageListItem extends StatefulWidget {
  const RoomUserJoinMessageListItem(
    this.msg,
    this.user, {
    this.showTime = true,
    this.showIdentify = true,
    this.showAvatar = true,
    this.showNickname = true,
    super.key,
  });
  final Message msg;
  final ChatUIKitProfile? user;
  final bool showTime;
  final bool showIdentify;
  final bool showAvatar;
  final bool showNickname;

  @override
  State<RoomUserJoinMessageListItem> createState() =>
      _RoomUserJoinMessageListItemState();
}

class _RoomUserJoinMessageListItemState
    extends State<RoomUserJoinMessageListItem> with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    return RoomMessageListItem(
      widget.msg,
      user: widget.user,
      showTime: widget.showTime,
      showIdentify: widget.showIdentify,
      showAvatar: widget.showAvatar,
      showNickname: widget.showNickname,
      inlineSpan: TextSpan(
          text: " ${ChatUIKitLocal.roomMessageJoined.localString(context)}",
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.secondaryColor7
                : theme.color.secondaryColor8,
          )),
    );
  }
}

class RoomGiftMessageListItem extends StatefulWidget {
  const RoomGiftMessageListItem(
    this.msg,
    this.user, {
    this.showTime = true,
    this.showIdentify = true,
    this.showAvatar = true,
    this.showNickname = true,
    super.key,
  });
  final Message msg;
  final ChatUIKitProfile? user;
  final bool showTime;
  final bool showIdentify;
  final bool showAvatar;
  final bool showNickname;
  @override
  State<RoomGiftMessageListItem> createState() =>
      _RoomGiftMessageListItemState();
}

class _RoomGiftMessageListItemState extends State<RoomGiftMessageListItem>
    with ChatUIKitThemeMixin {
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    if (!widget.msg.isChatRoomGift) return const SizedBox();
    ChatRoomGift? gift = widget.msg.getGift();

    return RoomMessageListItem(
      widget.msg,
      user: widget.user,
      showTime: widget.showTime,
      showIdentify: widget.showIdentify,
      showAvatar: widget.showAvatar,
      showNickname: widget.showNickname,
      inlineSpan: TextSpan(
        children: [
          const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 4))),
          TextSpan(text: gift!.giftName ?? ChatUIKitLocal.roomGiftDefaultName.localString(context)),
          WidgetSpan(
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(9)),
              ),
              width: 18,
              height: 18,
              margin: const EdgeInsets.only(left: 4),
              child: ChatRoomImageLoader.roomNetworkImage(
                image: gift.giftIcon,
                size: 18,
                placeholderWidget:
                    (ChatUIKitSettings.roomDefaultGiftIcon == null)
                        ? Container()
                        : Image.asset(
                            ChatUIKitSettings.roomDefaultGiftIcon!,
                          ),
              ),
            ),
            alignment: PlaceholderAlignment.middle,
          ),
        ],
      ),
    );
  }
}

class RoomTextMessageListItem extends StatefulWidget {
  const RoomTextMessageListItem(
    this.msg,
    this.user, {
    this.showTime = true,
    this.showIdentify = true,
    this.showAvatar = true,
    this.showNickname = true,
    super.key,
  });
  final Message msg;
  final ChatUIKitProfile? user;
  final bool showTime;
  final bool showIdentify;
  final bool showAvatar;
  final bool showNickname;
  @override
  State<RoomTextMessageListItem> createState() =>
      _RoomTextMessageListItemState();
}

class _RoomTextMessageListItemState extends State<RoomTextMessageListItem>
    with ChatUIKitThemeMixin {
  String? content;
  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    if (widget.msg.body.type == MessageType.TXT) {
      TextMessageBody body = widget.msg.body as TextMessageBody;
      // TODO: 翻译
      // body.translations?.forEach((key, value) {
      //   if (key.contains(
      //       LanguageConvertor.instance.targetLanguage(context).code)) {
      //     content = value;
      //   }
      // });

      content ??= body.content;
    }

    content = EmojiMapping.replaceEmojiToImage(content!);

    List<InlineSpan> list = [];
    List<EmojiIndex> indexList = [];

    String tmpStr = content!;
    for (var element in EmojiMapping.emojiImages) {
      int indexFirst = 0;
      do {
        indexFirst = tmpStr.indexOf(element, indexFirst);
        if (indexFirst == -1) {
          break;
        }

        indexList.add(EmojiIndex(
          emoji: element,
          index: indexFirst,
          length: element.length,
        ));
        indexFirst += element.length;
      } while (indexFirst != -1);
    }

    indexList.sort((a, b) => a.index.compareTo(b.index));
    EmojiIndex? lastIndex;
    for (final emojiIndex in indexList) {
      if (lastIndex == null) {
        list.add(TextSpan(text: content!.substring(0, emojiIndex.index)));
      } else {
        list.add(
          TextSpan(
            text: content!.substring(
              lastIndex.index + lastIndex.length,
              emojiIndex.index,
            ),
          ),
        );
      }
      list.add((WidgetSpan(
          child: ChatRoomImageLoader.roomEmoji(emojiIndex.emoji, size: 20))));

      lastIndex = emojiIndex;
    }

    if (lastIndex != null) {
      list.add(
        TextSpan(
          text: content!.substring(lastIndex.index + lastIndex.emoji.length),
        ),
      );
    } else {
      list.add(
        TextSpan(text: content),
      );
    }

    return RoomMessageListItem(
      widget.msg,
      user: widget.user,
      showTime: widget.showTime,
      showIdentify: widget.showIdentify,
      showAvatar: widget.showAvatar,
      showNickname: widget.showNickname,
      inlineSpan: TextSpan(
        children: [
          const WidgetSpan(child: Padding(padding: EdgeInsets.only(left: 4))),
          TextSpan(children: list),
        ],
      ),
    );
  }
}
