import 'dart:developer';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth_service.dart';
import '../../services/biometric_service.dart';
import '../../services/session_manager.dart';

/// Controller for the Perfil screen.
///
/// Manages:
/// - Tab navigation state (Meu plano, Perfil, Preferências)
/// - User profile data
/// - Subscription status
/// - User preferences/settings
class PerfilController extends GetxController {
  final SessionManager _sessionManager = Get.find<SessionManager>();
  final AuthService _authService = Get.find<AuthService>();

  // Tab state (0: Meu plano, 1: Perfil, 2: Preferências)
  final RxInt selectedTabIndex = 1.obs; // Default to Perfil tab

  // Loading states
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  // User profile data (from SessionManager metadata)
  String get fullName => _sessionManager.userFullName ?? '';
  String get firstName => _getUserMetadata('first_name') ?? '';
  String get email => _sessionManager.currentUser.value?.email ?? '';
  String get phone => _getUserMetadata('phone_number') ?? '';
  String get cpf => _getUserMetadata('tax_id') ?? '';
  DateTime? get birthDate {
    final dateStr = _getUserMetadata('birthdate');
    if (dateStr == null) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (e) {
      return null;
    }
  }
  String? get nickname => _getUserMetadata('nickname');
  String? get profilePhotoUrl => _getUserMetadata('profile_photo_url');

  // Subscription status (will be backend-driven)
  // TODO: Replace with real subscription status from backend
  final RxString planType = 'free'.obs; // 'free' or 'pro'
  bool get isPro => planType.value == 'pro';

  // Plan details (will come from backend)
  String? get planStatus => _getUserMetadata('plan_status');
  String? get planStartDate => _getUserMetadata('plan_start_date');
  String? get planNextPaymentDate => _getUserMetadata('plan_next_payment_date');
  String? get planAnnualPrice => _getUserMetadata('plan_annual_price');
  String? get paymentMethodLast4 => _getUserMetadata('payment_method_last4');

  // Preferences
  final RxBool notificationsEnabled = true.obs;
  final RxBool biometricEnabled = false.obs;
  final RxBool biometricAvailable = false.obs;
  final RxString biometricType = 'Biometria'.obs;

  @override
  void onInit() {
    super.onInit();
    log('PerfilController initialized');
    _loadUserData();
    _loadPreferences();
    _checkBiometricAvailability();
  }

  /// Extracts user metadata from Supabase user
  String? _getUserMetadata(String key) {
    final user = _sessionManager.currentUser.value;
    if (user == null) return null;

    final metadata = user.userMetadata;
    if (metadata == null) return null;

    return metadata[key]?.toString();
  }

  /// Loads user data from session/backend
  Future<void> _loadUserData() async {
    // User data is already available from SessionManager
    // Additional data loading can be added here when backend is ready
    final user = _sessionManager.currentUser.value;
    log('User metadata: ${user?.userMetadata}');
  }

  // Preference keys for SharedPreferences
  static const String _keyNotifications = 'pref_notifications_enabled';
  static const String _keyBiometric = 'pref_biometric_enabled';

  /// Loads preferences from SharedPreferences, falls back to metadata if empty
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load notifications preference
      if (prefs.containsKey(_keyNotifications)) {
        notificationsEnabled.value = prefs.getBool(_keyNotifications) ?? true;
      } else {
        // Fallback to metadata
        final metaValue = _getUserMetadata('notifications_enabled');
        if (metaValue != null) {
          notificationsEnabled.value = metaValue.toLowerCase() == 'true';
        }
      }

      // Load biometric preference
      if (prefs.containsKey(_keyBiometric)) {
        biometricEnabled.value = prefs.getBool(_keyBiometric) ?? false;
      } else {
        // Fallback to metadata
        final metaValue = _getUserMetadata('biometric_enabled');
        if (metaValue != null) {
          biometricEnabled.value = metaValue.toLowerCase() == 'true';
        }
      }

