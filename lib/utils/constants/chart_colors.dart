import 'package:flutter/material.dart';

/// Centralized chart color definitions for consistent chart styling across the app.
/// Based on Figma design specifications from docs/figma-chart-requirements.md
class ChartColors {
  // Prevent instantiation
  ChartColors._();

  // Line chart colors
  static const Color portfolioLine = Color(0xFFBADBC1); // Teal/green - Sua carteira
  static const Color ibovLine = Color(0xFFDFDFE0); // Gray - IBOV (per Figma)
  static const Color cdiLine = Color(0xFFF4A261); // Orange
  static const Color ipcaLine = Color(0xFFE76F51); // Red-orange
  static const Color ifixLine = Color(0xFF9B59B6); // Purple

  // Positive/negative indicators
  static const Color positive = Color(0xFFBADBC1); // Green (Figma: #BADBC1)
  static const Color negative = Color(0xFFFF6B6B); // Red

  // Composition chart (pie/donut)
  static const Color stocks = Color(0xFF5FB3D3); // Blue - Ações
  static const Color realEstate = Color(0xFFBADBC1); // Teal - FIIs
  static const Color fixedIncome = Color(0xFFF4A261); // Orange - Renda Fixa
  static const Color cash = Color(0xFF9B59B6); // Purple - Caixa
  static const Color etfs = Color(0xFF3498DB); // Light blue - ETFs
  static const Color others = Color(0xFFE76F51); // Red-orange - Outros

  // UI elements
  static const Color gridLines = Color(0x1AFFFFFF); // White @ 10%
  static const Color tooltipBackground = Color(0xFF15254E);
  static const Color legendBackground = Color(0xFF15254E);
  static const Color labelColor = Color(0xFF7C7C83);

  // Bar chart colors
  static const Color barPrimary = Color(0xFF1B6FFF);
  static const Color barSecondary = Color(0xFFBADBC1);
  static const Color barDividends = Color(0xFFBADBC1);
  static const Color barJcp = Color(0xFF5FB3D3);

  /// Returns a list of colors for pie/donut charts based on the number of segments
  static List<Color> getCompositionColors(int count) {
    const baseColors = [
      stocks,
      realEstate,
      fixedIncome,
      cash,
      etfs,
      others,
    ];

    if (count <= baseColors.length) {
      return baseColors.take(count).toList();
    }

    // Generate additional colors if needed
    final colors = List<Color>.from(baseColors);
    for (int i = baseColors.length; i < count; i++) {
      colors.add(Color.lerp(stocks, others, i / count)!);
    }
    return colors;
  }

  /// Returns the appropriate color for a percentage change
  static Color getChangeColor(double change) {
    if (change > 0) return positive;
    if (change < 0) return negative;
    return const Color(0xFFDFDFE0); // Neutral
  }

  /// Returns a color for a specific benchmark
  static Color getBenchmarkColor(String benchmark) {
    switch (benchmark.toUpperCase()) {
      case 'IBOV':
        return ibovLine;
      case 'CDI':
        return cdiLine;
      case 'IPCA':
        return ipcaLine;
      case 'IFIX':
        return ifixLine;
      default:
        return ibovLine;
    }
  }

  /// Returns a color for a specific asset type
  static Color getAssetTypeColor(String assetType) {
    switch (assetType.toLowerCase()) {
      case 'ações':
      case 'stocks':
      case 'acoes':
        return stocks;
      case 'fiis':
      case 'fii':
      case 'fundos imobiliários':
        return realEstate;
      case 'renda fixa':
      case 'fixed income':
        return fixedIncome;
      case 'caixa':
      case 'cash':
        return cash;
      case 'etfs':
      case 'etf':
        return etfs;
      default:
        return others;
    }
  }
}
