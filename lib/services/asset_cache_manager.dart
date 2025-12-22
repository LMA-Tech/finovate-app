import 'package:flutter/material.dart';

import '../utils/constants/image_strings.dart';

class AssetCacheManager {

  static Future<void> preloadCriticalAssets() async {
    try {
      // For local assets, we'll use Flutter's precacheImage with optimizations
      final context = WidgetsBinding.instance.rootElement;
      if (context != null) {
        await Future.wait([
          precacheImage(const AssetImage(FinImages.darkAppBgOverlay), context),
          precacheImage(const AssetImage(FinImages.lightAppLogo), context),
          precacheImage(const AssetImage(FinImages.darkAppLogo), context),
        ]);
      }
    } catch (e) {
      debugPrint('Asset preloading failed: $e');
    }
  }

  // Method to get cached image
  static ImageProvider getCachedAssetImage(String assetPath) {
    return AssetImage(assetPath);
  }
}