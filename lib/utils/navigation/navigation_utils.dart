import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class FinNavigationUtils {
  /// Validate if route exists in defined routes
  static bool isValidRoute(String route) {
    const validRoutes = ['/home', '/conjuntura', '/sofia', '/carteira', '/perfil'];
    return validRoutes.contains(route);
  }

  /// Safe navigation with validation
  static void safeNavigateTo(String route, {bool clearStack = true}) {
    if (!isValidRoute(route)) {
      Get.offAllNamed('/home'); // Fallback
      return;
    }

    clearStack ? Get.offAllNamed(route) : Get.toNamed(route);
  }
}