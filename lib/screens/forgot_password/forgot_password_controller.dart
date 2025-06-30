import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import '../../services/auth_service.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/text_strings.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _auth = AuthService();

  late FormGroup forgotPasswordForm;

  final RxBool isLoading = false.obs;
  final RxBool canResetPasswordReactive = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeForm();
    _setupFormListener();
  }

  void _initializeForm() {
    forgotPasswordForm = FormGroup({
      'email': FormControl<String>(
        validators: [
          Validators.required,
          Validators.email,
        ],
        // This makes validation trigger on every change, not just on focus loss
        touched: false,
      ),
    });
  }

  void _setupFormListener() {
// Debug: Log form status changes
    forgotPasswordForm.statusChanged.listen((status) {
      print('Form status changed: $status');
      print('Form valid: ${forgotPasswordForm.valid}');
      print('Email control value: ${forgotPasswordForm.control('email').value}');
      print('Email control valid: ${forgotPasswordForm.control('email').valid}');
      print('Email control errors: ${forgotPasswordForm.control('email').errors}');

      canResetPasswordReactive.value = forgotPasswordForm.valid;
    });

    // Also listen to email field specifically
    forgotPasswordForm.control('email').valueChanges.listen((value) {
      print('Email value changed: $value');
    });
  }

  Future<void> sendResetCode() async {
    if (!forgotPasswordForm.valid) {
      forgotPasswordForm.markAllAsTouched();
      return;
    }

    try {
      isLoading.value = true;
      final email = forgotPasswordForm.control('email').value;

      await _auth.resetPassword(email);

      // Navigate to check email screen
      // Get.toNamed('/checkEmail', arguments: {'email': email});

      Get.snackbar(
        'Email Enviado',
        'Código de redefinição enviado para seu email',
        backgroundColor: FinColors.success,
        colorText: FinColors.white,
      );
    } catch (e) {
      Get.snackbar(
        FinTexts.error,
        e.toString(),
        backgroundColor: FinColors.error,
        colorText: FinColors.white,
        duration: const Duration(seconds: 4),
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