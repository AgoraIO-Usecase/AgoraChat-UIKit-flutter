import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ToastPage extends StatefulWidget {
  const ToastPage({required this.child, super.key});
  final Widget child;
  @override
  State<ToastPage> createState() => _ToastPageState();
}

class _ToastPageState extends State<ToastPage>
    with ChatSDKEventsObserver, ChatUIKitEventsObservers {
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
  }

  @override
  void dispose() {
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void onChatUIKitEventsReceived(ChatUIKitEvent event) {
    if (event == ChatUIKitEvent.groupIdCopied ||
        event == ChatUIKitEvent.userIdCopied ||
        event == ChatUIKitEvent.messageCopied) {
      EasyLoading.showSuccess('复制成功');
    } else if (event == ChatUIKitEvent.messageDownloading) {
      EasyLoading.showInfo('下载中');
    } else if (event == ChatUIKitEvent.noCameraPermission ||
        event == ChatUIKitEvent.noMicrophonePermission ||
        event == ChatUIKitEvent.noStoragePermission) {
      EasyLoading.showError('权限不足');
    } else if (event == ChatUIKitEvent.voiceTypeNotSupported) {
      EasyLoading.showError('语音格式不支持');
    } else if (event == ChatUIKitEvent.targetMessageNotFound) {
      EasyLoading.showError('原消息未找到');
    }
  }

  @override
  void onChatSDKEventBegin(ChatSDKEvent event) {
    if (event == ChatSDKEvent.acceptContactRequest ||
        event == ChatSDKEvent.fetchGroupMemberAttributes ||
        event == ChatSDKEvent.setGroupMemberAttributes ||
        event == ChatSDKEvent.sendContactRequest ||
        event == ChatSDKEvent.changeGroupOwner ||
        event == ChatSDKEvent.declineContactRequest ||
        event == ChatSDKEvent.setSilentMode ||
        event == ChatSDKEvent.createGroup ||
        event == ChatSDKEvent.fetchChatThreadMembers ||
        event == ChatSDKEvent.reportMessage ||
        event == ChatSDKEvent.clearSilentMode ||
        event == ChatSDKEvent.fetchPinnedMessages) {
      EasyLoading.show();
    }
  }

  @override
  void onChatSDKEventEnd(ChatSDKEvent event, ChatError? error) {
    if (event == ChatSDKEvent.acceptContactRequest ||
        event == ChatSDKEvent.fetchGroupMemberAttributes ||
        event == ChatSDKEvent.fetchChatThreadMembers ||
        event == ChatSDKEvent.setGroupMemberAttributes ||
        event == ChatSDKEvent.sendContactRequest ||
        event == ChatSDKEvent.changeGroupOwner ||
        event == ChatSDKEvent.declineContactRequest ||
        event == ChatSDKEvent.setSilentMode ||
        event == ChatSDKEvent.reportMessage ||
        event == ChatSDKEvent.createGroup ||
        event == ChatSDKEvent.clearSilentMode ||
        event == ChatSDKEvent.fetchPinnedMessages) {
      EasyLoading.dismiss();
      if (error != null) {
        EasyLoading.showError(error.description);
      }
    }
  }
}
