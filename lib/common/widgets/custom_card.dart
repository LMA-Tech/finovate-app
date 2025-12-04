import 'package:flutter/material.dart';

/// A reusable card component with consistent styling across the app.
///
/// Supports three variants:
/// - `default`: Standard card with solid background
/// - `elevated`: Card with subtle shadow
/// - `outlined`: Card with border, no fill
class CustomCard extends StatelessWidget {
  final Widget child;
  final CardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Widget? header;
  final Widget? footer;

  const CustomCard({
    required this.child,
    this.variant = CardVariant.defaultCard,
    this.padding,
    this.margin,
    this.borderRadius = 12,
    this.backgroundColor,
    this.onTap,
    this.header,
    this.footer,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (header != null) ...[
          header!,
          const SizedBox(height: 12),
        ],
        child,
        if (footer != null) ...[
          const SizedBox(height: 12),
          footer!,
        ],
      ],
    );

    final decoration = _getDecoration();

    Widget card = Container(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: decoration,
      child: cardContent,
    );

    if (onTap != null) {
      card = GestureDetector(
        onTap: onTap,
        child: card,
      );
    }

    return card;
  }

  BoxDecoration _getDecoration() {
    switch (variant) {
      case CardVariant.defaultCard:
        return BoxDecoration(
          color: backgroundColor ?? const Color(0xFF2D3245),
          borderRadius: BorderRadius.circular(borderRadius),
        );
      case CardVariant.elevated:
        return BoxDecoration(
          color: backgroundColor ?? const Color(0xFF2D3245),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        );
      case CardVariant.outlined:
        return BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: const Color(0xFF3D4255),
            width: 1,
          ),
        );
    }
  }
}

enum CardVariant {
  defaultCard,
  elevated,
  outlined,
}
