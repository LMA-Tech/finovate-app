import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../services/auth_service.dart';
import '../../services/biometric_service.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/constants/colors.dart';

class LoginController extends GetxController {
  final AuthService _auth = AuthService();

  late FormGroup loginForm;

  final RxBool isLoading = false.obs;
  final RxBool hidePassword = true.obs;
  final RxBool canLoginReactive = false.obs;
  final RxString biometricType = "Biometria".obs;
  final RxBool biometricAvailable = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
    _setupFormListener();
    _checkBiometricAvailability();
  }

  void _initializeForm() {
    loginForm = FormGroup({
      'email': FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
      ),
      'password': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(6),
        ],
      ),
    });
  }

  void _setupFormListener() {
    loginForm.statusChanged.listen((_) {
      canLoginReactive.value = loginForm.valid;
    });
  }

  Future<void> _checkBiometricAvailability() async {
    biometricAvailable.value = await BiometricService.isAvailable();
    if (biometricAvailable.value) {
      biometricType.value = await BiometricService.getBiometricType();
    }
  }

  void togglePassword() => hidePassword.toggle();

  Future<void> login() async {
    if (!loginForm.valid) {
      loginForm.markAllAsTouched();
      return;
    }

    try {
      isLoading.value = true;

      await _auth.login(
        loginForm.control('email').value,
        loginForm.control('password').value,
      );

      // Offer biometric enrollment after successful login
      await _offerBiometricEnrollment();

      Get.snackbar(
        FinTexts.loginSuccessTitle,
        FinTexts.loginSuccessMessage,
        backgroundColor: FinColors.success,
        colorText: FinColors.white,
      );
    } catch (e) {
      Get.snackbar(
        FinTexts.loginErrorTitle,
        e.toString(),
        backgroundColor: FinColors.error,
        colorText: FinColors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _offerBiometricEnrollment() async {
    // Only offer if biometrics are available
    if (!biometricAvailable.value) return;

    // TODO: Check if user already has biometric login enabled
    // For now, always offer

    final shouldEnroll = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Ativar ${biometricType.value}?'),
        content: Text('Use ${biometricType.value} para fazer login mais rapidamente nas próximas vezes.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            style: TextButton.styleFrom(foregroundColor: FinColors.darkGrey),
            child: const Text(FinTexts.notNow),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(backgroundColor: FinColors.primary),
            child: const Text(FinTexts.activate),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (shouldEnroll == true) {
      // TODO: Save biometric preference to secure storage
      Get.snackbar(
        FinTexts.biometricActivatedTitle,
        '${FinTexts.biometricActivatedMessage} ${biometricType.value} ${FinTexts.biometricActivatedMessageEnd}',
        backgroundColor: FinColors.success,
        colorText: FinColors.white,
      );
    }
  }

  Future<void> resetPassword() async {
    final email = loginForm.control('email').value;

    if (email == null || email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        FinTexts.error,
        FinTexts.resetPasswordEmailError,
        backgroundColor: FinColors.error,
        colorText: FinColors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _auth.resetPassword(email);

      Get.snackbar(
        FinTexts.resetPasswordEmailSentTitle,
        FinTexts.resetPasswordEmailSentMessage,
        backgroundColor: FinColors.info,
        colorText: FinColors.white,
      );
    } catch (e) {
      Get.snackbar(
        FinTexts.error,
        e.toString(),
        backgroundColor: FinColors.error,
        colorText: FinColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}