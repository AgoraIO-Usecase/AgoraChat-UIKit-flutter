import 'dart:io';

import 'package:flutter/material.dart';

import '../../../chat_uikit.dart';

typedef ChatUIKitDownloadBuilder = Widget Function(
  BuildContext context,
  String? path,
  String? name,
  ChatUIKitMessageDownloadState state,
  int progress,
);

class ChatUIKitDownloadController {
  ChatUIKitDownloadController();
  VoidCallback? callback;
  void download() {
    callback?.call();
  }

  void _sendHandler(VoidCallback callback) {
    this.callback = callback;
  }

  void _dispose() {
    callback = null;
  }
}

typedef ChatUIKitDownloadResult = void Function(
  Message message,
  String? path,
  ChatError? error,
);

class ChatUIKitDownloadsHelperWidget extends StatefulWidget {
  const ChatUIKitDownloadsHelperWidget({
    required this.message,
    this.builder,
    this.controller,
    this.onDownloadResult,
    super.key,
  });

  final ChatUIKitDownloadBuilder? builder;
  final ChatUIKitDownloadController? controller;
  final ChatUIKitDownloadResult? onDownloadResult;
  final Message message;

  @override
  State<ChatUIKitDownloadsHelperWidget> createState() =>
      _ChatUIKitDownloadsHelperWidgetState();
}

class _ChatUIKitDownloadsHelperWidgetState
    extends State<ChatUIKitDownloadsHelperWidget> with MessageObserver {
  ValueNotifier<ChatUIKitMessageDownloadState> isDownloading =
      ValueNotifier(ChatUIKitMessageDownloadState.idle);
  ValueNotifier<int> progress = ValueNotifier(0);

  Message? message;
  late ChatUIKitDownloadController controller;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    message = widget.message;
    controller = widget.controller ?? ChatUIKitDownloadController();
    updateControllerCallback();
    controller.download();
  }

  void updateControllerCallback() {
    controller._sendHandler(downloadMessage);
  }

  @override
  void didUpdateWidget(covariant ChatUIKitDownloadsHelperWidget oldWidget) {
    if (controller != widget.controller) {
      oldWidget.controller?._dispose();
      updateControllerCallback();
    }
    super.didUpdateWidget(oldWidget);
  }

  void downloadMessage() {
    File file = File(message!.localPath!);
    if (file.existsSync()) {
      isDownloading.value = ChatUIKitMessageDownloadState.success;
      widget.onDownloadResult?.call(message!, message!.localPath, null);
      return;
    }
    ChatUIKit.instance.downloadAttachment(message: message!);
    isDownloading.value = ChatUIKitMessageDownloadState.downloading;
  }

  @override
  void dispose() {
    controller._dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    if ((widget.message.bodyType == MessageType.FILE ||
            widget.message.bodyType == MessageType.IMAGE ||
            widget.message.bodyType == MessageType.VIDEO ||
            widget.message.bodyType == MessageType.VOICE) &&
        isDownloading.value == ChatUIKitMessageDownloadState.idle) {
      downloadMessage();
    }

    return Container(
      key: ValueKey(widget.message.localTime),
      child: ValueListenableBuilder<ChatUIKitMessageDownloadState>(
        valueListenable: isDownloading,
        builder: (context, state, child) {
          if (state == ChatUIKitMessageDownloadState.success) {
            return widget.builder?.call(
                  context,
                  message!.localPath,
                  message!.displayName,
                  state,
                  100,
                ) ??
                const SizedBox();
          }
          if (state == ChatUIKitMessageDownloadState.downloading) {
            return ValueListenableBuilder<int>(
              valueListenable: progress,
              builder: (context, progress, child) {
                return widget.builder?.call(
                      context,
                      null,
                      message!.displayName,
                      state,
                      progress,
                    ) ??
                    CircularProgressIndicator(
                      color: theme.color.isDark
                          ? theme.color.primaryColor6
                          : theme.color.primaryColor5,
                      value: progress.toDouble(),
                    );
              },
              child: widget.builder?.call(
                context,
                null,
                message!.displayName,
                state,
                0,
              ),
            );
          }
          return widget.builder?.call(
                context,
                null,
                message!.displayName,
                state,
                0,
              ) ??
              const SizedBox();
        },
      ),
    );
  }

  @override
  void onSuccess(String msgId, Message msg) {
    if (msgId == message!.msgId) {
      isDownloading.value = ChatUIKitMessageDownloadState.success;
      widget.onDownloadResult?.call(msg, msg.localPath, null);
    }
  }

  @override
  void onError(String msgId, Message msg, ChatError error) {
    if (msgId == message!.msgId) {
      isDownloading.value = ChatUIKitMessageDownloadState.error;
      widget.onDownloadResult?.call(msg, null, error);
    }
  }

  @override
  void onProgress(String msgId, int progress) {
    if (msgId == message!.msgId) {
      this.progress.value = progress;
    }
  }
}

enum ChatUIKitMessageDownloadState {
  idle,
  downloading,
  success,
  error,
}
