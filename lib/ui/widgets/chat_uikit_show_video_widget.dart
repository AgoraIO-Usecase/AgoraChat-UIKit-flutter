import 'dart:io';

import '../../../chat_uikit.dart';
import '../../../universal/inner_headers.dart';

import 'package:flutter/material.dart';

class ChatUIKitShowVideoWidget extends StatefulWidget {
  const ChatUIKitShowVideoWidget({
    required this.message,
    this.onLongPressed,
    this.onError,
    this.onProgress,
    this.onSuccess,
    this.playIcon,
    this.isCombine = false,
    super.key,
  });

  final void Function(BuildContext context, Message message)? onLongPressed;

  final Message message;

  final void Function(ChatError error)? onError;
  final void Function(int progress)? onProgress;
  final bool isCombine;
  final Widget? playIcon;
  final VoidCallback? onSuccess;

  @override
  State<ChatUIKitShowVideoWidget> createState() =>
      _ChatUIKitShowVideoWidgetState();
}

class _ChatUIKitShowVideoWidgetState extends State<ChatUIKitShowVideoWidget>
    with MessageObserver, ChatUIKitThemeMixin {
  Message? message;
  VideoPlayerController? _controller;

  String? localThumbPath;
  String? remoteThumbPath;
  bool isPlaying = false;
  bool downloading = false;
  bool isPlayed = false;
  final ValueNotifier _hasThumb = ValueNotifier(false);
  final ValueNotifier<int> _progress = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    message = widget.message;
    WidgetsBinding.instance.addPostFrameCallback((time) {
      checkVideoFile();
    });
  }

  void checkVideoFile() async {
    if (message?.localPath?.isNotEmpty == true) {
      File file = File(message!.localPath!);

      if (file.existsSync()) {
        await updateController(file);
      } else {
        if (widget.isCombine) {
          ChatUIKit.instance
              .downloadMessageAttachmentInCombine(message: message!);
        } else {
          ChatUIKit.instance.downloadAttachment(message: message!);
        }
        downloading = true;
      }
    }

    if (message?.thumbnailLocalPath?.isNotEmpty == true) {
      File file = File(message!.thumbnailLocalPath!);
      if (file.existsSync()) {
        localThumbPath = message!.thumbnailLocalPath;
      }
    } else {
      if (widget.isCombine) {
        ChatUIKit.instance.downloadMessageThumbnailInCombine(message: message!);
      } else {
        ChatUIKit.instance.downloadThumbnail(message: message!);
      }
    }
    safeSetState(() {});
  }

  @override
  void dispose() {
    _hasThumb.dispose();
    _progress.dispose();
    _controller?.dispose();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onMessageSendProgress(String msgId, int progress) {
    if (widget.message.msgId == msgId) {
      if (downloading) {
        _progress.value = progress;
        widget.onProgress?.call(progress);
      }
    }
  }

  @override
  void onMessageSendError(String msgId, Message msg, ChatError error) {
    if (widget.message.msgId == msgId) {
      message = msg;
      widget.onError?.call(error);
    }
  }

  @override
  void onMessageSendSuccess(String msgId, Message msg) {
    if (widget.message.msgId == msgId) {
      if (downloading) {
        if ((msg.body as VideoMessageBody).fileStatus ==
            DownloadStatus.SUCCESS) {
          downloading = false;
        }
      }
      message = msg;
      checkVideoFile();
    }
  }

  Future<void> updateController(File file) async {
    if (_controller != null) return;
    try {
      debugPrint('updateController: $file');
      _controller = VideoPlayerController.file(file);

      _controller?.addListener(() {
        if (_controller?.value.isInitialized == true) {
          if (isPlaying != (_controller?.value.isPlaying ?? false)) {
            isPlaying = (_controller?.value.isPlaying ?? false);
            safeSetState(() {});
          }
        }
      });
      await _controller?.initialize();
    } catch (e) {
      debugPrint('updateController error: $e');
    }
  }

  Widget loadingWidget() {
    if (!downloading) {
      return const SizedBox();
    }
    return ValueListenableBuilder(
      valueListenable: _progress,
      builder: (context, value, child) {
        if (_progress.value == 100) {
          return const SizedBox();
        }
        return SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(value: value / 100));
      },
    );
  }

  Widget thumbWidget() {
    if ((_controller?.value.isPlaying ?? false) || isPlayed) {
      return const SizedBox();
    }

    Widget? content;
    if (localThumbPath?.isNotEmpty == true) {
      content = Image.file(
        File(localThumbPath!),
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      );
      content = Center(child: content);
    }
    content ??= const SizedBox();

    return content;
  }

  Widget playerWidget() {
    return Stack(
      children: [
        () {
          if (_controller?.value.isInitialized == true) {
            Widget content = AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!));

            content = Center(child: content);

            return content;
          } else {
            return const SizedBox();
          }
        }(),
        Positioned.fill(child: thumbWidget()),
        Positioned.fill(
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () {
              if (_controller?.value.isInitialized == true) {
                isPlayed = true;
                safeSetState(() {
                  if (_controller!.value.isPlaying) {
                    _controller?.pause();
                  } else {
                    _controller?.play();
                  }
                });
              } else {
                ChatUIKit.instance.onChatUIKitEventsReceived(
                    ChatUIKitEvent.messageDownloading);
              }
            },
            child: isPlaying
                ? const SizedBox()
                : widget.playIcon ??
                    Icon(
                      Icons.play_circle_outline,
                      size: 70,
                      color: theme.color.isDark
                          ? theme.color.neutralColor2
                          : theme.color.neutralColor95,
                    ),
          ),
        ),
      ],
    );
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = Stack(
      children: [
        Positioned.fill(
          child: InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onLongPress: onLongPressed,
            child: playerWidget(),
          ),
        ),
        Positioned.fill(child: Center(child: loadingWidget())),
      ],
    );

    return content;
  }

  void onLongPressed() {
    _controller?.pause();
    widget.onLongPressed?.call(context, message!);
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}
