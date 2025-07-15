import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Reusable header component for the home screen
/// Shows user greeting, name, and notification icon
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    this.onNotificationPressed,
    this.hasNotification = false,
  });

  final String userName;
  final VoidCallback? onNotificationPressed;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // User greeting section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting
                Text(
                  'Olá, $userName',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.29,
                    letterSpacing: -0.28,
                  ),
                ),
                const SizedBox(height: 2),

                // Welcome message
                const Text(
                  'Bem vindo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                    letterSpacing: -0.4,
                  ),
                ),
              ],
            ),
          ),

          // Notification icon with indicator
          Stack(
            children: [
              IconButton(
                onPressed: onNotificationPressed,
                icon: const Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 24,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
              ),

              // Notification indicator dot
              if (hasNotification)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: FinColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}