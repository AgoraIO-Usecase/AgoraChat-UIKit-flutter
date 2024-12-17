import 'dart:math';

import 'package:flutter/material.dart';

import '../../../chat_uikit.dart';

const double _kHorizontalPadding = 21;
const double _verticalPadding = 50;
const double _kMenuArrowHeight = 10.0;
const double _kMenuArrowWidth = 16.0;
const double kMenuHorizontalPadding = 8.0;
const double _kMenuDividerHeight = 0.5;

class ChatUIKitPopupMenuStyle {
  const ChatUIKitPopupMenuStyle({
    this.shadowColor,
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.foregroundColor = const Color(0xFF000000),
    this.dividerColor = const Color(0xFFE0E0E0),
    this.radiusCircular = 4,
  });

  final Color backgroundColor;
  final Color foregroundColor;
  final Color dividerColor;
  final Color? shadowColor;
  final double radiusCircular;
}

class ChatUIKitPopupMenu extends StatefulWidget {
  const ChatUIKitPopupMenu({
    required this.child,
    required this.controller,
    this.style = const ChatUIKitPopupMenuStyle(),
    super.key,
  });
  final Widget child;
  final ChatUIKitPopupMenuController controller;
  final ChatUIKitPopupMenuStyle style;
  @override
  State<ChatUIKitPopupMenu> createState() => _ChatUIKitPopupMenuState();
}

class _ChatUIKitPopupMenuState extends State<ChatUIKitPopupMenu>
    with WidgetsBindingObserver {
  OverlayEntry? entry;
  Offset? menuLeftTop;
  Offset? menuRightBottom;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((call) {
      RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      RenderBox current = context.findRenderObject() as RenderBox;
      Rect rect = Rect.fromPoints(
        current.localToGlobal(Offset.zero),
        current.localToGlobal(Offset(current.size.width, current.size.height),
            ancestor: overlay),
      );

      menuLeftTop = rect.topLeft;
      menuRightBottom = rect.bottomRight;
    });

    widget.controller.addListener(() {
      if (widget.controller.isShow) {
        showMenu();
      } else {
        hideMenu();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = NotificationListener(
        child: widget.child,
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
            widget.controller.hideMenu();
          }
          return true;
        });

    content = Listener(
      onPointerHover: (event) {
        widget.controller.hideMenu();
      },
      child: content,
    );

    return content;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ChatUIKitPopupMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback((call) {
      RenderBox overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      RenderBox current = context.findRenderObject() as RenderBox;
      Rect rect = Rect.fromPoints(
        current.localToGlobal(Offset.zero),
        current.localToGlobal(Offset(current.size.width, current.size.height),
            ancestor: overlay),
      );

      menuLeftTop = rect.topLeft;
      menuRightBottom = rect.bottomRight;
    });
    super.didChangeDependencies();
  }

  void showMenu() {
    hideMenu();

    double maxWidth =
        MediaQuery.of(context).size.width - _kHorizontalPadding * 2;

    double reactionHeight = 0;
    if (widget.controller.topWidget != null) {
      reactionHeight = 40 + kMenuHorizontalPadding + kMenuHorizontalPadding;
    }

    double itemWidth = maxWidth / 5;
    double itemHeight = itemWidth / 68 * 58;
    double menuHeight =
        (widget.controller.list!.length / 5).ceil() * itemHeight +
            kMenuHorizontalPadding * 2;
    double menuWidth =
        min(maxWidth, itemWidth * widget.controller.list!.length);

    double dy = 0;
    double dx = 0;
    bool arrowOnTop = false;

    if (widget.controller.rect!.top -
            menuHeight -
            reactionHeight -
            _kMenuArrowHeight -
            _verticalPadding >
        menuLeftTop!.dy) {
      dy = widget.controller.rect!.top -
          menuHeight -
          reactionHeight -
          _kMenuArrowHeight;
      arrowOnTop = false;
    } else if (widget.controller.rect!.top +
            widget.controller.rect!.height +
            reactionHeight +
            _kMenuArrowHeight +
            menuHeight +
            _verticalPadding <
        menuRightBottom!.dy) {
      dy = widget.controller.rect!.top +
          widget.controller.rect!.height +
          _kMenuArrowHeight;
      arrowOnTop = true;
    } else {
      dy = menuRightBottom!.dy -
          menuHeight -
          _kMenuArrowHeight -
          _verticalPadding -
          reactionHeight;
      arrowOnTop = true;
    }
    double offset = 0;
    if (widget.controller.topWidget == null) {
      if (widget.controller.list!.length < 5) {
        dx = widget.controller.rect!.left -
            menuWidth / 2 +
            widget.controller.rect!.width / 2;

        if (dx + menuWidth > maxWidth) {
          double x = maxWidth - menuWidth;
          offset = x - dx;
          dx = x;
        } else if (dx < 0) {
          double x = 0;
          offset = x - dx + _kHorizontalPadding;
          dx = x;
        }
      }
    }

    // debugPrint(widget.controller.rect!.top.toString());
    // debugPrint(widget.controller.rect!.height.toString());
    // debugPrint(menuLeftTop.toString());
    // debugPrint(menuRightBottom.toString());

    // debugPrint('menuHeight: $menuHeight');
    // if (arrowOnTop) {
    //   if ((menuRightBottom!.dy - menuLeftTop!.dy) >
    //       (widget.controller.rect!.top + widget.controller.rect!.height)) {
    //     debugPrint('箭头正确');
    //   } else {
    //     debugPrint('箭头错误');
    //   }
    // }

    Widget menuWidget = _PopUpMenuWidget(
      offset: offset,
      topWidget: widget.controller.topWidget,
      arrowOnTop: arrowOnTop,
      actions: widget.controller.list!,
      rect: widget.controller.rect!,
      leftTop: menuLeftTop!,
      rightBottom: menuRightBottom!,
      style: widget.style,
      close: () => widget.controller.hideMenu(),
    );

    entry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: dx == 0 ? _kHorizontalPadding : dx,
          top: dy,
          width: widget.controller.topWidget != null ? maxWidth : menuWidth,
          child: menuWidget,
        );
      },
    );
    Overlay.of(context).insert(entry!);
  }

  void hideMenu() {
    if (entry != null) {
      entry?.remove();
      entry = null;
    }
  }
}

