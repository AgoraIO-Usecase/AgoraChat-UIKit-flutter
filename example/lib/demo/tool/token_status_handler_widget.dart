import 'package:agora_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';

class TokenStatusHandlerWidget extends StatefulWidget {
  const TokenStatusHandlerWidget({required this.child, super.key});

  final Widget child;

  @override
  State<TokenStatusHandlerWidget> createState() =>
      _TokenStatusHandlerWidgetState();
}

class _TokenStatusHandlerWidgetState extends State<TokenStatusHandlerWidget>
    with ConnectObserver {
  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    ChatUIKit.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void onConnected() {
    debugPrint('onConnected');
  }

  @override
  void onDisconnected() {
    debugPrint('onDisconnected');
  }

  @override
  void onUserDidLoginFromOtherDevice(LoginExtensionInfo info) {
    showDialogInfo(title: 'Login From ${info.deviceName}');
  }

  @override
  void onUserDidRemoveFromServer() {
    debugPrint('onUserDidRemoveFromServer');
    showDialogInfo(
        title: 'User Removed', content: 'Please contact the administrator');
  }

  @override
  void onUserDidForbidByServer() {
    debugPrint('onUserDidForbidByServer');
    showDialogInfo(
        title: 'User Forbidden', content: 'Please contact the administrator');
  }

  @override
  void onUserDidChangePassword() {
    debugPrint('onUserDidChangePassword');
    showDialogInfo(title: 'Password Changed', content: 'Please login again');
  }

  @override
  void onUserDidLoginTooManyDevice() {
    debugPrint('onUserDidLoginTooManyDevice');
    showDialogInfo(title: 'LoginTooManyDevice');
  }

  @override
  void onUserKickedByOtherDevice() {
    debugPrint('onUserKickedByOtherDevice');
    showDialogInfo(title: 'KickedByOtherDevice');
  }

  @override
  void onUserAuthenticationFailed() {
    debugPrint('onUserAuthenticationFailed');
    showDialogInfo(
        title: 'Authentication Failed', content: 'Please login again');
  }

  @override
  void onTokenWillExpire() {
    debugPrint('onTokenWillExpire');
  }

  @override
  void onTokenDidExpire() {
    showDialogInfo(title: 'Token Expired', content: 'Please login again');
  }

  @override
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
                toLoginPage();
              });
            },
          ),
        ]);
  }

  void toLoginPage() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}
