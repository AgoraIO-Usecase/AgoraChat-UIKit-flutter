import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class TokenStatusHandlerWidget extends StatefulWidget {
  const TokenStatusHandlerWidget({required this.child, super.key});

  final Widget child;

  @override
  State<TokenStatusHandlerWidget> createState() =>
      _TokenStatusHandlerWidgetState();
}

class _TokenStatusHandlerWidgetState extends State<TokenStatusHandlerWidget> {
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.connectHandler(
      onUserAuthenticationFailed: onUserAuthenticationFailed,
      onUserDidChangePassword: onUserDidChangePassword,
      onUserDidForbidByServer: onUserDidForbidByServer,
      onUserDidLoginFromOtherDevice: onUserDidLoginFromOtherDevice,
      onUserDidLoginTooManyDevice: onUserDidLoginTooManyDevice,
      onUserDidRemoveFromServer: onUserDidRemoveFromServer,
      onUserKickedByOtherDevice: onUserKickedByOtherDevice,
      onConnected: onConnected,
      onDisconnected: onDisconnected,
      onTokenWillExpire: onTokenWillExpire,
      onTokenDidExpire: onTokenDidExpire,
      onAppActiveNumberReachLimit: onAppActiveNumberReachLimit,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void onConnected() {
    debugPrint('onConnected');
  }

  void onDisconnected() {
    debugPrint('onDisconnected');
  }

  void onUserDidLoginFromOtherDevice(String deviceName) {
    debugPrint('onUserDidLoginFromOtherDevice: $deviceName');
    showDialogInfo(title: 'Login From Other Device');
  }

  void onUserDidRemoveFromServer() {
    debugPrint('onUserDidRemoveFromServer');
    showDialogInfo(
        title: 'User Removed', content: 'Please contact the administrator');
  }

  void onUserDidForbidByServer() {
    debugPrint('onUserDidForbidByServer');
    showDialogInfo(
        title: 'User Forbidden', content: 'Please contact the administrator');
  }

  void onUserDidChangePassword() {
    debugPrint('onUserDidChangePassword');
    showDialogInfo(title: 'Password Changed', content: 'Please login again');
  }

  void onUserDidLoginTooManyDevice() {
    debugPrint('onUserDidLoginTooManyDevice');
    showDialogInfo(title: 'LoginTooManyDevice');
  }

  void onUserKickedByOtherDevice() {
    debugPrint('onUserKickedByOtherDevice');
    showDialogInfo(title: 'KickedByOtherDevice');
  }

  void onUserAuthenticationFailed() {
    debugPrint('onUserAuthenticationFailed');
    showDialogInfo(
        title: 'Authentication Failed', content: 'Please login again');
  }

  void onTokenWillExpire() {
    debugPrint('onTokenWillExpire');
  }

  void onTokenDidExpire() {
    showDialogInfo(title: 'Token Expired', content: 'Please login again');
  }

  void onAppActiveNumberReachLimit() {
    showDialogInfo(
      title: 'onAppActiveNumberReachLimit',
    );
  }

  void showDialogInfo({
    required String title,
    String? content,
    List<ChatUIKitDialogAction> items = const [],
  }) {
    showChatUIKitDialog(
        barrierDismissible: false,
        context: context,
        title: title,
        content: content,
        actionItems: [
          ChatUIKitDialogAction.confirm(
            label: 'Confirm',
            onTap: () async {
              Navigator.of(context).pop();
              ChatUIKit.instance.logout().then((value) {}).whenComplete(() {
                Navigator.of(context).popAndPushNamed('/login');
              });
            },
          ),
        ]);
  }
}
