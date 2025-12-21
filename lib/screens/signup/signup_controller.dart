import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../common/dialogs/app_dialogs.dart';
import '../../services/auth_service.dart';
import '../../services/centralized_email_service.dart';
import '../../services/finovate_api_service.dart';
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
  // QUESTIONNAIRE STATE (Steps 7-11)
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Stores questionnaire answers: {questionNumber: displayText}
  final RxMap<int, String> questionnaireAnswers = <int, String>{}.obs;

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
      'taxId': FormControl<String>(
        validators: [
          Validators.required,
          Validators.minLength(14), // Minimum: CPF formatted (14 chars: 000.000.000-00)
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
    ever(questionnaireAnswers, (_) => _updateCanProceed());
  }

  void _updateCanProceed() {
    canProceedReactive.value = canProceed;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UI HELPERS
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Show progress indicator on steps 1-4 (signup flow) or 7-10 (questionnaire)
  bool shouldShowProgressIndicator() {
    // Show on signup steps 1-4
    if (currentStep.value >= 1 && currentStep.value <= 4) return true;

    // Show on questionnaire steps 7-10
    if (currentStep.value >= 7 && currentStep.value <= 10) return true;

    return false;
  }

  /// Check if we're in questionnaire mode (for progress indicator styling)
  bool get isQuestionnaireMode => currentStep.value >= 7 && currentStep.value <= 10;

  /// Get current questionnaire progress (1-4)
  int get questionnaireProgress {
    if (currentStep.value < 7) return 0;
    return currentStep.value - 6; // Step 7 = Q1, Step 8 = Q2, etc.
  }

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
      return FinColors.primary;
    }
    return FinColors.primary.withValues(alpha: 0.4);
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

    // Step 2: Check if tax ID (CPF/CNPJ) exists
    if (currentStep.value == 2) {
      final taxId = step3Form.control('taxId').value;
      if (taxId != null && taxId.isNotEmpty) {
        final taxIdExists = await _auth.checkTaxIdExists(taxId);
        if (taxIdExists) {
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
      case 7:
      case 8:
      case 9:
      case 10:
      // Questionnaire questions - must have answer for current question
        final questionNumber = currentStep.value - 6; // Map step 7→Q1, 8→Q2, etc.
        return questionnaireAnswers.containsKey(questionNumber);
      case 11:
        return allQuestionsAnswered; // Final screen - all questions must be answered
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
      case 7:
      case 8:
      case 9:
      case 10:
      // Questionnaire questions - must have answer for current question
        final questionNumber = currentStep.value - 6; // Map step 7→Q1, 8→Q2, etc.
        return questionnaireAnswers.containsKey(questionNumber);
      case 11:
        return allQuestionsAnswered; // Final screen - all questions must be answered
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
          taxId: userData['tax_id'],
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
        message: FinTexts.signupErrorVerificationInvalid,
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

    final taxId = step3Form.control('taxId').value;
    if (taxId != null && taxId.isNotEmpty) {
      userData['tax_id'] = taxId.replaceAll(RegExp(r'[^\d]'), '');
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
  // QUESTIONNAIRE METHODS
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Select an answer for a questionnaire question
  void selectQuestionnaireAnswer(int questionNumber, String displayText) {
    questionnaireAnswers[questionNumber] = displayText;
  }

  /// Get the selected answer for a question (returns null if not answered)
  String? getSelectedAnswer(int questionNumber) {
    return questionnaireAnswers[questionNumber];
  }

  /// Check if all questionnaire questions have been answered
  bool get allQuestionsAnswered {
    return questionnaireAnswers.length == 4 &&
        questionnaireAnswers.containsKey(1) &&
        questionnaireAnswers.containsKey(2) &&
        questionnaireAnswers.containsKey(3) &&
        questionnaireAnswers.containsKey(4);
  }

  /// Map display text to backend enum value
  String _mapAnswerToBackendEnum(int questionNumber, String displayText) {
    switch (questionNumber) {
      case 1: // Wealth Range
        if (displayText == FinTexts.question1Option1) return 'UNDER_50K';
        if (displayText == FinTexts.question1Option2) return 'BETWEEN_50K_500K';
        if (displayText == FinTexts.question1Option3) return 'BETWEEN_500K_1M';
        if (displayText == FinTexts.question1Option4) return 'OVER_1M';
        if (displayText == FinTexts.question1Option5) return 'PREFER_NOT_SAY';
        break;

      case 2: // Investment Knowledge
        if (displayText == FinTexts.question2Option1) return 'BEGINNER';
        if (displayText == FinTexts.question2Option2) return 'INTERMEDIATE';
        if (displayText == FinTexts.question2Option3) return 'ADVANCED';
        if (displayText == FinTexts.question2Option4) return 'EXPERT';
        break;

      case 3: // Decision Style
        if (displayText == FinTexts.question3Option1) return 'CONSULT_FRIENDS_FAMILY';
        if (displayText == FinTexts.question3Option2) return 'RESEARCH_ONLINE';
        if (displayText == FinTexts.question3Option3) return 'CONSULT_ADVISOR';
        if (displayText == FinTexts.question3Option4) return 'INDEPENDENT_DECISION';
        break;

      case 4: // Risk Profile
        if (displayText == FinTexts.question4Option1) return 'CONSERVATIVE';
        if (displayText == FinTexts.question4Option2) return 'MODERATE';
        if (displayText == FinTexts.question4Option3) return 'AGGRESSIVE';
        break;
    }

    throw Exception('Invalid answer mapping: Q$questionNumber = $displayText');
  }

  /// Submit questionnaire to backend (called from final welcome screen)
  Future<void> submitQuestionnaire() async {
    // Validate all questions answered
    if (!allQuestionsAnswered) {
      await AppDialogs.showError(
        title: 'Questionário incompleto',
        message: 'Por favor, responda todas as perguntas antes de continuar.',
      );
      return;
    }

    try {
      isLoading.value = true;

      // Map display text to backend enum values
      final wealthRange = _mapAnswerToBackendEnum(1, questionnaireAnswers[1]!);
      final investmentKnowledge = _mapAnswerToBackendEnum(2, questionnaireAnswers[2]!);
      final decisionStyle = _mapAnswerToBackendEnum(3, questionnaireAnswers[3]!);
      final riskProfile = _mapAnswerToBackendEnum(4, questionnaireAnswers[4]!);

      print('Submitting questionnaire:');
      print('  Wealth: $wealthRange');
      print('  Knowledge: $investmentKnowledge');
      print('  Decision: $decisionStyle');
      print('  Risk: $riskProfile');

      // Submit to backend
      await FinovateApiService.submitQuestionnaire(
        wealthRange: wealthRange,
        investmentKnowledge: investmentKnowledge,
        decisionStyle: decisionStyle,
        riskProfile: riskProfile,
      );

      print('Questionnaire submitted successfully!');

      // Navigate to final welcome screen (step 11)
      // Don't mark signup complete yet - final screen will do that
      nextStep(); // Moves to Success Screen

    } catch (e) {
      print('Questionnaire submission error: $e');
      await AppDialogs.showError(
        title: 'Erro ao enviar',
        message: 'Não foi possível enviar o questionário. Tente novamente.',
      );
    } finally {
      isLoading.value = false;
    }
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