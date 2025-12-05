// lib/screens/conjuntura/conjuntura_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/fin_bottom_navigation.dart';
import '../../services/activity_tracker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// Conjuntura Screen - Market analysis and economic indicators
///
/// This screen will display economic indicators, market trends,
/// and analysis tools for users to understand market conditions
/// and make informed investment decisions.
class ConjunturaScreen extends StatelessWidget {
  const ConjunturaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityTracker = Get.find<ActivityTracker>();

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Conjuntura'),
            automaticallyImplyLeading: false, // No back button for main tabs
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Add market analysis filters/settings
                },
                icon: const Icon(Icons.filter_list),
              ),
            ],
          ),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(FinSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Market Overview Section
                _SectionHeader(
                  title: 'Visão Geral do Mercado',
                  subtitle: 'Principais indicadores econômicos',
                ),
                SizedBox(height: FinSizes.spaceBtwItems),
                _MarketOverviewCards(),

                SizedBox(height: FinSizes.spaceBtwSections),

                // Economic Indicators Section
                _SectionHeader(
                  title: 'Indicadores Econômicos',
                  subtitle: 'Acompanhe os principais índices',
                ),
                SizedBox(height: FinSizes.spaceBtwItems),
                _EconomicIndicators(),

                SizedBox(height: FinSizes.spaceBtwSections),

                // Market Analysis Section
                _SectionHeader(
                  title: 'Análise de Mercado',
                  subtitle: 'Insights e tendências',
                ),
                SizedBox(height: FinSizes.spaceBtwItems),
                _MarketAnalysisSection(),
              ],
            ),
          ),
          bottomNavigationBar: const FinBottomNavigation(),
        ),
      ),
    );
  }
}

/// Section header widget for consistent styling
class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeXLg,
            fontWeight: FontWeight.w600,
            color: FinColors.textWhite,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: FinSizes.fontSizeSm,
            color: FinColors.textWhite.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

/// Market overview cards showing key metrics
class _MarketOverviewCards extends StatelessWidget {
  const _MarketOverviewCards();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _MetricCard(
            title: 'IBOVESPA',
            value: '118.234',
            change: '+2.45%',
            isPositive: true,
            icon: Icons.trending_up,
          ),
        ),
        SizedBox(width: FinSizes.spaceBtwItems),
        Expanded(
          child: _MetricCard(
            title: 'SELIC',
            value: '12.75%',
            change: 'Sem alteração',
            isPositive: null,
            icon: Icons.percent,
          ),
        ),
      ],
    );
  }
}

/// Economic indicators list
class _EconomicIndicators extends StatelessWidget {
  const _EconomicIndicators();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _IndicatorItem(
          name: 'IPCA (Inflação)',
          value: '4.62%',
          period: 'Últimos 12 meses',
          trend: 'stable',
        ),
        const SizedBox(height: FinSizes.spaceBtwItems),
        _IndicatorItem(
          name: 'PIB',
          value: '+2.9%',
          period: 'Crescimento anual',
          trend: 'up',
        ),
        const SizedBox(height: FinSizes.spaceBtwItems),
        _IndicatorItem(
          name: 'Desemprego',
          value: '8.9%',
          period: 'Taxa atual',
          trend: 'down',
        ),
      ],
    );
  }
}

/// Market analysis section placeholder
class _MarketAnalysisSection extends StatelessWidget {
  const _MarketAnalysisSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: FinColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        border: Border.all(
          color: FinColors.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.analytics,
            size: 48,
            color: FinColors.primary,
          ),
          const SizedBox(height: FinSizes.spaceBtwItems),
          const Text(
            'Análises Avançadas',
            style: TextStyle(
              fontSize: FinSizes.fontSizeLg,
              fontWeight: FontWeight.w600,
              color: FinColors.textWhite,
            ),
          ),
          const SizedBox(height: FinSizes.sm),
          Text(
            'Gráficos interativos, análise técnica e insights do mercado serão implementados aqui.',
            style: TextStyle(
              fontSize: FinSizes.fontSizeSm,
              color: FinColors.textWhite.withOpacity(0.8),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: FinSizes.spaceBtwItems),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FinSizes.sm,
              vertical: FinSizes.xs,
            ),
            decoration: BoxDecoration(
              color: FinColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(FinSizes.borderRadiusSm),
            ),
            child: const Text(
              'Em desenvolvimento',
              style: TextStyle(
                fontSize: FinSizes.md,
                fontWeight: FontWeight.w500,
                color: FinColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual metric card widget
class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final String change;
  final bool? isPositive;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.change,
    required this.isPositive,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    Color changeColor = FinColors.textWhite.withOpacity(0.7);
    if (isPositive == true) changeColor = FinColors.success;
    if (isPositive == false) changeColor = FinColors.error;

    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        border: Border.all(
          color: FinColors.textWhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: FinSizes.fontSizeSm,
                  color: FinColors.textWhite.withOpacity(0.7),
                ),
              ),
              Icon(
                icon,
                size: 16,
                color: FinColors.primary,
              ),
            ],
          ),
          const SizedBox(height: FinSizes.sm),
          Text(
            value,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeLg,
              fontWeight: FontWeight.w600,
              color: FinColors.textWhite,
            ),
          ),
          const SizedBox(height: FinSizes.xs),
          Text(
            change,
            style: TextStyle(
              fontSize: FinSizes.md,
              fontWeight: FontWeight.w500,
              color: changeColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual indicator item widget
class _IndicatorItem extends StatelessWidget {
  final String name;
  final String value;
  final String period;
  final String trend; // 'up', 'down', 'stable'

  const _IndicatorItem({
    required this.name,
    required this.value,
    required this.period,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    IconData trendIcon;
    Color trendColor;

    switch (trend) {
      case 'up':
        trendIcon = Icons.trending_up;
        trendColor = FinColors.success;
        break;
      case 'down':
        trendIcon = Icons.trending_down;
        trendColor = FinColors.error;
        break;
      default:
        trendIcon = Icons.trending_flat;
        trendColor = FinColors.textWhite.withOpacity(0.7);
    }

    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        border: Border.all(
          color: FinColors.textWhite.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                    color: FinColors.textWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  period,
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeSm,
                    color: FinColors.textWhite.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: FinSizes.fontSizeLg,
                  fontWeight: FontWeight.w600,
                  color: FinColors.textWhite,
                ),
              ),
              Icon(
                trendIcon,
                size: 16,
                color: trendColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}