class ChatUIKitPopupMenuController with ChangeNotifier {
  ChatUIKitPopupMenuController();

  Widget? topWidget;
  bool isShow = false;
  Rect? rect;

  List<ChatUIKitEventAction>? list;

  void showMenu(
    Widget? topWidget,
    Rect rect,
    List<ChatUIKitEventAction> list,
  ) {
    this.topWidget = topWidget;
    this.rect = rect;
    this.list = list;
    isShow = true;
    notifyListeners();
  }

  void hideMenu() {
    if (isShow) {
      isShow = false;
      rect = null;
      list = null;
      notifyListeners();
    }
  }
}

class _PopUpMenuWidget extends StatefulWidget {
  final List<ChatUIKitEventAction> actions;
  final Rect rect;
  final Offset leftTop;
  final Offset rightBottom;
  final ChatUIKitPopupMenuStyle style;
  final VoidCallback? close;
  final bool arrowOnTop;
  final Widget? topWidget;
  final double offset;
  const _PopUpMenuWidget({
    required this.actions,
    required this.rect,
    required this.leftTop,
    required this.rightBottom,
    required this.style,
    required this.arrowOnTop,
    this.topWidget,
    this.offset = 0,
    this.close,
  });

  @override
  State<_PopUpMenuWidget> createState() => _PopupMenuWidgetState();
}

class _PopupMenuWidgetState extends State<_PopUpMenuWidget> {
  double opacity = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth =
        MediaQuery.of(context).size.width - _kHorizontalPadding * 2;

    double itemWidth = maxWidth / 5;
    double itemHeight = itemWidth / 68 * 58;

