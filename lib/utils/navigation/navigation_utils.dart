import 'package:get/get.dart';
import '../constants/routes.dart';

class FinNavigationUtils {
  /// Validate if route exists in defined routes
  static bool isValidRoute(String route) {
    return AppRoutes.allRoutes.contains(route);
  }

  /// Safe navigation with validation
  static void safeNavigateTo(String route, {bool clearStack = true}) {
    if (!isValidRoute(route)) {
      Get.offAllNamed(AppRoutes.home); // Fallback to home
      return;
    }

    clearStack ? Get.offAllNamed(route) : Get.toNamed(route);
  }

  /// Check if route requires authentication
  static bool requiresAuth(String route) {
    return AppRoutes.protectedRoutes.contains(route);
  }

  /// Check if route is a bottom nav route
  static bool isBottomNavRoute(String route) {
    return AppRoutes.bottomNavRoutes.contains(route);
  }
}