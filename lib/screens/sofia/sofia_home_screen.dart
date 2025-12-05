// lib/screens/sofia/sofia_home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import 'widgets/welcome_section.dart';
import 'widgets/chat_input.dart';
import 'sofia_home_controller.dart';  // ✅ Import home controller
import '../../services/activity_tracker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/routes.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';

/// SofIA Home Screen - Welcome and dashboard interface
class SofiaHomeScreen extends StatelessWidget {
  const SofiaHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityTracker = Get.find<ActivityTracker>();
    final controller = Get.put(SofiaHomeController());  // ✅ Use home controller

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          appBar: buildHomeAppBar(),
          body: Column(
            children: [
              Expanded(
                child: WelcomeSection(
                  userName: controller.userName.value,
                  onSuggestionTap: (suggestion) => navigateToChat(suggestion),
                  isLoading: controller.isLoading.value,
                  useCompactLayout: false,
                ),
              ),
              Obx(() => ChatInput(
                onSendMessage: (message) => navigateToChat(message),
                hintText: FinTexts.sofiaChatInputHint,
                isEnabled: !controller.isLoading.value,
                isLoading: controller.isLoading.value,
              )),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget buildHomeAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: true,
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Get.offAllNamed(AppRoutes.home),
        icon: const Icon(Icons.arrow_back, color: FinColors.textWhite),
      ),
      title: null,
      actions: [
        IconButton(
          onPressed: showHomeOptions,
          icon: const Icon(Icons.more_vert, color: FinColors.textWhite),
        ),
      ],
    );
  }

  void navigateToChat([String? message]) {
    if (message != null && message.isNotEmpty) {
      // Navigate with message as argument
      Get.toNamed(AppRoutes.sofiaChat, arguments: {'initialMessage': message});
    } else {
      // Navigate without message
      Get.toNamed(AppRoutes.sofiaChat);
    }
  }

  void showHomeOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(FinSizes.defaultSpace),
        decoration: const BoxDecoration(
          color: FinColors.cardBackground,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FinSizes.borderRadiusLg),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: FinColors.textWhite.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: FinSizes.lg),
            const Text(
              'Opções',
              style: TextStyle(
                fontSize: FinSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: FinColors.textWhite,
              ),
            ),
            const SizedBox(height: FinSizes.lg),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: FinColors.textWhite),
              title: const Text('Limpar histórico', style: TextStyle(color: FinColors.textWhite)),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Em breve',
                  'Função disponível em breve',
                  backgroundColor: FinColors.primary.withValues(alpha: 0.8),
                  colorText: FinColors.textWhite,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}