    Widget content = Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.start,
      children: widget.actions.map((item) {
        return InkWell(
          onTap: () {
            widget.close?.call();
            item.onTap?.call();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            width: itemWidth,
            height: itemHeight,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (item.icon != null)
                  SizedBox(
                    height: 28,
                    width: 28,
                    child: item.icon!,
                  ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textScaler: TextScaler.noScaling,
                  style: TextStyle(
                    color: widget.style.foregroundColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );

    content = Container(
      padding: const EdgeInsets.symmetric(vertical: kMenuHorizontalPadding),
      decoration: BoxDecoration(
        color: widget.style.backgroundColor,
        borderRadius: BorderRadius.circular(widget.style.radiusCircular),
      ),
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: itemHeight,
      ),
      child: content,
    );

    content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [content],
    );

    if (widget.topWidget != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.arrowOnTop) ...[
            SizedBox(
              width: maxWidth,
              child: Padding(
                  padding: const EdgeInsets.only(
                    top: kMenuHorizontalPadding,
                    left: kMenuHorizontalPadding + 5,
                    right: kMenuHorizontalPadding + 5,
                  ),
                  child: widget.topWidget),
            ),
            const SizedBox(height: kMenuHorizontalPadding),
            Divider(
              height: _kMenuDividerHeight,
              indent: _kHorizontalPadding,
              endIndent: _kHorizontalPadding,
              color: widget.style.dividerColor,
            ),
          ],
          content,
          if (!widget.arrowOnTop) ...[
            Divider(
              height: _kMenuDividerHeight,
              indent: _kHorizontalPadding,
              endIndent: _kHorizontalPadding,
              color: widget.style.dividerColor,
            ),
            const SizedBox(height: kMenuHorizontalPadding),
            SizedBox(
              width: maxWidth,
              child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: kMenuHorizontalPadding,
                    left: kMenuHorizontalPadding + 5,
                    right: kMenuHorizontalPadding + 5,
                  ),
                  child: widget.topWidget),
            )
          ],
        ],
      );
    }

    content = CustomPaint(
      size: const Size(8, _kMenuArrowHeight),
      painter: _TrianglePainter(
        offset: widget.offset,
        shadowColor: widget.style.shadowColor,
        color: widget.style.backgroundColor,
        bubbleRect: widget.rect,
        arrowOnTop: widget.arrowOnTop,
        arrowWidth: _kMenuArrowWidth,
        arrowHeight: _kMenuArrowHeight,
        borderRadius: widget.style.radiusCircular,
        screenWidth:
            widget.leftTop.dx + widget.rightBottom.dx - _kHorizontalPadding * 2,
      ),
      child: RepaintBoundary(
        child: content,
      ),
    );

    if (widget.topWidget == null) {
      content = Row(
        children: [content],
      );
    }

    content = AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: content,
    );

    content = Material(
      color: Colors.transparent,
      child: content,
    );
    content = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: content,
    );

    content = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        widget.close?.call();
      },
      child: content,
    );

    return content;
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  final double arrowWidth;
  final double arrowHeight;
  final double borderRadius;
  final Rect bubbleRect;
  final double screenWidth;
  final double offset;
  final Color? shadowColor;
  _TrianglePainter({
    required this.color,
    this.shadowColor,
    this.offset = 0,
    required this.arrowWidth,
    required this.arrowHeight,
    required this.bubbleRect,
    required this.screenWidth,
    this.borderRadius = 8,
    this.arrowOnTop = true,
  });

  final bool arrowOnTop;

  @override
  void paint(Canvas canvas, Size size) {
    final shadowColor = this.shadowColor ?? Colors.black.withOpacity(0.9);
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    Rect rect = Rect.fromPoints(
      const Offset(0, 0),
      Offset(size.width, size.height),
    );
    RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    canvas.drawRRect(rRect, paint);

    Path path = Path()..addRRect(rRect);

    double x = 0;

    if (size.width > bubbleRect.width && size.width == screenWidth) {
      x = bubbleRect.left - _kHorizontalPadding + bubbleRect.width / 2 - offset;
    } else {
      x = size.width / 2 - offset;
    }

    if (arrowOnTop) {
      path.moveTo(x - arrowWidth / 2, 0);
      path.lineTo(x, -arrowHeight);
      path.lineTo(x + arrowWidth / 2, 0);
    } else {
      path.moveTo(x - arrowWidth / 2, size.height);
      path.lineTo(x, size.height + arrowHeight);
      path.lineTo(x + arrowWidth / 2, size.height);
    }

    path.close();
    canvas.drawShadow(path.shift(const Offset(0, -2)),
        shadowColor.withOpacity(1), 2.0, false);
    canvas.drawShadow(path.shift(const Offset(0, 0)),
        shadowColor.withOpacity(0.5), 2.0, false);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
