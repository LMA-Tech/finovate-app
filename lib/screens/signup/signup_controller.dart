import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/dialogs/app_dialogs.dart';
import '../../services/auth_service.dart';
import '../../services/centralized_email_service.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';

/// Controller for managing the multi-step signup process
///
/// CURRENT FLOW (7 steps):
/// Step 0: Email/Password
/// Step 1: Name
/// Step 2: CPF/Phone/Birthdate
/// Step 3: Verification Method Selection
/// Step 4: OTP Code Entry
/// Step 5: Success Screen ("Conta criada com sucesso!")
/// Step 6: Questionnaire Intro ("Queremos te conhecer!")
class SignupController extends GetxController {
  // ═══════════════════════════════════════════════════════════════════════════════════════
  // SERVICES
  // ═══════════════════════════════════════════════════════════════════════════════════════

  final AuthService _auth = AuthService();

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // NAVIGATION & STATE
  // ═══════════════════════════════════════════════════════════════════════════════════════

  final PageController pageController = PageController();
  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;

  // Constants
  static const int totalSteps = 7; // 0-6
  static const int totalProgressLevels = 5; // For progress indicator
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.easeInOut;

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // FORM STATE (Steps 0-2)
  // ═══════════════════════════════════════════════════════════════════════════════════════

  late FormGroup step1Form; // Email, password, confirm password
  late FormGroup step2Form; // First name, last name, middle name
  late FormGroup step3Form; // CPF, phone, birthdate

  // Password visibility toggles
  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;

  // Reactive variable to track if user can proceed to next step
  final RxBool canProceedReactive = false.obs;

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // VERIFICATION STATE (Steps 3-4)
  // ═══════════════════════════════════════════════════════════════════════════════════════

  final Rx<VerificationMethod> selectedVerificationMethod = VerificationMethod.email.obs;
  final RxString verificationCode = ''.obs;
  final RxInt resendTimer = 300.obs; // 5 minutes
  final RxBool canResendCode = false.obs;

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // PHONE FORMATTING
  // ═══════════════════════════════════════════════════════════════════════════════════════

  final intelligentPhoneFormatter = MaskTextInputFormatter(
    mask: null,
    filter: {"#": RegExp(r'[0-9+]')},
    type: MaskAutoCompletionType.lazy,
  );

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // INITIALIZATION
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();

    // Prevent auto-navigation during signup
    Get.find<SessionManager>().isInSignupFlow.value = true;

    // Initialize forms
    _initializeForms();

    // Setup phone formatting
    _setupPhoneFormatting();

    // Setup validation listeners
    _setupListeners();

