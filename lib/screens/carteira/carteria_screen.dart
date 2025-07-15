// lib/screens/carteira/carteira_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/app_background.dart';
import '../../common/widgets/fin_bottom_navigation.dart';
import '../../services/activity_tracker.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';

/// Carteira Screen - User's investment portfolio and wallet
///
/// This screen will display the user's investment portfolio,
/// asset allocation, performance metrics, and transaction history.
class CarteiraScreen extends StatelessWidget {
  const CarteiraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityTracker = Get.find<ActivityTracker>();

    return GestureDetector(
      onTap: () => activityTracker.recordActivity(),
      child: AppBackground(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Minha Carteira'),
            automaticallyImplyLeading: false, // No back button for main tabs
            actions: [
              IconButton(
                onPressed: () {
                  // TODO: Add portfolio settings
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
          body: const SingleChildScrollView(
            padding: EdgeInsets.all(FinSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Portfolio Summary
                _PortfolioSummary(),

                SizedBox(height: FinSizes.spaceBtwSections),

                // Asset Allocation
                _SectionHeader(
                  title: 'Alocação de Ativos',
                  subtitle: 'Distribuição da sua carteira',
                ),
                SizedBox(height: FinSizes.spaceBtwItems),
                _AssetAllocation(),

                SizedBox(height: FinSizes.spaceBtwSections),

                // Holdings List
                _SectionHeader(
                  title: 'Seus Investimentos',
                  subtitle: 'Ativos em carteira',
                ),
                SizedBox(height: FinSizes.spaceBtwItems),
                _HoldingsList(),

                SizedBox(height: FinSizes.spaceBtwSections),

                // Recent Transactions
                _SectionHeader(
                  title: 'Transações Recentes',
                  subtitle: 'Últimas movimentações',
                ),
                SizedBox(height: FinSizes.spaceBtwItems),
                _RecentTransactions(),
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
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: FinSizes.fontSizeSm,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

/// Portfolio summary card showing total value and performance
class _PortfolioSummary extends StatelessWidget {
  const _PortfolioSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(FinSizes.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FinColors.primary.withOpacity(0.8),
            FinColors.primary.withOpacity(0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Patrimônio Total',
            style: TextStyle(
              fontSize: FinSizes.fontSizeMd,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: FinSizes.sm),
          const Text(
            'R\$ 147.832,45',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: FinSizes.sm),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: FinSizes.sm,
                  vertical: FinSizes.xs,
                ),
                decoration: BoxDecoration(
                  color: FinColors.success.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(FinSizes.borderRadiusSm),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up,
                      size: 14,
                      color: FinColors.success,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+R\$ 8.432,12 (6.05%)',
                      style: TextStyle(
                        fontSize: FinSizes.fontSizeSm,
                        fontWeight: FontWeight.w600,
                        color: FinColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: FinSizes.sm),
              Text(
                'Este mês',
                style: TextStyle(
                  fontSize: FinSizes.fontSizeSm,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Asset allocation chart placeholder
class _AssetAllocation extends StatelessWidget {
  const _AssetAllocation();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Placeholder for pie chart
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FinColors.primary.withOpacity(0.1),
            ),
            child: const Icon(
              Icons.pie_chart,
              size: 48,
              color: FinColors.primary,
            ),
          ),
          const SizedBox(height: FinSizes.spaceBtwItems),

          // Asset allocation items
          const _AllocationItem(
            label: 'Ações',
            percentage: '65%',
            value: 'R\$ 96.091,09',
            color: FinColors.primary,
          ),
          const SizedBox(height: FinSizes.sm),
          const _AllocationItem(
            label: 'Renda Fixa',
            percentage: '25%',
            value: 'R\$ 36.958,11',
            color: FinColors.success,
          ),
          const SizedBox(height: FinSizes.sm),
          const _AllocationItem(
            label: 'FIIs',
            percentage: '10%',
            value: 'R\$ 14.783,25',
            color: FinColors.warning,
          ),
        ],
      ),
    );
  }
}

/// Holdings list showing individual investments
class _HoldingsList extends StatelessWidget {
  const _HoldingsList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HoldingItem(
          symbol: 'PETR4',
          name: 'Petrobras PN',
          quantity: '200',
          currentPrice: 'R\$ 32,45',
          change: '+2.3%',
          isPositive: true,
        ),
        const SizedBox(height: FinSizes.spaceBtwItems),
        _HoldingItem(
          symbol: 'VALE3',
          name: 'Vale ON',
          quantity: '150',
          currentPrice: 'R\$ 68,22',
          change: '-1.1%',
          isPositive: false,
        ),
        const SizedBox(height: FinSizes.spaceBtwItems),
        _HoldingItem(
          symbol: 'ITUB4',
          name: 'Itaú Unibanco PN',
          quantity: '300',
          currentPrice: 'R\$ 26,89',
          change: '+0.5%',
          isPositive: true,
        ),
      ],
    );
  }
}

/// Recent transactions list
class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _TransactionItem(
          type: 'Compra',
          asset: 'PETR4',
          quantity: '50',
          price: 'R\$ 31,80',
          date: 'Hoje',
          isDebit: true,
        ),
        const SizedBox(height: FinSizes.spaceBtwItems),
        _TransactionItem(
          type: 'Venda',
          asset: 'VALE3',
          quantity: '25',
          price: 'R\$ 69,15',
          date: 'Ontem',
          isDebit: false,
        ),
        const SizedBox(height: FinSizes.spaceBtwItems),
        _TransactionItem(
          type: 'Dividendo',
          asset: 'ITUB4',
          quantity: '300',
          price: 'R\$ 0,015',
          date: '2 dias',
          isDebit: false,
        ),
      ],
    );
  }
}

