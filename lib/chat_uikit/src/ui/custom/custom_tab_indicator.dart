import 'package:flutter/material.dart';

class CustomTabIndicator extends Decoration {
  const CustomTabIndicator({
    this.color,
    this.size = const Size(0, 0),
    this.radius = 0,
  });

  final double radius;
  final Size size;
  final Color? color;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomIndicatorPainter(this, onChanged);
  }
}

class _CustomIndicatorPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomIndicatorPainter(
    this.decoration,
    super.onChanged,
  );

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final centerX = configuration.size!.width / 2 + offset.dx;
    final bottom = configuration.size!.height - decoration.size.height;
    final RRect rRect = RRect.fromLTRBR(
      centerX - decoration.size.width / 2,
      bottom - decoration.size.height,
      centerX + decoration.size.width / 2,
      bottom,
      Radius.circular(decoration.radius),
    );

    canvas.drawRRect(
        rRect,
        Paint()
          ..style = PaintingStyle.fill
          ..color = decoration.color ?? Colors.blue);
  }
}
