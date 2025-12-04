import 'package:flutter/material.dart';

/// A shimmer effect widget for skeleton loading states.
///
/// Use this to show placeholder content while data is loading.
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool isCircle;

  const SkeletonLoader({
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius = 4,
    this.isCircle = false,
    super.key,
  });

  /// Factory for circular avatar skeleton
  factory SkeletonLoader.circle({
    double size = 40,
  }) {
    return SkeletonLoader(
      width: size,
      height: size,
      isCircle: true,
    );
  }

  /// Factory for text line skeleton
  factory SkeletonLoader.text({
    double? width,
    double height = 14,
  }) {
    return SkeletonLoader(
      width: width ?? double.infinity,
      height: height,
      borderRadius: 4,
    );
  }

  /// Factory for card skeleton
  factory SkeletonLoader.card({
    double? width,
    double height = 120,
    double borderRadius = 12,
  }) {
    return SkeletonLoader(
      width: width ?? double.infinity,
      height: height,
      borderRadius: borderRadius,
    );
  }

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.isCircle
                ? null
                : BorderRadius.circular(widget.borderRadius),
            shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFF2D3245),
                Color(0xFF3D4255),
                Color(0xFF2D3245),
              ],
              stops: [
                0.0,
                0.5 + (_animation.value / 4),
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A skeleton list item for loading states in lists.
class SkeletonListItem extends StatelessWidget {
  final bool showAvatar;
  final bool showSubtitle;
  final bool showTrailing;

  const SkeletonListItem({
    this.showAvatar = true,
    this.showSubtitle = true,
    this.showTrailing = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (showAvatar) ...[
            SkeletonLoader.circle(size: 40),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader.text(width: 120, height: 16),
                if (showSubtitle) ...[
                  const SizedBox(height: 8),
                  SkeletonLoader.text(width: 180, height: 12),
                ],
              ],
            ),
          ),
          if (showTrailing) ...[
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SkeletonLoader.text(width: 60, height: 16),
                const SizedBox(height: 8),
                SkeletonLoader.text(width: 40, height: 12),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// A skeleton for chart loading states.
class SkeletonChart extends StatelessWidget {
  final double height;

  const SkeletonChart({
    this.height = 200,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SkeletonLoader.text(width: 100, height: 24),
            SkeletonLoader.text(width: 60, height: 16),
          ],
        ),
        const SizedBox(height: 16),
        SkeletonLoader.card(height: height, borderRadius: 8),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkeletonLoader.text(width: 80, height: 12),
            const SizedBox(width: 16),
            SkeletonLoader.text(width: 80, height: 12),
          ],
        ),
      ],
    );
  }
}

/// A skeleton for card grid loading states.
class SkeletonCardGrid extends StatelessWidget {
  final int itemCount;
  final double cardHeight;
  final double cardWidth;
  final Axis scrollDirection;

  const SkeletonCardGrid({
    this.itemCount = 3,
    this.cardHeight = 120,
    this.cardWidth = 160,
    this.scrollDirection = Axis.horizontal,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (scrollDirection == Axis.horizontal) {
      return SizedBox(
        height: cardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, index) => SkeletonLoader.card(
            width: cardWidth,
            height: cardHeight,
          ),
        ),
      );
    }

    return Column(
      children: List.generate(
        itemCount,
        (index) => Padding(
          padding: EdgeInsets.only(bottom: index < itemCount - 1 ? 12 : 0),
          child: SkeletonLoader.card(height: cardHeight),
        ),
      ),
    );
  }
}
