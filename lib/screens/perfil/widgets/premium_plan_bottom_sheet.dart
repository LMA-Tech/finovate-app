import 'package:flutter/material.dart';

import '../../../common/widgets/primary_button.dart';
import '../../../common/widgets/profile_avatar.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

/// Bottom sheet for displaying Premium plan subscription offer.
///
/// Shown when user taps "Ver planos" from Meu Plano tab.
/// Features:
/// - Personalized greeting with user's first name
/// - Price highlight with gradient border
/// - Feature list with checkmarks
/// - CTA button to subscribe
class PremiumPlanBottomSheet extends StatelessWidget {
  final String userName;
  final String? userPhotoUrl;
  final VoidCallback? onSubscribe;

  const PremiumPlanBottomSheet({
    required this.userName,
    this.userPhotoUrl,
    this.onSubscribe,
    super.key,
  });

  /// Shows the premium plan bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required String userName,
    String? userPhotoUrl,
    VoidCallback? onSubscribe,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PremiumPlanBottomSheet(
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        onSubscribe: onSubscribe,
      ),
    );
  }

  String get _firstName {
    final parts = userName.trim().split(' ');
    return parts.isNotEmpty ? parts[0] : userName;
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
                // Avatar with premium styling
                ProfileAvatar(
                  userName: userName,
                  photoUrl: userPhotoUrl,
                  size: 58,
                  isPremium: true,
                  showPremiumBadge: true,
                  borderWidth: FinSizes.borderWidthMd,
                ),

                const SizedBox(height: FinSizes.md),

                // Title
                const Text(
                  FinTexts.premiumPlanTitle,
                  style: TextStyle(
                    color: FinColors.textWhite,
                    fontSize: FinSizes.fontSizeXLg,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.60,
                    letterSpacing: -0.40,
                  ),
                ),

                const SizedBox(height: FinSizes.sm),

                // Personalized subtitle
                Text(
                  FinTexts.premiumPlanSubtitle.replaceAll('{NAME}', _firstName),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: FinColors.textWhite,
                    fontSize: FinSizes.fontSizeMd,
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                    letterSpacing: -0.32,
                  ),
                ),

                const SizedBox(height: 40),

                // Price highlight text
                _buildPriceHighlight(),

                const SizedBox(height: FinSizes.md),

                // Feature boxes
                _buildFeatureBox(
                  title: FinTexts.premiumFeature1Title,
                  description: FinTexts.premiumFeature1Description,
                ),

                const SizedBox(height: FinSizes.md),

                _buildFeatureBox(
                  title: FinTexts.premiumFeature2Title,
                  description: FinTexts.premiumFeature2Description,
                ),

                const SizedBox(height: FinSizes.xxl),

                // CTA Button
                PrimaryButton(
                  text: FinTexts.premiumSubscribeButton,
                  onPressed: onSubscribe ?? () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
    );
  }

  Widget _buildPriceHighlight() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
        style: TextStyle(
          color: FinColors.textWhite,
          fontSize: FinSizes.fontSizeMd,
          fontFamily: 'General Sans',
          fontWeight: FontWeight.w400,
          height: 1.50,
          letterSpacing: -0.32,
        ),
        children: [
          TextSpan(text: FinTexts.premiumPriceTextPart1),
          TextSpan(
            text: FinTexts.premiumPriceHighlight,
            style: TextStyle(
              color: FinColors.trendPositive,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: FinTexts.premiumPriceTextPart2),
        ],
      ),
    );
  }

  Widget _buildFeatureBox({
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: FinSizes.md, horizontal: FinSizes.sm),
      decoration: BoxDecoration(
        color: FinColors.stockItemBackground,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with checkmark
          Row(
            children: [
              const Icon(
                Icons.check,
                color: FinColors.borderMint,
                size: FinSizes.iconMd - 4,
              ),
              const SizedBox(width: FinSizes.sm),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: FinColors.bannerText,
                    fontSize: FinSizes.fontSizeMd,
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.w500,
                    height: 1.50,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: FinSizes.sm),

          // Description (indented to align with title text)
          Padding(
            padding: const EdgeInsets.only(left: 28), // icon size + spacing
            child: Text(
              description,
              style: const TextStyle(
                color: FinColors.textSubtitle,
                fontSize: FinSizes.fontSizeSm,
                fontFamily: 'General Sans',
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
