import 'package:flutter/material.dart';
import '../../utils/constants/chart_colors.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';

/// A linear risk gauge widget that displays risk level (Baixo/Moderado/Alto)
/// with a colored bar and animated indicator marker.
///
/// Supports two modes:
/// - Single indicator (IBOV only when B3 not connected)
/// - Dual indicators (IBOV + Portfolio when B3 connected)
///
/// Animations:
/// - Indicator positions slide smoothly when volatility changes
/// - Volatility percentage counts up/down
/// - Label highlight transitions smoothly
class RiskGauge extends StatefulWidget {
  const RiskGauge({
    super.key,
    required this.level,
    required this.label,
    this.volatility,
    this.portfolioLevel,
    this.portfolioLabel,
    this.portfolioVolatility,
    this.showPortfolio = false,
  });

  /// IBOV risk level: "low", "moderate", "high"
  final String level;

  /// IBOV localized label: "Baixo", "Moderado", "Alto"
  final String label;

  /// IBOV raw annualized volatility (e.g., 0.18 = 18%)
  final double? volatility;

  /// Portfolio risk level (when B3 connected)
  final String? portfolioLevel;

  /// Portfolio localized label (when B3 connected)
  final String? portfolioLabel;

  /// Portfolio raw annualized volatility (when B3 connected)
  final double? portfolioVolatility;

  /// Whether to show portfolio indicator alongside IBOV
  final bool showPortfolio;

  @override
  State<RiskGauge> createState() => _RiskGaugeState();
}

