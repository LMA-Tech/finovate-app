import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';

class SignupController extends GetxController with GetSingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final PageController pageController = PageController();

  // Form keys for each step
  final step1FormKey = GlobalKey<FormState>();
  final step2FormKey = GlobalKey<FormState>();
  final step3FormKey = GlobalKey<FormState>();

  // Text Controllers for all fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final cpfController = TextEditingController();
  final birthdateController = TextEditingController();
  final phoneController = TextEditingController();

  // Observable states
  final RxInt currentStep = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool hidePassword = true.obs;
  final RxBool hideConfirmPassword = true.obs;
  final RxBool acceptTerms = false.obs;
  final RxBool saveInfo = false.obs;
  final Rx<DateTime?> selectedBirthdate = Rx<DateTime?>(null);

  // Add reactive variable to track if we can proceed (make it public for debugging)
  final RxBool canProceedReactive = false.obs;

  // Animation controller for shake effect
  AnimationController? shakeController;
  Animation<double>? shakeAnimation;

  // Constants
  static const int totalSteps = 4;
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Curve transitionCurve = Curves.easeInOut;

  @override
  void onInit() {
    super.onInit();

    // Initialize shake animation controller
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

    // Add listeners to text controllers to trigger reactivity
    emailController.addListener(_updateCanProceed);
    passwordController.addListener(_updateCanProceed);
    confirmPasswordController.addListener(_updateCanProceed);
    firstNameController.addListener(_updateCanProceed);
    lastNameController.addListener(_updateCanProceed);

    // Also listen to currentStep changes
    ever(currentStep, (_) => _updateCanProceed());
    ever(acceptTerms, (_) => _updateCanProceed());

    // Initialize the reactive state
    _updateCanProceed();
  }

  // Method to update the reactive state
  void _updateCanProceed() {
    final newValue = canProceed;
    print('DEBUG: _updateCanProceed called, canProceed: $newValue, currentStep: ${currentStep.value}');
    print('DEBUG: email: "${emailController.text}", password: "${passwordController.text}", confirm: "${confirmPasswordController.text}"');
    print('DEBUG: email empty: ${emailController.text.isEmpty}, password empty: ${passwordController.text.isEmpty}, confirm empty: ${confirmPasswordController.text.isEmpty}');
    print('DEBUG: passwords match: ${passwordController.text == confirmPasswordController.text}');
    canProceedReactive.value = newValue;
    print('DEBUG: canProceedReactive set to: ${canProceedReactive.value}');
  }

  // Test method to manually check state
  void debugCheckState() {
    print('=== DEBUG CHECK STATE ===');
    print('currentStep: ${currentStep.value}');
    print('email: "${emailController.text}" (empty: ${emailController.text.isEmpty})');
    print('password: "${passwordController.text}" (empty: ${passwordController.text.isEmpty})');
    print('confirm: "${confirmPasswordController.text}" (empty: ${confirmPasswordController.text.isEmpty})');
    print('passwords match: ${passwordController.text == confirmPasswordController.text}');
    print('canProceed getter: ${canProceed}');
    print('canProceedReactive: ${canProceedReactive.value}');
    print('========================');
  }

  // UI Logic Methods
  bool shouldShowProgressIndicator() => currentStep.value > 0;

  String getButtonText() {
    return currentStep.value == totalSteps - 1 ? 'Finalizar Cadastro' : 'Continuar';
  }

  Color getButtonColor() {
    print('DEBUG: getButtonColor called, canProceedReactive: ${canProceedReactive.value}, isLoading: ${isLoading.value}');
    if (canProceedReactive.value && !isLoading.value) {
      return const Color(0xFF1B6FFF); // Full blue
    }
    return const Color(0xFF1B6FFF).withOpacity(0.4); // 40% opacity
  }

  VoidCallback? getButtonAction() {
    if (isLoading.value || !canProceedReactive.value) return null;
    return nextStep;
  }

  void handleBackNavigation(BuildContext context) {
    if (currentStep.value > 0) {
      previousStep();
    } else {
      Navigator.pop(context);
    }
  }

  void updateCurrentStep(int index) => currentStep.value = index;

  // Handle page changes (validates when swiping forward)
  void handlePageChange(int newIndex) {
    print('DEBUG: handlePageChange called - from: ${currentStep.value} to: $newIndex');

    // If trying to go forward, validate current step
    if (newIndex > currentStep.value) {
      print('DEBUG: Trying to go forward, validating step ${currentStep.value}');

      if (!_validateCurrentStep()) {
        print('DEBUG: Validation failed, triggering shake animation');

        // Trigger shake animation
        _triggerShakeAndShowError();

        // Force return to current step without animation
        pageController.jumpToPage(currentStep.value);
        return;
      }
    }

    // Update current step if validation passed or going backward
    print('DEBUG: Navigation allowed, updating currentStep to: $newIndex');
    currentStep.value = newIndex;
  }

  // Trigger shake animation and show error
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

  // Get appropriate validation message for current step
  String _getValidationMessage() {
    switch (currentStep.value) {
      case 0:
        if (emailController.text.isEmpty) return 'Por favor, digite seu email';
        if (passwordController.text.isEmpty) return 'Por favor, digite sua senha';
        if (confirmPasswordController.text.isEmpty) return 'Por favor, confirme sua senha';
        if (passwordController.text != confirmPasswordController.text) return 'As senhas não coincidem';
        if (!GetUtils.isEmail(emailController.text)) return 'Por favor, digite um email válido';
        if (passwordController.text.length < 6) return 'A senha deve ter pelo menos 6 caracteres';
        return 'Por favor, preencha todos os campos obrigatórios';
      case 1:
        if (firstNameController.text.isEmpty) return 'Por favor, digite seu primeiro nome';
        if (lastNameController.text.isEmpty) return 'Por favor, digite seu sobrenome';
        if (firstNameController.text.length < 2) return 'O nome deve ter pelo menos 2 caracteres';
        if (lastNameController.text.length < 2) return 'O sobrenome deve ter pelo menos 2 caracteres';
        return 'Por favor, preencha todos os campos obrigatórios';
      case 2:
        return 'Por favor, verifique as informações inseridas';
      case 3:
        return 'Por favor, aceite os termos e condições';
      default:
        return 'Por favor, complete este passo antes de continuar';
    }
  }

  // Business Logic Methods
  void togglePassword() => hidePassword.toggle();
  void toggleConfirmPassword() => hideConfirmPassword.toggle();
  void toggleTerms(bool? value) => acceptTerms.value = value ?? false;
  void toggleSaveInfo(bool? value) => saveInfo.value = value ?? false;

  void nextStep() {
    print('DEBUG: nextStep() called - currentStep: ${currentStep.value}, totalSteps: $totalSteps');

    if (currentStep.value < totalSteps - 1) {
      print('DEBUG: Not last step, checking validation...');
      if (_validateCurrentStep()) {
        print('DEBUG: Validation passed, moving to next step');
        currentStep.value++;
        print('DEBUG: currentStep updated to: ${currentStep.value}');
        _animateToPage(currentStep.value);
      } else {
        print('DEBUG: Validation failed!');
      }
    } else {
      print('DEBUG: Last step, calling signUp()');
      signUp();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      _animateToPage(currentStep.value);
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step < totalSteps) {
      currentStep.value = step;
      _animateToPage(step);
    }
  }

  Future<void> selectBirthdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)),
    );

    if (picked != null) {
      selectedBirthdate.value = picked;
      birthdateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  // Private Helper Methods
  void _animateToPage(int page) {
    print('DEBUG: _animateToPage called with page: $page');
    pageController.animateToPage(
      page,
      duration: pageTransitionDuration,
      curve: transitionCurve,
    );
    print('DEBUG: Page animation initiated');
  }

  bool _validateCurrentStep() {
    print('DEBUG: _validateCurrentStep() called for step: ${currentStep.value}');

    switch (currentStep.value) {
      case 0:
        final isValid = step1FormKey.currentState?.validate() ?? false;
        print('DEBUG: Step 0 validation result: $isValid');
        return isValid;
      case 1:
        final isValid = step2FormKey.currentState?.validate() ?? false;
        print('DEBUG: Step 1 validation result: $isValid');
        return isValid;
      case 2:
        final isValid = step3FormKey.currentState?.validate() ?? false;
        print('DEBUG: Step 2 validation result: $isValid');
        return isValid;
      case 3:
        final isValid = acceptTerms.value;
        print('DEBUG: Step 3 validation result: $isValid');
        return isValid;
      default:
        print('DEBUG: Unknown step, returning true');
        return true;
    }
  }

  // Computed Properties
  bool get canProceed {
    switch (currentStep.value) {
      case 0:
        final emailFilled = emailController.text.isNotEmpty;
        final passwordFilled = passwordController.text.isNotEmpty;
        final confirmPasswordFilled = confirmPasswordController.text.isNotEmpty;
        final passwordsMatch = passwordController.text == confirmPasswordController.text;

        print('DEBUG: Step 0 - email: $emailFilled, password: $passwordFilled, confirm: $confirmPasswordFilled, match: $passwordsMatch');

        return emailFilled && passwordFilled && confirmPasswordFilled && passwordsMatch;
      case 1:
        return firstNameController.text.isNotEmpty &&
            lastNameController.text.isNotEmpty;
      case 2:
        return true; // Optional fields
      case 3:
        return acceptTerms.value;
      default:
        return false;
    }
  }

  double get stepProgress => (currentStep.value + 1) / totalSteps;

  // Validation Methods
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Digite um email válido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != passwordController.text) {
      return 'Senhas não coincidem';
    }
    return null;
  }

  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Primeiro nome é obrigatório';
    }
    if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Sobrenome é obrigatório';
    }
    if (value.length < 2) {
      return 'Sobrenome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  String? validateCPF(String? value) {
    if (value != null && value.isNotEmpty) {
      String cleanCPF = value.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanCPF.length != 11) {
        return 'CPF deve ter 11 dígitos';
      }
      if (!_isValidCPF(cleanCPF)) {
        return 'Digite um CPF válido';
      }
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      String cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanPhone.length < 10 || cleanPhone.length > 11) {
        return 'Digite um número válido (10-11 dígitos)';
      }
    }
    return null;
  }

  // Authentication Logic
  Future<void> signUp() async {
    if (!acceptTerms.value) {
      Get.snackbar('Erro', 'Aceite os termos e condições para continuar');
      return;
    }

    try {
      isLoading.value = true;
      final userData = _buildUserData();

      final response = await _auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        userData: userData,
      );

      _handleSignUpResponse(response);
    } catch (e) {
      _showSignUpError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Private Authentication Helpers
  Map<String, dynamic> _buildUserData() {
    final userData = <String, dynamic>{
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
    };

    if (middleNameController.text.isNotEmpty) {
      userData['middle_name'] = middleNameController.text.trim();
    }
    if (phoneController.text.isNotEmpty) {
      userData['phone_number'] = phoneController.text.trim();
    }
    if (cpfController.text.isNotEmpty) {
      userData['cpf'] = cpfController.text.replaceAll(RegExp(r'[^\d]'), '');
    }
    if (selectedBirthdate.value != null) {
      userData['birthdate'] = selectedBirthdate.value!.toIso8601String();
    }

    return userData;
  }

  void _handleSignUpResponse(response) {
    if (response.user != null) {
      if (response.user!.emailConfirmedAt == null) {
        _showEmailVerificationDialog();
      } else {
        Get.snackbar(
          'Sucesso',
          'Conta criada com sucesso!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    }
  }

  void _showSignUpError(String error) {
    Get.snackbar(
      'Erro no Cadastro',
      error,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  }

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
              'Enviamos um email de verificação para ${emailController.text}. Verifique sua caixa de entrada e clique no link de verificação.',
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

  bool _isValidCPF(String cpf) {
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    // Dispose animation controller
    shakeController?.dispose();

    // Remove listeners before disposing
    emailController.removeListener(_updateCanProceed);
    passwordController.removeListener(_updateCanProceed);
    confirmPasswordController.removeListener(_updateCanProceed);
    firstNameController.removeListener(_updateCanProceed);
    lastNameController.removeListener(_updateCanProceed);

    // Dispose controllers
    pageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    middleNameController.dispose();
    cpfController.dispose();
    birthdateController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}