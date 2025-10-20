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
import '../../utils/constants/routes.dart';
import '../../utils/constants/text_strings.dart';

/// Controller for managing the multi-step signup process
///
/// This controller handles:
/// - Multi-step form navigation (6 steps total)
/// - Reactive form validation using reactive_forms package
/// - Real-time validation feedback
/// - User authentication via AuthService
/// - UI state management for buttons, loading states, etc.
class SignupController extends GetxController {
  // Services
  final AuthService _auth = AuthService();

  // Navigation
  final PageController pageController = PageController();

  // Reactive forms for each signup step
  // These handle validation automatically and provide real-time feedback
  late FormGroup step1Form; // Email, password, confirm password
  late FormGroup step2Form; // First name, last name, middle name
  late FormGroup step3Form; // CPF, phone, birthdate (all required)

  // Reactive state variables for UI updates
  final RxInt currentStep = 0.obs; // Current step index (0-5)
  final RxBool isLoading = false.obs; // Loading state for signup process
  final RxBool hidePassword = true.obs; // Password visibility toggle
  final RxBool hideConfirmPassword = true.obs; // Confirm password visibility toggle
  final Rx<VerificationMethod> selectedVerificationMethod = VerificationMethod.email.obs; // Verification Method
  final RxString verificationCode = ''.obs;
  final RxInt resendTimer = 300.obs;
  final RxBool canResendCode = false.obs;

  // Reactive variable to track if user can proceed to next step
  final RxBool canProceedReactive = false.obs;

  // Constants
  static const int totalSteps = 6;
  /// Total progress levels (different from total steps)
  static const int totalProgressLevels = 5;
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.easeInOut;

