import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../common/widgets/custom_text_field.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

/// Bottom sheet for editing a single profile field.
///
/// Supports different field types with appropriate keyboards and validation.
class EditFieldBottomSheet extends StatefulWidget {
  final String fieldKey;
  final String fieldLabel;
  final String currentValue;
  final Future<void> Function(String newValue) onSave;

  const EditFieldBottomSheet({
    required this.fieldKey,
    required this.fieldLabel,
    required this.currentValue,
    required this.onSave,
    super.key,
  });

  /// Show the bottom sheet and return true if saved successfully
  static Future<bool?> show({
    required BuildContext context,
    required String fieldKey,
    required String fieldLabel,
    required String currentValue,
    required Future<void> Function(String newValue) onSave,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditFieldBottomSheet(
        fieldKey: fieldKey,
        fieldLabel: fieldLabel,
        currentValue: currentValue,
        onSave: onSave,
      ),
    );
  }

  @override
  State<EditFieldBottomSheet> createState() => _EditFieldBottomSheetState();
}

class _EditFieldBottomSheetState extends State<EditFieldBottomSheet> {
  late TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  TextInputType get _keyboardType {
    switch (widget.fieldKey) {
      case 'phone':
        return TextInputType.phone;
      case 'email':
        return TextInputType.emailAddress;
      case 'birthDate':
        return TextInputType.datetime;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter>? get _inputFormatters {
    switch (widget.fieldKey) {
      case 'phone':
        return [
          FilteringTextInputFormatter.digitsOnly,
          _PhoneInputFormatter(),
        ];
      case 'birthDate':
        return [
          FilteringTextInputFormatter.digitsOnly,
          _DateInputFormatter(),
        ];
      default:
        return null;
    }
  }

  String? _validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo é obrigatório';
    }

    switch (widget.fieldKey) {
      case 'email':
        if (!GetUtils.isEmail(value.trim())) {
          return 'E-mail inválido';
        }
        break;
      case 'phone':
        final digits = value.replaceAll(RegExp(r'[^\d]'), '');
        if (digits.length < 10 || digits.length > 11) {
          return 'Telefone inválido';
        }
        break;
      case 'birthDate':
        // Validate DD/MM/YYYY format
        final parts = value.split('/');
        if (parts.length != 3) {
          return 'Data inválida (DD/MM/AAAA)';
        }
        try {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          if (day < 1 || day > 31 || month < 1 || month > 12 || year < 1900 || year > DateTime.now().year) {
            return 'Data inválida';
          }
        } catch (e) {
          return 'Data inválida (DD/MM/AAAA)';
        }
        break;
      case 'fullName':
      case 'nickname':
        if (value.trim().length < 2) {
          return 'Mínimo de 2 caracteres';
        }
        break;
    }
    return null;
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.onSave(_controller.text.trim());
      if (mounted) {
        Navigator.of(context).pop(true);
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
                    'Editar ${widget.fieldLabel.toLowerCase()}',
                    style: const TextStyle(
                      fontSize: FinSizes.fontSizeXLg,
                      fontWeight: FontWeight.w600,
                      color: FinColors.textWhite,
                    ),
                  ),

                  const SizedBox(height: FinSizes.lg),

                  // Input field
                  CustomTextField(
                    controller: _controller,
                    label: widget.fieldLabel,
                    keyboardType: _keyboardType,
                    inputFormatters: _inputFormatters,
                    validator: _validate,
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

                  const SizedBox(height: FinSizes.lg),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
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
                          child: const Text(FinTexts.dialogCancel),
                        ),
                      ),
                      const SizedBox(width: FinSizes.md),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleSave,
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
                              : const Text(FinTexts.save),
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

/// Formats phone input as (XX) XXXXX-XXXX
class _PhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 11; i++) {
      if (i == 0) buffer.write('(');
      if (i == 2) buffer.write(') ');
      if (i == 7) buffer.write('-');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

/// Formats date input as DD/MM/YYYY
class _DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 8; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(digits[i]);
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}
