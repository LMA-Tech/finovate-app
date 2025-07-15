// lib/screens/perfil/perfil_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/fin_bottom_navigation.dart';
import '../../services/activity_tracker.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// Perfil Screen - User profile and account settings
///
/// This screen displays user information, account settings,
/// preferences, and provides access to various app configurations.
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityTracker = Get.find<ActivityTracker>();
    final sessionManager = Get.find<SessionManager>();

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Perfil'),
            automaticallyImplyLeading: false, // No back button for main tabs
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Add profile settings
                },
                icon: const Icon(Icons.edit),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(FinSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Profile Header
                _UserProfileHeader(sessionManager: sessionManager),

                const SizedBox(height: FinSizes.spaceBtwSections),

                // Account Section
                const _SectionHeader(
                  title: 'Conta',
                  subtitle: 'Configurações da sua conta',
                ),
                const SizedBox(height: FinSizes.spaceBtwItems),
                const _AccountSettings(),

                const SizedBox(height: FinSizes.spaceBtwSections),

                // App Settings Section
                const _SectionHeader(
                  title: 'Configurações',
                  subtitle: 'Preferências do aplicativo',
                ),
                const SizedBox(height: FinSizes.spaceBtwItems),
                const _AppSettings(),

                const SizedBox(height: FinSizes.spaceBtwSections),

                // Support Section
                const _SectionHeader(
                  title: 'Suporte',
                  subtitle: 'Ajuda e informações',
                ),
                const SizedBox(height: FinSizes.spaceBtwItems),
                const _SupportSection(),

                const SizedBox(height: FinSizes.spaceBtwSections),

                // Logout Button
                _LogoutButton(sessionManager: sessionManager),

                const SizedBox(height: FinSizes.spaceBtwSections),
              ],
            ),
          ),
          bottomNavigationBar: const FinBottomNavigation(),
        ),
      ),
    );
  }
}

/// Section header widget for consistent styling
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeXLg,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: FinSizes.fontSizeSm,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

/// User profile header with avatar and basic info
class _UserProfileHeader extends StatelessWidget {
  final SessionManager sessionManager;

  const _UserProfileHeader({required this.sessionManager});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.all(FinSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FinColors.primary.withOpacity(0.8),
            FinColors.primary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: FinSizes.md),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sessionManager.currentUser.value?.email?.split('@')[0] ?? 'Usuário',
                  style: const TextStyle(
                    fontSize: FinSizes.fontSizeXLg,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  sessionManager.currentUser.value?.email ?? 'email@exemplo.com',
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeMd,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: FinSizes.sm,
                    vertical: FinSizes.xs,
                  ),
                  decoration: BoxDecoration(
                    color: FinColors.success.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(FinSizes.borderRadiusSm),
                  ),
                  child: const Text(
                    'Conta Verificada',
                    style: TextStyle(
                      fontSize: FinSizes.md,
                      fontWeight: FontWeight.w600,
                      color: FinColors.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

/// Account settings options
class _AccountSettings extends StatelessWidget {
  const _AccountSettings();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingsItem(
          icon: Icons.person_outline,
          title: 'Informações Pessoais',
          subtitle: 'Nome, CPF, telefone',
          onTap: () {
            // TODO: Navigate to personal info
          },
        ),
        _SettingsItem(
          icon: Icons.security,
          title: 'Segurança',
          subtitle: 'Senha, autenticação em dois fatores',
          onTap: () {
            // TODO: Navigate to security settings
          },
        ),
        _SettingsItem(
          icon: Icons.account_balance_outlined,
          title: 'Contas Bancárias',
          subtitle: 'Gerenciar contas vinculadas',
          onTap: () {
            // TODO: Navigate to bank accounts
          },
        ),
        _SettingsItem(
          icon: Icons.receipt_long,
          title: 'Histórico de Transações',
          subtitle: 'Ver todas as movimentações',
          onTap: () {
            // TODO: Navigate to transaction history
          },
        ),
      ],
    );
  }
}

/// App settings and preferences
class _AppSettings extends StatelessWidget {
  const _AppSettings();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingsItem(
          icon: Icons.notification_add_outlined,
          title: 'Notificações',
          subtitle: 'Alertas de mercado, dividendos',
          onTap: () {
            // TODO: Navigate to notification settings
          },
          trailing: Switch(
            value: true,
            onChanged: (value) {
              // TODO: Toggle notifications
            },
            activeColor: FinColors.primary,
          ),
        ),
        _SettingsItem(
          icon: Icons.dark_mode_outlined,
          title: 'Tema',
          subtitle: 'Claro, escuro ou automático',
          onTap: () {
            // TODO: Show theme selection
          },
        ),
        _SettingsItem(
          icon: Icons.language,
          title: 'Idioma',
          subtitle: 'Português (Brasil)',
          onTap: () {
            // TODO: Show language selection
          },
        ),
        _SettingsItem(
          icon: Icons.fingerprint,
          title: 'Biometria',
          subtitle: 'Login com impressão digital',
          onTap: () {
            // TODO: Configure biometric settings
          },
          trailing: Switch(
            value: false,
            onChanged: (value) {
              // TODO: Toggle biometric login
            },
            activeColor: FinColors.primary,
          ),
        ),
      ],
    );
  }
}

/// Support and help section
class _SupportSection extends StatelessWidget {
  const _SupportSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SettingsItem(
          icon: Icons.help_outline,
          title: 'Central de Ajuda',
          subtitle: 'FAQ e tutoriais',
          onTap: () {
            // TODO: Navigate to help center
          },
        ),
        _SettingsItem(
          icon: Icons.chat_bubble_outline,
          title: 'Fale Conosco',
          subtitle: 'Entre em contato com o suporte',
          onTap: () {
            // TODO: Navigate to contact support
          },
        ),
        _SettingsItem(
          icon: Icons.star_outline,
          title: 'Avaliar App',
          subtitle: 'Deixe sua avaliação na loja',
          onTap: () {
            // TODO: Open app store for rating
          },
        ),
        _SettingsItem(
          icon: Icons.info_outline,
          title: 'Sobre',
          subtitle: 'Versão 1.0.0',
          onTap: () {
            // TODO: Show about dialog
          },
        ),
      ],
    );
  }
}

/// Logout button
class _LogoutButton extends StatelessWidget {
  final SessionManager sessionManager;

  const _LogoutButton({required this.sessionManager});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () async {
          // Show confirmation dialog
          final shouldLogout = await Get.dialog<bool>(
            AlertDialog(
              backgroundColor: const Color(0xFF2D3245),
              title: const Text(
                'Sair da Conta',
                style: TextStyle(color: Colors.white),
              ),
              content: const Text(
                'Tem certeza que deseja sair da sua conta?',
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                TextButton(
                  onPressed: () => Get.back(result: false),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white.withOpacity(0.7)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Get.back(result: true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FinColors.error,
                  ),
                  child: const Text(
                    'Sair',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );

          if (shouldLogout == true) {
            await sessionManager.signOut();
          }
        },
        icon: const Icon(
          Icons.logout,
          color: FinColors.error,
        ),
        label: const Text(
          'Sair da Conta',
          style: TextStyle(
            color: FinColors.error,
            fontSize: FinSizes.fontSizeMd,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: FinColors.error),
          padding: const EdgeInsets.symmetric(vertical: FinSizes.md),
        ),
      ),
    );
  }
}

/// Individual settings item widget
class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: FinSizes.spaceBtwItems),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(FinSizes.md),
        tileColor: const Color(0xFF2D3245),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
          side: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: FinColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: FinColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: FinSizes.fontSizeSm,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.5),
            ),
      ),
    );
  }
}