import 'package:flutter/material.dart';
import '../../../common/widgets/charts/custom_pie_chart.dart';
import '../../../models/dashboard_summary.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Composicao (Asset Allocation) Section Component
/// Shows pie chart with asset allocation breakdown when B3 is connected
/// Shows connection prompt when B3 is not connected
class ComposicaoSection extends StatelessWidget {
  const ComposicaoSection({
    super.key,
    required this.b3Connected,
    this.composicaoData,
    this.height = 200,
  });

  final bool b3Connected;
  final ComposicaoData? composicaoData;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    // Not connected to B3
    if (!b3Connected) {
      return _buildConnectionPrompt();
    }

    // Connected but no data available
    if (composicaoData == null || !composicaoData!.available) {
      return _buildDataUnavailable();
    }

    // Has data - show pie chart with breakdown
    return _buildPieChart();
  }

  Widget _buildConnectionPrompt() {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.link_off_rounded,
                size: 40,
                color: FinColors.textGray300,
              ),
              SizedBox(height: 16),
              Text(
                'Conecte sua conta B3',
                style: TextStyle(
                  color: FinColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Para visualizar a composição da sua carteira, conecte sua conta da B3.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FinColors.textGray300,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataUnavailable() {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: FinColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty_rounded,
                size: 40,
                color: FinColors.textGray300,
              ),
              SizedBox(height: 16),
              Text(
                'Dados em processamento',
                style: TextStyle(
                  color: FinColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Estamos processando os dados da sua carteira. Volte em alguns minutos.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FinColors.textGray300,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final breakdown = composicaoData!.breakdown;

    if (breakdown.isEmpty) {
      return _buildDataUnavailable();
    }

    // Convert breakdown to pie chart segments
    final segments = breakdown.map((item) {
      return PieChartSegment(
        label: item.label,
        value: item.value,
        percentage: item.percentage,
        color: _getColorForType(item.type),
        formattedValue: item.formattedValue,
      );
    }).toList();

    // Format update date
    String updateDateText = '';
    if (composicaoData!.updatedAt != null) {
      final date = composicaoData!.updatedAt!;
      final months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
      updateDateText = 'Data de atualização: ${date.day} de ${months[date.month - 1]} ${date.year}';
    }

    return Column(
      children: [
        // Update date text
        if (updateDateText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              updateDateText,
              style: const TextStyle(
                color: FinColors.textGray200,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.1,
              ),
            ),
          ),

        // Pie chart with legend
        SizedBox(
          height: height - 40,
          child: Row(
            children: [
              // Pie chart on the left
              Expanded(
                flex: 1,
                child: Center(
                  child: CustomPieChart(
                    segments: segments,
                    size: 140,
                    strokeWidth: 28,
                    showLabels: false,
                    showCenterContent: false,
                  ),
                ),
              ),

              // Legend on the right
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: segments.map((segment) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: FinColors.tooltipBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: segment.color,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              segment.label ?? '',
                              style: const TextStyle(
                                color: FinColors.textGray200,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'renda_variavel':
        return FinColors.navy;
      case 'renda_fixa':
        return FinColors.composicaoRendaFixa;
      case 'fundos':
        return FinColors.warning;
      case 'crypto':
        return FinColors.info;
      default:
        return FinColors.textGray300;
    }
  }
}
