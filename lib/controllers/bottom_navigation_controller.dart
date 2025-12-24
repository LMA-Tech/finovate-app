// lib/controllers/bottom_navigation_controller.dart

import 'package:get/get.dart';

import '../services/app_logger.dart';
import '../utils/constants/routes.dart';

/// Controller for managing bottom navigation state and tab switching
/// Handles navigation logic and maintains current tab state across the app
class BottomNavigationController extends GetxController {
  static const String _tag = 'BottomNav';
  static BottomNavigationController get instance => Get.find();

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // Reactive variables for bottom navigation state
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Current selected tab index (0-4)
  final RxInt currentIndex = 0.obs;

  /// List of navigation routes corresponding to each tab
  /// MUST match the order of bottom navigation bar icons
  final List<String> routes = [
    AppRoutes.home,        // 0 - Home
    AppRoutes.conjuntura,  // 1 - Conjuntura (Market Analysis)
    AppRoutes.sofiaHome,   // 2 - SofIA (AI Assistant)
    AppRoutes.carteira,    // 3 - Carteira (Portfolio)
    AppRoutes.perfil,      // 4 - Perfil (Profile)
  ];

  /// Tab labels for accessibility and display
  final List<String> tabLabels = [
    'Home',
    'Conjuntura',
    'SofIA',
    'Carteira',
    'Perfil',
  ];

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // NAVIGATION METHODS
  // Handle tab selection and route navigation
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Change to specific tab and navigate to corresponding route
  ///
  /// [index] - Tab index (0-4)
  /// Uses GetX offAllNamed for main tabs, Get.to for profile (smoother transition)
  void changeTab(int index) {
    if (index < 0 || index >= routes.length) return;

    // Don't navigate if already on the same tab
    if (currentIndex.value == index) {
      AppLogger.verbose('Already on tab $index (${routes[index]}) - skipping navigation', tag: _tag);
      return;
    }

    // Debug print to help track navigation
    AppLogger.debug('Navigating to tab $index: ${routes[index]}', tag: _tag);

    try {
      // Profile tab (index 4) uses push navigation for smooth back transition
      // since it doesn't have bottom nav and uses a back button
      if (index == 4) {
        currentIndex.value = index;
        Get.toNamed(routes[index]);
      } else {
        // For other tabs, use offAllNamed to clear stack
        currentIndex.value = index;
        Get.offAllNamed(routes[index]);
      }
    } catch (e) {
      AppLogger.error('Navigation error', error: e, tag: _tag);
      // Fallback to home if navigation fails
      currentIndex.value = 0;
      Get.offAllNamed('/home');
    }
  }

  /// Navigate to specific route and update tab index
  ///
  /// [route] - Route path to navigate to
  /// Useful when navigating programmatically from other parts of the app
  void navigateToRoute(String route) {
    final index = routes.indexOf(route);
    if (index != -1) {
      changeTab(index);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // Helper methods for tab management
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Check if given index is the currently selected tab
  bool isSelected(int index) => currentIndex.value == index;

  /// Get current route path
  String get currentRoute => routes[currentIndex.value];

  /// Get current tab label
  String get currentTabLabel => tabLabels[currentIndex.value];

  /// Initialize controller with specific tab (useful for deep linking)
  void initializeWithTab(int index) {
    if (index >= 0 && index < routes.length) {
      currentIndex.value = index;
    }
  }

  /// Reset to home tab (index 0)
  /// Call this when navigating to home after login/signup
  void resetToHome() {
    AppLogger.debug('Resetting bottom navigation to Home tab', tag: _tag);
    currentIndex.value = 0;
  }

  /// Sync tab index with current route
  /// Call this when route changes happen outside of changeTab()
  /// (e.g., back button navigation, deep links)
  void syncWithCurrentRoute() {
    final currentRoute = Get.currentRoute;
    final index = routes.indexOf(currentRoute);

    if (index != -1 && index != currentIndex.value) {
      AppLogger.verbose('Syncing tab: route=$currentRoute, updating index to $index', tag: _tag);
      currentIndex.value = index;
    } else if (index == -1) {
      // Route not in bottom nav - don't change tab selection
      AppLogger.verbose('Route $currentRoute not in bottom nav - keeping current tab', tag: _tag);
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // LIFECYCLE METHODS
  // Controller initialization and cleanup
  // ═══════════════════════════════════════════════════════════════════════════════════════

  @override
  void onInit() {
    super.onInit();
    // Set initial tab based on current route if needed
    _setInitialTab();
  }

  /// Set initial tab based on current route
  /// Useful when app is opened via deep link or restored state
  void _setInitialTab() {
    final currentRoute = Get.currentRoute;

    AppLogger.debug('Setting initial tab for route: $currentRoute', tag: _tag);

    final index = routes.indexOf(currentRoute);
    if (index != -1) {
      currentIndex.value = index;
      AppLogger.verbose('Tab set to index $index', tag: _tag);
    } else {
      // Default to home if route not found
      currentIndex.value = 0;
      AppLogger.verbose('Route not found, defaulting to Home (index 0)', tag: _tag);
    }
  }
}