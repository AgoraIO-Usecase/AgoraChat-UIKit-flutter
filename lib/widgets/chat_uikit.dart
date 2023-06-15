import 'package:flutter/widgets.dart';

import '../agora_chat_uikit.dart';
import '../internal/chat_uikit_manager.dart';

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
  late final ChatConversationsController _controller;

  ChatUIKitTheme get theme => widget.theme;
  ChatConversationsController get conversationsController => _controller;

  @override
  void initState() {
    super.initState();
    ChatUIKitManager.shared;
    _controller = ChatConversationsController();
  }

  @override
  void dispose() {
    ChatUIKitManager.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? Container();
  }
}