    // Initial state
    _updateCanProceed();
  }

  void _initializeForms() {
    // Step 0: Email & Password
    step1Form = FormGroup({
      'email': FormControl<String>(
        validators: [Validators.required, Validators.email],
      ),
      'password': FormControl<String>(
        validators: [Validators.required, Validators.minLength(8)],
      ),
      'confirmPassword': FormControl<String>(
        validators: [Validators.required],
      ),
    }, validators: [
      Validators.mustMatch('password', 'confirmPassword'),
    ]);

    // Step 1: Name
    step2Form = FormGroup({
      'firstName': FormControl<String>(
        validators: [Validators.required, Validators.minLength(2)],
      ),
      'lastName': FormControl<String>(
        validators: [Validators.required, Validators.minLength(2)],
      ),
      'middleName': FormControl<String>(), // Optional
    });

    // Step 2: Personal Details
    step3Form = FormGroup({
      'cpf': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$'),
        ],
      ),
      'phone': FormControl<String>(
        validators: [Validators.required, Validators.minLength(10)],
      ),
      'birthdate': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(r'^\d{2}/\d{2}/\d{4}$'),
        ],
      ),
    });
  }

  void _setupPhoneFormatting() {
    step3Form.control('phone').valueChanges.listen((value) {
      if (value == null) return;
      final formatted = _formatPhoneNumber(value.toString());
      if (formatted != value) {
        step3Form.control('phone').value = formatted;
      }
    });
  }

  void _setupListeners() {
    // Listen to step changes
    ever(currentStep, (_) => _updateCanProceed());

    // Listen to form validation
    step1Form.statusChanged.listen((_) => _updateCanProceed());
    step2Form.statusChanged.listen((_) => _updateCanProceed());
    step3Form.statusChanged.listen((_) => _updateCanProceed());
  }

  void _updateCanProceed() {
    canProceedReactive.value = canProceed;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UI HELPERS
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Show progress indicator on steps 1-4 only
  bool shouldShowProgressIndicator() =>
      currentStep.value >= 1 && currentStep.value <= 4;

  /// Get button text for current step
  String getButtonText() {
    switch (currentStep.value) {
      case 3:
        return "Enviar código"; // Step 4 - send verification
      case 5:
        return FinTexts.signupFinalbutton; // Step 6 - "Tudo certo!"
      case 6:
        return FinTexts.questionnaireIntroButton; // Step 7 - "Ok, vamos!"
      default:
        return FinTexts.signupContinueButton; // Steps 1-3 - "Continuar"
    }
  }

  /// Get button color based on validation
  Color getButtonColor() {
    if (canProceedReactive.value && !isLoading.value) {
      return const Color(0xFF1B6FFF);
    }
    return const Color(0xFF1B6FFF).withValues(alpha: 0.4);
  }

  /// Get button action (null when disabled)
  VoidCallback? getButtonAction() {
    if (isLoading.value || !canProceedReactive.value) return null;
    return nextStep;
  }

  /// Handle back navigation - either go to previous step or exit signup
  void handleBackNavigation(BuildContext context) {
    // Prevent going back from success screen (Step 5) or questionnaire intro (Step 6)
    if (currentStep.value == 5 || currentStep.value == 6) {
      return; // Do nothing - user cannot go back after account creation
    }
    if (currentStep.value > 0) {
      previousStep();
    } else {
      Navigator.pop(context);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // NAVIGATION
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Move to next step
  Future<void> nextStep() async {
    // Step 0: Check if email exists
    if (currentStep.value == 0) {
      final email = step1Form.control('email').value;
      final emailExists = await _auth.checkEmailExists(email);
      if (emailExists) {
        await AppDialogs.showError(
          title: FinTexts.signupErrorTitle,
          message: FinTexts.signupErrorEmailExists,
        );
        return;
      }
    }

    // Step 2: Check if CPF exists
    if (currentStep.value == 2) {
      final cpf = step3Form.control('cpf').value;
      if (cpf != null && cpf.isNotEmpty) {
        final cpfExists = await _auth.checkCpfExists(cpf);
        if (cpfExists) {
          await AppDialogs.showError(
            title: FinTexts.signupErrorTitle,
            message: FinTexts.signupErrorCpfExists,
          );
          return;
        }
      }
    }

    // Step 3: Send verification code
    if (currentStep.value == 3) {
      await signUp(); // This will send OTP and move to step 4
      return;
    }

    // Step 4: Verify OTP code
    if (currentStep.value == 4) {
      await verifyCode(); // This will verify and move to step 5
      return;
    }

    // All other steps: Validate and advance
    if (_validateCurrentStep()) {
      currentStep.value++;
      _animateToPage(currentStep.value);
    }
  }

  /// Move to previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      _animateToPage(currentStep.value);
    }
  }

  void _animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: pageTransitionDuration,
      curve: transitionCurve,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // VALIDATION
  // ═══════════════════════════════════════════════════════════════════════════════════════

  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        step1Form.markAllAsTouched();
        return step1Form.valid;
      case 1:
        step2Form.markAllAsTouched();
        return step2Form.valid;
      case 2:
        step3Form.markAllAsTouched();
        return step3Form.valid;
      case 3:
        return selectedVerificationMethod.value != null;
      case 4:
        return verificationCode.value.length == 6;
      case 5:
      case 6:
        return true; // Success and intro screens
      default:
        return false;
    }
  }

  bool get canProceed {
    switch (currentStep.value) {
      case 0:
        return step1Form.valid;
      case 1:
        return step2Form.controls['firstName']!.valid &&
            step2Form.controls['lastName']!.valid;
      case 2:
        return step3Form.valid;
      case 3:
        return selectedVerificationMethod.value != null;
      case 4:
        return verificationCode.value.length == 6;
      case 5:
      case 6:
        return true; // Success and intro screens
      default:
        return false;
    }
  }

  int get progressLevel {
    switch (currentStep.value) {
      case 0:
        return 0;
      case 1:
      case 2:
        return 1;
      case 3:
        return 2;
      case 4:
        return 3;
      default:
        return 0;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // VERIFICATION METHODS
  // ═══════════════════════════════════════════════════════════════════════════════════════

  void selectVerificationMethod(VerificationMethod method) {
    selectedVerificationMethod.value = method;
  }

  bool canSendVerification() => !isLoading.value;

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // PASSWORD VISIBILITY
  // ═══════════════════════════════════════════════════════════════════════════════════════

  void togglePassword() => hidePassword.toggle();
  void toggleConfirmPassword() => hideConfirmPassword.toggle();

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // OTP VERIFICATION
  // ═══════════════════════════════════════════════════════════════════════════════════════

  void onCodeChanged(String code) {
    verificationCode.value = code;
  }

  Future<void> verifyCode() async {
    if (verificationCode.value.length != 6) return;

    try {
      isLoading.value = true;

      AuthResponse response;

      if (selectedVerificationMethod.value == VerificationMethod.email) {
        final email = step1Form.control('email').value;
        response = await _auth.verifyOTP(
          email: email,
          token: verificationCode.value,
        );
      } else {
        final phoneNumber = step3Form.control('phone').value;
        response = await _auth.verifySmsOTP(
          phoneNumber: phoneNumber,
          token: verificationCode.value,
        );
      }

      if (response.user != null) {
        print('Verification successful!');

        // Create user profile
        final userData = _buildUserData();
        await _auth.updateUserProfile(
          firstName: userData['first_name'],
          lastName: userData['last_name'],
          middleName: userData['middle_name'],
          birthdate: userData['birthdate'] != null
              ? DateTime.parse(userData['birthdate'])
              : null,
          cpf: userData['cpf'],
          phoneNumber: userData['phone_number'],
        );

        print('User profile created successfully');

        // Go to success screen (Step 5)
        currentStep.value = 5;
        _animateToPage(5);

      } else {
        await AppDialogs.showError(
          title: FinTexts.signupErrorTitle,
          message: FinTexts.signupErrorVerificationInvalid,
        );
      }
    } catch (e) {
      print('Verification error: $e');
      await AppDialogs.showError(
        title: FinTexts.signupErrorTitle,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void startResendTimer() {
    resendTimer.value = 300;
    canResendCode.value = false;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResendCode.value = true;
        timer.cancel();
      }
    });
  }

  String get formattedTimer {
    int minutes = resendTimer.value ~/ 60;
    int seconds = resendTimer.value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> resendVerification() async {
    try {
      isLoading.value = true;

      if (selectedVerificationMethod.value == VerificationMethod.email) {
        final email = step1Form.control('email').value;
        await EmailService.resendSignupVerification(email);
      } else {
        final phoneNumber = step3Form.control('phone').value;
        final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
        await _auth.resendSmsOTP(cleanPhoneNumber);
      }

      startResendTimer();

    } catch (e) {
      await AppDialogs.showError(
        title: FinTexts.signupErrorTitle,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendCode() => resendVerification();

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // SIGNUP / AUTHENTICATION
  // ═══════════════════════════════════════════════════════════════════════════════════════

  Future<void> signUp() async {
    try {
      isLoading.value = true;
      final userData = _buildUserData();

      AuthResponse response;

      if (selectedVerificationMethod.value == VerificationMethod.email) {
        final email = step1Form.control('email').value;
        final password = step1Form.control('password').value;

        response = await _auth.signUp(
          email: email,
          password: password,
          userData: userData,
        );
      } else {
        final phoneNumber = step3Form.control('phone').value;
        final password = step1Form.control('password').value;
        final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');

        response = await _auth.signUpWithPhone(
          phoneNumber: cleanPhoneNumber,
          password: password,
          userData: userData,
        );
      }

      _handleSignUpResponse(response);

    } catch (e) {
      await AppDialogs.showError(
        title: FinTexts.signupErrorTitle,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic> _buildUserData() {
    final userData = <String, dynamic>{
      'first_name': step2Form.control('firstName').value,
      'last_name': step2Form.control('lastName').value,
      'email': step1Form.control('email').value.trim().toLowerCase(),
    };

    final cpf = step3Form.control('cpf').value;
    if (cpf != null && cpf.isNotEmpty) {
      userData['cpf'] = cpf.replaceAll(RegExp(r'[^\d]'), '');
    }

    final phone = step3Form.control('phone').value;
    if (phone != null && phone.isNotEmpty) {
      userData['phone_number'] = phone.replaceAll(RegExp(r'[^\d+]'), '');
    }

    final birthdate = step3Form.control('birthdate').value;
    if (birthdate != null && birthdate.isNotEmpty) {
      try {
        final parts = birthdate.split('/');
        if (parts.length == 3) {
          final date = DateTime(
            int.parse(parts[2]),
            int.parse(parts[1]),
            int.parse(parts[0]),
          );
          userData['birthdate'] = date.toIso8601String();
        }
      } catch (e) {
        print('Invalid date format: $birthdate');
      }
    }

    return userData;
  }

  void _handleSignUpResponse(AuthResponse response) {
    print('=== SIGNUP RESPONSE ===');
    print('User exists: ${response.user != null}');

    if (response.user != null) {
      // Go to OTP verification (Step 4)
      print('Moving to OTP verification');
      currentStep.value = 4;
      _animateToPage(4);
      startResendTimer();
    } else {
      AppDialogs.showError(
        title: FinTexts.signupErrorTitle,
        message: FinTexts.signupErrorGeneric,
      );
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // PHONE FORMATTING
  // ═══════════════════════════════════════════════════════════════════════════════════════

  String _formatPhoneNumber(String input) {
    final cleaned = input.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.isEmpty) return '';

    if (cleaned.startsWith('+')) {
      if (cleaned.length > 3) {
        final countryCode = cleaned.substring(0, 3);
        final remaining = cleaned.substring(3);

        if (countryCode == '+55' && remaining.length >= 2) {
          final areaCode = remaining.substring(0, 2);
          final rest = remaining.substring(2);

          if (rest.length <= 8) {
            if (rest.length > 4) {
              return '+55 ($areaCode) ${rest.substring(0, 4)}-${rest.substring(4)}';
            }
            return '+55 ($areaCode) $rest';
          } else {
            if (rest.length > 5) {
              return '+55 ($areaCode) ${rest.substring(0, 5)}-${rest.substring(5, rest.length > 9 ? 9 : remaining.length)}';
            }
            return '+55 ($areaCode) $rest';
          }
        } else {
          if (remaining.length > 6) {
            return '$countryCode ${remaining.substring(0, remaining.length - 4)}-${remaining.substring(remaining.length - 4)}';
          }
          return '$countryCode $remaining';
        }
      }
      return cleaned;
    } else {
      if (cleaned.length >= 2) {
        final areaCode = cleaned.substring(0, 2);
        final rest = cleaned.substring(2);

        if (rest.length <= 8) {
          if (rest.length > 4) {
            return '($areaCode) ${rest.substring(0, 4)}-${rest.substring(4)}';
          }
          return '($areaCode) $rest';
        } else {
          if (rest.length > 5) {
            return '($areaCode) ${rest.substring(0, 5)}-${rest.substring(5, rest.length > 9 ? 9 : rest.length)}';
          }
          return '($areaCode) $rest';
        }
      }
      return cleaned;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // QUESTIONNAIRE (STUBS - Not implemented yet)
  // These methods exist to prevent compile errors in unused questionnaire widgets
  // ═══════════════════════════════════════════════════════════════════════════════════════

  void selectQuestionnaireAnswer(int questionNumber, String displayText) {
    // TODO: Implement when adding questionnaire
    print('Questionnaire answer selected: Q$questionNumber = $displayText');
  }

  String? getSelectedAnswer(int questionNumber) {
    // TODO: Implement when adding questionnaire
    return null;
  }

  Future<void> submitQuestionnaire() async {
    // TODO: Implement when adding questionnaire
    print('Questionnaire submission - not implemented yet');
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // CLEANUP
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  void onClose() {
    Get.find<SessionManager>().isInSignupFlow.value = false;
    pageController.dispose();
    super.onClose();
  }
}

enum VerificationMethod {
  email,
  sms,
}