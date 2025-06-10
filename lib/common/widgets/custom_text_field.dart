import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

class FinCustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final String? hintText;

  const FinCustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.suffixIcon,
    this.onTap,
    this.readOnly = false,
    this.hintText,
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
            color: FinColors.lightGray, // Using existing color constant
            fontSize: FinSizes.fontSizeSm - 1, // 13px
            fontWeight: FontWeight.w500,
            height: 1.50,
            letterSpacing: -0.13,
          ),
        ),
        const SizedBox(height: FinSizes.xs * 2), // 8px

        // Text Field Container
        Container(
          width: double.infinity,
          height: 56,
          decoration: ShapeDecoration(
            color: const Color(0xFF2D3245), // Local-input color
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1,
                color: Color(0xFFE3EBFF), // brand-primary-lighter
              ),
              borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x3DE4E5E7),
                blurRadius: 2,
                offset: Offset(0, 1),
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            onTap: onTap,
            readOnly: readOnly,
            style: const TextStyle(
              color: Color(0xFFE3EBFF), // brand-primary-lighter
              fontSize: FinSizes.fontSizeMd,
              fontWeight: FontWeight.w500,
              height: 1.38,
              letterSpacing: -0.16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(FinSizes.sm + 6), // 14px
              suffixIcon: suffixIcon,
              hintText: hintText,
              hintStyle: TextStyle(
                color: const Color(0xFFE3EBFF).withOpacity(0.5),
                fontSize: FinSizes.fontSizeMd,
                fontWeight: FontWeight.w500,
                height: 1.38,
                letterSpacing: -0.16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}