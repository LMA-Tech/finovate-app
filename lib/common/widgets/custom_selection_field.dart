import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';

/// Custom selection field that matches CustomTextFieldReactive styling
/// Used for selectable options like verification methods
class CustomSelectionField extends StatelessWidget {
  final String label;
  final String title;
  final bool isSelected;
  final bool isEnabled;
  final VoidCallback onTap;
  final Widget? trailingIcon;

  const CustomSelectionField({
    super.key,
    required this.label,
    required this.title,
    required this.isSelected,
    required this.isEnabled,
    required this.onTap,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        if (label.isNotEmpty) ...[
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
        ],

        // Selection field (styled like text field)
        GestureDetector(
          onTap: isEnabled ? onTap : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isEnabled
                  ? const Color(0xFF2D3245)
                  : const Color(0xFF2D3245).withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFFE3EBFF)  // Same as focused border in text fields
                    : const Color(0xFFE3EBFF).withOpacity(0.3), // Same as enabled border
                width: isSelected ? 1 : 1, // Keep consistent with text fields
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title text
                Text(
                  title,
                  style: TextStyle(
                    color: isEnabled
                        ? FinColors.white
                        : FinColors.white.withOpacity(0.5),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.38,
                    letterSpacing: -0.16,
                  ),
                ),

                // Trailing icon (checkmark or custom icon)
                if (trailingIcon != null)
                  trailingIcon!
                else if (isSelected && isEnabled)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C853), // Green checkmark
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}