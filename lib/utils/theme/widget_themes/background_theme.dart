import 'package:flutter/cupertino.dart';

import '../../../services/asset_cache_manager.dart';
import '../../constants/colors.dart';
import '../../constants/image_strings.dart';
import '../../helpers/helper_functions.dart'; // Add this import

class FinThemeBackground extends StatelessWidget {
  final Widget child;

  const FinThemeBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final dark = FinHelperFunctions.isDarkMode(context);

    if (dark) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetCacheManager.getCachedAssetImage(FinImages.darkAppBg2), // Use cached version
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      );
    } else {
      return Container(
        color: FinColors.white,
        child: child,
      );
    }
  }
}