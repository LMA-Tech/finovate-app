import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../utils/constants/image_strings.dart';

class AssetCacheManager {
  static final _cacheManager = DefaultCacheManager();

  static Future<void> preloadCriticalAssets() async {
    try {
      // For local assets, we'll use Flutter's precacheImage with optimizations
      final context = WidgetsBinding.instance.rootElement;
      if (context != null) {
        await Future.wait([
          precacheImage(const AssetImage(FinImages.darkAppBg2), context),
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