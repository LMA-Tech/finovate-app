import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import '../../utils/constants/colors.dart';

/// Simple reactive text field that keeps your exact styling
class CustomTextFieldReactive extends StatelessWidget {
  final String formControlName;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final Map<String, String Function(Object)>? validationMessages;

  const CustomTextFieldReactive({
    super.key,
    required this.formControlName,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
    this.validationMessages,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: const TextStyle(
            color: FinColors.lightGray,
            fontSize: 13,
            fontWeight: FontWeight.w500,
            height: 1.50,
            letterSpacing: -0.13,
          ),
        ),
        const SizedBox(height: 8),

        // Reactive text field with your styling
        ReactiveTextField<String>(
          formControlName: formControlName,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          validationMessages: validationMessages ?? {},
          style: const TextStyle(
            color: FinColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.38,
            letterSpacing: -0.16,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2D3245),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFE3EBFF).withOpacity(0.3),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color(0xFFE3EBFF).withOpacity(0.3),
                width: 1,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: Color(0xFFE3EBFF),
                width: 1,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: FinColors.error,
                width: 1,
              ),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(
                color: FinColors.error,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
            suffixIcon: suffixIcon,
            errorStyle: const TextStyle(
              color: FinColors.error,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}