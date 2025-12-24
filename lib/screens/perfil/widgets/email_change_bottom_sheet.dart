import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_text_field.dart';
import '../../../services/app_logger.dart';
import '../../../services/auth_service.dart';
import '../../../services/session_manager.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

/// Bottom sheet for changing email with OTP verification.
///
/// Flow:
/// 1. User enters new email
/// 2. OTP is sent to new email
/// 3. User enters OTP code
/// 4. Email is updated if code is valid
class EmailChangeBottomSheet extends StatefulWidget {
  const EmailChangeBottomSheet({super.key});

  /// Show the bottom sheet and return true if email was changed successfully
  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const EmailChangeBottomSheet(),
    );
  }

  @override
  State<EmailChangeBottomSheet> createState() => _EmailChangeBottomSheetState();
}

class _EmailChangeBottomSheetState extends State<EmailChangeBottomSheet> {
  final _authService = Get.find<AuthService>();
  final _sessionManager = Get.find<SessionManager>();

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _otpSent = false;
  String? _errorMessage;
  String? _newEmail;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo é obrigatório';
    }
    if (!GetUtils.isEmail(value.trim())) {
      return 'E-mail inválido';
    }
    return null;
  }

  String? _validateOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Digite o código';
    }
    if (value.length != 6) {
      return 'O código deve ter 6 dígitos';
    }
    return null;
  }

  Future<void> _handleSendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _newEmail = _emailController.text.trim();
      await _authService.requestEmailChange(_newEmail!);

      setState(() {
        _otpSent = true;
      });
    } catch (e) {
      AppLogger.error('Error sending OTP', error: e, tag: 'EmailChange');
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.verifyEmailChangeOTP(
        newEmail: _newEmail!,
        token: _otpController.text.trim(),
      );

      // Refresh user data
      _sessionManager.refreshCurrentUser();

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      AppLogger.error('Error verifying OTP', error: e, tag: 'EmailChange');
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleResendOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _authService.requestEmailChange(_newEmail!);
      setState(() {
        _errorMessage = null;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(FinTexts.emailResendSuccess),
            backgroundColor: FinColors.success,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: FinColors.cardBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(FinSizes.defaultSpace),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _otpSent ? FinTexts.emailVerifyTitle : FinTexts.emailChangeTitle,
                    style: const TextStyle(
                      fontSize: FinSizes.fontSizeXLg,
                      fontWeight: FontWeight.w600,
                      color: FinColors.textWhite,
                    ),
                  ),

                  const SizedBox(height: FinSizes.sm),

                  // Subtitle
                  Text(
                    _otpSent
                        ? '${FinTexts.emailVerifySubtitle} $_newEmail'
                        : FinTexts.emailChangeSubtitle,
                    style: TextStyle(
                      fontSize: FinSizes.fontSizeSm,
                      color: FinColors.textWhite.withValues(alpha: 0.7),
                    ),
                  ),

                  const SizedBox(height: FinSizes.lg),

                  // Input field - Email or OTP
                  if (!_otpSent)
                    CustomTextField(
                      controller: _emailController,
                      label: FinTexts.emailNewLabel,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      enabled: !_isLoading,
                      autofocus: true,
                    )
                  else
                    CustomTextField(
                      controller: _otpController,
                      label: FinTexts.emailOtpLabel,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(6),
                      ],
                      validator: _validateOtp,
                      enabled: !_isLoading,
                      autofocus: true,
                    ),

                  // Error message
                  if (_errorMessage != null) ...[
                    const SizedBox(height: FinSizes.sm),
                    Text(
                      _errorMessage!,
                      style: const TextStyle(
                        fontSize: FinSizes.fontSizeSm,
                        color: FinColors.error,
                      ),
                    ),
                  ],

                  // Resend OTP link
                  if (_otpSent) ...[
                    const SizedBox(height: FinSizes.md),
                    GestureDetector(
                      onTap: _isLoading ? null : _handleResendOtp,
                      child: Text(
                        FinTexts.emailResendCode,
                        style: TextStyle(
                          fontSize: FinSizes.fontSizeSm,
                          color: _isLoading
                              ? FinColors.textWhite.withValues(alpha: 0.3)
                              : FinColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: FinSizes.lg),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_otpSent) {
                                    // Go back to email input
                                    setState(() {
                                      _otpSent = false;
                                      _otpController.clear();
                                      _errorMessage = null;
                                    });
                                  } else {
                                    Navigator.of(context).pop(false);
                                  }
                                },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: FinColors.textWhite,
                            side: BorderSide(
                              color: FinColors.textWhite.withValues(alpha: 0.3),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: FinSizes.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
                            ),
                          ),
                          child: Text(_otpSent ? FinTexts.emailBack : FinTexts.dialogCancel),
                        ),
                      ),
                      const SizedBox(width: FinSizes.md),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : (_otpSent ? _handleVerifyOtp : _handleSendOtp),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: FinColors.primary,
                            foregroundColor: FinColors.textWhite,
                            padding: const EdgeInsets.symmetric(vertical: FinSizes.md),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(FinColors.textWhite),
                                  ),
                                )
                              : Text(_otpSent ? FinTexts.emailVerify : FinTexts.emailSendCode),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
