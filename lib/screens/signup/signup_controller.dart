import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../services/auth_service.dart';
import '../../utils/constants/text_strings.dart';

/// Controller for managing the multi-step signup process
///
/// This controller handles:
/// - Multi-step form navigation (4 steps total)
/// - Reactive form validation using reactive_forms package
/// - Real-time validation feedback
/// - User authentication via AuthService
/// - UI state management for buttons, loading states, etc.
class SignupController extends GetxController with GetSingleTickerProviderStateMixin {
  // Services
  final AuthService _auth = AuthService();

  // Navigation
  final PageController pageController = PageController();

  // Reactive forms for each signup step
  // These handle validation automatically and provide real-time feedback
  late FormGroup step1Form;  // Email, password, confirm password
  late FormGroup step2Form;  // First name, last name, middle name
  late FormGroup step3Form;  // CPF, phone, birthdate (all optional)

  // Reactive state variables for UI updates
  final RxInt currentStep = 0.obs;                    // Current step index (0-3)
  final RxBool isLoading = false.obs;                 // Loading state for signup process
  final RxBool hidePassword = true.obs;               // Password visibility toggle
  final RxBool hideConfirmPassword = true.obs;        // Confirm password visibility toggle
  final RxBool acceptTerms = false.obs;               // Terms and conditions acceptance
  final Rx<DateTime?> selectedBirthdate = Rx<DateTime?>(null);  // Selected birthdate
  final Rx<VerificationMethod> selectedVerificationMethod = VerificationMethod.email.obs; // Verification Method

  // Reactive variable to track if user can proceed to next step
  final RxBool canProceedReactive = false.obs;

  // Animation controller for shake effect on validation errors
  AnimationController? shakeController;
  Animation<double>? shakeAnimation;

  // Constants
  static const int totalSteps = 4;
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.easeInOut;

  @override
  void onInit() {
    super.onInit();

    // Initialize reactive forms with validation rules
    _initializeReactiveForms();

    // Initialize shake animation for validation error feedback
    _initializeShakeAnimation();

    // Set up listeners for real-time validation updates
    _setupValidationListeners();

    // Initialize reactive state
    _updateCanProceed();
  }

