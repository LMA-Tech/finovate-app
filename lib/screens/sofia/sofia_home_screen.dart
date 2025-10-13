// lib/screens/sofia/sofia_home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../screens/sofia/widgets/welcome_section.dart';
import '../../screens/sofia/widgets/chat_input.dart';
import '../../screens/sofia/sofia_controller.dart';
import '../../services/activity_tracker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/routes.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';

/// SofIA Home Screen - Welcome and dashboard interface
///
/// This screen provides the main entry point for SofIA interactions.
/// Features personalized greeting, quick action suggestions, and navigation
/// to start new conversations or view recent chat history.
class SofiaHomeScreen extends StatelessWidget {
  const SofiaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controllers
    final activityTracker = Get.find<ActivityTracker>();
    final sofiaController = Get.put(SofiaController());

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          // Clean minimal app bar for home screen
          appBar: _buildHomeAppBar(),

          body: Column(
            children: [
              // Main welcome content using existing widget
              Expanded(
                child: WelcomeSection(
                  userName: sofiaController.userName.value,
                  onSuggestionTap: (suggestion) => _navigateToChat(suggestion, sofiaController),
                  isLoading: sofiaController.isLoading.value,
                  useCompactLayout: false,
                ),
              ),

              // Recent conversations section using widget (TBA)
              // Obx(() => sofiaController.hasMessages
              //     ? ChatHistoryWidget(
              //   controller: sofiaController,
              //   onConversationTap: () => _openRecentConversation(sofiaController),
              //   onViewAllTap: () => _viewAllConversations(sofiaController),
              // )
              //     : const SizedBox.shrink(),
              // ),

              // Chat input using existing widget
              Obx(() => ChatInput(
                onSendMessage: (message) => _navigateToChat(message, sofiaController),
                hintText: FinTexts.sofiaChatInputHint,
                isEnabled: !sofiaController.isLoading.value,
                isLoading: sofiaController.isLoading.value,
              )),
            ],
          ),
        ),
      ),
    );
  }

  /// Build clean home screen app bar
  PreferredSizeWidget _buildHomeAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: true,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.offAllNamed(AppRoutes.home),
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
      ),
      // No title on home screen for clean look
      title: null,
      actions: [
        // Settings or menu option
        IconButton(
          onPressed: () => _showHomeOptions(),
          icon: const Icon(
            Icons.more_vert,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  /// Navigate to chat screen with message
  void _navigateToChat(String message, SofiaController controller) {
    Get.toNamed(AppRoutes.sofiaChat, arguments: { // ← USE CONSTANT
      'initialMessage': message,
      'controller': controller,
    });
  }

  /// Open recent conversation in chat screen
  void _openRecentConversation(SofiaController controller) {
    Get.toNamed(AppRoutes.sofiaChat, arguments: { // ← USE CONSTANT
      'controller': controller,
      'resumeChat': true,
    });
  }

  /// View all conversations (placeholder for future feature)
  void _viewAllConversations(SofiaController controller) {
    Get.snackbar(
      'Em breve',
      'Histórico completo de conversas estará disponível em breve',
      backgroundColor: FinColors.primary.withValues(alpha: 0.8),
      colorText: Colors.white,
    );
  }

  /// Show home screen options menu
  void _showHomeOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(FinSizes.defaultSpace),
        decoration: const BoxDecoration(
          color: Color(0xFF2D3245),
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FinSizes.borderRadiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: FinSizes.lg),

            // Title
            const Text(
              'Opções',
              style: TextStyle(
                fontSize: FinSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: FinSizes.lg),

            // Settings option
            ListTile(
              leading: const Icon(
                Icons.settings_outlined,
                color: Colors.white,
              ),
              title: const Text(
                'Configurações',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FinSizes.fontSizeMd,
                ),
              ),
              onTap: () {
                Get.back();
                // TODO: Navigate to settings
              },
            ),

            // Help option
            ListTile(
              leading: const Icon(
                Icons.help_outline,
                color: Colors.white,
              ),
              title: const Text(
                'Ajuda',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FinSizes.fontSizeMd,
                ),
              ),
              onTap: () {
                Get.back();
                // TODO: Navigate to help
              },
            ),

            // Close option
            ListTile(
              leading: Icon(
                Icons.close,
                color: Colors.white.withValues(alpha: 0.8),
              ),
              title: Text(
                FinTexts.sofiaClose,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: FinSizes.fontSizeMd,
                ),
              ),
              onTap: () => Get.back(),
            ),

            // Safe area padding
            SizedBox(height: MediaQuery.of(Get.context!).padding.bottom),
          ],
        ),
      ),
    );
  }
}