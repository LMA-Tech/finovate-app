import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import '../stock_detail_controller.dart';

/// Header for stock detail screen with back button, ticker, and bookmark
class StockDetailHeader extends StatelessWidget {
  final String ticker;
  final StockDetailController controller;

  const StockDetailHeader({
    required this.ticker,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: FinSizes.sm,
        vertical: FinSizes.md,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Centered ticker
          Text(
            ticker,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeLg,
              fontWeight: FontWeight.w600,
              color: FinColors.textWhite,
            ),
          ),

          // Back button (left)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: FinColors.textWhite,
                size: FinSizes.iconMd,
              ),
              onPressed: () => Get.back(),
            ),
          ),

          // Bookmark button (right)
          Align(
            alignment: Alignment.centerRight,
            child: Obx(() => IconButton(
                  icon: Icon(
                    controller.isFavorite.value
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: FinColors.textWhite,
                    size: FinSizes.iconMd,
                  ),
                  onPressed: () => _toggleFavorite(context),
                )),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(BuildContext context) {
    final wasFavorite = controller.isFavorite.value;
    controller.toggleFavorite();

    // Show toast notification
    final message = wasFavorite
        ? FinTexts.stockDetailFavoriteRemoved
        : FinTexts.stockDetailFavoriteAdded;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check,
              color: FinColors.toastSuccessText,
              size: FinSizes.iconSm,
            ),
            const SizedBox(width: FinSizes.sm),
            Text(
              message,
              style: const TextStyle(
                fontSize: FinSizes.fontSizeSm,
                fontWeight: FontWeight.w500,
                color: FinColors.toastSuccessText,
              ),
            ),
          ],
        ),
        backgroundColor: FinColors.toastSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FinSizes.borderRadiusMd),
        ),
        margin: const EdgeInsets.all(FinSizes.md),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
