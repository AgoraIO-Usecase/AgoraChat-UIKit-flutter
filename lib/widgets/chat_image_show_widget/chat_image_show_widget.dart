import 'dart:io';

import 'package:flutter/material.dart';
import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:agora_chat_uikit/internal/chat_method.dart';

class ChatImageShowWidget extends StatefulWidget {
  const ChatImageShowWidget(this.message, {super.key});

  final ChatMessage message;

  @override
  State<ChatImageShowWidget> createState() => _ChatImageShowWidgetState();
}

class _ChatImageShowWidgetState extends State<ChatImageShowWidget> {
  final ValueNotifier<int> _progress = ValueNotifier(0);

  final String _msgEventKey = "msgEventKey";
  ChatImageMessageBody? body;
  ChatMessage? message;
  @override
  void initState() {
    super.initState();
    message = widget.message;
    chatClient.chatManager.addMessageEvent(
        _msgEventKey,
        ChatMessageEvent(
          onProgress: (msgId, progress) {
            if (msgId == message!.msgId) {
              debugPrint("progress: $progress");
              _progress.value = progress;
            }
          },
          onSuccess: (msgId, msg) {
            if (msgId == message!.msgId) {
              message = msg;
              setState(() {});
            }
          },
          onError: (msgId, msg, error) {
            if (msgId == message!.msgId) {
              message = msg;
              setState(() {});
            }
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    body = message!.body as ChatImageMessageBody;
    Widget? content;
    bool needDownload = false;
    do {
      File file = File(body!.localPath);
      if (file.existsSync()) {
        content = Image.file(File(body!.localPath));
        break;
      }
      if (body!.fileStatus != DownloadStatus.FAILED) {
        needDownload = true;
        _downloadImage(message!);
      } else {
        needDownload = false;
      }

      file = File(body!.thumbnailLocalPath!);
      if (file.existsSync()) {
        content = Image.file(File(body!.thumbnailLocalPath!));
        break;
      }

      content = Image.network(body!.thumbnailRemotePath!);
    } while (false);

    content = InteractiveViewer(
      child: content,
    );

    content = SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: content,
    );

    content = Stack(
      alignment: Alignment.center,
      children: [
        content,
        Positioned(
          left: 5,
          top: 5,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        () {
          return needDownload
              ? Positioned(
                  child: SizedBox(
                  width: 30,
                  height: 30,
                  child: ValueListenableBuilder(
                    valueListenable: _progress,
                    builder: (context, value, child) {
                      return CircularProgressIndicator(
                        value: value / 100,
                      );
                    },
                  ),
                ))
              : Container();
        }(),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(child: content),
    );
  }

  void _downloadImage(ChatMessage message) {
    chatClient.chatManager.downloadAttachment(message);
  }

  @override
  void dispose() {
    chatClient.chatManager.removeMessageEvent(_msgEventKey);
    super.dispose();
  }
}