  /// Intelligent phone formatter that detects country code and formats appropriately
  final intelligentPhoneFormatter = MaskTextInputFormatter(
    mask: null, // Dynamic mask
    filter: {"#": RegExp(r'[0-9+]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void onInit() {
    super.onInit();

    // Set signup flag to prevent auto-navigation
    Get.find<SessionManager>().isInSignupFlow.value = true;

    // Initialize reactive forms with validation rules
    _initializeReactiveForms();

    // Set up intelligent phone formatting
    _setupIntelligentPhoneFormatting();

    // Set up listeners for real-time validation updates
    _setupValidationListeners();

    // Initialize reactive state
    _updateCanProceed();
  }

  /// Set up listeners for real-time validation state updates
  void _setupValidationListeners() {
    // Listen to step changes
    ever(currentStep, (_) => _updateCanProceed());

    // Listen to form validation changes
    step1Form.statusChanged.listen((_) => _updateCanProceed());
    step2Form.statusChanged.listen((_) => _updateCanProceed());
    step3Form.statusChanged.listen((_) => _updateCanProceed());
  }

  /// Initialize reactive forms with validation rules for each signup step
  void _initializeReactiveForms() {
    // Step 1: Authentication credentials
    step1Form = FormGroup({
      'email': FormControl<String>(
        validators: [
          Validators.required, // Email is required
          Validators.email, // Must be valid email format
        ],
      ),
      'password': FormControl<String>(
        validators: [
          Validators.required, // Password is required
          Validators.minLength(6), // Minimum 6 characters
        ],
      ),
      'confirmPassword': FormControl<String>(
        validators: [Validators.required], // Confirmation is required
      ),
    }, validators: [
      // Cross-field validation: passwords must match
      Validators.mustMatch('password', 'confirmPassword')
    ]);

    // Step 2: Personal information (required)
    step2Form = FormGroup({
      'firstName': FormControl<String>(
        validators: [
          Validators.required, // First name is required
          Validators.minLength(2), // Minimum 2 characters
        ],
      ),
      'lastName': FormControl<String>(
        validators: [
          Validators.required, // Last name is required
          Validators.minLength(2), // Minimum 2 characters
        ],
      ),
      'middleName': FormControl<String>(), // Optional field
    });

    // Step 3: Personal information (required)
    step3Form = FormGroup({
      'cpf': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(r'^\d{3}\.\d{3}\.\d{3}-\d{2}$'), // CPF with formatting
        ],
      ),
      'phone': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(r'^\+55 \(\d{2}\) \d{5}-\d{4}$|^\+1 \(\d{3}\) \d{3}-\d{4}$'), // Brazil or US format
        ],
      ),
      'birthdate': FormControl<String>(
        validators: [
          Validators.required,
          Validators.pattern(r'^\d{2}/\d{2}/\d{4}$'), // Date with formatting
        ],
      ),
    });
  }

  /// Setup intelligent phone formatting that detects country codes
  void _setupIntelligentPhoneFormatting() {
    step3Form.control('phone').valueChanges.listen((value) {
      if (value != null && value.isNotEmpty) {
        final formatted = _formatPhoneIntelligently(value);
        if (formatted != value) {
          // Use a slight delay to avoid infinite loop
          Future.microtask(() {
            step3Form.control('phone').updateValue(formatted);
          });
        }
      }
    });
  }

  /// Format phone number based on detected country code
  String _formatPhoneIntelligently(String input) {
    // Remove all non-digits except +
    String cleaned = input.replaceAll(RegExp(r'[^\d+]'), '');

    // Don't auto-add + if user is still typing numbers
    if (cleaned.isEmpty) return input;

    // Only format if we have enough digits
    if (cleaned.startsWith('+55') && cleaned.length >= 5) {
      // Brazil format: +55 (11) 99999-9999
      final digits = cleaned.substring(3);
      if (digits.length >= 2) {
        String formatted = '+55 (${digits.substring(0, 2)})';
        if (digits.length > 2) {
          final remaining = digits.substring(2);
          if (remaining.length <= 5) {
            formatted += ' $remaining';
          } else {
            formatted += ' ${remaining.substring(0, 5)}-${remaining.substring(5, remaining.length > 9 ? 9 : remaining.length)}';
          }
        }
        return formatted;
      }
    } else if (cleaned.startsWith('+1') && cleaned.length >= 4) {
      // US format: +1 (555) 123-4567
      final digits = cleaned.substring(2);
      if (digits.length >= 3) {
        String formatted = '+1 (${digits.substring(0, 3)})';
        if (digits.length > 3) {
          final remaining = digits.substring(3);
          if (remaining.length <= 3) {
            formatted += ' $remaining';
          } else {
            formatted += ' ${remaining.substring(0, 3)}-${remaining.substring(3, remaining.length > 7 ? 7 : remaining.length)}';
          }
        }
        return formatted;
      }
    }

    // Return cleaned version for partial inputs
    return cleaned.startsWith('+') ? cleaned : '+$cleaned';
  }

  /// Update the reactive canProceed state based on current step validation
  void _updateCanProceed() {
    final newValue = canProceed;
    canProceedReactive.value = newValue;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UI LOGIC METHODS
  // These methods control the visual state and behavior of the signup UI
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Whether to show the progress indicator (hidden on first step and final step)
  bool shouldShowProgressIndicator() => currentStep.value > 0 && currentStep.value != 5;

  /// Get the appropriate button text based on current step
  String getButtonText() {
    return currentStep.value == totalSteps - 1
        ? FinTexts.signupFinalizeButton
        : FinTexts.signupContinueButton;
  }

  /// Get button color based on validation state and loading status
  Color getButtonColor() {
    if (canProceedReactive.value && !isLoading.value) {
      return const Color(0xFF1B6FFF); // Full blue when enabled
    }
    return const Color(0xFF1B6FFF).withValues(alpha: 0.4); // 40% opacity when disabled
  }

  /// Get button action callback - null when disabled, nextStep when enabled
  VoidCallback? getButtonAction() {
    if (isLoading.value || !canProceedReactive.value) return null;
    return nextStep;
  }

  /// Handle back navigation - either go to previous step or exit signup
  void handleBackNavigation(BuildContext context) {
    if (currentStep.value > 0) {
      previousStep();
    } else {
      Navigator.pop(context);
    }
  }

  /// Select verification method (Email or SMS)
  void selectVerificationMethod(VerificationMethod method) {
    selectedVerificationMethod.value = method;
  }

  /// Check if verification can be sent
  bool canSendVerification() {
    return !isLoading.value;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // BUSINESS LOGIC METHODS
  // These methods handle the core functionality of the signup process
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Toggle password visibility for password field
  void togglePassword() => hidePassword.toggle();

  /// Toggle password visibility for confirm password field
  void toggleConfirmPassword() => hideConfirmPassword.toggle();

  /// Proceed to next step or complete signup if on final step
  Future<void> nextStep() async {
    /// Check if user email exists on step 1
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

    /// Check if CPF exists on step 3 (before moving to step 4)
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

    /// Validate current step and proceed
    if (currentStep.value < totalSteps - 1) {
      if (_validateCurrentStep()) {
        currentStep.value++;
        _animateToPage(currentStep.value);
      }
    } else {
      signUp();
    }
  }

  /// Go back to previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      _animateToPage(currentStep.value);
    }
  }

  /// Start countdown timer for resend code
  void startResendTimer() {
    resendTimer.value = 300; // 5 minutes
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

  /// Format timer display (4:59 format)
  String get formattedTimer {
    int minutes = resendTimer.value ~/ 60;
    int seconds = resendTimer.value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Validate verification code input
  void onCodeChanged(String code) {
    verificationCode.value = code;
  }

  /// Verify the OTP code using selected method
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
        // SUCCESS: Verification completed
        print('${selectedVerificationMethod.value.name} verification successful!');

        // Create user profile in custom users table
        final userData = _buildUserData();

        try {
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

          // Clear signup flag
          Get.find<SessionManager>().isInSignupFlow.value = false;

          // SUCCESS: Navigate to home
          Get.offAllNamed(AppRoutes.home);

          // Show success message
          Get.snackbar(
            FinTexts.dialogSuccessTitle,
            selectedVerificationMethod.value == VerificationMethod.email
                ? 'Email verificado com sucesso!'
                : 'SMS verificado com sucesso!',
            backgroundColor: FinColors.success,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );

        } catch (profileError) {
          print('Error creating user profile: $profileError');
          await AppDialogs.showError(
            title: FinTexts.signupErrorTitle,
            message: FinTexts.signupErrorProfileCreation,
          );
        }
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

  /// Resend verification code based on selected method
  Future<void> resendVerification() async {
    try {
      isLoading.value = true;

      if (selectedVerificationMethod.value == VerificationMethod.email) {
        final email = step1Form.control('email').value;
        await EmailService.resendSignupVerification(email);
      } else if (selectedVerificationMethod.value == VerificationMethod.sms) {
        final phoneNumber = step3Form.control('phone').value;
        final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
        await _auth.resendSmsOTP(cleanPhoneNumber);
      }

      // Restart timer
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

  /// Resend OTP code (for backward compatibility)
  Future<void> resendCode() async {
    await resendVerification();
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // PRIVATE HELPER METHODS
  // Internal methods for navigation, validation, and animation
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Animate to specific page with smooth transition
  void _animateToPage(int page) {
    pageController.animateToPage(
      page,
      duration: pageTransitionDuration,
      curve: transitionCurve,
    );
  }

  /// Validate current step using reactive forms
  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        step1Form.markAllAsTouched(); // Show validation errors
        return step1Form.valid;
      case 1:
        step2Form.markAllAsTouched(); // Show validation errors
        return step2Form.valid;
      case 2:
        step3Form.markAllAsTouched(); // Show validation errors
        return step3Form.valid;
      case 3:
        return selectedVerificationMethod.value != null;
      case 4:
        return verificationCode.value.length == 6;
      default:
        return true;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // COMPUTED PROPERTIES
  // Dynamic properties that compute values based on current state
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Check if user can proceed to next step based on current step validation
  bool get canProceed {
    switch (currentStep.value) {
      case 0:
        return step1Form.valid;
      case 1:
        return step2Form.controls['firstName']!.valid && step2Form.controls['lastName']!.valid;
      case 2:
        return step3Form.valid;
      case 3:
        return selectedVerificationMethod.value != null;
      case 4:
        return verificationCode.value.length == 6; // 6-digit code required
      default:
        return false;
    }
  }

  /// Get the progress level for the progress indicator
  /// Steps 1 and 2 are both considered "personal info" so same progress level
  int get progressLevel {
    switch (currentStep.value) {
      case 0:
        return 0; // Email/password step
      case 1:
      case 2:
        return 1; // Personal info steps
      case 3:
        return 2; // Verification method
      case 4:
        return 3; // Code verification
      default:
        return 0;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION LOGIC
  // Methods for user registration and account creation
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Attempt to sign up user with provided information
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
        // SMS signup flow
        final phoneNumber = step3Form.control('phone').value;
        final password = step1Form.control('password').value;
        final cleanPhoneNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
        print("phone_number:" + cleanPhoneNumber);

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

  /// Build user data object from form inputs
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
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
          userData['birthdate'] = date.toIso8601String();
        }
      } catch (e) {
        print('Invalid date format: $birthdate');
      }
    }

    return userData;
  }

  /// Handle successful signup response
  void _handleSignUpResponse(response) {
    print('=== HANDLE SIGNUP RESPONSE ===');
    print('User exists: ${response.user != null}');
    print('User email: ${response.user?.email}');
    print('Email confirmed at: ${response.user?.emailConfirmedAt}');
    print('Session exists: ${response.session != null}');

    if (response.user != null) {
      // Always go to step 5 for OTP verification, regardless of session
      print('Going to step 5 for OTP verification');
      currentStep.value = 4; // Step 5 (index 4)
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
  // CLEANUP AND DISPOSAL
  // Proper resource cleanup when controller is destroyed
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  void onClose() {
    // Clear signup flag
    Get.find<SessionManager>().isInSignupFlow.value = false;

    // Dispose page controller
    pageController.dispose();

    super.onClose();
  }
}

enum VerificationMethod {
  email,
  sms,
}