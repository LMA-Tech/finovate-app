import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String label;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.validator,
    required this.label,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
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

        // Text Field Container
        TextFormField(
          controller: controller,
          validator: validator,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          style: const TextStyle(
            color: FinColors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.38,
            letterSpacing: -0.16,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2D3245), // Dark container
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