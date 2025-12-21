import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';

/// A reusable profile avatar component with optional premium badge.
///
/// Used in:
/// - HomeHeader (32x32, simple border)
/// - PerfilScreen (80x80, with premium gradient border option)
///
/// Features:
/// - Network image support with fallback to initials
/// - Simple border for free users
/// - Gradient orange-to-red border for premium users
/// - Optional star badge for premium indicator
/// - Configurable size
class ProfileAvatar extends StatelessWidget {
  /// The user's full name (used for initials fallback)
  final String userName;

  /// Optional URL to the user's profile photo
  final String? photoUrl;

  /// Size of the avatar (width and height)
  final double size;

  /// Whether user has premium/pro subscription
  final bool isPremium;

  /// Whether to show the premium star badge
  final bool showPremiumBadge;

  /// Callback when avatar is tapped
  final VoidCallback? onTap;

  /// Border width around the avatar
  final double borderWidth;

  const ProfileAvatar({
    required this.userName,
    this.photoUrl,
    this.size = 80,
    this.isPremium = false,
    this.showPremiumBadge = false,
    this.onTap,
    this.borderWidth = 2.85,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(size * 0.64); // ~51.52 for 80px

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main avatar with border
          if (isPremium)
            // Premium: Gradient border using Container with gradient + inner container
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFE02244), // Red at start
                    Color(0xFFF3AD43), // Orange/gold at end
                  ],
                  stops: [0.01, 0.72],
                ),
                borderRadius: borderRadius,
              ),
              child: Container(
                margin: EdgeInsets.all(borderWidth),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(size * 0.64 - borderWidth),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(size * 0.64 - borderWidth),
                  child: _buildAvatarContent(),
                ),
              ),
            )
          else
            // Free: Simple solid border
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                border: Border.all(
                  width: borderWidth,
                  color: FinColors.avatarBorder,
                ),
                borderRadius: borderRadius,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size * 0.64 - borderWidth),
                child: _buildAvatarContent(),
              ),
            ),

          // Premium star badge
          if (showPremiumBadge && isPremium)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: const BoxDecoration(
                  color: FinColors.bgColorTop,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '✱',
                    style: TextStyle(
                      fontSize: size * 0.18,
                      color: FinColors.starOrange,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatarContent() {
    final innerSize = size - (borderWidth * 2);

    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Image.network(
        photoUrl!,
        width: innerSize,
        height: innerSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildInitialsAvatar(innerSize),
      );
    }

    return _buildInitialsAvatar(innerSize);
  }

  Widget _buildInitialsAvatar(double innerSize) {
    final initials = _getInitials(userName);
    final fontSize = innerSize * 0.35;

    return Container(
      width: innerSize,
      height: innerSize,
      color: FinColors.cardBackground,
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: FinColors.textWhite,
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

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
