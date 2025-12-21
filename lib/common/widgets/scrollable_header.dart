import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// A header widget with back button and centered title for scrollable screens.
///
/// Unlike CustomAppBar (which is a PreferredSizeWidget for Scaffold.appBar),
/// this widget can be placed inside scrollable content like ListView.
///
/// Usage:
/// ```dart
/// ListView(
///   children: [
///     ScrollableHeader(title: 'Ações'),
///     // ... other content
///   ],
/// )
/// ```
class ScrollableHeader extends StatelessWidget {
  /// The title text displayed in the center
  final String title;

  /// Custom back button action (defaults to Get.back())
  final VoidCallback? onBack;

  /// Whether to show the back button (default: true)
  final bool showBackButton;

  const ScrollableHeader({
    required this.title,
    this.onBack,
    this.showBackButton = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FinSizes.md,
        vertical: FinSizes.md,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered title
          Text(
            title,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeXLg,
              fontWeight: FontWeight.w600,
              color: FinColors.textWhite,
              height: 1.60,
              letterSpacing: -0.40,
            ),
          ),
          // Back button aligned to left
          if (showBackButton)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: FinColors.textWhite,
                  size: FinSizes.iconMd,
                ),
                onPressed: onBack ?? () => Get.back(),
              ),
            ),
        ],
      ),
    );
  }
}
