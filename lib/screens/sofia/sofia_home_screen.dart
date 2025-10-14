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
                  onSuggestionTap: (suggestion) => navigateToChat(),
                  isLoading: controller.isLoading.value,
                  useCompactLayout: false,
                ),
              ),
              Obx(() => ChatInput(
                onSendMessage: (message) => navigateToChat(),
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
        icon: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      title: null,
      actions: [
        IconButton(
          onPressed: showHomeOptions,
          icon: const Icon(Icons.more_vert, color: Colors.white),
        ),
      ],
    );
  }

  void navigateToChat() {
    Get.toNamed(AppRoutes.sofiaChat);
  }

  void showHomeOptions() {
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
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: FinSizes.lg),
            const Text(
              'Opções',
              style: TextStyle(
                fontSize: FinSizes.fontSizeLg,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: FinSizes.lg),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.white),
              title: const Text('Limpar histórico', style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                Get.snackbar(
                  'Em breve',
                  'Função disponível em breve',
                  backgroundColor: FinColors.primary.withValues(alpha: 0.8),
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}