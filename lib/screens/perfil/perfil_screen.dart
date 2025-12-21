import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/profile_avatar.dart';
import '../../common/widgets/segmented_tabs.dart';
import '../../common/widgets/toast_notification.dart';
import '../../services/activity_tracker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../signup/widgets/policy_bottom_sheet.dart';
import 'perfil_controller.dart';
import 'widgets/edit_field_bottom_sheet.dart';
import 'widgets/email_change_bottom_sheet.dart';
import 'widgets/meu_plano_tab.dart';
import 'widgets/perfil_info_tab.dart';
import 'widgets/preferencias_tab.dart';

/// Perfil Screen - User profile and account settings
///
/// Features a 3-tab structure:
/// - Meu plano: Subscription status and plan features
/// - Perfil: Personal information with masked values
/// - Preferências: App settings and preferences
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityTracker = Get.find<ActivityTracker>();

    // Initialize controller if not already registered
    final controller = Get.put(PerfilController());

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // Header with title
                _buildHeader(),

                const SizedBox(height: FinSizes.md),

                // Profile avatar and name
                _buildProfileSection(controller),

                const SizedBox(height: FinSizes.lg),

                // Tab navigation
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
                  child: Obx(() => SegmentedTabs(
                    tabs: const [
                      FinTexts.perfilTabMeuPlano,
                      FinTexts.perfilTabPerfil,
                      FinTexts.perfilTabPreferencias,
                    ],
                    selectedIndex: controller.selectedTabIndex.value,
                    onTabChanged: controller.selectTab,
                    // "Meu plano" tab (index 0) uses gradient based on subscription
                    gradientTabIndex: 0,
                    selectedGradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: controller.isPro
                          ? const [FinColors.gradientRedStart, FinColors.gradientOrangeEnd]
                          : const [FinColors.bannerGradientStart, FinColors.bannerGradientEnd],
                      stops: const [0.01, 0.72],
                    ),
                  )),
                ),

                const SizedBox(height: FinSizes.md),

                // Tab content
                Expanded(
                  child: Obx(() => _buildTabContent(context, controller)),
                ),
              ],
            ),
          ),
          // No bottom navigation - using back button instead
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FinSizes.md,
        vertical: FinSizes.md,
      ),
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(
              Icons.chevron_left,
              color: FinColors.textWhite,
              size: FinSizes.iconLg,
            ),
          ),
          const Expanded(
            child: Text(
              FinTexts.perfilScreenTitle,
              style: TextStyle(
                fontSize: FinSizes.fontSizeXLg,
                fontWeight: FontWeight.w600,
                color: FinColors.textWhite,
                height: 1.60,
                letterSpacing: -0.40,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Spacer to balance the back button
          const SizedBox(width: FinSizes.iconLg),
        ],
      ),
    );
  }

  Widget _buildProfileSection(PerfilController controller) {
    return Obx(() => Column(
      children: [
        // Profile avatar with premium border for pro users
        ProfileAvatar(
          userName: controller.fullName,
          photoUrl: controller.profilePhotoUrl,
          size: FinSizes.avatarXl,
          isPremium: controller.isPro,
          showPremiumBadge: controller.isPro,
        ),

        const SizedBox(height: FinSizes.md),

        // User name
        Text(
          controller.fullName.isNotEmpty ? controller.fullName : controller.email,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeSm,
            fontWeight: FontWeight.w400,
            color: FinColors.textWhite,
            height: 1.29,
            letterSpacing: -0.28,
          ),
        ),
      ],
    ));
  }

  Widget _buildTabContent(BuildContext context, PerfilController controller) {
    switch (controller.selectedTabIndex.value) {
      case 0:
        return MeuPlanoTab(
          hasPlan: controller.isPro,
          status: controller.planStatus,
          startDate: controller.planStartDate,
          nextPaymentDate: controller.planNextPaymentDate,
          annualPrice: controller.planAnnualPrice,
          paymentMethodLast4: controller.paymentMethodLast4,
          onViewPlansTap: () {
            // TODO: Navigate to plans screen
          },
        );
      case 1:
        return PerfilInfoTab(
          fullName: controller.fullName,
          nickname: controller.nickname,
          email: controller.email,
          phone: controller.phone,
          cpf: controller.cpf,
          birthDate: controller.birthDate,
          onEditField: (field) => _showEditFieldSheet(context, controller, field),
          onLogoutTap: () => _showLogoutDialog(controller),
        );
      case 2:
        return PreferenciasTab(
          notificationsEnabled: controller.notificationsEnabled.value,
          biometricEnabled: controller.biometricEnabled.value,
          isPro: controller.isPro,
          onNotificationsChanged: controller.toggleNotifications,
          onBiometricChanged: controller.toggleBiometric,
          onContasConectadasTap: () {
            // TODO: Navigate to connected accounts
          },
          onConectarB3Tap: () {
            // TODO: Navigate to B3 connection
          },
          onPoliticaPrivacidadeTap: () {
            PolicyBottomSheet.showPrivacyPolicy(context);
          },
          onAjudaTap: () => _openSupportEmail(),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _showLogoutDialog(PerfilController controller) async {
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: FinColors.cardBackground,
        title: const Text(
          FinTexts.perfilSairConfirmTitle,
          style: TextStyle(color: FinColors.textWhite),
        ),
        content: const Text(
          FinTexts.perfilSairConfirmMessage,
          style: TextStyle(color: FinColors.textWhite),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(
              FinTexts.dialogCancel,
              style: TextStyle(color: FinColors.textWhite.withValues(alpha: 0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: FinColors.error,
            ),
            child: const Text(
              FinTexts.perfilSairConta,
              style: TextStyle(color: FinColors.textWhite),
            ),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await controller.signOut();
    }
  }

  Future<void> _showEditFieldSheet(
    BuildContext context,
    PerfilController controller,
    String fieldKey,
  ) async {
    // Email has a special flow with OTP verification
    if (fieldKey == 'email') {
      final result = await EmailChangeBottomSheet.show(context);
      if (result == true && context.mounted) {
        ToastNotification.show(
          context: context,
          message: FinTexts.profileUpdated,
          type: ToastType.success,
        );
      }
      return;
    }

    final result = await EditFieldBottomSheet.show(
      context: context,
      fieldKey: fieldKey,
      fieldLabel: controller.getFieldLabel(fieldKey),
      currentValue: controller.getFieldValue(fieldKey),
      onSave: (newValue) => controller.updateField(fieldKey, newValue),
    );

    if (result == true && context.mounted) {
      ToastNotification.show(
        context: context,
        message: FinTexts.profileUpdated,
        type: ToastType.success,
      );
    }
  }

  Future<void> _openSupportEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: FinTexts.supportEmail,
      query: 'subject=${FinTexts.supportEmailSubject}',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }
}
