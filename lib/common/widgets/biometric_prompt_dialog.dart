import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/activity_tracker.dart';
import '../../services/biometric_service.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/text_strings.dart';

/// Dialog that prompts user for biometric authentication
/// Automatically detects available biometric type (Face ID, Fingerprint, etc.)
/// and displays appropriate UI with fallback options
class BiometricPromptDialog extends StatefulWidget {
  const BiometricPromptDialog({super.key});

  @override
  BiometricPromptDialogState createState() => BiometricPromptDialogState();
}

class BiometricPromptDialogState extends State<BiometricPromptDialog> {

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // Track authentication state and biometric capabilities
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Whether biometric authentication is currently in progress
  bool isAuthenticating = false;

  /// Localized name of the detected biometric type
  String biometricType = "Biometria";

  /// Icon representing the detected biometric type
  IconData biometricIcon = Icons.fingerprint;

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // LIFECYCLE MANAGEMENT
  // Initialize biometric detection and authentication flow
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  void initState() {
    super.initState();
    _initBiometricInfo();
  }

  /// Detects available biometric capabilities and initializes UI
  /// In production mode, automatically triggers authentication after setup
  Future<void> _initBiometricInfo() async {
    if (kDebugMode) {
      debugPrint('🔍 Inicializando informações biométricas...');
    }

    try {
      // Get biometric type and icon from service
      final type = await BiometricService.getBiometricType();
      final icon = await BiometricService.getBiometricIcon();

      if (kDebugMode) {
        debugPrint('🔍 Tipo detectado: $type');
        debugPrint('🔍 Ícone selecionado: $icon');
      }

      // Update UI with detected biometric info
      if (mounted) {
        setState(() {
          biometricType = type;
          biometricIcon = icon;
        });
      }

      // In production mode, auto-trigger authentication after brief delay
      if (!kDebugMode) {
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            _authenticate();
          }
        });
      } else {
        if (kDebugMode) {
          debugPrint('🧪 Modo de teste ativo - autenticação manual necessária');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro ao inicializar biometria: $e');
      }
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION FLOW
  // Handle biometric authentication process
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Performs biometric authentication
  /// Updates UI state and handles success/failure scenarios
  Future<void> _authenticate() async {
    if (isAuthenticating) {
      if (kDebugMode) {
        debugPrint('⚠️ Autenticação já em andamento');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('🔒 Iniciando autenticação biométrica...');
    }

    // Update UI to show authentication in progress
    if (mounted) {
      setState(() {
        isAuthenticating = true;
      });
    }

    try {
      final success = await BiometricService.authenticate(
          reason: FinTexts.biometricAuthReason
      );

      if (success) {
        if (kDebugMode) {
          debugPrint('✅ Autenticação biométrica bem-sucedida');
        }

        // Mark successful biometric authentication in activity tracker
        Get.find<ActivityTracker>().markBiometricAuth();

        // Close dialog and return to app
        Get.back(result: true);
      } else {
        if (kDebugMode) {
          debugPrint('❌ Autenticação biométrica falhou');
        }

        // Show failure state after brief delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          setState(() {
            isAuthenticating = false;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Erro durante autenticação biométrica: $e');
      }

      // Show error state after brief delay
      await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) {
        setState(() {
          isAuthenticating = false;
        });
      }
    }
  }

  /// Simulates successful authentication for debug/testing purposes
  void _simulateSuccess() {
    if (kDebugMode) {
      debugPrint('🧪 Simulando sucesso da autenticação biométrica');
    }

    Get.find<ActivityTracker>().markBiometricAuth();
    Get.back(result: true);
  }

  /// Signs out user and closes dialog
  void _signOut() {
    if (kDebugMode) {
      debugPrint('👋 Usuário escolheu sair durante prompt biométrico');
    }
    // Close dialog first
    Get.back(result: false);

    // Navigate to login screen (which has same AppBackground)
    Get.offAllNamed('/login');

    // Then sign out (this will clear the session but not navigate since we're already on login)
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.find<SessionManager>().signOutToLogin();
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UI BUILDING
  // Construct the biometric prompt dialog interface
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent dismissing dialog by back gesture/button
      child: AlertDialog(
        title: Text(
          "Desbloqueie com $biometricType",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Biometric icon with dynamic color
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                biometricIcon,
                size: 64,
                color: isAuthenticating
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).disabledColor,
              ),
            ),
            const SizedBox(height: 16),

            // Status message
            Text(
              _getStatusMessage(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            // Loading indicator when authenticating
            if (isAuthenticating) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: _buildActionButtons(),
      ),
    );
  }

  /// Returns appropriate status message based on current state
  String _getStatusMessage() {
    if (isAuthenticating) {
      return "Aguardando $biometricType...";
    } else if (kDebugMode) {
      return "Modo de teste - use botão manual";
    } else {
      return "Use $biometricType para continuar";
    }
  }

  /// Builds action buttons based on current state and debug mode
  List<Widget> _buildActionButtons() {
    List<Widget> actions = [];

    // Authentication button (production mode only, when not authenticating)
    if (!isAuthenticating && !kDebugMode) {
      actions.add(
        TextButton(
          onPressed: _authenticate,
          child: Text("Usar $biometricType"),
        ),
      );
    }

    // Debug mode simulation button
    if (kDebugMode) {
      actions.add(
        TextButton(
          onPressed: _simulateSuccess,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
          child: const Text("✅ Simular Sucesso"),
        ),
      );
    }

    // Sign out button (always available)
    actions.add(
      TextButton(
        onPressed: _signOut,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        ),
        child: const Text(FinTexts.biometricPromptSignOut),
      ),
    );

    return actions;
  }
}