class _RiskGaugeState extends State<RiskGauge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ibovPositionAnimation;
  late Animation<double> _ibovVolatilityAnimation;
  late Animation<double> _portfolioPositionAnimation;
  late Animation<double> _portfolioVolatilityAnimation;

  double _oldIbovPosition = 0.0;
  double _oldIbovVolatility = 0.0;
  double _oldPortfolioPosition = 0.0;
  double _oldPortfolioVolatility = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _initializeAnimations();
  }

  void _initializeAnimations() {
    final ibovPosition = _getIndicatorPosition(widget.volatility, widget.level);
    final ibovVolatility = widget.volatility ?? 0.0;
    final portfolioPosition = _getIndicatorPosition(widget.portfolioVolatility, widget.portfolioLevel);
    final portfolioVolatility = widget.portfolioVolatility ?? 0.0;

    _oldIbovPosition = ibovPosition;
    _oldIbovVolatility = ibovVolatility;
    _oldPortfolioPosition = portfolioPosition;
    _oldPortfolioVolatility = portfolioVolatility;

    _ibovPositionAnimation = Tween<double>(
      begin: ibovPosition,
      end: ibovPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _ibovVolatilityAnimation = Tween<double>(
      begin: ibovVolatility,
      end: ibovVolatility,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _portfolioPositionAnimation = Tween<double>(
      begin: portfolioPosition,
      end: portfolioPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _portfolioVolatilityAnimation = Tween<double>(
      begin: portfolioVolatility,
      end: portfolioVolatility,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(RiskGauge oldWidget) {
    super.didUpdateWidget(oldWidget);

    final newIbovPosition = _getIndicatorPosition(widget.volatility, widget.level);
    final newIbovVolatility = widget.volatility ?? 0.0;
    final newPortfolioPosition = _getIndicatorPosition(widget.portfolioVolatility, widget.portfolioLevel);
    final newPortfolioVolatility = widget.portfolioVolatility ?? 0.0;

    bool needsAnimation = false;

    if (newIbovPosition != _oldIbovPosition || newIbovVolatility != _oldIbovVolatility) {
      _ibovPositionAnimation = Tween<double>(
        begin: _oldIbovPosition,
        end: newIbovPosition,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

      _ibovVolatilityAnimation = Tween<double>(
        begin: _oldIbovVolatility,
        end: newIbovVolatility,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _oldIbovPosition = newIbovPosition;
      _oldIbovVolatility = newIbovVolatility;
      needsAnimation = true;
    }

    if (newPortfolioPosition != _oldPortfolioPosition || newPortfolioVolatility != _oldPortfolioVolatility) {
      _portfolioPositionAnimation = Tween<double>(
        begin: _oldPortfolioPosition,
        end: newPortfolioPosition,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

      _portfolioVolatilityAnimation = Tween<double>(
        begin: _oldPortfolioVolatility,
        end: newPortfolioVolatility,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      _oldPortfolioPosition = newPortfolioPosition;
      _oldPortfolioVolatility = newPortfolioVolatility;
      needsAnimation = true;
    }

    if (needsAnimation) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Calculate indicator position (0.0 to 1.0) based on level and volatility
  double _getIndicatorPosition(double? volatility, String? level) {
    if (volatility != null) {
      // Position precisely within the range based on volatility
      // Scale: 0% = 0.0, 40% = 1.0 (generous range for visualization)
      final position = (volatility / 0.40).clamp(0.0, 1.0);
      return position;
    }

    // Fallback: center of each segment
    switch (level) {
      case 'low':
        return 0.17;
      case 'moderate':
        return 0.5;
      case 'high':
        return 0.83;
      default:
        return 0.5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final showDualIndicators = widget.showPortfolio && widget.portfolioVolatility != null;

    return Container(
      padding: const EdgeInsets.all(FinSizes.lg),
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(FinSizes.cardRadiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Risk labels - show both when portfolio available
          if (showDualIndicators) ...[
            _buildDualLabelsSection(),
          ] else ...[
            _buildSingleLabelSection(),
          ],

          const SizedBox(height: FinSizes.lg),

          // Gauge bar with animated indicator(s)
          LayoutBuilder(
            builder: (context, constraints) {
              final barWidth = constraints.maxWidth;
              final indicatorWidth = FinSizes.md;

              return Column(
                children: [
                  // Gauge bar
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Colored bar segments
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(FinSizes.borderRadiusMd),
                        child: Row(
                          children: [
                            // Low (green)
                            Expanded(
                              child: Container(
                                height: FinSizes.borderRadiusLg,
                                color: FinColors.trendPositive,
                              ),
                            ),
                            // Moderate (yellow/amber)
                            Expanded(
                              child: Container(
                                height: FinSizes.borderRadiusLg,
                                color: FinColors.warning,
                              ),
                            ),
                            // High (red)
                            Expanded(
                              child: Container(
                                height: FinSizes.borderRadiusLg,
                                color: FinColors.trendNegative,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Portfolio indicator (if showing dual)
                      if (showDualIndicators)
                        AnimatedBuilder(
                          animation: _portfolioPositionAnimation,
                          builder: (context, child) {
                            final indicatorLeft =
                                (barWidth * _portfolioPositionAnimation.value) - (indicatorWidth / 2);
                            return Positioned(
                              left: indicatorLeft.clamp(0, barWidth - indicatorWidth),
                              top: -6,
                              child: child!,
                            );
                          },
                          child: _buildIndicatorMarker(ChartColors.portfolioLine, ChartColors.portfolioStroke),
                        ),

                      // IBOV indicator (always shown)
                      AnimatedBuilder(
                        animation: _ibovPositionAnimation,
                        builder: (context, child) {
                          final indicatorLeft =
                              (barWidth * _ibovPositionAnimation.value) - (indicatorWidth / 2);
                          return Positioned(
                            left: indicatorLeft.clamp(0, barWidth - indicatorWidth),
                            top: -6,
                            child: child!,
                          );
                        },
                        child: _buildIndicatorMarker(ChartColors.ibovLine, ChartColors.ibovStroke),
                      ),
                    ],
                  ),

                  const SizedBox(height: FinSizes.borderRadiusLg),

                  // Risk level labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _AnimatedLabel(
                        text: FinTexts.riskLevelLow,
                        isActive: widget.level == 'low' || (showDualIndicators && widget.portfolioLevel == 'low'),
                      ),
                      _AnimatedLabel(
                        text: FinTexts.riskLevelModerate,
                        isActive: widget.level == 'moderate' || (showDualIndicators && widget.portfolioLevel == 'moderate'),
                      ),
                      _AnimatedLabel(
                        text: FinTexts.riskLevelHigh,
                        isActive: widget.level == 'high' || (showDualIndicators && widget.portfolioLevel == 'high'),
                      ),
                    ],
                  ),

                  // Legend when showing dual indicators
                  if (showDualIndicators) ...[
                    const SizedBox(height: FinSizes.md),
                    _buildLegend(),
                  ],
                ],
              );
            },
          ),

          const SizedBox(height: FinSizes.lg),

          // Explanation text
          Text(
            FinTexts.riskCalculationExplanation,
            style: TextStyle(
              color: FinColors.textGray300.withValues(alpha: 0.7),
              fontSize: FinSizes.iconXs,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build single label section (IBOV only)
  Widget _buildSingleLabelSection() {
    return Column(
      children: [
        // IBOV indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: ChartColors.ibovLine,
                shape: BoxShape.circle,
                border: Border.all(color: ChartColors.ibovStroke, width: 1),
              ),
            ),
            const SizedBox(width: FinSizes.xs),
            Text(
              'IBOV',
              style: TextStyle(
                color: FinColors.textGray300,
                fontSize: FinSizes.fontSizeSm - 2,
              ),
            ),
          ],
        ),
        const SizedBox(height: FinSizes.xs),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            widget.label,
            key: ValueKey(widget.label),
            style: const TextStyle(
              color: FinColors.textWhite,
              fontSize: FinSizes.fontSizeXXLg + 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (widget.volatility != null) ...[
          const SizedBox(height: FinSizes.xs),
          AnimatedBuilder(
            animation: _ibovVolatilityAnimation,
            builder: (context, child) {
              final percent = (_ibovVolatilityAnimation.value * 100).round();
              return Text(
                '${FinTexts.riskVolatilityLabel} $percent%',
                style: const TextStyle(
                  color: FinColors.textGray300,
                  fontSize: FinSizes.fontSizeSm,
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  /// Build dual labels section (Portfolio + IBOV)
  Widget _buildDualLabelsSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Portfolio (Sua carteira)
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: ChartColors.portfolioLine,
                      shape: BoxShape.circle,
                      border: Border.all(color: ChartColors.portfolioStroke, width: 1),
                    ),
                  ),
                  const SizedBox(width: FinSizes.xs),
                  Text(
                    'Sua carteira',
                    style: TextStyle(
                      color: FinColors.textGray300,
                      fontSize: FinSizes.fontSizeSm - 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FinSizes.xs),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  widget.portfolioLabel ?? 'Moderado',
                  key: ValueKey(widget.portfolioLabel),
                  style: const TextStyle(
                    color: FinColors.textWhite,
                    fontSize: FinSizes.fontSizeXLg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _portfolioVolatilityAnimation,
                builder: (context, child) {
                  final percent = (_portfolioVolatilityAnimation.value * 100).round();
                  return Text(
                    '$percent%',
                    style: const TextStyle(
                      color: FinColors.textGray300,
                      fontSize: FinSizes.fontSizeSm,
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        // Divider
        Container(
          width: 1,
          height: 50,
          color: FinColors.textGray300.withValues(alpha: 0.3),
        ),

        // IBOV
        Expanded(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: ChartColors.ibovLine,
                      shape: BoxShape.circle,
                      border: Border.all(color: ChartColors.ibovStroke, width: 1),
                    ),
                  ),
                  const SizedBox(width: FinSizes.xs),
                  Text(
                    'IBOV',
                    style: TextStyle(
                      color: FinColors.textGray300,
                      fontSize: FinSizes.fontSizeSm - 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FinSizes.xs),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  widget.label,
                  key: ValueKey(widget.label),
                  style: const TextStyle(
                    color: FinColors.textWhite,
                    fontSize: FinSizes.fontSizeXLg,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AnimatedBuilder(
                animation: _ibovVolatilityAnimation,
                builder: (context, child) {
                  final percent = (_ibovVolatilityAnimation.value * 100).round();
                  return Text(
                    '$percent%',
                    style: const TextStyle(
                      color: FinColors.textGray300,
                      fontSize: FinSizes.fontSizeSm,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build indicator marker with specified colors
  Widget _buildIndicatorMarker(Color fillColor, Color strokeColor) {
    return Container(
      width: FinSizes.md,
      height: FinSizes.lg,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusSm),
        border: Border.all(
          color: strokeColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: FinSizes.xs,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }

  /// Build legend for dual indicators
  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem('Sua carteira', ChartColors.portfolioLine, ChartColors.portfolioStroke),
        const SizedBox(width: FinSizes.lg),
        _buildLegendItem('IBOV', ChartColors.ibovLine, ChartColors.ibovStroke),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, Color strokeColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: FinSizes.sm,
          height: FinSizes.md,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
            border: Border.all(color: strokeColor, width: 1),
          ),
        ),
        const SizedBox(width: FinSizes.xs),
        Text(
          label,
          style: TextStyle(
            color: FinColors.textGray300,
            fontSize: FinSizes.fontSizeSm - 2,
          ),
        ),
      ],
    );
  }
}

/// Animated label that smoothly transitions between active/inactive states
class _AnimatedLabel extends StatelessWidget {
  const _AnimatedLabel({
    required this.text,
    required this.isActive,
  });

  final String text;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 250),
      style: TextStyle(
        color: isActive ? FinColors.textWhite : FinColors.textGray300,
        fontSize: FinSizes.iconXs,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
      ),
      child: Text(text),
    );
  }
}
