import 'dart:io';
import 'dart:math';

import '../../../../../chat_uikit.dart';
import 'package:flutter/material.dart';

double maxImageWidth = 225;
double maxImageHeight = 300;

class ChatUIKitImageBubbleWidget extends StatefulWidget {
  const ChatUIKitImageBubbleWidget({
    required this.model,
    this.progressIndicatorColor,
    this.isCombine = false,
    this.isLeft,
    this.style,
    super.key,
  });
  final MessageModel model;

  final Color? progressIndicatorColor;
  final bool? isLeft;
  final bool isCombine;
  final ChatUIKitMessageListViewBubbleStyle? style;

  @override
  State<ChatUIKitImageBubbleWidget> createState() =>
      _ChatUIKitImageBubbleWidgetState();
}

class _ChatUIKitImageBubbleWidgetState extends State<ChatUIKitImageBubbleWidget>
    with MessageObserver, ChatUIKitThemeMixin {
  late MessageModel model;

  bool downloading = false;
  bool downloadError = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    model = widget.model;
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onMessageSendSuccess(String msgId, Message msg) {
    if (msgId == model.message.msgId) {
      model = model.copyWith(message: msg);
      safeSetState(() {
        downloading = false;
      });
    }
  }

  @override
  void onMessageSendError(String msgId, Message msg, ChatError error) {
    if (msgId == model.message.msgId && msg.bodyType == MessageType.IMAGE) {
      (msg.body as ImageMessageBody).fileStatus !=
          (model.message.body as ImageMessageBody).fileStatus;
      safeSetState(() {
        downloading = false;
        downloadError = true;
      });
    }
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    bool left =
        widget.isLeft ?? model.message.direction == MessageDirection.RECEIVE;

    String? localPath = model.message.localPath;
    String? thumbnailLocalPath = model.message.thumbnailLocalPath;

    double width = model.message.width;
    double height = model.message.height;
    if (width == 0) width = maxImageWidth;
    if (height == 0) height = maxImageHeight;
    double aspectRatio = width / height;

    if (aspectRatio < 0.1) {
      height = min(height, width * 10);
      if (height > maxImageHeight) {
        height = maxImageHeight;
        width = height / 10;
      }
    } else if (aspectRatio >= 0.1 && aspectRatio < 0.75) {
      if (height > maxImageHeight) {
        height = maxImageHeight;
        width = height * aspectRatio;
      }
    } else if (aspectRatio >= 0.75 && aspectRatio <= 1) {
      if (width > maxImageWidth) {
        width = maxImageWidth;
        height = width / aspectRatio;
      }
    } else if (aspectRatio > 1 && aspectRatio <= 10) {
      if (width > maxImageWidth) {
        width = maxImageWidth;
        height = width / aspectRatio;
      }
    } else {
      width = min(width, height * 10);
      if (width > maxImageWidth) {
        width = maxImageWidth;
        height = width / 10;
      }
    }

    Widget? content;

    if (downloadError) {
      content = loadError(width, height);
    } else {
      if (thumbnailLocalPath?.isNotEmpty == true) {
        final file = File(thumbnailLocalPath!);
        bool exists = file.existsSync();
        if (exists) {
          content = Image(
            image: ResizeImage(
              FileImage(file),
              width: width.toInt(),
              height: height.toInt(),
              policy: ResizeImagePolicy.fit,
            ),
            width: width,
            height: height,
            gaplessPlayback: true,
            excludeFromSemantics: true,
            alignment: left ? Alignment.centerLeft : Alignment.centerRight,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          );
        }
      }

      if (content == null) {
        if (localPath?.isNotEmpty == true) {
          final file = File(localPath!);
          bool exists = file.existsSync();
          if (exists) {
            content = Image(
              image: ResizeImage(
                FileImage(file),
                width: width.toInt(),
                height: height.toInt(),
                policy: ResizeImagePolicy.fit,
              ),
              width: width,
              height: height,
              gaplessPlayback: true,
              alignment: left ? Alignment.centerLeft : Alignment.centerRight,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            );
          }
        }
      }

      if (content == null) {
        download();
        content = SizedBox(
          width: width,
          height: height,
          child: Center(
            child: CircularProgressIndicator(
              color: widget.progressIndicatorColor,
            ),
          ),
        );
      }

      content = SizedBox(
        width: width,
        height: height,
        child: content,
      );
    }

    bool isArrow = widget.style != null
        ? widget.style == ChatUIKitMessageListViewBubbleStyle.arrow
        : ChatUIKitSettings.messageBubbleStyle ==
            ChatUIKitMessageListViewBubbleStyle.arrow;

    content = Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isArrow ? 4 : 16),
        border: Border.all(
          width: 1,
          color: theme.color.isDark
              ? downloadError
                  ? theme.color.neutralColor3
                  : theme.color.neutralColor2
              : downloadError
                  ? theme.color.neutralColor8
                  : theme.color.neutralColor9,
        ),
      ),
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isArrow ? 4 : 16),
        border: Border.all(
          width: 1,
          color: theme.color.isDark
              ? downloadError
                  ? theme.color.neutralColor3
                  : theme.color.neutralColor2
              : downloadError
                  ? theme.color.neutralColor8
                  : theme.color.neutralColor9,
        ),
      ),
      child: content,
    );

    return content;
  }

  void download() {
    if (downloading) return;
    downloading = true;
    if (model.message.thumbnailLocalPath?.isNotEmpty == true) {
      if (widget.isCombine) {
        ChatUIKit.instance
            .downloadMessageThumbnailInCombine(message: model.message);
      } else {
        ChatUIKit.instance.downloadThumbnail(message: model.message);
      }
    } else {
      if (widget.isCombine) {
        ChatUIKit.instance
            .downloadMessageAttachmentInCombine(message: model.message);
      } else {
        ChatUIKit.instance.downloadAttachment(message: model.message);
      }
    }
  }

  Widget loadError(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: theme.color.isDark
            ? theme.color.neutralColor2
            : theme.color.neutralColor9,
      ),
      child: Center(
        child: ChatUIKitImageLoader.imageDefault(
          width: 64,
          height: 64,
          color: theme.color.isDark
              ? theme.color.neutralColor5
              : theme.color.neutralColor7,
        ),
      ),
    );
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
