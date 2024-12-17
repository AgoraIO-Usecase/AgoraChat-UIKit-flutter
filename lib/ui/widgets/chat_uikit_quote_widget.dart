import 'dart:io';
import '../../../chat_uikit.dart';

import 'package:flutter/material.dart';

class ChatUIKitQuoteWidget extends StatefulWidget {
  const ChatUIKitQuoteWidget({
    required this.model,
    this.isLeft = false,
    super.key,
  });

  final QuoteModel model;
  final bool isLeft;
  @override
  State<ChatUIKitQuoteWidget> createState() => _ChatUIKitQuoteWidgetState();
}

class _ChatUIKitQuoteWidgetState extends State<ChatUIKitQuoteWidget>
    with ChatUIKitThemeMixin {
  late final QuoteModel model;
  Message? message;
  bool fetched = false;
  @override
  void initState() {
    super.initState();
    model = widget.model;
    loadMessage();
  }

  void loadMessage() async {
    message = await ChatUIKit.instance.loadMessage(
      messageId: model.msgId,
    );
    fetched = true;
    if (mounted) setState(() {});
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = _buildContext(context, message: message);
    content = Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: content,
    );

    return content;
  }

  Widget _buildContext(BuildContext context, {Message? message}) {
    BorderRadiusGeometry? borderRadius;
    if (ChatUIKitSettings.messageBubbleStyle ==
        ChatUIKitMessageListViewBubbleStyle.arrow) {
      borderRadius = const BorderRadius.all(Radius.circular(4));
    } else {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(widget.isLeft ? 12 : 16),
        bottomLeft: Radius.circular(widget.isLeft ? 4 : 16),
        topRight: Radius.circular(!widget.isLeft ? 12 : 16),
        bottomRight: Radius.circular(!widget.isLeft ? 4 : 16),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor2
            : theme.color.neutralColor95,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.all(8),
      child: () {
        if (message == null) {
          return _emptyWidget(theme);
        }

        MessageType type = model.msgType.getMessageType;

        switch (type) {
          case MessageType.TXT:
            return textWidget(theme, message);
          case MessageType.IMAGE:
            return imageWidget(theme, message);
          case MessageType.VIDEO:
            return videoWidget(theme, message);
          case MessageType.VOICE:
            return voiceWidget(theme, message);
          case MessageType.FILE:
            return fileWidget(theme, message);
          case MessageType.COMBINE:
            return combineWidget(theme, message);
          case MessageType.CUSTOM:
            return custom(theme, message);
          default:
        }
        return _unSupportWidget(theme);
      }(),
    );
  }

  Widget textWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          () {
            ChatUIKitProfile? profile =
                ChatUIKitProvider.instance.getProfileById(message.from!);
            profile ??= message.fromProfile;
            return profile.contactShowName;
          }(),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        ChatUIKitEmojiRichText(
          emojiSize: const Size(16, 16),
          text: message.textContent,
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          maxLines: 2,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralColor6
                : theme.color.neutralColor5,
            fontSize: theme.font.bodyMedium.fontSize,
            fontWeight: theme.font.bodyMedium.fontWeight,
          ),
        ),
      ],
    );

    return content;
  }

  Widget imageWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ChatUIKitImageLoader.imageDefault(width: 16, height: 16),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            ChatUIKitLocal.quoteWidgetTitleImage.localString(context),
            overflow: TextOverflow.ellipsis,
            textScaler: TextScaler.noScaling,
            maxLines: 1,
            style: TextStyle(
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
            ),
          ),
        )
      ],
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          () {
            return ChatUIKitProvider.instance
                    .getProfileById(message.from!)
                    ?.contactShowName ??
                message.nickname ??
                message.from!;
          }(),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        content,
      ],
    );

    content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: content,
        ),
        const SizedBox(width: 16),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Builder(
            builder: (context) {
              Widget? content;

              if (message.thumbnailLocalPath?.isNotEmpty == true) {
                File file = File(message.thumbnailLocalPath!);
                if (file.existsSync()) {
                  content = Image(
                    gaplessPlayback: true,
                    image: ResizeImage(
                      FileImage(file),
                      width: 36,
                      height: 36,
                      policy: ResizeImagePolicy.fit,
                    ),
                    fit: BoxFit.cover,
                  );
                }
              }
              if (message.thumbnailRemotePath?.isNotEmpty == true &&
                  content == null) {
                content = Image(
                  gaplessPlayback: true,
                  image: ResizeImage(
                    NetworkImage(message.thumbnailRemotePath!),
                    width: 36,
                    height: 36,
                  ),
                  fit: BoxFit.cover,
                );
              }

              if (message.localPath?.isNotEmpty == true) {
                File file = File(message.localPath!);
                if (file.existsSync()) {
                  content = Image(
                    gaplessPlayback: true,
                    image: ResizeImage(
                      FileImage(file),
                      width: 36,
                      height: 36,
                      policy: ResizeImagePolicy.fit,
                    ),
                    fit: BoxFit.cover,
                  );
                }
              }

              content ??= Center(
                child: ChatUIKitImageLoader.imageDefault(
                  width: 24,
                  height: 24,
                  color: theme.color.isDark
                      ? theme.color.neutralColor5
                      : theme.color.neutralColor7,
                ),
              );

              content = Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: theme.color.isDark
                        ? theme.color.neutralColor3
                        : theme.color.neutralColor8,
                  ),
                ),
                foregroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 1,
                    color: theme.color.isDark
                        ? theme.color.neutralColor3
                        : theme.color.neutralColor8,
                  ),
                ),
                child: content,
              );

              return content;
            },
          ),
        ),
      ],
    );
    return content;
  }

  Widget videoWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ChatUIKitImageLoader.videoDefault(
            width: 16,
            height: 16,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            ChatUIKitLocal.quoteWidgetTitleVideo.localString(context),
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: theme.font.labelMedium.fontWeight,
              fontSize: theme.font.labelMedium.fontSize,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5,
            ),
          ),
        ),
      ],
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          () {
            return ChatUIKitProvider.instance
                    .getProfileById(message.from!)
                    ?.contactShowName ??
                message.nickname ??
                message.from!;
          }(),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        content,
      ],
    );
    bool hasLoad = true;

    Widget videoWidget = () {
      Widget? content;

      if (message.thumbnailLocalPath?.isNotEmpty == true) {
        File file = File(message.thumbnailLocalPath!);
        if (file.existsSync()) {
          content = Image(
            gaplessPlayback: true,
            image: ResizeImage(
              FileImage(file),
              width: 36,
              height: 36,
              policy: ResizeImagePolicy.fit,
            ),
            fit: BoxFit.cover,
          );
        }
      }

      if (message.thumbnailRemotePath?.isNotEmpty == true && content == null) {
        content = Image(
          gaplessPlayback: true,
          image: ResizeImage(
            NetworkImage(message.thumbnailRemotePath!),
            width: 36,
            height: 36,
            policy: ResizeImagePolicy.fit,
          ),
          fit: BoxFit.cover,
        );
      }

      content ??= () {
        hasLoad = false;
        return Center(
          child: ChatUIKitImageLoader.videoDefault(
            width: 24,
            height: 24,
            color: theme.color.isDark
                ? theme.color.neutralColor5
                : theme.color.neutralColor7,
          ),
        );
      }();
      content = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: theme.color.isDark
              ? theme.color.neutralColor1
              : theme.color.neutralColor98,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: theme.color.isDark
                ? theme.color.neutralColor3
                : theme.color.neutralColor8,
          ),
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 1,
            color: theme.color.isDark
                ? theme.color.neutralColor3
                : theme.color.neutralColor8,
          ),
        ),
        child: content,
      );
      return content;
    }();

    content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: content,
        ),
        const SizedBox(width: 16),
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              videoWidget,
              if (hasLoad)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_circle_outline,
                      size: 20,
                      color: theme.color.isDark
                          ? theme.color.neutralColor1
                          : theme.color.neutralColor98,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
    return content;
  }

  Widget voiceWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ChatUIKitImageLoader.bubbleVoice(2,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor5),
        ),
        const SizedBox(width: 4),
        Flexible(
          fit: FlexFit.loose,
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textScaler: TextScaler.noScaling,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      ChatUIKitLocal.quoteWidgetTitleVoice.localString(context),
                  style: TextStyle(
                    fontWeight: theme.font.bodySmall.fontWeight,
                    fontSize: theme.font.bodySmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
                TextSpan(
                  text: "${message.duration}''",
                  style: TextStyle(
                    fontWeight: theme.font.labelSmall.fontWeight,
                    fontSize: theme.font.labelSmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          () {
            return ChatUIKitProvider.instance
                    .getProfileById(message.from!)
                    ?.contactShowName ??
                message.nickname ??
                message.from!;
          }(),
          overflow: TextOverflow.ellipsis,
          textScaler: TextScaler.noScaling,
          maxLines: 1,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        content,
      ],
    );
    return content;
  }

  Widget fileWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ChatUIKitImageLoader.file(
              width: 32,
              height: 32,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor7),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textScaler: TextScaler.noScaling,
            text: TextSpan(
              children: [
                TextSpan(
                  text:
                      ChatUIKitLocal.quoteWidgetTitleFile.localString(context),
                  style: TextStyle(
                    fontWeight: theme.font.labelSmall.fontWeight,
                    fontSize: theme.font.labelSmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
                TextSpan(
                  text: message.displayName,
                  style: TextStyle(
                    fontWeight: theme.font.bodySmall.fontWeight,
                    fontSize: theme.font.bodySmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          () {
            return ChatUIKitProvider.instance
                    .getProfileById(message.from!)
                    ?.contactShowName ??
                message.nickname ??
                message.from!;
          }(),
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        content,
      ],
    );

    return content;
  }

  Widget combineWidget(ChatUIKitTheme theme, Message message) {
    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: ChatUIKitImageLoader.messageHistory(
              width: 32,
              height: 32,
              color: theme.color.isDark
                  ? theme.color.neutralColor6
                  : theme.color.neutralColor7),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textScaler: TextScaler.noScaling,
            text: TextSpan(
              children: [
                TextSpan(
                  text: ChatUIKitLocal.quoteWidgetTitleCombine
                      .localString(context),
                  style: TextStyle(
                    fontWeight: theme.font.labelSmall.fontWeight,
                    fontSize: theme.font.labelSmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
                TextSpan(
                  text: message.displayName,
                  style: TextStyle(
                    fontWeight: theme.font.bodySmall.fontWeight,
                    fontSize: theme.font.bodySmall.fontSize,
                    color: theme.color.isDark
                        ? theme.color.neutralSpecialColor6
                        : theme.color.neutralSpecialColor5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
    content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message.fromProfile.contactShowName,
          textScaler: TextScaler.noScaling,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.color.isDark
                ? theme.color.neutralSpecialColor5
                : theme.color.neutralSpecialColor6,
            fontSize: theme.font.labelSmall.fontSize,
            fontWeight: theme.font.labelSmall.fontWeight,
          ),
        ),
        content,
      ],
    );

    return content;
  }

  Widget custom(ChatUIKitTheme theme, Message message) {
    if (model.msgType == MessageType.CUSTOM.getString &&
        message.isCardMessage) {
      Widget content = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: ChatUIKitImageLoader.card(
                width: 32,
                height: 32,
                color: theme.color.isDark
                    ? theme.color.neutralColor6
                    : theme.color.neutralColor7),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: RichText(
              textScaler: TextScaler.noScaling,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: ChatUIKitLocal.quoteWidgetTitleContact
                        .localString(context),
                    style: TextStyle(
                      fontWeight: theme.font.labelMedium.fontWeight,
                      fontSize: theme.font.labelMedium.fontSize,
                      color: theme.color.isDark
                          ? theme.color.neutralColor6
                          : theme.color.neutralColor5,
                    ),
                  ),
                  TextSpan(
                    text: message.cardUserNickname ?? message.cardUserId,
                    style: TextStyle(
                      fontWeight: theme.font.bodyMedium.fontWeight,
                      fontSize: theme.font.bodyMedium.fontSize,
                      color: theme.color.isDark
                          ? theme.color.neutralSpecialColor6
                          : theme.color.neutralSpecialColor5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            () {
              return ChatUIKitProvider.instance
                      .getProfileById(message.from!)
                      ?.contactShowName ??
                  message.nickname ??
                  message.from!;
            }(),
            textScaler: TextScaler.noScaling,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.color.isDark
                  ? theme.color.neutralSpecialColor5
                  : theme.color.neutralSpecialColor6,
              fontSize: theme.font.labelSmall.fontSize,
              fontWeight: theme.font.labelSmall.fontWeight,
            ),
          ),
          content,
        ],
      );

      return content;
    }
    return Container();
  }

  Widget _emptyWidget(ChatUIKitTheme theme) {
    return Text(
      ChatUIKitLocal.quoteWidgetTitleUnFind.localString(context),
      textScaler: TextScaler.noScaling,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
        fontSize: theme.font.bodyMedium.fontSize,
        fontWeight: theme.font.bodyMedium.fontWeight,
      ),
    );
  }

  Widget _unSupportWidget(ChatUIKitTheme theme) {
    return Text(
      ChatUIKitLocal.nonSupportMessage.localString(context),
      textScaler: TextScaler.noScaling,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: theme.color.isDark
            ? theme.color.neutralColor5
            : theme.color.neutralColor7,
        fontSize: theme.font.bodyMedium.fontSize,
        fontWeight: theme.font.bodyMedium.fontWeight,
      ),
    );
  }
}
