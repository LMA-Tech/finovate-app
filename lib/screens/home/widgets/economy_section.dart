import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';

/// Economy Indicator Card Component
/// Displays economic indicators like Dollar, Interest Rate, etc.
class EconomyIndicatorCard extends StatelessWidget {
  const EconomyIndicatorCard({
    super.key,
    required this.title,
    this.value = '',
    this.change = '',
    this.changePercent = '',
    this.isPositive = true,
    this.onTap,
  });

  final String title;
  final String value;
  final String change;
  final String changePercent;
  final bool isPositive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 168,
      height: 120, // Fixed height to match container
      padding: const EdgeInsets.all(12), // Reduced padding
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space evenly
            children: [
              // Header with title and trend indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15, // Slightly smaller font
                        fontWeight: FontWeight.w600,
                        height: 1.2, // Tighter line height
                      ),
                      maxLines: 2, // Allow wrapping for longer titles
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Trend indicator (only show if there's a change)
                  if (change.isNotEmpty || changePercent.isNotEmpty)
                    Container(
                      width: 20, // Smaller indicator
                      height: 20,
                      decoration: BoxDecoration(
                        color: isPositive
                            ? const Color(0xFFBADBC1)
                            : const Color(0xFFFFD7DE),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        isPositive
                            ? Icons.trending_up
                            : Icons.trending_down,
                        color: isPositive
                            ? const Color(0xFF0CB97B)
                            : const Color(0xFFE02244),
                        size: 12, // Smaller icon
                      ),
                    ),
                ],
              ),

              // Content section
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Value (if available)
                    if (value.isNotEmpty) ...[
                      Text(
                        value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],

                    // Change information
                    if (change.isNotEmpty && changePercent.isNotEmpty)
                      Text(
                        '$change • $changePercent',
                        style: TextStyle(
                          color: isPositive
                              ? const Color(0xFF0CB97B)
                              : const Color(0xFFE02244),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    else if (changePercent.isNotEmpty)
                      Text(
                        changePercent,
                        style: TextStyle(
                          color: isPositive
                              ? const Color(0xFF0CB97B)
                              : const Color(0xFFE02244),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      )
                    else if (change.isNotEmpty)
                        Text(
                          change,
                          style: TextStyle(
                            color: isPositive
                                ? const Color(0xFF0CB97B)
                                : const Color(0xFFE02244),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Economy Section Component
/// Displays economic indicators in a horizontal scrollable layout
class EconomySection extends StatelessWidget {
  const EconomySection({
    super.key,
    this.onSeeMorePressed,
    this.indicators = const [],
  });

  final VoidCallback? onSeeMorePressed;
  final List<EconomyIndicatorData> indicators;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Economia',
                style: TextStyle(
                  color: Color(0xFFFEFEFE),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  letterSpacing: 0.1,
                ),
              ),
              GestureDetector(
                onTap: onSeeMorePressed,
                child: const Text(
                  'Ver mais',
                  style: TextStyle(
                    color: Color(0xFFBADBC1),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Indicators horizontal list
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
            itemCount: indicators.length,
            itemBuilder: (context, index) {
              final indicator = indicators[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index < indicators.length - 1 ? 12 : 0,
                ),
                child: EconomyIndicatorCard(
                  title: indicator.title,
                  value: indicator.value,
                  change: indicator.change,
                  changePercent: indicator.changePercent,
                  isPositive: indicator.isPositive,
                  onTap: indicator.onTap,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Data model for economy indicator information
class EconomyIndicatorData {
  const EconomyIndicatorData({
    required this.title,
    this.value = '',
    this.change = '',
    this.changePercent = '',
    this.isPositive = true,
    this.onTap,
  });

  final String title;
  final String value;
  final String change;
  final String changePercent;
  final bool isPositive;
  final VoidCallback? onTap;
}