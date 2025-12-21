import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

/// Meu Plano (My Plan) tab content.
///
/// Shows different layouts based on subscription status:
/// - With plan: Status, dates, payment info
/// - Without plan: CTA to subscribe
class MeuPlanoTab extends StatelessWidget {
  final bool hasPlan;
  final String? status;
  final String? startDate;
  final String? nextPaymentDate;
  final String? annualPrice;
  final String? paymentMethodLast4;
  final VoidCallback? onAnnualPriceTap;
  final VoidCallback? onPaymentMethodTap;
  final VoidCallback? onChangePlanTap;
  final VoidCallback? onViewPlansTap;

  const MeuPlanoTab({
    required this.hasPlan,
    this.status,
    this.startDate,
    this.nextPaymentDate,
    this.annualPrice,
    this.paymentMethodLast4,
    this.onAnnualPriceTap,
    this.onPaymentMethodTap,
    this.onChangePlanTap,
    this.onViewPlansTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (hasPlan) {
      return _buildWithPlanContent();
    } else {
      return _buildWithoutPlanContent();
    }
  }

  /// Content shown when user has an active plan
  Widget _buildWithPlanContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: FinSizes.lg), // 20px from tabs

          // Geral section
          _buildSectionLabel(FinTexts.perfilPlanoGeral),
          const SizedBox(height: FinSizes.md),

          _buildInfoRow(
            label: FinTexts.perfilPlanoStatus,
            value: status ?? FinTexts.perfilPlanoStatusActive,
          ),
          _buildDivider(),

          _buildInfoRow(
            label: FinTexts.perfilPlanoComeouEm,
            value: startDate ?? '-',
          ),
          _buildDivider(),

          _buildInfoRow(
            label: FinTexts.perfilPlanoProximoPagamento,
            value: nextPaymentDate ?? '-',
          ),

          const SizedBox(height: FinSizes.spaceBtwSections),

          // Pagamento section
          _buildSectionLabel(FinTexts.perfilPlanoPagamento),
          const SizedBox(height: FinSizes.md),

          _buildNavigationRow(
            label: FinTexts.perfilPlanoPrecoAnual,
            value: annualPrice ?? 'R\$ 997,00',
            onTap: onAnnualPriceTap,
          ),
          _buildDivider(),

          _buildPaymentMethodRow(
            last4: paymentMethodLast4 ?? '5809',
            onTap: onPaymentMethodTap,
          ),
          _buildDivider(),

          _buildNavigationRow(
            label: FinTexts.perfilPlanoMudar,
            onTap: onChangePlanTap,
          ),
        ],
      ),
    );
  }

  /// Content shown when user has no plan (free tier)
  Widget _buildWithoutPlanContent() {
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: FinSizes.spacingMeuPlanoTop),

          // Star icon with gradient
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                FinColors.gradientRedStart,
                FinColors.gradientOrangeEnd,
              ],
              stops: [0.01, 0.72],
            ).createShader(bounds),
            child: const Text(
              '✱',
              style: TextStyle(
                fontSize: FinSizes.iconLg,
                color: Colors.white, // Required for ShaderMask
              ),
            ),
          ),

          const SizedBox(height: FinSizes.md),

          // Main message
          const Text(
            FinTexts.perfilPlanoMaximize,
            style: TextStyle(
              fontSize: FinSizes.fontSizeMd,
              fontWeight: FontWeight.w400,
              color: FinColors.textWhite,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: FinSizes.md),

          // Subscribe message with bold "Assine agora"
          RichText(
            textAlign: TextAlign.center,
            text: const TextSpan(
              style: TextStyle(
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w400,
                color: FinColors.textWhite,
              ),
              children: [
                TextSpan(
                  text: FinTexts.perfilPlanoAssineAgora,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: FinTexts.perfilPlanoAssineDesc),
              ],
            ),
          ),

          const SizedBox(height: FinSizes.spacingMeuPlanoButton),

          // Ver planos button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewPlansTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: FinColors.primary,
                foregroundColor: FinColors.textWhite,
                padding: const EdgeInsets.symmetric(vertical: FinSizes.md),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
                ),
              ),
              child: const Text(
                FinTexts.perfilPlanoVerPlanos,
                style: TextStyle(
                  fontSize: FinSizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: FinSizes.fontSizeSm,
        fontWeight: FontWeight.w400,
        color: FinColors.textGray300,
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FinSizes.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeMd,
              fontWeight: FontWeight.w600,
              color: FinColors.textWhite,
              height: 1.50,
              letterSpacing: -0.32,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: FinSizes.fontSizeSm,
              fontWeight: FontWeight.w500,
              color: valueColor ?? FinColors.borderMint,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow({
    required String label,
    String? value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FinSizes.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w600,
                color: FinColors.textWhite,
                height: 1.50,
                letterSpacing: -0.32,
              ),
            ),
            Row(
              children: [
                if (value != null)
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      fontWeight: FontWeight.w500,
                      color: FinColors.borderMint,
                      height: 1.50,
                    ),
                  ),
                const SizedBox(width: FinSizes.sm),
                Icon(
                  Icons.chevron_right,
                  color: FinColors.textWhite.withValues(alpha: 0.5),
                  size: FinSizes.iconMd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodRow({
    required String last4,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: FinSizes.md),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              FinTexts.perfilPlanoMetodo,
              style: TextStyle(
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w600,
                color: FinColors.textWhite,
                height: 1.50,
                letterSpacing: -0.32,
              ),
            ),
            Row(
              children: [
                Text(
                  '*$last4',
                  style: const TextStyle(
                    fontSize: FinSizes.fontSizeSm,
                    fontWeight: FontWeight.w500,
                    color: FinColors.borderMint,
                    height: 1.50,
                  ),
                ),
                const SizedBox(width: FinSizes.sm),
                // Mastercard logo (two overlapping circles)
                SizedBox(
                  width: FinSizes.iconLg,
                  height: FinSizes.iconMd,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        child: Container(
                          width: FinSizes.iconMd,
                          height: FinSizes.iconMd,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEB001B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        left: FinSizes.borderRadiusLg,
                        child: Container(
                          width: FinSizes.iconMd,
                          height: FinSizes.iconMd,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF79E1B),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: FinSizes.sm),
                Icon(
                  Icons.chevron_right,
                  color: FinColors.textWhite.withValues(alpha: 0.5),
                  size: FinSizes.iconMd,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: FinSizes.borderWidthSm,
      thickness: FinSizes.borderWidthSm,
      color: FinColors.textWhite.withValues(alpha: 0.1),
    );
  }
}
