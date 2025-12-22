import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/widgets/primary_button.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

/// Bottom sheet shown after successful premium subscription.
///
/// Displays a success icon with checkmark and star badge,
/// congratulatory message, and CTA to start using premium features.
class SubscriptionSuccessBottomSheet extends StatelessWidget {
  final VoidCallback? onStartNow;

  const SubscriptionSuccessBottomSheet({
    this.onStartNow,
    super.key,
  });

  /// Shows the subscription success bottom sheet.
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onStartNow,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => SubscriptionSuccessBottomSheet(
        onStartNow: onStartNow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FinColors.bottomSheetGradientStart,
            FinColors.bottomSheetGradientEnd,
          ],
          stops: [0.01, 0.72],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(FinSizes.borderRadiusXLg)),
      ),
      child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(FinSizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon with star badge
                _buildSuccessIcon(),

                const SizedBox(height: 40),

                // Title
                const Text(
                  FinTexts.subscriptionSuccessTitle,
                  style: TextStyle(
                    color: FinColors.textWhite,
                    fontSize: FinSizes.fontSizeXLg,
                    fontWeight: FontWeight.w600,
                    height: 1.60,
                    letterSpacing: -0.40,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: FinSizes.md),

                // Subtitle
                const Text(
                  FinTexts.subscriptionSuccessSubtitle,
                  style: TextStyle(
                    color: FinColors.textWhite,
                    fontSize: FinSizes.fontSizeMd,
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.32,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: FinSizes.spaceBtwSections),

                // CTA Button
                PrimaryButton(
                  text: FinTexts.subscriptionSuccessButton,
                  onPressed: onStartNow ?? () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildSuccessIcon() {
    return SvgPicture.asset(FinImages.premiumCheckmark);
  }
}