/// Individual allocation item
class _AllocationItem extends StatelessWidget {
  final String label;
  final String percentage;
  final String value;
  final Color color;

  const _AllocationItem({
    required this.label,
    required this.percentage,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: FinSizes.sm),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: FinSizes.fontSizeMd,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: FinSizes.fontSizeMd,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: FinSizes.sm),
        Text(
          value,
          style: TextStyle(
            fontSize: FinSizes.fontSizeSm,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}

/// Individual holding item
class _HoldingItem extends StatelessWidget {
  final String symbol;
  final String name;
  final String quantity;
  final String currentPrice;
  final String change;
  final bool isPositive;

  const _HoldingItem({
    required this.symbol,
    required this.name,
    required this.quantity,
    required this.currentPrice,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Asset info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeSm,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                Text(
                  '$quantity cotas',
                  style: TextStyle(
                    fontSize: FinSizes.md,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),

          // Price and change
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currentPrice,
                style: const TextStyle(
                  fontSize: FinSizes.fontSizeMd,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                change,
                style: TextStyle(
                  fontSize: FinSizes.fontSizeSm,
                  fontWeight: FontWeight.w500,
                  color: isPositive ? FinColors.success : FinColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual transaction item
class _TransactionItem extends StatelessWidget {
  final String type;
  final String asset;
  final String quantity;
  final String price;
  final String date;
  final bool isDebit;

  const _TransactionItem({
    required this.type,
    required this.asset,
    required this.quantity,
    required this.price,
    required this.date,
    required this.isDebit,
  });

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;

    switch (type) {
      case 'Compra':
        icon = Icons.add_circle;
        iconColor = FinColors.primary;
        break;
      case 'Venda':
        icon = Icons.remove_circle;
        iconColor = FinColors.warning;
        break;
      case 'Dividendo':
        icon = Icons.monetization_on;
        iconColor = FinColors.success;
        break;
      default:
        icon = Icons.swap_horiz;
        iconColor = FinColors.darkGrey;
    }

    return Container(
      padding: const EdgeInsets.all(FinSizes.md),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Transaction icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),

          const SizedBox(width: FinSizes.md),

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type $asset',
                  style: const TextStyle(
                    fontSize: FinSizes.fontSizeMd,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '$quantity x $price',
                  style: TextStyle(
                    fontSize: FinSizes.fontSizeSm,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // Date
          Text(
            date,
            style: TextStyle(
              fontSize: FinSizes.fontSizeSm,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}