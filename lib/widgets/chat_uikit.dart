import 'package:flutter/widgets.dart';

import '../agora_chat_uikit.dart';

class ChatUIKit extends StatefulWidget {
  ChatUIKit({
    super.key,
    this.child,
    ChatUIKitTheme? theme,
  }) : theme = theme ?? ChatUIKitTheme();
  final Widget? child;
  final ChatUIKitTheme theme;

  static Widget init({TransitionBuilder? builder}) {
    if (builder != null) {}
    return ChatUIKit();
  }

  @override
  State<ChatUIKit> createState() => ChatUIKitState();

  static ChatUIKitState of(BuildContext context) {
    ChatUIKitState? state;
    state = context.findAncestorStateOfType<ChatUIKitState>();
    assert(
      state != null,
      'You must have a ChatUIKit widget at the top of the widget',
    );
    return state!;
  }
}

class ChatUIKitState extends State<ChatUIKit> {
  ChatUIKitTheme get theme => widget.theme;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}
