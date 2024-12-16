import '../../../../../chat_uikit.dart';
import 'package:flutter/widgets.dart';

class ChatUIKitNonsupportMessageWidget extends StatelessWidget {
  const ChatUIKitNonsupportMessageWidget({
    required this.model,
    this.style,
    this.forceLeft,
    super.key,
  });

  final TextStyle? style;
  final MessageModel model;
  final bool? forceLeft;

  @override
  Widget build(BuildContext context) {
    final theme = ChatUIKitTheme.instance;
    bool left =
        forceLeft ?? model.message.direction == MessageDirection.RECEIVE;
    Widget content = Text(
      ChatUIKitLocal.nonSupportMessage.localString(context),
      textScaler: TextScaler.noScaling,
      overflow: TextOverflow.ellipsis,
      style: style ??
          (left
              ? TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor5
                      : theme.color.neutralColor7,
                )
              : TextStyle(
                  fontWeight: theme.font.bodyLarge.fontWeight,
                  fontSize: theme.font.bodyLarge.fontSize,
                  color: theme.color.isDark
                      ? theme.color.neutralColor1
                      : theme.color.neutralColor98,
                )),
    );

    return content;
  }
}
