import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

/// A security notice widget with lock icon and privacy message.
///
/// Used in profile screens to inform users about data protection.
/// Features gradient background (blue to green) with dark text.
class SecurityNotice extends StatelessWidget {
  /// The notice message to display
  final String message;

  const SecurityNotice({
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.00, 0.50),
          end: Alignment(1.00, 0.50),
          colors: [Color(0xFF62B2FD), Color(0xFFBADBC1)],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.lock_outline,
            size: FinSizes.iconSm,
            color: Color(0xFF040404),
          ),
          const SizedBox(width: FinSizes.sm),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFF040404),
                fontSize: FinSizes.fontSizeSm,
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
