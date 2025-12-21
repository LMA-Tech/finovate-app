import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/formatters.dart';

/// A pill-shaped widget showing price change with appropriate colors and icon.
/// Used for displaying stock price changes with positive/negative/neutral states.
class TrendChangePill extends StatelessWidget {
  final double changeValue;
  final double changePercent;
  final bool showValue;

  const TrendChangePill({
    required this.changeValue,
    required this.changePercent,
    this.showValue = true,
    super.key,
  });

  /// Create from pre-calculated positive/negative state
  factory TrendChangePill.fromState({
    required double changeValue,
    required double changePercent,
    required bool isPositive,
    required bool isNegative,
    bool showValue = true,
  }) {
    return _TrendChangePillWithState(
      changeValue: changeValue,
      changePercent: changePercent,
      isPositive: isPositive,
      isNegative: isNegative,
      showValue: showValue,
    );
  }

  bool get isPositive => changeValue > 0;
  bool get isNegative => changeValue < 0;

  @override
  Widget build(BuildContext context) {
    return _buildPill(
      isPositive: isPositive,
      isNegative: isNegative,
    );
  }

  Widget _buildPill({required bool isPositive, required bool isNegative}) {
    final Color backgroundColor;
    final Color textColor;
    final IconData? icon;

    if (isPositive) {
      backgroundColor = FinColors.trendPositiveBg;
      textColor = FinColors.textDark;
      icon = Icons.arrow_upward;
    } else if (isNegative) {
      backgroundColor = FinColors.trendNegativeBg;
      textColor = FinColors.textWhite;
      icon = Icons.arrow_downward;
    } else {
      backgroundColor = FinColors.trendNeutralBg;
      textColor = FinColors.textDark;
      icon = null;
    }

    final formattedPercent = FinFormatters.formatPercent(changePercent);
    final displayText = showValue
        ? 'R\$ ${FinFormatters.formatCurrency(changeValue.abs(), showSign: false)} ($formattedPercent)'
        : formattedPercent;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: FinSizes.sm,
        vertical: FinSizes.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: FinSizes.iconXs,
              color: textColor,
            ),
            const SizedBox(width: FinSizes.xs / 2),
          ],
          Text(
            displayText,
            style: TextStyle(
              fontSize: FinSizes.fontSizeSm,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal implementation that accepts pre-calculated state
class _TrendChangePillWithState extends TrendChangePill {
  final bool _isPositive;
  final bool _isNegative;

  const _TrendChangePillWithState({
    required super.changeValue,
    required super.changePercent,
    required bool isPositive,
    required bool isNegative,
    super.showValue,
  })  : _isPositive = isPositive,
        _isNegative = isNegative;

  @override
  bool get isPositive => _isPositive;

  @override
  bool get isNegative => _isNegative;
}
