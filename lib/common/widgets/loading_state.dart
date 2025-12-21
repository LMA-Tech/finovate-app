import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// A centered loading indicator widget using the loading_indicator package.
///
/// Uses ballPulseSync animation for a clean, modern look.
///
/// Usage:
/// ```dart
/// // Simple loading spinner
/// LoadingState()
///
/// // With custom message
/// LoadingState(message: 'Carregando ações...')
/// ```
class LoadingState extends StatelessWidget {
  /// Optional message to display below the spinner
  final String? message;

  /// Size of the loading indicator (default: 50)
  final double size;

  const LoadingState({
    this.message,
    this.size = 50,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: [FinColors.primary],
              strokeWidth: 3,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: FinSizes.md),
            Text(
              message!,
              style: const TextStyle(
                fontSize: FinSizes.fontSizeSm,
                color: FinColors.textGray200,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
