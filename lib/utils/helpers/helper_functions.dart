import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/sizes.dart';

class FinHelperFunctions {
  static Color? getColor(String value) {
    /// Color Palette here and it will match the attribute colors and show specific 🟠🟡🟢🔵🟣🟤

    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size screenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }

  // ═══════════════════════════════════════════════════════════════════════════════════════
  // RESPONSIVE SAFE AREA HELPERS
  // Methods for handling bottom safe areas and responsive padding
  // ═══════════════════════════════════════════════════════════════════════════════════════

  /// Returns a SafeArea widget with intelligent bottom padding
  /// Automatically handles device safe areas (home indicators, gesture bars)
  /// while ensuring minimum padding for visual comfort
  static Widget getBottomSafeArea({
    required Widget child,
    double minimumPadding = FinSizes.spaceBtwSections,
  }) {
    return SafeArea(
      minimum: EdgeInsets.only(bottom: minimumPadding),
      child: child,
    );
  }

  /// Get bottom safe padding value for manual control
  /// Automatically detects device safe areas and provides appropriate padding
  static double getBottomSafePadding(BuildContext context, {
    double minimumPadding = FinSizes.spaceBtwSections,
  }) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return bottomPadding > 0
        ? bottomPadding + minimumPadding
        : minimumPadding * 1.5; // Slightly more padding for devices without safe area
  }

  /// Get responsive font size based on screen width
  /// Helps prevent text overflow on smaller devices
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Scale font size based on screen width
    if (screenWidth < 360) {
      return baseFontSize * 0.85; // Smaller screens
    } else if (screenWidth > 414) {
      return baseFontSize * 1.1; // Larger screens
    }
    return baseFontSize; // Standard screens
  }

  /// Get responsive padding based on screen size
  /// Provides consistent spacing across different devices
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const basePadding = FinSizes.defaultSpace;

    if (screenWidth < 360) {
      return const EdgeInsets.all(basePadding * 0.75);
    } else if (screenWidth > 414) {
      return const EdgeInsets.all(basePadding * 1.25);
    }
    return const EdgeInsets.all(basePadding);
  }
}