import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Reusable header component for the home screen
/// Shows user avatar, greeting, name, and notification icon
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.userName,
    this.userPhotoUrl,
    this.onNotificationPressed,
    this.hasNotification = false,
  });

  final String userName;
  final String? userPhotoUrl;
  final VoidCallback? onNotificationPressed;
  final bool hasNotification;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar and greeting section
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User avatar with green border
                _buildAvatar(),
                const SizedBox(width: 12),

                // Greeting text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Greeting
                      Text(
                        'Olá, $userName',
                        style: const TextStyle(
                          color: FinColors.textWhite,
                          fontSize: FinSizes.fontSizeSm,
                          fontWeight: FontWeight.w400,
                          height: 1.29,
                          letterSpacing: -0.28,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),

                      // Welcome message
                      const Text(
                        'Bem vindo',
                        style: TextStyle(
                          color: FinColors.textWhite,
                          fontSize: FinSizes.fontSizeXLg,
                          fontWeight: FontWeight.w600,
                          height: 1.6,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ],
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
                  color: FinColors.textWhite,
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

  /// Builds the user avatar with a green border
  /// Size: 32x32 per Figma with 2px border
  Widget _buildAvatar() {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: FinColors.avatarBorder,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: userPhotoUrl != null && userPhotoUrl!.isNotEmpty
            ? Image.network(
                userPhotoUrl!,
                width: 28,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
              )
            : _buildDefaultAvatar(),
      ),
    );
  }

  /// Builds a default avatar with user initials
  Widget _buildDefaultAvatar() {
    // Get initials from userName (first letter of first and last name)
    final initials = _getInitials(userName);

    return Container(
      width: 28,
      height: 28,
      color: FinColors.cardBackground,
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: FinColors.textWhite,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// Extracts initials from full name
  String _getInitials(String name) {
    if (name.isEmpty) return 'U';

    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }

    // First letter of first name + first letter of last name
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}