import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// B3 Connection Banner Component
/// Displays a gradient banner encouraging users to connect their B3 account
class B3ConnectionBanner extends StatelessWidget {
  const B3ConnectionBanner({
    super.key,
    this.onPressed,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF013ACB), // from-[#013acb]
            Color(0xFF477552), // to-[#477552]
          ],
          stops: [0.01389, 0.72345],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 24, 8),
            child: Row(
              children: [
                // Banner text
                const Expanded(
                  child: Text(
                    'Conecte sua conta B3 para aproveitar todos os recursos.',
                    style: TextStyle(
                      color: Color(0xFFF0F5EF),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ),

                // Arrow icon
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}