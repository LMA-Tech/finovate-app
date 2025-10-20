import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../common/dialogs/app_dialogs.dart';
import '../../services/auth_service.dart';
import '../../services/centralized_email_service.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';

/// Controller for managing the multi-step forgot password process
///
/// This controller handles:
/// - Multi-step navigation (4 steps total)
/// - Reactive form validation using reactive_forms package
/// - Password reset flow via Supabase
/// - UI state management for buttons, loading states, etc.
class ForgotPasswordController extends GetxController {
  // Services
  final AuthService _auth = AuthService();

  // Navigation
  final PageController pageController = PageController();

  // Reactive forms for each step
  late FormGroup step1Form; // Email input
  late FormGroup step3Form; // New password and confirm password

  // Reactive state variables for UI updates
  final RxInt currentStep = 0.obs; // Current step index (0-3)
  final RxBool isLoading = false.obs; // Loading state for API calls
  final RxBool hidePassword = true.obs; // Password visibility toggle
  final RxBool hideConfirmPassword = true.obs; // Confirm password visibility toggle
  final RxString resetToken = ''.obs; // Token from reset email
  final RxString userEmail = ''.obs; // Store email from step 1

  // Reactive variable to track if user can proceed to next step
  final RxBool canProceedReactive = false.obs;

  // Reactive variables for step 2 (reset code verification)
  final RxString resetCode = ''.obs; // Reset code from step 2
  final RxInt resendTimer = 300.obs; // 5 minutes
  final RxBool canResendCode = false.obs;

  // Constants
  static const int totalSteps = 4;
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.easeInOut;

  @override
  void onInit() {
    super.onInit();

    // Initialize reactive forms with validation rules
    _initializeReactiveForms();

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
    step3Form.statusChanged.listen((_) => _updateCanProceed());
  }

