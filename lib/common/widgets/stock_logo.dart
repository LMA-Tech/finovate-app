import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// Reusable stock logo widget that handles network images (SVG and raster),
/// with fallback to showing ticker initials.
class StockLogo extends StatelessWidget {
  final String? logoUrl;
  final String ticker;
  final double size;
  final BorderRadius? borderRadius;
  final bool showBorder;
  final Color? borderColor;

  const StockLogo({
    required this.ticker,
    this.logoUrl,
    this.size = FinSizes.avatarMd,
    this.borderRadius,
    this.showBorder = false,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(FinSizes.borderRadiusMd);

    if (logoUrl != null && logoUrl!.isNotEmpty) {
      final isSvg = logoUrl!.toLowerCase().endsWith('.svg');

      if (isSvg) {
        return _buildContainer(
          radius: radius,
          child: SvgPicture.network(
            logoUrl!,
            width: size,
            height: size,
            fit: BoxFit.cover,
            placeholderBuilder: (_) => _buildPlaceholderContent(),
          ),
        );
      }

      return _buildContainer(
        radius: radius,
        child: Image.network(
          logoUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholderContent(),
        ),
      );
    }

    return _buildPlaceholder(radius);
  }

  Widget _buildContainer({required BorderRadius radius, required Widget child}) {
    if (showBorder) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: borderColor ?? FinColors.borderMint,
            width: FinSizes.borderWidthSm,
          ),
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ),
      );
    }

    return ClipRRect(
      borderRadius: radius,
      child: child,
    );
  }

  Widget _buildPlaceholder(BorderRadius radius) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: radius,
        border: showBorder
            ? Border.all(
                color: borderColor ?? FinColors.borderMint,
                width: FinSizes.borderWidthSm,
              )
            : null,
      ),
      child: _buildPlaceholderContent(),
    );
  }

  Widget _buildPlaceholderContent() {
    final displayText = ticker.length > 2 ? ticker.substring(0, 2) : ticker;

    return Center(
      child: Text(
        displayText.isNotEmpty ? displayText : '?',
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w600,
          color: FinColors.textWhite,
        ),
      ),
    );
  }
}
