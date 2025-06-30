import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/biometric_service.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// Widget for educating users about biometric authentication and offering setup
class BiometricEducationDialog extends StatelessWidget {
  final VoidCallback? onBiometricEnabled;
  final VoidCallback? onSkipped;
  final bool showSkipOption;

  const BiometricEducationDialog({
    super.key,
    this.onBiometricEnabled,
    this.onSkipped,
    this.showSkipOption = true,
  });

  /// Shows the biometric education dialog
  static Future<bool?> show({
    VoidCallback? onBiometricEnabled,
    VoidCallback? onSkipped,
    bool showSkipOption = true,
  }) async {
    return await Get.dialog<bool>(
      BiometricEducationDialog(
        onBiometricEnabled: onBiometricEnabled,
        onSkipped: onSkipped,
        showSkipOption: showSkipOption,
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: BiometricService.getBiometricCapabilities(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final capabilities = snapshot.data!;
        final isAvailable = capabilities['isFullySetup'] ?? false;
        final biometricType = capabilities['primaryType'] ?? 'Biometria';

        return AlertDialog(
          backgroundColor: const Color(0xFF2D3245),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
          ),
          title: Row(
            children: [
              FutureBuilder<IconData>(
                future: BiometricService.getBiometricIcon(),
                builder: (context, iconSnapshot) {
                  return Icon(
                    iconSnapshot.data ?? Icons.security,
                    color: FinColors.primary,
                    size: 32,
                  );
                },
              ),
              const SizedBox(width: FinSizes.spaceBtwItems),
              Expanded(
                child: Text(
                  isAvailable
                      ? 'Ativar $biometricType?'
                      : 'Configurar Biometria',
                  style: const TextStyle(
                    color: FinColors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isAvailable) ...[
                _buildBenefitItem(
                  icon: Icons.speed,
                  title: 'Login Rápido',
                  description: 'Acesse sua conta em segundos com $biometricType',
                ),
                const SizedBox(height: FinSizes.spaceBtwItems),
                _buildBenefitItem(
                  icon: Icons.security,
                  title: 'Mais Seguro',
                  description: 'Sua biometria é única e não pode ser copiada',
                ),
                const SizedBox(height: FinSizes.spaceBtwItems),
                _buildBenefitItem(
                  icon: Icons.phone_android,
                  title: 'Sempre Disponível',
                  description: 'Funciona mesmo sem internet',
                ),
              ] else ...[
                Text(
                  _getUnavailabilityMessage(capabilities),
                  style: const TextStyle(
                    color: FinColors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: FinSizes.spaceBtwItems),
                _buildSetupInstructions(),
              ],
            ],
          ),
          actions: [
            if (showSkipOption)
              TextButton(
                onPressed: () {
                  Get.back(result: false);
                  onSkipped?.call();
                },
                style: TextButton.styleFrom(
                  foregroundColor: FinColors.darkGrey,
                ),
                child: const Text('Agora não'),
              ),
            ElevatedButton(
              onPressed: () async {
                if (isAvailable) {
                  // Test biometric authentication
                  final result = await BiometricService.authenticateWithContext(
                    context: BiometricContext.settings,
                    customReason: 'Teste sua $biometricType para ativar login rápido',
                  );

                  if (result.success) {
                    Get.back(result: true);
                    onBiometricEnabled?.call();
                    Get.snackbar(
                      'Sucesso!',
                      '$biometricType ativado com sucesso',
                      backgroundColor: FinColors.success,
                      colorText: FinColors.white,
                      duration: const Duration(seconds: 3),
                    );
                  } else {
                    Get.snackbar(
                      'Erro',
                      result.errorMessage ?? 'Falha ao configurar biometria',
                      backgroundColor: FinColors.error,
                      colorText: FinColors.white,
                    );
                  }
                } else {
                  Get.back(result: false);
                  // Direct user to settings
                  Get.snackbar(
                    'Configuração Necessária',
                    'Configure a biometria nas configurações do seu dispositivo',
                    backgroundColor: FinColors.info,
                    colorText: FinColors.white,
                    duration: const Duration(seconds: 4),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FinColors.primary,
                foregroundColor: FinColors.white,
              ),
              child: Text(isAvailable ? 'Ativar $biometricType' : 'Entendi'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBenefitItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: FinColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: FinColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: FinSizes.spaceBtwItems),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: FinColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: FinColors.white.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetupInstructions() {
    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: FinColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: FinColors.info.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: FinColors.info,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Como configurar:',
                style: TextStyle(
                  color: FinColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '1. Vá para Configurações do dispositivo\n'
                '2. Procure por "Biometria" ou "Segurança"\n'
                '3. Configure impressão digital ou reconhecimento facial\n'
                '4. Retorne ao app para ativar',
            style: TextStyle(
              color: FinColors.white.withOpacity(0.9),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _getUnavailabilityMessage(Map<String, dynamic> capabilities) {
    final canCheck = capabilities['canCheck'] ?? false;
    final isSupported = capabilities['isSupported'] ?? false;
    final availableTypes = capabilities['availableTypes'] as List? ?? [];

    if (!isSupported) {
      return 'Este dispositivo não suporta autenticação biométrica. Você pode continuar usando sua senha normalmente.';
    } else if (!canCheck) {
      return 'A autenticação biométrica não está habilitada no sistema. Configure-a nas configurações do dispositivo.';
    } else if (availableTypes.isEmpty) {
      return 'Nenhuma biometria foi cadastrada no seu dispositivo. Configure impressão digital ou reconhecimento facial primeiro.';
    } else {
      return 'Configure a biometria nas configurações do seu dispositivo para usar esta funcionalidade.';
    }
  }
}

/// Quick helper widget to show biometric status in UI
class BiometricStatusIndicator extends StatelessWidget {
  final bool showLabel;
  final MainAxisSize mainAxisSize;

  const BiometricStatusIndicator({
    super.key,
    this.showLabel = true,
    this.mainAxisSize = MainAxisSize.min,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: BiometricService.isBiometricSetup(),
      builder: (context, snapshot) {
        final isAvailable = snapshot.data ?? false;

        return Row(
          mainAxisSize: mainAxisSize,
          children: [
            FutureBuilder<IconData>(
              future: BiometricService.getBiometricIcon(),
              builder: (context, iconSnapshot) {
                return Icon(
                  iconSnapshot.data ?? Icons.security,
                  color: isAvailable ? FinColors.success : FinColors.darkGrey,
                  size: 16,
                );
              },
            ),
            if (showLabel) ...[
              const SizedBox(width: 8),
              FutureBuilder<String>(
                future: BiometricService.getBiometricType(),
                builder: (context, typeSnapshot) {
                  final type = typeSnapshot.data ?? 'Biometria';
                  return Text(
                    isAvailable ? type : 'Não disponível',
                    style: TextStyle(
                      color: isAvailable ? FinColors.success : FinColors.darkGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                },
              ),
            ],
          ],
        );
      },
    );
  }
}

/// Extension to easily show biometric education from anywhere
extension BiometricEducationExtension on GetInterface {
  /// Show biometric education dialog with default callbacks
  Future<bool?> showBiometricEducation({
    VoidCallback? onEnabled,
    VoidCallback? onSkipped,
    bool showSkip = true,
  }) async {
    return await BiometricEducationDialog.show(
      onBiometricEnabled: onEnabled,
      onSkipped: onSkipped,
      showSkipOption: showSkip,
    );
  }
}