import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';

class SignupController extends GetxController {
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();

  // Text Controllers for all fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final middleNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cpfController = TextEditingController();
  final birthdateController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool hidePassword = true.obs;
  final RxBool acceptTerms = false.obs;
  final Rx<DateTime?> selectedBirthdate = Rx<DateTime?>(null);

  // Validation methods
  String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'First name is required';
    }
    if (value.length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Last name is required';
    }
    if (value.length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePhone(String? value) {
    // Phone is optional, but if provided should be valid
    if (value != null && value.isNotEmpty) {
      // Remove formatting characters
      String cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanPhone.length < 10 || cleanPhone.length > 11) {
        return 'Please enter a valid phone number (10-11 digits)';
      }
    }
    return null;
  }

  String? validateCPF(String? value) {
    // CPF is optional, but if provided should be valid format
    if (value != null && value.isNotEmpty) {
      // Remove formatting characters
      String cleanCPF = value.replaceAll(RegExp(r'[^\d]'), '');
      if (cleanCPF.length != 11) {
        return 'CPF must have 11 digits';
      }
      // You can add more sophisticated CPF validation here
      if (!_isValidCPF(cleanCPF)) {
        return 'Please enter a valid CPF';
      }
    }
    return null;
  }

  String? validateBirthdate(String? value) {
    // Birthdate is optional, but if provided should be reasonable
    if (value != null && value.isNotEmpty && selectedBirthdate.value != null) {
      final now = DateTime.now();
      final birthdate = selectedBirthdate.value!;
      final age = now.year - birthdate.year;

      if (age < 13) {
        return 'Must be at least 13 years old';
      }
      if (age > 120) {
        return 'Please enter a valid birthdate';
      }
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Toggle methods
  void togglePassword() => hidePassword.toggle();
  void toggleTerms(bool? value) => acceptTerms.value = value ?? false;

  // Date picker
  Future<void> selectBirthdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 25)), // 25 years ago
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)), // 100 years ago
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 13)), // 13 years ago
    );

    if (picked != null) {
      selectedBirthdate.value = picked;
      birthdateController.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  // Main signup function
  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    if (!acceptTerms.value) {
      Get.snackbar('Error', 'Please accept the terms and conditions');
      return;
    }

    try {
      isLoading.value = true;

      // Prepare user data
      final userData = <String, dynamic>{
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
      };

      // Add optional fields if they have values
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

      final response = await _auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text,
        userData: userData,
      );

      if (response.user != null) {
        if (response.user!.emailConfirmedAt == null) {
          // Show email verification dialog
          _showEmailVerificationDialog();
        } else {
          // Direct login - SessionManager will handle navigation
          Get.snackbar(
            'Success',
            'Account created successfully!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        'Signup Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showEmailVerificationDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Verify Your Email'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.email_outlined, size: 64, color: Colors.blue),
            const SizedBox(height: 16),
            Text(
              'We\'ve sent a verification email to ${emailController.text}. Please check your inbox and click the verification link.',
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
            child: const Text('Go to Login'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  // Simple CPF validation (you can make this more sophisticated)
  bool _isValidCPF(String cpf) {
    // Basic check - all digits the same
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) {
      return false;
    }

    // You can add more sophisticated CPF algorithm validation here
    // This is a simplified version for the MVP
    return true;
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    middleNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cpfController.dispose();
    birthdateController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}