// lib/controllers/bottom_navigation_controller.dart

import 'package:get/get.dart';

/// Controller for managing bottom navigation state and tab switching
/// Handles navigation logic and maintains current tab state across the app
class BottomNavigationController extends GetxController {
  static BottomNavigationController get instance => Get.find();

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // STATE MANAGEMENT
  // Reactive variables for bottom navigation state
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Current selected tab index (0-4)
  final RxInt currentIndex = 0.obs;

  /// List of navigation routes corresponding to each tab
  final List<String> routes = [
    '/home',        // 0 - Home
    '/conjuntura',  // 1 - Conjuntura (Analysis)
    '/sofia/home',       // 2 - SofIA (AI Chat)
    '/carteira',    // 3 - Carteira (Wallet)
    '/perfil',      // 4 - Perfil (Profile)
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
  /// Uses GetX offAllNamed to replace the current route stack
  void changeTab(int index) {
    if (index < 0 || index >= routes.length) return;

    // Don't navigate if already on the same tab
    if (currentIndex.value == index) {
      print('Already on tab $index (${routes[index]}) - skipping navigation');
      return;
    }

    // Update current index first
    currentIndex.value = index;

    // Debug print to help track navigation
    print('Navigating to tab $index: ${routes[index]}');

    try {
      // Navigate to corresponding route
      Get.offAllNamed(routes[index]);
    } catch (e) {
      print('Navigation error: $e');
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
    final index = routes.indexOf(currentRoute);
    if (index != -1) {
      currentIndex.value = index;
    }
  }
}