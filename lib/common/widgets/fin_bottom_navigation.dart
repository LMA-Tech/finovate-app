// lib/common/widgets/fin_bottom_navigation.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../utils/constants/colors.dart';
import '../../controllers/bottom_navigation_controller.dart';
import '../../utils/constants/image_strings.dart';

/// Custom bottom navigation bar following Figma design
///
/// Features:
/// - 5 tabs with custom SVG icons
/// - Special elevated center tab (SofIA)
/// - Dark theme with proper spacing
/// - Responsive design with proper proportions
class FinBottomNavigation extends StatelessWidget {
  const FinBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BottomNavigationController>();

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF242432), // Exact color from Figma
        border: Border(
          top: BorderSide(
            color: Color(0xFF2A2A3A), // Subtle top border
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 60, // Fixed content height
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Home Tab
              _buildTabItem(
                controller: controller,
                index: 0,
                iconPath: FinImages.bottomNavHome,
                label: 'Home',
              ),

              // Conjuntura Tab
              _buildTabItem(
                controller: controller,
                index: 1,
                iconPath: FinImages.bottomNavChart,
                label: 'Conjuntura',
              ),

              // SofIA Tab (Special Center Tab)
              _buildSofIATab(controller: controller),

              // Carteira Tab
              _buildTabItem(
                controller: controller,
                index: 3,
                iconPath: FinImages.bottomNavSofia,
                label: 'Carteira',
              ),

              // Perfil Tab
              _buildTabItem(
                controller: controller,
                index: 4,
                iconPath: FinImages.bottomNavProfile,
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build regular tab item
  ///
  /// [controller] - Bottom navigation controller
  /// [index] - Tab index
  /// [iconPath] - Path to SVG icon asset
  /// [label] - Tab label text
  Widget _buildTabItem({
    required BottomNavigationController controller,
    required int index,
    required String iconPath,
    required String label,
  }) {
    return Expanded(
      child: Obx(() => GestureDetector(
        onTap: () => controller.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 44, // Reduced height for tab content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              SvgPicture.asset(
                iconPath,
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                  controller.isSelected(index)
                      ? FinColors.primary
                      : FinColors.white,
                  BlendMode.srcIn,
                ),
                // Fallback for missing icons
                placeholderBuilder: (context) => Icon(
                  _getFallbackIcon(index),
                  size: 20,
                  color: controller.isSelected(index)
                      ? FinColors.primary
                      : FinColors.white,
                ),
              ),

              const SizedBox(height: 4),

              // Label
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  letterSpacing: 0.4,
                  color: controller.isSelected(index)
                      ? FinColors.primary
                      : FinColors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      )),
    );
  }

  /// Build special SofIA tab (center tab with elevated design)
  ///
  /// [controller] - Bottom navigation controller
  Widget _buildSofIATab({required BottomNavigationController controller}) {
    return Expanded(
      child: Obx(() => GestureDetector(
        onTap: () => controller.changeTab(2),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 44, // Reduced height for tab content
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Special elevated icon container
              Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: controller.isSelected(2)
                      ? LinearGradient(
                    colors: [
                      FinColors.primary.withValues(alpha: 0.2),
                      FinColors.primary.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                      : null,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    FinImages.bottomNavSofia,
                    height: 20,
                    width: 20,
                    colorFilter: ColorFilter.mode(
                      controller.isSelected(2)
                          ? FinColors.primary
                          : FinColors.white,
                      BlendMode.srcIn,
                    ),
                    // Fallback for missing icon
                    placeholderBuilder: (context) => Icon(
                      Icons.smart_toy_outlined,
                      size: 20,
                      color: controller.isSelected(2)
                          ? FinColors.primary
                          : FinColors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Label
              Text(
                'SofIA',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  height: 1.0,
                  letterSpacing: 0.4,
                  color: controller.isSelected(2)
                      ? FinColors.primary
                      : FinColors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      )),
    );
  }

  /// Get fallback icon for when SVG assets are not available
  ///
  /// [index] - Tab index
  /// Returns appropriate Material Design icon
  IconData _getFallbackIcon(int index) {
    switch (index) {
      case 0: return Icons.home_outlined;
      case 1: return Icons.trending_up_outlined;
      case 2: return Icons.smart_toy_outlined;
      case 3: return Icons.account_balance_wallet_outlined;
      case 4: return Icons.person_outline;
      default: return Icons.help_outline;
    }
  }
}