  /// Initialize reactive forms with validation rules for each step
  void _initializeReactiveForms() {
    // Step 1: Email input
    step1Form = FormGroup({
      'email': FormControl<String>(
        validators: [
          Validators.required, // Email is required
          Validators.email, // Must be valid email format
        ],
      ),
    });

    // Force touch the email field when user types
    step1Form.control('email').valueChanges.listen((value) {
      if (value != null && value.isNotEmpty) {
        step1Form.control('email').markAsTouched();
      }
    });

// Step 3: New password setup
    step3Form = FormGroup({
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

    // Add listeners to mark fields as touched only when user starts typing
    step3Form.control('password').valueChanges.listen((value) {
      if (value != null && value.isNotEmpty) {
        step3Form.control('password').markAsTouched();
      }
    });

    step3Form.control('confirmPassword').valueChanges.listen((value) {
      if (value != null && value.isNotEmpty) {
        step3Form.control('confirmPassword').markAsTouched();
      }
    });
  }

  /// Update the reactive canProceed state based on current step validation
  void _updateCanProceed() {
    final newValue = canProceed;
    canProceedReactive.value = newValue;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UI LOGIC METHODS
  // These methods control the visual state and behavior of the forgot password UI
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Handle back navigation - either go to previous step or exit flow
  void handleBackNavigation(BuildContext context) {
    // Don't allow back navigation from success screen (step 4)
    if (currentStep.value == 3) return;

    if (currentStep.value > 0) {
      previousStep();
    } else {
      Navigator.pop(context);
    }
  }

  /// Get button color based on validation state and loading status
  Color getButtonColor() {
    if (canProceedReactive.value && !isLoading.value) {
      return FinColors.primary; // Full blue when enabled
    }
    return FinColors.primary.withOpacity(0.4); // 40% opacity when disabled
  }

  /// Get button action callback - null when disabled, nextStep when enabled
  VoidCallback? getButtonAction() {
    if (isLoading.value || !canProceedReactive.value) return null;
    return nextStep;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // STEP VALIDATION METHODS
  // Individual validation methods for each step
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Check if user can proceed from step 1 (email validation)
  bool canProceedStep1() {
    return step1Form.valid;
  }

  /// Check if user can proceed from step 3 (password validation)
  bool canProceedStep3() {
    return step3Form.valid;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // BUSINESS LOGIC METHODS
  // These methods handle the core functionality of the forgot password process
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Toggle password visibility for password field
  void togglePassword() => hidePassword.toggle();

  /// Toggle password visibility for confirm password field
  void toggleConfirmPassword() => hideConfirmPassword.toggle();

  /// Handle reset code input changes
  void onCodeChanged(String code) {
    resetCode.value = code;
  }

  /// Verify the reset code with Supabase via AuthService
  Future<void> verifyResetCode() async {
    if (resetCode.value.length != 6) return;

    try {
      isLoading.value = true;

      final email = userEmail.value;

      // Use your existing AuthService verifyOTP method (or new verifyResetOTP)
      final response = await _auth.verifyResetOTP(
        email: email,
        token: resetCode.value,
      );

      if (response.user != null) {
        // Success: Code is valid, proceed to next step (new password)
        nextStep();
      }

    } catch (e) {
      // Error is already logged in AuthService and user gets graceful message
      // Clearing the code so user can try again
      resetCode.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  /// Start countdown timer for resend code
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

  /// Proceed to next step or complete process if on final step
  Future<void> nextStep() async {
    if (currentStep.value < totalSteps - 1) {
      if (_validateCurrentStep()) {
        // Handle step-specific logic
        await _handleStepTransition();

        currentStep.value++;
        _animateToPage(currentStep.value);
      }
    } else {
      // Final step - return to login
      Get.offAllNamed('/login');
    }
  }

  /// Go back to previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      _animateToPage(currentStep.value);
    }
  }

  /// Handle step-specific logic before transitioning
  Future<void> _handleStepTransition() async {
    switch (currentStep.value) {
      case 0:
      // Step 1 -> Step 2: Send reset email
        await _sendResetEmail();
        break;
      case 1:
      // Step 2 -> Step 3: Token validation (if implementing in-app)
      // For now, just proceed
        break;
      case 2:
      // Step 3 -> Step 4: Set new password
        await _setNewPassword();
        break;
    }
  }

  /// Send password reset email
  Future<void> _sendResetEmail() async {
    isLoading.value = true;

    final email = step1Form.control('email').value;
    userEmail.value = email;

    final success = await EmailService.sendPasswordReset(email);

    if (success) {
      startResendTimer(); // Only start timer on success
    }

    isLoading.value = false;

    // Don't throw error - service handles user feedback
    if (!success) return; // Don't proceed to next step
  }

  /// Resend reset code
  Future<void> resendResetCode() async {
    final email = userEmail.value;
    await EmailService.resendPasswordReset(email);
    // Service handles all feedback
  }

  /// Set new password using AuthService
  Future<void> _setNewPassword() async {
    try {
      isLoading.value = true;
      final newPassword = step3Form.control('password').value;

      // Update password via AuthService
      await _auth.updatePassword(newPassword);

      if (kDebugMode) {
        debugPrint('✅ Password updated successfully');
      }

    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Password update failed: $e');
      }

      // Show error and don't proceed to next step
      await AppDialogs.showError(
        title: FinTexts.error,
        message: FinTexts.passwordResetErrorUpdate,
      );


      // Re-throw to prevent navigation to success screen
      rethrow;
    } finally {
      isLoading.value = false;
    }
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

// Update the _validateCurrentStep method:
  bool _validateCurrentStep() {
    switch (currentStep.value) {
      case 0:
        step1Form.markAllAsTouched(); // Show validation errors
        return step1Form.valid;
      case 1:
      // Step 2 validation for 6-digit code
        return resetCode.value.length == 6;
      case 2:
        step3Form.markAllAsTouched(); // Show validation errors
        return step3Form.valid;
      case 3:
      // Step 4 has no validation (success screen)
        return true;
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
        return resetCode.value.length == 6; // Step 2: code validation
      case 2:
        return step3Form.valid; // Step 3: password validation
      case 3:
        return true; // Step 4: success screen, always can proceed
      default:
        return false;
    }
  }

  /// Format timer display (4:59 format)
  String get formattedTimer {
    int minutes = resendTimer.value ~/ 60;
    int seconds = resendTimer.value % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Get masked email for display (ex***@gmail.com)
  String getMaskedEmail() {
    final email = userEmail.value;
    if (email.isEmpty) return '';

    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 3) {
      return '${username[0]}***@$domain';
    }

    return '${username.substring(0, 2)}***@$domain';
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // CLEANUP AND DISPOSAL
  // Proper resource cleanup when controller is destroyed
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  void onClose() {
    // Dispose page controller
    pageController.dispose();
    super.onClose();
  }
}