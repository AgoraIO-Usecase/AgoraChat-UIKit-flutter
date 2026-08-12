import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class DownloadFileWidget extends StatefulWidget {
  const DownloadFileWidget({required this.message, super.key});
  final Message message;
  @override
  State<DownloadFileWidget> createState() => _DownloadFileWidgetState();
}

class _DownloadFileWidgetState extends State<DownloadFileWidget> {
  final ChatUIKitDownloadController controller = ChatUIKitDownloadController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.message.displayName ?? '文件下载',
          textScaler: TextScaler.noScaling,
        ),
      ),
      body: ChatUIKitDownloadsHelperWidget(
        controller: controller,
        message: widget.message,
        builder: (context, path, name, state, progress) {
          debugPrint(
              'path: $path, name: $name, state: $state, progress: $progress');
          if (state == ChatUIKitMessageDownloadState.success) {
            return const SizedBox();
          } else if (state == ChatUIKitMessageDownloadState.error) {
            return Center(
              child: TextButton(
                onPressed: () {
                  controller.download();
                },
                child: const Text(
                  '下载失败，点击重试',
                  textScaler: TextScaler.noScaling,
                ),
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(
              value: progress.toDouble(),
            ),
          );
        },
      ),
    );
  }
}
