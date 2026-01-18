import 'package:flutter/material.dart';

class InnerShadowBox extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Offset offset;
  final double blurRadius;
  final BorderRadius borderRadius;

  const InnerShadowBox({
    super.key,
    required this.child,
    this.color,
    this.offset = const Offset(0, 2),
    this.blurRadius = 4,
    this.borderRadius = BorderRadius.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (color == null || color!.opacity == 0) return child;
    
    return CustomPaint(
      foregroundPainter: _InnerShadowPainter(
        shadowColor: color!,
        offset: offset,
        blurRadius: blurRadius,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _InnerShadowPainter extends CustomPainter {
  final Color shadowColor;
  final Offset offset;
  final double blurRadius;
  final BorderRadius borderRadius;

  _InnerShadowPainter({
    required this.shadowColor,
    required this.offset,
    required this.blurRadius,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = borderRadius.toRRect(Offset.zero & size);

    canvas.save();
    // 1. Clip to the inner area so we don't draw shadow outside the box
    canvas.clipRRect(rrect);

    // 2. Create a paint for the shadow
    final Paint paint = Paint()
      ..color = shadowColor
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, blurRadius);

    // 3. Create a path that is the "inverse" of the box.
    //    We create a large rectangle and subtract the rounded box from it.
    //    This creates a shape that is "solid outside, hole inside".
    final Path rrectPath = Path()..addRRect(rrect);
    final Rect outerRect = rrect.outerRect.inflate(blurRadius + offset.distance + 20);
    final Path outerPath = Path()..addRect(outerRect);
    final Path shapePath = Path.combine(PathOperation.difference, outerPath, rrectPath);

    // 4. Draw this inverse shape with the shadow offset.
    //    The shadow from the edges of the "hole" will fall into the hole.
    canvas.translate(offset.dx, offset.dy);
    canvas.drawPath(shapePath, paint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _InnerShadowPainter oldDelegate) {
    return oldDelegate.shadowColor != shadowColor ||
        oldDelegate.offset != offset ||
        oldDelegate.blurRadius != blurRadius ||
        oldDelegate.borderRadius != borderRadius;
  }
}
