import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// A text field that displays masked data with an edit button.
///
/// Used for sensitive personal information (email, CPF, phone, etc.)
/// Shows masked value by default, with edit icon to reveal and modify.
///
/// Based on Figma design for Perfil screen personal info fields.
class MaskedTextField extends StatelessWidget {
  /// The field label (e.g., "E-mail", "CPF")
  final String label;

  /// The masked value to display (e.g., "s***@*****.com")
  final String maskedValue;

  /// Callback when the edit button is tapped
  final VoidCallback? onEditTap;

  /// Whether the field is editable
  final bool isEditable;

  const MaskedTextField({
    required this.label,
    required this.maskedValue,
    this.onEditTap,
    this.isEditable = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        border: Border.all(
          color: FinColors.cardBackground.withValues(alpha: 0.3),
          width: FinSizes.borderWidthSm,
        ),
      ),
      child: Row(
        children: [
          // Label and value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label
                Text(
                  label,
                  style: const TextStyle(
                    color: FinColors.textGray200,
                    fontSize: FinSizes.fontSizeXs,
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                ),
                const SizedBox(height: FinSizes.xs),
                // Masked value
                Text(
                  maskedValue,
                  style: const TextStyle(
                    color: FinColors.textWhite,
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w500,
                    height: 1.38,
                  ),
                ),
              ],
            ),
          ),

          // Edit button
          if (isEditable)
            GestureDetector(
              onTap: onEditTap,
              child: Container(
                width: FinSizes.iconLg,
                height: FinSizes.iconLg,
                decoration: BoxDecoration(
                  color: FinColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  color: FinColors.primary,
                  size: FinSizes.iconSm,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A variant that shows an editable text field instead of masked value.
///
/// Used when the user taps edit on a MaskedTextField.
class EditableTextField extends StatelessWidget {
  /// The field label
  final String label;

  /// Controller for the text field
  final TextEditingController controller;

  /// Keyboard type for the field
  final TextInputType keyboardType;

  /// Callback when save is tapped
  final VoidCallback? onSave;

  /// Callback when cancel is tapped
  final VoidCallback? onCancel;

  /// Optional hint text
  final String? hintText;

  const EditableTextField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.onSave,
    this.onCancel,
    this.hintText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        border: Border.all(
          color: FinColors.primary,
          width: FinSizes.borderWidthSm,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            label,
            style: const TextStyle(
              color: FinColors.textGray200,
              fontSize: FinSizes.fontSizeXs,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          const SizedBox(height: FinSizes.xs),

          // Text field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    color: FinColors.textWhite,
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: FinColors.textWhite.withValues(alpha: 0.4),
                      fontSize: FinSizes.fontSizeMd,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),

              // Action buttons
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Cancel button
                  GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      width: FinSizes.iconLg,
                      height: FinSizes.iconLg,
                      decoration: BoxDecoration(
                        color: FinColors.error.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: FinColors.error,
                        size: FinSizes.iconSm,
                      ),
                    ),
                  ),
                  const SizedBox(width: FinSizes.sm),
                  // Save button
                  GestureDetector(
                    onTap: onSave,
                    child: Container(
                      width: FinSizes.iconLg,
                      height: FinSizes.iconLg,
                      decoration: const BoxDecoration(
                        color: FinColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: FinColors.textWhite,
                        size: FinSizes.iconSm,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