  /// Initialize shake animation controller for validation error feedback
  void _initializeShakeAnimation() {
    shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    shakeAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: shakeController!,
      curve: Curves.elasticIn,
    ));
  }

  /// Set up listeners for real-time validation state updates
  void _setupValidationListeners() {
    // Listen to step and terms changes
    ever(currentStep, (_) => _updateCanProceed());
    ever(acceptTerms, (_) => _updateCanProceed());

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
          Validators.required,  // Email is required
          Validators.email,     // Must be valid email format
        ],
      ),
      'password': FormControl<String>(
        validators: [
          Validators.required,        // Password is required
          Validators.minLength(6),    // Minimum 6 characters
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
          Validators.required,        // First name is required
          Validators.minLength(2),    // Minimum 2 characters
        ],
      ),
      'lastName': FormControl<String>(
        validators: [
          Validators.required,        // Last name is required
          Validators.minLength(2),    // Minimum 2 characters
        ],
      ),
      'middleName': FormControl<String>(), // Optional field
    });

    // Step 3: Personal information (required)
    step3Form = FormGroup({
      'cpf': FormControl<String>(
        validators: [
          Validators.required,           // ADD THIS
          Validators.pattern(r'^\d{11}$'),
        ],
      ),
      'phone': FormControl<String>(
        validators: [
          Validators.required,           // ADD THIS
          Validators.pattern(r'^\d{10,11}$'),
        ],
      ),
      'birthdate': FormControl<DateTime>(
        validators: [Validators.required],  // ADD THIS
      ),
    });
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

  /// Whether to show the progress indicator (hidden on first step)
  bool shouldShowProgressIndicator() => currentStep.value > 0;

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
    return const Color(0xFF1B6FFF).withOpacity(0.4); // 40% opacity when disabled
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

  /// Update current step index (used by UI components)
  void updateCurrentStep(int index) => currentStep.value = index;

  /// Handle page changes (validates when swiping forward)
  void handlePageChange(int newIndex) {
    // If trying to go forward, validate current step
    if (newIndex > currentStep.value) {
      if (!_validateCurrentStep()) {
        // Trigger shake animation
        _triggerShakeAndShowError();
        // Force return to current step without animation
        pageController.jumpToPage(currentStep.value);
        return;
      }
    }

    // Update current step if validation passed or going backward
    currentStep.value = newIndex;
  }

  /// Trigger shake animation and show error
  void _triggerShakeAndShowError() {
    // Reset and start shake animation
    shakeController?.reset();
    shakeController?.forward();

    // Show error message as a brief overlay
    Get.rawSnackbar(
      message: _getValidationMessage(),
      backgroundColor: Colors.red.withOpacity(0.9),
      borderRadius: 8,
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      duration: const Duration(seconds: 2),
      animationDuration: const Duration(milliseconds: 300),
      snackPosition: SnackPosition.TOP,
      shouldIconPulse: false,
      icon: const Icon(Icons.error_outline, color: Colors.white, size: 20),
    );
  }

  /// Get appropriate validation error message for current step
  String _getValidationMessage() {
    switch (currentStep.value) {
      case 0:
        if (!step1Form.control('email').valid) return FinTexts.signupValidationEmailRequired;
        if (!step1Form.control('password').valid) return FinTexts.signupValidationPasswordRequired;
        if (!step1Form.control('confirmPassword').valid) return FinTexts.signupValidationConfirmPasswordRequired;
        return 'Por favor, preencha todos os campos obrigatórios';
      case 1:
        if (!step2Form.control('firstName').valid) return FinTexts.signupValidationFirstNameRequired;
        if (!step2Form.control('lastName').valid) return FinTexts.signupValidationLastNameRequired;
        return 'Por favor, preencha todos os campos obrigatórios';
      case 2:
        return 'Por favor, verifique as informações inseridas';
      case 3:
        return 'Por favor, aceite os termos e condições';
      default:
        return 'Por favor, complete este passo antes de continuar';
    }
  }

  /// Select verification method (Email or SMS)
  void selectVerificationMethod(VerificationMethod method) {
    if (method == VerificationMethod.email) {
      selectedVerificationMethod.value = method;
    }
    // SMS is disabled, so no action for SMS selection
  }

  /// Check if verification can be sent
  bool canSendVerification() {
    return selectedVerificationMethod.value == VerificationMethod.email && !isLoading.value;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // BUSINESS LOGIC METHODS
  // These methods handle the core functionality of the signup process
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Toggle password visibility for password field
  void togglePassword() => hidePassword.toggle();

  /// Toggle password visibility for confirm password field
  void toggleConfirmPassword() => hideConfirmPassword.toggle();

  /// Toggle terms and conditions acceptance
  void toggleTerms(bool? value) => acceptTerms.value = value ?? false;

  /// Proceed to next step or complete signup if on final step
  void nextStep() {
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

  /// Jump directly to a specific step (used by progress indicator)
  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      currentStep.value = step;
      _animateToPage(step);
    }
  }

  /// Show date picker and handle birthdate selection
  Future<void> selectBirthdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
    );

    if (picked != null) {
      selectedBirthdate.value = picked;
      step3Form.control('birthdate').value = picked; // This should be the primary way
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
        return acceptTerms.value;
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
        return step2Form.controls['firstName']!.valid &&
            step2Form.controls['lastName']!.valid;
      case 2:
        return step3Form.valid;
      case 3:
        return selectedVerificationMethod.value == VerificationMethod.email; // CHANGE THIS LINE
      default:
        return false;
    }
  }

  /// Calculate progress percentage for progress indicator
  double get stepProgress => (currentStep.value + 1) / totalSteps;

  /// Get the progress level for the progress indicator
  /// Steps 1 and 2 are both considered "personal info" so same progress level
  int get progressLevel {
    switch (currentStep.value) {
      case 0: return 0;  // Email/password step
      case 1:
      case 2: return 1;  // Personal info steps (both name and additional info)
      case 3: return 2;  // Terms step
      default: return 0;
    }
  }

  /// Total progress levels (different from total steps)
  static const int totalProgressLevels = 3;


  // ═══════════════════════════════════════════════════════════════════════════════════════
  // AUTHENTICATION LOGIC
  // Methods for user registration and account creation
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Attempt to sign up user with provided information
  Future<void> signUp() async {
    try {
      isLoading.value = true;
      final userData = _buildUserData();

      final response = await _auth.signUp(
        email: step1Form.control('email').value,
        password: step1Form.control('password').value,
        userData: userData,
      );

      _handleSignUpResponse(response);
    } catch (e) {
      _showSignUpError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Build user data object from form inputs
  Map<String, dynamic> _buildUserData() {
    final userData = <String, dynamic>{
      'first_name': step2Form.control('firstName').value,
      'last_name': step2Form.control('lastName').value,
    };

    // Add optional fields if provided
    final middleName = step2Form.control('middleName').value;
    if (middleName != null && middleName.isNotEmpty) {
      userData['middle_name'] = middleName;
    }

    final phone = step3Form.control('phone').value;
    if (phone != null && phone.isNotEmpty) {
      userData['phone_number'] = phone;
    }

    final cpf = step3Form.control('cpf').value;
    if (cpf != null && cpf.isNotEmpty) {
      userData['cpf'] = cpf.replaceAll(RegExp(r'[^\d]'), '');
    }

    final birthdate = step3Form.control('birthdate').value;
    if (birthdate != null) {
      userData['birthdate'] = birthdate.toIso8601String();
    }

    return userData;
  }

  /// Handle successful signup response
  void _handleSignUpResponse(response) {
    if (response.user != null) {
      if (response.user!.emailConfirmedAt == null) {
        _showEmailVerificationDialog();
      } else {
        Get.snackbar(
          FinTexts.signupSuccessTitle,
          FinTexts.signupSuccessMessage,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }

  /// Show signup error message
  void _showSignUpError(String error) {
    Get.snackbar(
      FinTexts.signupErrorTitle,
      error,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

  /// Show email verification dialog
  void _showEmailVerificationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Verifique seu Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.email_outlined, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'Enviamos um email de verificação para ${step1Form.control('email').value}. Verifique sua caixa de entrada e clique no link de verificação.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/login');
            },
            child: const Text('Ir para Login'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // CLEANUP AND DISPOSAL
  // Proper resource cleanup when controller is destroyed
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  void onClose() {
    // Dispose animation controller
    shakeController?.dispose();

    // Dispose page controller
    pageController.dispose();

    super.onClose();
  }
}

enum VerificationMethod {
  email,
  sms,
}