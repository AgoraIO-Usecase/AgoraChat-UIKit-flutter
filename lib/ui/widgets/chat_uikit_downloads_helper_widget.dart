import 'dart:io';

import '../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

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

class ChatUIKitDownloadsHelperWidget extends StatefulWidget {
  const ChatUIKitDownloadsHelperWidget({
    required this.builder,
    required this.message,
    this.controller,
    super.key,
  });

  final ChatUIKitDownloadBuilder builder;
  final ChatUIKitDownloadController? controller;
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
  late ChatUIKitDownloadController? controller;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    message = widget.message;
    controller = widget.controller ?? ChatUIKitDownloadController();
    updateControllerCallback();
  }

  void updateControllerCallback() {
    controller?._sendHandler(downloadMessage);
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
      return;
    }
    ChatUIKit.instance.downloadAttachment(message: message!);
    isDownloading.value = ChatUIKitMessageDownloadState.downloading;
  }

  @override
  void dispose() {
    controller?._dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              return widget.builder(
                context,
                message!.localPath,
                message!.displayName,
                state,
                100,
              );
            }
            if (state == ChatUIKitMessageDownloadState.downloading) {
              return ValueListenableBuilder<int>(
                valueListenable: progress,
                builder: (context, progress, child) {
                  return widget.builder(
                    context,
                    null,
                    message!.displayName,
                    state,
                    progress,
                  );
                },
                child: widget.builder(
                  context,
                  null,
                  message!.displayName,
                  state,
                  0,
                ),
              );
            }
            return widget.builder(
              context,
              null,
              message!.displayName,
              state,
              0,
            );
          },
        ));
  }

  @override
  void onSuccess(String msgId, Message msg) {
    if (msgId == message!.msgId) {
      isDownloading.value = ChatUIKitMessageDownloadState.success;
    }
  }

  @override
  void onError(String msgId, Message msg, ChatError error) {
    if (msgId == message!.msgId) {
      isDownloading.value = ChatUIKitMessageDownloadState.error;
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