      log('Loaded preferences - notifications: ${notificationsEnabled.value}, biometric: ${biometricEnabled.value}');
    } catch (e) {
      log('Error loading preferences: $e');
    }
  }

  /// Checks if biometric authentication is available on this device
  Future<void> _checkBiometricAvailability() async {
    biometricAvailable.value = await BiometricService.isBiometricSetup();
    if (biometricAvailable.value) {
      biometricType.value = await BiometricService.getBiometricType();
    } else {
      // If biometric not available, ensure it's disabled
      biometricEnabled.value = false;
    }
    log('Biometric available: ${biometricAvailable.value}, type: ${biometricType.value}');
  }

  /// Saves a preference to both SharedPreferences and metadata
  Future<void> _savePreference(String key, bool value, String metadataKey) async {
    try {
      // Save locally first (fast)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);

      // Save to metadata (async, fire and forget)
      _authService.updateUserPreference(metadataKey, value.toString()).catchError((e) {
        log('Failed to save preference to metadata: $e');
      });
    } catch (e) {
      log('Error saving preference: $e');
    }
  }

  /// Changes the selected tab
  void selectTab(int index) {
    if (index >= 0 && index <= 2) {
      selectedTabIndex.value = index;
    }
  }

  /// Toggles notification preference
  Future<void> toggleNotifications(bool value) async {
    notificationsEnabled.value = value;
    await _savePreference(_keyNotifications, value, 'notifications_enabled');
    log('Notifications toggled: $value');
  }

  /// Toggles biometric preference
  /// When enabling, requires biometric authentication first
  Future<void> toggleBiometric(bool value) async {
    if (!biometricAvailable.value) {
      log('Biometric not available on this device');
      return;
    }

    if (value) {
      // When enabling, authenticate first to confirm
      final result = await BiometricService.authenticateWithContext(
        context: BiometricContext.settings,
      );

      if (!result.success) {
        log('Biometric authentication failed: ${result.errorMessage}');
        return; // Don't enable if auth failed
      }
    }

    biometricEnabled.value = value;
    await _savePreference(_keyBiometric, value, 'biometric_enabled');
    log('Biometric toggled: $value');
  }

  /// Signs out the user
  Future<void> signOut() async {
    await _sessionManager.signOut();
  }

  /// Refreshes user data
  Future<void> refreshData() async {
    isLoading.value = true;
    error.value = '';

    try {
      await _loadUserData();
    } catch (e) {
      error.value = e.toString();
      log('Error refreshing profile data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Updates a profile field
  Future<void> updateField(String fieldKey, String newValue) async {
    log('Updating field: $fieldKey with value: $newValue');

    switch (fieldKey) {
      case 'fullName':
        // Split full name into first and last name
        final parts = newValue.trim().split(' ');
        final firstName = parts.first;
        final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : null;
        await _authService.updateUserMetadata(
          firstName: firstName,
          lastName: lastName,
        );
        break;

      case 'nickname':
        await _authService.updateUserMetadata(nickname: newValue);
        break;

      case 'phone':
        await _authService.updateUserMetadata(phoneNumber: newValue);
        break;

      case 'birthDate':
        // Parse DD/MM/YYYY to DateTime
        final parts = newValue.split('/');
        if (parts.length == 3) {
          final date = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
          await _authService.updateUserMetadata(birthdate: date);
        }
        break;

      case 'email':
        // Email is handled separately via EmailChangeBottomSheet
        throw 'Use o fluxo de alteração de e-mail';

      case 'cpf':
        // CPF should not be editable after registration
        throw 'CPF não pode ser alterado';

      default:
        throw 'Campo não reconhecido';
    }

    // Refresh current user to get updated metadata
    _sessionManager.refreshCurrentUser();
    update(); // Notify GetX listeners
  }

  /// Gets the current value for a field (for editing)
  String getFieldValue(String fieldKey) {
    switch (fieldKey) {
      case 'fullName':
        return fullName;
      case 'nickname':
        return nickname ?? firstName;
      case 'phone':
        return phone;
      case 'birthDate':
        if (birthDate != null) {
          return '${birthDate!.day.toString().padLeft(2, '0')}/${birthDate!.month.toString().padLeft(2, '0')}/${birthDate!.year}';
        }
        return '';
      case 'email':
        return email;
      case 'cpf':
        return cpf;
      default:
        return '';
    }
  }

  /// Gets the label for a field
  String getFieldLabel(String fieldKey) {
    switch (fieldKey) {
      case 'fullName':
        return 'Nome';
      case 'nickname':
        return 'Apelido';
      case 'phone':
        return 'Telefone';
      case 'birthDate':
        return 'Data de nascimento';
      case 'email':
        return 'E-mail';
      case 'cpf':
        return 'CPF/CNPJ';
      default:
        return fieldKey;
    }
  }
}
