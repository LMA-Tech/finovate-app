import 'package:flutter/material.dart';

import '../../utils/helpers/helper_functions.dart';

/// Reusable CustomAppBar for the entire app
///
/// Handles common AppBar patterns:
/// - Optional back button with custom action
/// - Optional title (text or widget)
/// - Optional actions (buttons, icons)
/// - Transparent background (consistent with app design)
/// - Automatic dark/light mode icon colors
///
/// Usage examples:
/// ```dart
/// // Simple back button only
/// CustomAppBar()
///
/// // With title
/// CustomAppBar(title: 'Settings')
///
/// // Hide back button (e.g., on success screens)
/// CustomAppBar(showBackButton: false)
///
/// // Custom back action
/// CustomAppBar(onBackPressed: () => controller.handleBack(context))
///
/// // With actions
/// CustomAppBar(
///   title: 'Profile',
///   actions: [IconButton(icon: Icon(Icons.settings), onPressed: () {})],
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Whether to show the back button (default: true)
  final bool showBackButton;

  /// Custom back button action
  /// If null and showBackButton is true, defaults to Navigator.pop(context)
  final VoidCallback? onBackPressed;

  /// Title text (simple string)
  /// If both titleText and titleWidget are provided, titleWidget takes precedence
  final String? titleText;

  /// Custom title widget (for complex titles)
  final Widget? titleWidget;

  /// Whether to center the title (default: false, follows app theme)
  final bool? centerTitle;

  /// Custom back button icon (default: Icons.chevron_left)
  final IconData? backIcon;

  /// Action buttons on the right side
  final List<Widget>? actions;

  /// AppBar background color (default: transparent)
  final Color? backgroundColor;

  /// AppBar elevation (default: 0)
  final double? elevation;

  const CustomAppBar({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
    this.titleText,
    this.titleWidget,
    this.centerTitle,
    this.backIcon,
    this.actions,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);
    final iconColor = dark ? Colors.white : Colors.black;

    return AppBar(
      // Leading (back button)
      leading: showBackButton
          ? IconButton(
        icon: Icon(
          backIcon ?? Icons.chevron_left,
          color: iconColor,
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
      )
          : const SizedBox.shrink(),
      automaticallyImplyLeading: false,

      // Title
      title: titleWidget ??
          (titleText != null
              ? Text(
            titleText!,
            style: TextStyle(
              color: iconColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
              : null),
      centerTitle: centerTitle,

      // Actions
      actions: actions,

      // Styling
      backgroundColor: backgroundColor ?? Colors.transparent,
      elevation: elevation ?? 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}