import 'package:flutter/material.dart';

import '../../../common/widgets/gradient_border_box.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

/// Preferências (Preferences/Settings) tab content.
///
/// Features:
/// - Biometria and Notificações toggles
/// - Conectividade e suporte section with B3 banner
/// - Política de privacidade and Ajuda links
class PreferenciasTab extends StatelessWidget {
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final bool isPro;
  final ValueChanged<bool>? onNotificationsChanged;
  final ValueChanged<bool>? onBiometricChanged;
  final VoidCallback? onContasConectadasTap;
  final VoidCallback? onConectarB3Tap;
  final VoidCallback? onPoliticaPrivacidadeTap;
  final VoidCallback? onAjudaTap;

  const PreferenciasTab({
    required this.notificationsEnabled,
    required this.biometricEnabled,
    this.isPro = false,
    this.onNotificationsChanged,
    this.onBiometricChanged,
    this.onContasConectadasTap,
    this.onConectarB3Tap,
    this.onPoliticaPrivacidadeTap,
    this.onAjudaTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: FinSizes.lg), // 20px from tabs

          // Biometria row with toggle
          _buildToggleRow(
            label: FinTexts.perfilBiometria,
            isEnabled: biometricEnabled,
            onChanged: onBiometricChanged,
          ),
          _buildDivider(),

          // Notificações row with toggle
          _buildToggleRow(
            label: FinTexts.perfilNotificacoes,
            isEnabled: notificationsEnabled,
            onChanged: onNotificationsChanged,
          ),

          // Notification message when notifications are off/on
          const SizedBox(height: FinSizes.sm),
          _buildNotificationMessage(
            notificationsEnabled
                ? FinTexts.perfilNotificacoesOn
                : FinTexts.perfilNotificacoesOff,
            isEnabled: notificationsEnabled,
          ),

          const SizedBox(height: FinSizes.spaceBtwSections),

          // Conectividade e suporte section
          _buildSectionLabel(FinTexts.perfilConectividadeSuporte),
          const SizedBox(height: FinSizes.md),

          // Contas conectadas (for pro users)
          if (isPro) ...[
            _buildNavigationRow(
              label: FinTexts.perfilContasConectadas,
              onTap: onContasConectadasTap,
            ),
            _buildDivider(),
          ],

          // B3 Banner
          _buildB3Banner(),

          const SizedBox(height: FinSizes.md),

          // Política de privacidade
          _buildNavigationRow(
            label: FinTexts.perfilPoliticaPrivacidade,
            onTap: onPoliticaPrivacidadeTap,
          ),
          _buildDivider(),

          // Ajuda
          _buildNavigationRow(
            label: FinTexts.perfilAjuda,
            onTap: onAjudaTap,
          ),
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

  Widget _buildToggleRow({
    required String label,
    required bool isEnabled,
    ValueChanged<bool>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FinSizes.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeMd,
              fontWeight: FontWeight.w500,
              color: FinColors.textWhite,
              height: 1.24,
              letterSpacing: 0.08,
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: Switch(
              value: isEnabled,
              onChanged: onChanged,
              activeColor: FinColors.textWhite,
              activeTrackColor: FinColors.primary.withValues(alpha: 0.5),
              inactiveThumbColor: FinColors.textGray200,
              inactiveTrackColor: FinColors.textGray300.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow({
    required String label,
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
                fontWeight: FontWeight.w400,
                color: FinColors.textWhite,
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: FinColors.textWhite.withValues(alpha: 0.5),
              size: FinSizes.iconMd,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationMessage(String message, {required bool isEnabled}) {
    final gradientColors = isEnabled
        ? [FinColors.gradientRedStart, FinColors.gradientOrangeEnd]
        : [FinColors.gradientBlueStart, FinColors.gradientMintEnd];

    return SizedBox(
      width: double.infinity,
      child: GradientBorderBox(
        gradientColors: gradientColors,
        borderRadius: FinSizes.borderRadiusMd,
        padding: const EdgeInsets.symmetric(
          horizontal: FinSizes.md,
          vertical: 12,
        ),
        child: Text(
          message,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeS,
            fontWeight: FontWeight.w400,
            color: FinColors.notificationMessageText,
            height: 1.23,
          ),
        ),
      ),
    );
  }

  Widget _buildB3Banner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            FinColors.bannerGradientStart,
            FinColors.bannerGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              FinTexts.perfilConectarB3,
              style: const TextStyle(
                fontSize: FinSizes.fontSizeSm,
                fontWeight: FontWeight.w400,
                color: FinColors.bannerText,
              ),
            ),
          ),
          const SizedBox(width: FinSizes.sm),
          GestureDetector(
            onTap: onConectarB3Tap,
            child: Container(
              width: FinSizes.iconLg,
              height: FinSizes.iconLg,
              decoration: BoxDecoration(
                color: FinColors.textWhite.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: FinColors.textWhite,
                size: FinSizes.iconSm,
              ),
            ),
          ),
        ],
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
