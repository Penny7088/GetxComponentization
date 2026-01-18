import 'package:flutter/material.dart';
import 'package:lib_uikit/widget/app_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommonSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double>? onChanged;
  final int divisions;
  final double min;
  final double max;
  final Color? activeColor;
  final Color? inactiveColor;

  const CommonSlider({
    super.key,
    required this.value,
    this.onChanged,
    this.divisions = 3, // Default 4 points (0, 33, 66, 100)
    this.min = 0.0,
    this.max = 100.0,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  State<CommonSlider> createState() => _CommonSliderState();
}

class _CommonSliderState extends State<CommonSlider> {
  // Height of the track at the left end
  final double _minTrackHeight = 6.0;
  // Height of the track at the right end
  final double _maxTrackHeight = 16.0;
  final double _thumbSize = 28.0;
  final double _tooltipHeight = 34.0;
  final double _tooltipWidth = 50.0;
  final double _tooltipGap = 8.0; // Gap between tooltip and thumb

  void _handlePanUpdate(DragUpdateDetails details, double width) {
    if (widget.onChanged == null) return;

    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);

    // Calculate value based on horizontal position
    // Remove thumb padding from calculation area
    final double x = localOffset.dx.clamp(0.0, width);
    final double percent = x / width;

    final double newValue = widget.min + (widget.max - widget.min) * percent;

    // Snap to divisions if needed, but for smooth slider we might not want snap
    // If divisions > 0, we can snap or just show dots.
    // Usually sliders with dots snap, but let's make it smooth for now based on the image.
    // The image shows the thumb NOT exactly on a dot, so it's likely continuous.

    widget.onChanged!(newValue.clamp(widget.min, widget.max));
  }

  void _handleTapDown(TapDownDetails details, double width) {
    if (widget.onChanged == null) return;

    final double x = details.localPosition.dx.clamp(0.0, width);
    final double percent = x / width;
    final double newValue = widget.min + (widget.max - widget.min) * percent;

    widget.onChanged!(newValue.clamp(widget.min, widget.max));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = widget.activeColor ?? theme.primaryColor;
    final inactiveColor =
        widget.inactiveColor ?? theme.primaryColor.withOpacity(0.15);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        // Total height needs to accommodate tooltip + gap + thumb + shadows
        final totalHeight = _tooltipHeight + _tooltipGap + _thumbSize + 10;

        // Current percentage (0.0 - 1.0)
        final double percentage =
            (widget.value - widget.min) / (widget.max - widget.min);
        final double thumbX = width * percentage;

        return GestureDetector(
          onPanUpdate: (details) => _handlePanUpdate(details, width),
          onPanDown: (details) => _handlePanDown(details, width),
          onTapDown: (details) => _handleTapDown(details, width),
          child: SizedBox(
            height: totalHeight,
            width: width,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Track Layer
                Positioned(
                  left: 0,
                  right: 0,
                  bottom:
                      (_thumbSize - _maxTrackHeight) / 2 +
                      5, // Center vertically relative to thumb
                  child: SizedBox(
                    height: _maxTrackHeight,
                    child: CustomPaint(
                      painter: _TrackPainter(
                        percentage: percentage,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        minHeight: _minTrackHeight,
                        maxHeight: _maxTrackHeight,
                        divisions: widget.divisions,
                      ),
                    ),
                  ),
                ),

                // Thumb Layer
                Positioned(
                  left: thumbX - (_thumbSize / 2),
                  bottom: 5, // Bottom padding for shadow
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: activeColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: activeColor.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),

                // Tooltip Layer
                Positioned(
                  left: thumbX - (_tooltipWidth / 2),
                  bottom: _thumbSize + _tooltipGap,
                  child: _buildTooltip(percentage),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handlePanDown(DragDownDetails details, double width) {
    // Optional: handle touch down animation or logic
  }

  Widget _buildTooltip(double percentage) {
    final theme = Theme.of(context);
    final int value = (percentage * 100).round();
    final tooltipColor = theme.cardColor;
    final textColor = theme.textTheme.bodyMedium?.color;

    return Container(
      width: _tooltipWidth,
      height: _tooltipHeight,
      decoration: BoxDecoration(
        color: tooltipColor,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AppText.smallBold('$value%', color: textColor),
          // Triangle arrow
          Positioned(
            bottom: -6,
            child: CustomPaint(
              size: const Size(12, 6),
              painter: _TrianglePainter(color: tooltipColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackPainter extends CustomPainter {
  final double percentage;
  final Color activeColor;
  final Color inactiveColor;
  final double minHeight;
  final double maxHeight;
  final int divisions;

  _TrackPainter({
    required this.percentage,
    required this.activeColor,
    required this.inactiveColor,
    required this.minHeight,
    required this.maxHeight,
    required this.divisions,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height; // This is maxHeight

    // Calculate the path for the full wedge track
    // Left side height is minHeight, centered vertically relative to h
    // Right side height is maxHeight (h)

    final double leftTopY = (h - minHeight) / 2;
    final double leftBottomY = (h + minHeight) / 2;
    final double rightTopY = 0;
    final double rightBottomY = h;

    // Full Track Path (Inactive Background)
    final Path fullPath = Path()
      ..moveTo(0, leftTopY)
      ..lineTo(w, rightTopY)
      ..lineTo(w, rightBottomY)
      ..lineTo(0, leftBottomY)
      ..close();

    // Draw Inactive Track
    final Paint inactivePaint = Paint()
      ..color = inactiveColor
      ..style = PaintingStyle.fill;

    // Clip the track to rounded corners
    final RRect fullRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h), // Approximate bounds for clipping
      const Radius.circular(100), // Fully rounded caps
    );
    // Since it's a wedge, simple RRect clipping isn't perfect but for small height diffs it works.
    // Better: ClipPath with rounded ends.
    // Let's manually draw rounded caps.

    // Actually, simply drawing a thick line with StrokeCap.round doesn't create a wedge.
    // We need to draw the shape.

    canvas.save();
    // Use a clip path that follows the wedge shape but adds rounded ends
    final Path clipPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, w, h),
          Radius.circular(h / 2),
        ),
      );
    // The above clip is a rectangle. We want the wedge shape.

    // Let's just draw the wedge and rely on small height for rounded corners look,
    // or add circles at ends.

    // Draw Inactive
    canvas.drawPath(fullPath, inactivePaint);

    // Draw Active Track (Clipped)
    final double activeW = w * percentage;
    if (activeW > 0) {
      final Paint activePaint = Paint()
        ..color = activeColor
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.clipRect(Rect.fromLTWH(0, 0, activeW, h));
      canvas.drawPath(fullPath, activePaint);
      canvas.restore();
    }

    // Draw rounded caps for smoother look
    // Left Cap
    canvas.drawCircle(
      Offset(0, h / 2),
      minHeight / 2,
      activeW > 0 ? (Paint()..color = activeColor) : inactivePaint,
    );
    // Right Cap
    canvas.drawCircle(Offset(w, h / 2), maxHeight / 2, inactivePaint);

    // Draw Dots
    if (divisions > 0) {
      final Paint dotPaint = Paint()
        ..color = Colors.white.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      final double step = w / divisions;
      for (int i = 0; i <= divisions; i++) {
        final double dx = step * i;
        // Interpolate height at this x
        // h_at_x = minH + (maxH - minH) * (x/w)
        // But we just need vertical center, which is always h/2
        final double dy = h / 2;

        // Don't draw dot if it's under the thumb (optional, but looks cleaner)
        // if ((dx - activeW).abs() < 10) continue;

        canvas.drawCircle(Offset(dx, dy), 2.5, dotPaint);
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _TrackPainter oldDelegate) {
    return percentage != oldDelegate.percentage ||
        activeColor != oldDelegate.activeColor ||
        inactiveColor != oldDelegate.inactiveColor;
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;

  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
