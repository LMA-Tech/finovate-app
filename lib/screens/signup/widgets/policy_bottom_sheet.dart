import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/policy_content.dart';
import '../../../utils/constants/sizes.dart';

/// Bottom sheet widget for displaying privacy policy or terms of service
class PolicyBottomSheet extends StatelessWidget {
  final String title;
  final String content;

  const PolicyBottomSheet({
    super.key,
    required this.title,
    required this.content,
  });

  /// Show privacy policy bottom sheet
  static void showPrivacyPolicy(BuildContext context) {
    _showPolicySheet(
      context,
      title: 'Política de Privacidade',
      content: PolicyContent.privacyPolicy,
    );
  }

  /// Show terms of service bottom sheet
  static void showTermsOfService(BuildContext context) {
    _showPolicySheet(
      context,
      title: 'Termos de Serviço',
      content: PolicyContent.termsOfService,
    );
  }

  /// Generic method to show policy bottom sheet
  static void _showPolicySheet(
      BuildContext context, {
        required String title,
        required String content,
      }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PolicyBottomSheet(
        title: title,
        content: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: FinColors.cardBackground, // Same as your input fields
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Header with title
          Padding(
            padding: const EdgeInsets.all(FinSizes.defaultSpace),
            child: Text(
              title,
              style: const TextStyle(
                color: FinColors.textWhite,
                fontSize: FinSizes.fontSizeXLg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: FinSizes.defaultSpace,
                vertical: FinSizes.sm,
              ),
              child: Text(
                content,
                style: const TextStyle(
                  color: FinColors.textWhite,
                  fontSize: FinSizes.fontSizeSm,
                  height: 1.6,
                ),
              ),
            ),
          ),

          // Bottom padding
          const SizedBox(height: FinSizes.defaultSpace),
        ],
      ),
    );
  }
}