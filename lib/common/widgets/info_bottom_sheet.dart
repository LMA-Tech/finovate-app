import 'package:flutter/material.dart';

/// Shows a simple info bottom sheet with title and description.
///
/// Use this anywhere in the app where (ⓘ) icon or "O que é X?" links appear.
/// Based on Figma design specs from docs/global-components.md
void showInfoBottomSheet({
  required BuildContext context,
  required String title,
  required String description,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1A1A2E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFDFDFE0),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24), // Bottom safe area padding
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
    this.size = 20,
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
        color: color ?? const Color(0xFF9E9E9E),
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
            size: 16,
            color: Color(0xFF9E9E9E),
          ),
          const SizedBox(width: 8),
          Text(
            'O que é $subject?',
            style: const TextStyle(
              color: Color(0xFF9E9E9E),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
