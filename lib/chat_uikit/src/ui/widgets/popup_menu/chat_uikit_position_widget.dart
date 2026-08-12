import 'package:flutter/material.dart';

import '../../../universal/chat_uikit_defines.dart';

class ChatUIKitPositionWidget extends StatefulWidget {
  const ChatUIKitPositionWidget({
    required this.child,
    this.onDoubleTapPositionHandler,
    this.onTapPositionHandler,
    this.onLongPressPositionHandler,
    super.key,
  });
  final Widget child;

  final ChatUIKitPositionWidgetHandler? onTapPositionHandler;
  final ChatUIKitPositionWidgetHandler? onDoubleTapPositionHandler;
  final ChatUIKitPositionWidgetHandler? onLongPressPositionHandler;

  @override
  State<ChatUIKitPositionWidget> createState() =>
      _ChatUIKitPositionWidgetState();
}

class _ChatUIKitPositionWidgetState extends State<ChatUIKitPositionWidget> {
  late RenderBox current;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((call) {
      if (mounted) {
        current = context.findRenderObject() as RenderBox;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () {
        final Offset offset = current.localToGlobal(Offset.zero);
        widget.onDoubleTapPositionHandler?.call(
          Rect.fromLTWH(
              offset.dx, offset.dy, current.size.width, current.size.height),
        );
      },
      onLongPress: () {
        final Offset offset = current.localToGlobal(Offset.zero);
        widget.onLongPressPositionHandler?.call(
          Rect.fromLTWH(
              offset.dx, offset.dy, current.size.width, current.size.height),
        );
      },
      onTap: () {
        final Offset offset = current.localToGlobal(Offset.zero);
        widget.onTapPositionHandler?.call(
          Rect.fromLTWH(
              offset.dx, offset.dy, current.size.width, current.size.height),
        );
      },
      child: widget.child,
    );
  }
}
