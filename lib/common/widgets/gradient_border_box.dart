import 'package:flutter/material.dart';

/// A widget that displays a gradient border around its child.
///
/// The border is drawn using a custom painter, with a transparent fill.
/// Useful for notification messages, cards, or any container that needs
/// a gradient outline effect.
class GradientBorderBox extends StatelessWidget {
  final Widget child;
  final List<Color> gradientColors;
  final double borderRadius;
  final double strokeWidth;
  final EdgeInsetsGeometry? padding;

  const GradientBorderBox({
    required this.child,
    required this.gradientColors,
    this.borderRadius = 12.0,
    this.strokeWidth = 1.0,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GradientBorderPainter(
        colors: gradientColors,
        borderRadius: borderRadius,
        strokeWidth: strokeWidth,
      ),
      child: padding != null
          ? Padding(padding: padding!, child: child)
          : child,
    );
  }
}

/// Custom painter for gradient border with transparent fill
class _GradientBorderPainter extends CustomPainter {
  final List<Color> colors;
  final double borderRadius;
  final double strokeWidth;

  _GradientBorderPainter({
    required this.colors,
    required this.borderRadius,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: colors,
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
