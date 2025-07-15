import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

/// Portfolio Chart Component
/// Displays a line chart with portfolio performance and legend
class PortfolioChart extends StatelessWidget {
  const PortfolioChart({
    super.key,
    this.height = 200,
    this.portfolioReturn = '9.21%',
    this.benchmarkReturn = '7.13%',
  });

  final double height;
  final String portfolioReturn;
  final String benchmarkReturn;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FinSizes.defaultSpace),
      child: Column(
        children: [
          // Chart area (placeholder for now - you can integrate a real chart library)
          Container(
            height: height,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomPaint(
              painter: _ChartPainter(),
            ),
          ),

          const SizedBox(height: 16),

          // Performance indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPerformanceIndicator(
                portfolioReturn,
                'Sua carteira',
                const Color(0xFFBADBC1),
              ),
              const SizedBox(width: 32),
              _buildPerformanceIndicator(
                benchmarkReturn,
                'IBOV',
                const Color(0xFF39DDA2),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('IBOV', const Color(0xFF5FB3D3)),
              const SizedBox(width: 16),
              _buildLegendItem('Sua carteira', const Color(0xFFBADBC1)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceIndicator(String percentage, String label, Color color) {
    return Column(
      children: [
        Text(
          percentage,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFDFDFE0),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF15254E),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFDFDFE0),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              height: 1.85,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter for drawing a simplified chart
/// You can replace this with a proper chart library like fl_chart
class _ChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Portfolio line (green/teal)
    final portfolioPaint = Paint()
      ..color = const Color(0xFFBADBC1)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // IBOV line (blue)
    final ibovPaint = Paint()
      ..color = const Color(0xFF5FB3D3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 1;

    // Draw vertical grid lines
    for (int i = 0; i <= 4; i++) {
      final x = (size.width / 4) * i;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    // Draw horizontal grid lines
    for (int i = 0; i <= 3; i++) {
      final y = (size.height / 3) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Sample data points for portfolio (trending up)
    final portfolioPoints = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width, size.height * 0.2),
    ];

    // Sample data points for IBOV (more volatile)
    final ibovPoints = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.6),
      Offset(size.width * 0.8, size.height * 0.4),
      Offset(size.width, size.height * 0.3),
    ];

    // Draw portfolio line
    final portfolioPath = Path();
    portfolioPath.moveTo(portfolioPoints.first.dx, portfolioPoints.first.dy);
    for (int i = 1; i < portfolioPoints.length; i++) {
      portfolioPath.lineTo(portfolioPoints[i].dx, portfolioPoints[i].dy);
    }
    canvas.drawPath(portfolioPath, portfolioPaint);

    // Draw IBOV line
    final ibovPath = Path();
    ibovPath.moveTo(ibovPoints.first.dx, ibovPoints.first.dy);
    for (int i = 1; i < ibovPoints.length; i++) {
      ibovPath.lineTo(ibovPoints[i].dx, ibovPoints[i].dy);
    }
    canvas.drawPath(ibovPath, ibovPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}