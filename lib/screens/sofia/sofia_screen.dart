// lib/screens/sofia/sofia_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/fin_bottom_navigation.dart';
import '../../services/activity_tracker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// SofIA Screen - AI Chat interface for financial assistance
///
/// This screen will house the AI chat functionality where users can
/// interact with SofIA (the AI assistant) for investment advice,
/// financial planning, and market insights.
class SofiaScreen extends StatelessWidget {
  const SofiaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityTracker = Get.find<ActivityTracker>();

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('SofIA'),
            automaticallyImplyLeading: false, // No back button for main tabs
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Add chat settings/options
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
          body: const Column(
            children: [
              // Chat messages area (to be implemented)
              Expanded(
                child: Center(
                  child: _PlaceholderContent(),
                ),
              ),

              // Chat input area (to be implemented)
              _ChatInputPlaceholder(),
            ],
          ),
          bottomNavigationBar: const FinBottomNavigation(),
        ),
      ),
    );
  }
}

/// Placeholder content for the SofIA chat interface
class _PlaceholderContent extends StatelessWidget {
  const _PlaceholderContent();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AI Icon
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FinColors.primary.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.smart_toy,
              size: 50,
              color: FinColors.primary,
            ),
          ),

          const SizedBox(height: FinSizes.spaceBtwSections),

          // Title
          const Text(
            'SofIA - Assistente IA',
            style: TextStyle(
              fontSize: FinSizes.fontSizeXXLg,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: FinSizes.spaceBtwItems),

          // Subtitle
          Text(
            'Converse com nossa IA especializada em investimentos e finanças.',
            style: TextStyle(
              fontSize: FinSizes.fontSizeMd,
              fontWeight: FontWeight.w400,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: FinSizes.spaceBtwSections),

          // Ready to implement badge
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FinSizes.md,
              vertical: FinSizes.sm,
            ),
            decoration: BoxDecoration(
              color: FinColors.success.withOpacity(0.2),
              borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
              border: Border.all(
                color: FinColors.success.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              'Interface de chat será implementada aqui',
              style: TextStyle(
                fontSize: FinSizes.fontSizeSm,
                fontWeight: FontWeight.w500,
                color: FinColors.success,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Placeholder for chat input interface
class _ChatInputPlaceholder extends StatelessWidget {
  const _ChatInputPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Text input placeholder
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FinSizes.md,
                  vertical: FinSizes.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
                ),
                child: Text(
                  'Digite sua mensagem...',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: FinSizes.fontSizeMd,
                  ),
                ),
              ),
            ),

            const SizedBox(width: FinSizes.sm),

            // Send button placeholder
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: FinColors.primary.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send,
                color: FinColors.white.withOpacity(0.7),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}