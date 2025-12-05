import 'package:finovate_app/screens/home/widgets/b3_connection_banner.dart';
import 'package:finovate_app/screens/home/widgets/economy_section.dart';
import 'package:finovate_app/screens/home/widgets/feedback_button.dart';
import 'package:finovate_app/screens/home/widgets/home_header.dart';
import 'package:finovate_app/screens/home/widgets/portfolio_chart.dart';
import 'package:finovate_app/screens/home/widgets/portfolio_section.dart';
import 'package:finovate_app/screens/home/widgets/stock_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/app_background.dart';
import '../../common/widgets/fin_bottom_navigation.dart';
import '../../common/widgets/skeleton_loader.dart';
import '../../controllers/bottom_navigation_controller.dart';
import '../../services/activity_tracker.dart';
import '../../services/session_manager.dart';
import '../../utils/constants/routes.dart';
import '../../utils/constants/sizes.dart';

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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Header with greeting and notification
                  Obx(() => HomeHeader(
                    userName: sessionManager.userFullName ?? 'Usuário',
                    userPhotoUrl: sessionManager.userPhotoUrl,
                    hasNotification: true,
                    onNotificationPressed: _handleNotificationPressed,
                  )),

                  const SizedBox(height: 32),

                  // B3 connection banner
                  const B3ConnectionBanner(),

                  const SizedBox(height: 32),

                  // Portfolio section with tabs and filters
                  Obx(() => PortfolioSection(
                    selectedTab: selectedTab.value,
                    selectedPeriod: selectedPeriod.value,
                    onTabChanged: (index) => selectedTab.value = index,
                    onPeriodChanged: (index) => selectedPeriod.value = index,
                    onSeeMorePressed: _handlePortfolioSeeMore,
                  )),

                  const SizedBox(height: 24),

                  // Portfolio chart with skeleton loading
                  Obx(() => isPortfolioLoading.value
                      ? _buildPortfolioSkeleton()
                      : const PortfolioChart()),

                  const SizedBox(height: 32),

                  // Stocks section with skeleton loading
                  Obx(() => isStocksLoading.value
                      ? _buildStocksSkeleton()
                      : StocksGrid(
                          title: 'Bolsa',
                          onSeeMorePressed: _handleStocksSeeMore,
                          stocks: _getSampleStocks(),
                        )),

                  const SizedBox(height: 32),

                  // Economy section with skeleton loading
                  Obx(() => isEconomyLoading.value
                      ? _buildEconomySkeleton()
                      : EconomySection(
                          onSeeMorePressed: _handleEconomySeeMore,
                          indicators: _getSampleEconomyData(),
                        )),

                  const SizedBox(height: 32),

                  // Feedback button
                  FeedbackButton(
                    onPressed: _handleFeedbackPressed,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          bottomNavigationBar: const FinBottomNavigation(),
        ),
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

  /// Handle stocks see more - Navigate to Conjuntura tab (market section)
  void _handleStocksSeeMore() {
    final bottomNav = Get.find<BottomNavigationController>();
    bottomNav.changeTab(1); // Conjuntura tab
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

  /// Sample stocks data
  List<StockData> _getSampleStocks() {
    return [
      const StockData(
        symbol: 'AMZN',
        companyName: 'Amazon Inc',
        price: '\$ 443.01',
        change: '+ \$ 9.45',
        changePercent: '1.89%',
        isPositive: true,
      ),
      const StockData(
        symbol: 'ADBE',
        companyName: 'Adobe Inc',
        price: '\$ 1,842.01',
        change: '- \$ 4.28',
        changePercent: '0.21%',
        isPositive: false,
      ),
      const StockData(
        symbol: 'AAPL',
        companyName: 'Apple Inc',
        price: '\$ 178.85',
        change: '+ \$ 2.15',
        changePercent: '1.22%',
        isPositive: true,
      ),
    ];
  }

  /// Sample economy data
  List<EconomyIndicatorData> _getSampleEconomyData() {
    return [
      const EconomyIndicatorData(
        title: 'Dólar',
        change: '+ \$ 2.45',
        changePercent: '1.89%',
        isPositive: true,
      ),
      const EconomyIndicatorData(
        title: 'Taxa de juros',
        changePercent: '1.89%',
        isPositive: true,
      ),
      const EconomyIndicatorData(
        title: 'IPCA',
        value: '4.56%',
        changePercent: '+0.12%',
        isPositive: false,
      ),
    ];
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SKELETON LOADERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Build skeleton loader for portfolio chart section
  Widget _buildPortfolioSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: SkeletonChart(height: 200),
    );
  }

  /// Build skeleton loader for stocks section
  Widget _buildStocksSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLoader.text(width: 60, height: 16),
              SkeletonLoader.text(width: 60, height: 14),
            ],
          ),
          const SizedBox(height: 16),
          // Cards skeleton
          SkeletonCardGrid(
            itemCount: 3,
            cardHeight: 120,
            cardWidth: 160,
            scrollDirection: Axis.horizontal,
          ),
        ],
      ),
    );
  }

  /// Build skeleton loader for economy section
  Widget _buildEconomySkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLoader.text(width: 80, height: 16),
              SkeletonLoader.text(width: 60, height: 14),
            ],
          ),
          const SizedBox(height: 16),
          // Cards skeleton
          SkeletonCardGrid(
            itemCount: 3,
            cardHeight: 80,
            cardWidth: 140,
            scrollDirection: Axis.horizontal,
          ),
        ],
      ),
    );
  }
}