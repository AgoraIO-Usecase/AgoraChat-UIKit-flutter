import 'package:flutter/material.dart';

import '../../../../chat_uikit.dart';

const double arrowWidth = 4.2;
const double arrowPadding = 8.0;
const double arrowHeight = 8.0;
const double arrowPosition = 10.0;

enum ChatUIKitMessageListViewBubbleStyle {
  arrow,
  noArrow,
}

class ChatUIKitMessageBubbleWidget extends StatefulWidget {
  const ChatUIKitMessageBubbleWidget({
    required this.child,
    this.isLeft = true,
    this.style,
    this.color,
    this.needSmallCorner = true,
    this.padding,
    this.isVisible = true,
    super.key,
  });
  final Widget child;
  final bool isLeft;
  final Color? color;
  final bool needSmallCorner;
  final EdgeInsets? padding;
  final bool isVisible;

  final ChatUIKitMessageListViewBubbleStyle? style;
  @override
  State<ChatUIKitMessageBubbleWidget> createState() =>
      _ChatUIKitMessageBubbleWidgetState();
}

class _ChatUIKitMessageBubbleWidgetState
    extends State<ChatUIKitMessageBubbleWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child;
    if (widget.isVisible == false) {
      return content;
    }
    final theme = ChatUIKitTheme.instance;

    if ((widget.style ?? ChatUIKitSettings.messageBubbleStyle) ==
        ChatUIKitMessageListViewBubbleStyle.arrow) {
      content = CustomPaint(
          painter: _BubblePainter(
            color: widget.color ??
                (!widget.isLeft
                    ? (theme.color.isDark
                        ? theme.color.primaryColor6
                        : theme.color.primaryColor5)
                    : (theme.color.isDark
                        ? theme.color.primaryColor2
                        : theme.color.primaryColor95)),
            isLeft: widget.isLeft,
          ),
          child: RepaintBoundary(
            child: Padding(
              padding: () {
                if (widget.padding != null) {
                  return EdgeInsets.only(
                    left:
                        widget.padding!.left + (widget.isLeft ? arrowWidth : 0),
                    right: widget.padding!.right +
                        (!widget.isLeft ? arrowWidth : 0),
                    top: widget.padding!.top,
                    bottom: widget.padding!.bottom,
                  );
                } else {
                  return EdgeInsets.only(
                    left: (widget.isLeft ? arrowWidth : 0) + 12,
                    right: (!widget.isLeft ? arrowWidth : 0) + 12,
                    top: 7,
                    bottom: 7,
                  );
                }
              }(),
              child: widget.child,
            ),
          ));
    } else {
      content = Container(
        decoration: BoxDecoration(
          color: widget.color ??
              (!widget.isLeft
                  ? (theme.color.isDark
                      ? theme.color.primaryColor6
                      : theme.color.primaryColor5)
                  : (theme.color.isDark
                      ? theme.color.primaryColor2
                      : theme.color.primaryColor95)),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
                widget.isLeft ? (!widget.needSmallCorner ? 4 : 12) : 16),
            topRight: Radius.circular(
                !widget.isLeft ? (!widget.needSmallCorner ? 4 : 12) : 16),
            bottomLeft: Radius.circular(widget.isLeft ? 4 : 16),
            bottomRight: Radius.circular(!widget.isLeft ? 4 : 16),
          ),
        ),
        child: Padding(
          padding: widget.padding ??
              const EdgeInsets.only(
                left: 12,
                right: 12,
                top: 7,
                bottom: 7,
              ),
          child: widget.child,
        ),
      );
    }

    return content;
  }
}

class _BubblePainter extends CustomPainter {
  _BubblePainter({
    required this.color,
    this.isLeft = true,
  });

  final bool isLeft;

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Rect rect = Rect.fromPoints(
      Offset(isLeft ? arrowWidth : 0, 0),
      Offset(size.width - (!isLeft ? arrowWidth : 0), size.height),
    );
    RRect rRect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
    canvas.drawRRect(rRect, paint);

    Path path = Path();
    if (isLeft) {
      path.moveTo(arrowWidth, size.height - arrowPosition);
      path.lineTo(0, size.height - arrowPosition - arrowHeight / 2);
      path.lineTo(arrowWidth, size.height - arrowPosition - arrowHeight);
    } else {
      path.moveTo(size.width - arrowWidth, size.height - arrowPosition);
      path.lineTo(size.width, size.height - arrowPosition - arrowHeight / 2);
      path.lineTo(
          size.width - arrowWidth, size.height - arrowPosition - arrowHeight);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
