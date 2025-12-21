import 'package:flutter/material.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// Shows a simple info bottom sheet with title and description.
void showInfoBottomSheet({
  required BuildContext context,
  required String title,
  required String description,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: FinColors.cardBackground,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(FinSizes.borderRadiusLg)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(FinSizes.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeLg,
              fontWeight: FontWeight.w600,
              color: FinColors.textWhite,
            ),
          ),
          const SizedBox(height: FinSizes.sm),
          Text(
            description,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeSm,
              fontWeight: FontWeight.w400,
              color: FinColors.textGray200,
              height: 1.5,
            ),
          ),
          const SizedBox(height: FinSizes.lg),
        ],
      ),
    ),
  );
}

/// An info icon button that triggers the info bottom sheet.
class InfoIconButton extends StatelessWidget {
  final String title;
  final String description;
  final double size;
  final Color? color;

  const InfoIconButton({
    required this.title,
    required this.description,
    this.size = FinSizes.iconMd,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showInfoBottomSheet(
        context: context,
        title: title,
        description: description,
      ),
      child: Icon(
        Icons.info_outline,
        size: size,
        color: color ?? FinColors.iconGray,
      ),
    );
  }
}

/// A "O que é X?" link that triggers the info bottom sheet.
class WhatIsLink extends StatelessWidget {
  final String subject;
  final String title;
  final String description;

  const WhatIsLink({
    required this.subject,
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showInfoBottomSheet(
        context: context,
        title: title,
        description: description,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.info_outline,
            size: FinSizes.iconSm,
            color: FinColors.iconGray,
          ),
          const SizedBox(width: FinSizes.sm),
          Text(
            'O que é $subject?',
            style: const TextStyle(
              color: FinColors.iconGray,
              fontSize: FinSizes.fontSizeS,
            ),
          ),
        ],
      ),
    );
  }
}
