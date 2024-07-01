import 'package:flutter/material.dart';

class ChatUIKitWaterRipper extends StatefulWidget {
  const ChatUIKitWaterRipper({
    required this.color,
    this.duration = const Duration(milliseconds: 1000),
    this.count = 3,
    this.child,
    this.enable = true,
    super.key,
  });

  final int count;
  final Duration duration;
  final Widget? child;
  final Color color;
  final bool enable;

  @override
  State<ChatUIKitWaterRipper> createState() => _ChatUIKitWaterRipperState();
}

class _ChatUIKitWaterRipperState extends State<ChatUIKitWaterRipper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return widget.enable
            ? LayoutBuilder(
                builder: (context, constraints) {
                  return CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: WaterRipplePainter(
                      _controller.value,
                      count: widget.count,
                      color: widget.color,
                      child: widget.child ?? const SizedBox(),
                    ),
                    child: RepaintBoundary(
                      child: child,
                    ),
                  );
                },
              )
            : widget.child ?? const SizedBox();
      },
      child: widget.child,
    );
  }
}

class WaterRipplePainter extends CustomPainter {
  final double progress;
  final int count;
  final Color color;
  final Widget child;

  final Paint _paint = Paint()..style = PaintingStyle.fill;

  WaterRipplePainter(
    this.progress, {
    required this.color,
    this.count = 2,
    required this.child,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double width = 94;
    double height = 64;
    double borderRadius = 100;

    for (int i = count; i >= 0; i--) {
      final double opacity = (1.0 - ((i + progress) / (count + 1)));
      final Color paintColor = color.withOpacity(opacity);
      _paint.color = paintColor;

      double width0 = width * ((i + progress) / (count + 1));
      double height0 = height * ((i + progress) / (count + 1));

      RRect rect = RRect.fromLTRBR(
        (size.width - width0) / 2,
        (size.height - height0) / 2,
        (size.width + width0) / 2,
        (size.height + height0) / 2,
        Radius.circular(borderRadius),
      );

      canvas.drawRRect(rect, _paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
