import '../../../chat_uikit.dart';
import 'package:flutter/material.dart';

enum MessageStatusType {
  loading,
  fail,
  succeed,
  deliver,
  read,
}

class ChatUIKitMessageStatusWidget extends StatelessWidget {
  final MessageStatusType statusType;
  final Color? color;
  final double size;
  final VoidCallback? onErrorBtnTap;

  const ChatUIKitMessageStatusWidget({
    required this.statusType,
    this.color,
    this.size = 14,
    this.onErrorBtnTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.of(context);
    switch (statusType) {
      case MessageStatusType.loading:
        {
          return _loading(theme);
        }
      case MessageStatusType.fail:
        {
          return _fail(theme);
        }
      case MessageStatusType.succeed:
        {
          return _succeed(theme);
        }
      case MessageStatusType.deliver:
        {
          return _deliver(theme);
        }
      case MessageStatusType.read:
        {
          return _read(theme);
        }
    }
  }

  Widget _loading(ChatUIKitTheme theme) {
    return SizedBox(
      width: size - 4,
      height: size - 4,
      child: CircularProgressIndicator(
        color: color ??
            (theme.color.isDark
                ? theme.color.neutralColor6
                : theme.color.neutralColor7),
        strokeWidth: 1.5,
      ),
    );
  }

  Widget _deliver(ChatUIKitTheme theme) {
    return Icon(
      Icons.done_all,
      size: size,
      color: color ??
          (theme.color.isDark
              ? theme.color.neutralColor6
              : theme.color.neutralColor7),
    );
  }

  Widget _succeed(ChatUIKitTheme theme) {
    return Icon(
      Icons.check,
      size: size,
      color: color ??
          (theme.color.isDark
              ? theme.color.neutralColor6
              : theme.color.neutralColor7),
    );
  }

  Widget _read(ChatUIKitTheme theme) {
    return Icon(
      Icons.done_all,
      size: size,
      color: color ??
          (theme.color.isDark
              ? theme.color.secondaryColor5
              : theme.color.secondaryColor4),
    );
  }

  Widget _fail(ChatUIKitTheme theme) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onErrorBtnTap,
      child: Icon(
        Icons.error_outline,
        size: size,
        color: color ??
            (theme.color.isDark
                ? theme.color.errorColor6
                : theme.color.errorColor5),
      ),
    );
  }
}
