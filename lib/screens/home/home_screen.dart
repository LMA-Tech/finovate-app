import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/charts/custom_line_chart.dart';
import '../../common/widgets/error_state.dart';
import '../../common/widgets/fin_bottom_navigation.dart';
import '../../common/widgets/skeleton_loader.dart';
import '../../controllers/bottom_navigation_controller.dart';
import '../../models/models.dart';
import '../../services/activity_tracker.dart';
import '../../services/finovate_api_service.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/routes.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../stocks/stock_detail_screen.dart';
import 'widgets/b3_connection_banner.dart';
import 'widgets/composicao_section.dart';
import 'widgets/economy_section.dart';
import 'widgets/feedback_button.dart';
import 'widgets/home_header.dart';
import 'widgets/portfolio_chart.dart';
import 'widgets/portfolio_section.dart';
import 'widgets/stock_card.dart';

part 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  createState() => _HomeScreen();
}

class _HomeScreen extends HomeController {
  @override
  Widget build(BuildContext context) {
    final sessionManager = Get.find<SessionManager>();
    final activityTracker = Get.find<ActivityTracker>();

    // Sync bottom nav tab when home screen appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<BottomNavigationController>()) {
        final bottomNav = Get.find<BottomNavigationController>();
        // Only sync if we're actually on home route
        if (Get.currentRoute == AppRoutes.home) {
          bottomNav.syncWithCurrentRoute();
        }
      }
    });

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          body: SafeArea(
            child: Obx(() {
              // Show full-screen skeleton while loading
              if (isLoading.value) {
                return _buildFullScreenSkeleton();
              }

              // Show error state with retry if there's an error
              if (error.value.isNotEmpty) {
                return ErrorState(
                  title: FinTexts.homeErrorTitle,
                  message: FinTexts.homeErrorMessage,
                  onRetry: refreshData,
                );
              }

              // Show content with pull-to-refresh
              return RefreshIndicator(
                onRefresh: refreshData,
                color: FinColors.primary,
                backgroundColor: FinColors.cardBackground,
                child: _buildHomeContent(sessionManager, activityTracker),
              );
            }),
          ),
          bottomNavigationBar: const FinBottomNavigation(),
        ),
      ),
    );
  }

  /// Build the full home screen content once data is loaded
  Widget _buildHomeContent(SessionManager sessionManager, ActivityTracker activityTracker) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Header with greeting and notification
          HomeHeader(
            userName: userName,
            userPhotoUrl: sessionManager.userPhotoUrl,
            hasNotification: hasNotifications,
            onNotificationPressed: _handleNotificationPressed,
          ),

          const SizedBox(height: FinSizes.xl), // 32

          // B3 connection banner (only show if not connected)
          if (!b3Connected) const B3ConnectionBanner(),

          const SizedBox(height: FinSizes.xl), // 32

          // Portfolio section with tabs and filters
          Obx(() => PortfolioSection(
            selectedTab: selectedTab.value,
            selectedPeriod: selectedPeriod.value,
            onTabChanged: (index) => selectedTab.value = index,
            onPeriodChanged: (index) => selectedPeriod.value = index,
            onSeeMorePressed: _handlePortfolioSeeMore,
          )),

          const SizedBox(height: FinSizes.lg), // 24

          // Portfolio chart or composicao based on selected tab
          Obx(() => selectedTab.value == 2
              // Composicao tab - show pie chart or B3 connection prompt
              ? ComposicaoSection(
                  b3Connected: b3Connected,
                  composicaoData: composicaoData,
                )
              // Rentabilidade or Risco tab - show line chart or risk gauge
              : PortfolioChart(
                  b3Connected: b3Connected,
                  benchmarkData: getIbovChartData(),
                  benchmarkReturn: ibovReturnPercent,
                  portfolioData: getPortfolioChartData(),
                  portfolioReturn: portfolioReturnPercent ?? 0.0,
                  hasPortfolioHistory: hasPortfolioHistory,
                  selectedTab: selectedTab.value,
                  ibovRiscoData: currentIbovRiscoData,
                  portfolioRiscoData: currentPortfolioRiscoData,
                )),

          const SizedBox(height: 32),

          // Stocks section
          StocksGrid(
            title: 'Bolsa',
            onSeeMorePressed: _handleStocksSeeMore,
            stocks: getStockDataList(),
          ),

          const SizedBox(height: 32),

          // Economy section
          EconomySection(
            onSeeMorePressed: _handleEconomySeeMore,
            indicators: getIndicatorDataList(),
          ),

          const SizedBox(height: 32),

          // Feedback button
          FeedbackButton(
            onPressed: _handleFeedbackPressed,
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Handle notification press
  void _handleNotificationPressed() {
    // TODO: Navigate to notifications screen
    Get.snackbar(
      'Notificações',
      'Funcionalidade em desenvolvimento',
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Handle portfolio see more - Navigate to Carteira tab
  void _handlePortfolioSeeMore() {
    final bottomNav = Get.find<BottomNavigationController>();
    bottomNav.changeTab(3); // Carteira tab
  }

  /// Handle stocks see more - Navigate to Stocks list screen
  void _handleStocksSeeMore() {
    Get.toNamed(AppRoutes.stocks);
  }

  /// Handle economy see more - Navigate to Conjuntura tab
  void _handleEconomySeeMore() {
    final bottomNav = Get.find<BottomNavigationController>();
    bottomNav.changeTab(1); // Conjuntura tab
  }

  /// Handle feedback button press - Navigate to feedback flow
  void _handleFeedbackPressed() {
    Get.toNamed(AppRoutes.feedback);
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SKELETON LOADERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build full-screen skeleton while initial data loads
  Widget _buildFullScreenSkeleton() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Header skeleton (greeting + avatar + notification)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLoader.text(width: 80, height: 14),
                    const SizedBox(height: 8),
                    SkeletonLoader.text(width: 140, height: 20),
                  ],
                ),
                Row(
                  children: [
                    SkeletonLoader.circle(size: 40),
                    const SizedBox(width: 12),
                    SkeletonLoader.circle(size: 40),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            // B3 banner skeleton
            SkeletonLoader.card(height: 80, borderRadius: 12),

            const SizedBox(height: 32),

            // Portfolio section header skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader.text(width: 100, height: 18),
                SkeletonLoader.text(width: 60, height: 14),
              ],
            ),
            const SizedBox(height: 16),
            // Tab pills skeleton
            Row(
              children: [
                SkeletonLoader.card(width: 100, height: 32, borderRadius: 16),
                const SizedBox(width: 8),
                SkeletonLoader.card(width: 80, height: 32, borderRadius: 16),
                const SizedBox(width: 8),
                SkeletonLoader.card(width: 100, height: 32, borderRadius: 16),
              ],
            ),

            const SizedBox(height: 24),

            // Chart skeleton
            SkeletonLoader.card(height: 200, borderRadius: 12),

            const SizedBox(height: 32),

            // Stocks section skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader.text(width: 60, height: 16),
                SkeletonLoader.text(width: 60, height: 14),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  Expanded(child: SkeletonLoader.card(height: 120, borderRadius: 12)),
                  const SizedBox(width: 12),
                  Expanded(child: SkeletonLoader.card(height: 120, borderRadius: 12)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Economy section skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonLoader.text(width: 80, height: 16),
                SkeletonLoader.text(width: 60, height: 14),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  Expanded(child: SkeletonLoader.card(height: 120, borderRadius: 12)),
                  const SizedBox(width: 12),
                  Expanded(child: SkeletonLoader.card(height: 120, borderRadius: 12)),
                  const SizedBox(width: 12),
                  Expanded(child: SkeletonLoader.card(height: 120, borderRadius: 12)),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

}