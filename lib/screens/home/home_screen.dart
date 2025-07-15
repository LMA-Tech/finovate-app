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
import '../../services/activity_tracker.dart';
import '../../services/session_manager.dart';

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
                    userName: _getUserFirstName(sessionManager.userEmail ?? ''),
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

                  // Portfolio chart
                  const PortfolioChart(),

                  const SizedBox(height: 32),

                  // Stocks section
                  StocksGrid(
                    title: 'Bolsa',
                    onSeeMorePressed: _handleStocksSeeMore,
                    stocks: _getSampleStocks(),
                  ),

                  const SizedBox(height: 32),

                  // Economy section
                  EconomySection(
                    onSeeMorePressed: _handleEconomySeeMore,
                    indicators: _getSampleEconomyData(),
                  ),

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

  /// Extract first name from email
  String _getUserFirstName(String email) {
    if (email.isEmpty) return 'Usuário';

    // For demo purposes, extract from email
    // In real app, you'd get this from user profile
    final username = email.split('@').first;
    return username.split('.').first.capitalize ?? 'Usuário';
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

  /// Handle portfolio see more
  void _handlePortfolioSeeMore() {
    // TODO: Navigate to detailed portfolio screen
    Get.snackbar(
      'Portfolio',
      'Navegando para detalhes da carteira...',
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Handle stocks see more
  void _handleStocksSeeMore() {
    // TODO: Navigate to stocks screen
    Get.snackbar(
      'Bolsa',
      'Navegando para bolsa...',
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Handle economy see more
  void _handleEconomySeeMore() {
    // TODO: Navigate to economy screen
    Get.snackbar(
      'Economia',
      'Navegando para indicadores econômicos...',
      snackPosition: SnackPosition.TOP,
    );
  }

  /// Handle feedback button press
  void _handleFeedbackPressed() {
    // TODO: Open feedback form or navigate to feedback screen
    Get.snackbar(
      'Feedback',
      'Obrigado! Funcionalidade em desenvolvimento',
      snackPosition: SnackPosition.TOP,
    );
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
}