# Chart Requirements from Figma Designs

**Review Date:** 2025-12-02
**Source:** Home screen Figma designs and analysis
**Related Review:** `figma-review-home.md`

## Overview

Based on the Figma designs for the Finovate app, the following chart types and specifications have been identified. This document serves as a technical specification for implementing charts across the application.

## 1. Line Chart (Portfolio Performance)

### Primary Use Case
Display portfolio performance vs benchmark (IBOV) over time with comparative analysis.

### Location
Home screen - Portfolio section (Rentabilidade tab)

### Technical Specifications

#### Chart Dimensions
```dart
const double chartHeight = 200.0;
const double chartWidth = double.infinity; // Full container width
const EdgeInsets chartPadding = EdgeInsets.symmetric(horizontal: 24.0);
```

#### Data Model
```dart
class PortfolioChartData {
  final DateTime date;
  final double portfolioValue;
  final double benchmarkValue;

  PortfolioChartData({
    required this.date,
    required this.portfolioValue,
    required this.benchmarkValue,
  });
}

// Example data structure
List<PortfolioChartData> sampleData = [
  PortfolioChartData(
    date: DateTime(2025, 1, 1),
    portfolioValue: 100.0,
    benchmarkValue: 100.0,
  ),
  // ... more data points
];
```

#### Visual Specifications

**Grid Lines:**
- **Vertical lines:** 5 evenly spaced
- **Horizontal lines:** 4 evenly spaced
- **Color:** `Colors.white.withOpacity(0.1)`
- **Stroke width:** 1.0

**Data Lines:**
```dart
// Portfolio line
final portfolioLinePaint = Paint()
  ..color = Color(0xFFBADBC1)  // Teal/green
  ..strokeWidth = 2.0
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round;

// IBOV benchmark line
final ibovLinePaint = Paint()
  ..color = Color(0xFF5FB3D3)  // Blue
  ..strokeWidth = 2.0
  ..style = PaintingStyle.stroke
  ..strokeCap = StrokeCap.round;
```

**Line Style:**
- Smooth curves (use cubic bezier or similar smoothing)
- No fill under lines (stroke only)
- Rounded line caps

#### Interactive Elements

**Tooltip on Touch/Hover:**
```dart
class ChartTooltip {
  final DateTime date;
  final double portfolioValue;
  final double ibovValue;

  // Display format
  String get dateLabel => 'dd de MMM yyyy'; // e.g., "5 de Fev 2025"
  String get portfolioLabel => '${portfolioValue.toStringAsFixed(2)}%';
  String get ibovLabel => '${ibovValue.toStringAsFixed(2)}%';
}

// Tooltip styling
const tooltipBackground = Color(0xFF15254E);
const tooltipBorderRadius = 8.0;
const tooltipPadding = EdgeInsets.all(12.0);
const tooltipTextColor = Colors.white;
```

#### Performance Indicators (Above Chart)

**Layout:**
Two columns showing return percentages

**Left Indicator (Portfolio):**
```dart
Text(
  '9.21%',  // Dynamic value
  style: TextStyle(
    color: Color(0xFFBADBC1),  // Green/teal
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.33,
  ),
)
Text(
  'Sua carteira',
  style: TextStyle(
    color: Color(0xFFDFDFE0),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
)
```

**Right Indicator (IBOV):**
```dart
Text(
  '7.13%',  // Dynamic value
  style: TextStyle(
    color: Color(0xFF5FB3D3),  // Blue (or green if positive)
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.33,
  ),
)
Text(
  'IBOV',
  style: TextStyle(
    color: Color(0xFFDFDFE0),
    fontSize: 12,
    fontWeight: FontWeight.w500,
  ),
)
```

#### Legend (Below Chart)

**Pill Style:**
```dart
Container(
  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  decoration: BoxDecoration(
    color: Color(0xFF15254E),
    borderRadius: BorderRadius.circular(6),
  ),
  child: Row(
    children: [
      // Colored dot
      Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: lineColor,  // #5FB3D3 or #BADBC1
          shape: BoxShape.circle,
        ),
      ),
      SizedBox(width: 4),
      // Label
      Text(
        label,  // "IBOV" or "Sua carteira"
        style: TextStyle(
          color: Color(0xFFDFDFE0),
          fontSize: 13,
          fontWeight: FontWeight.w500,
          height: 1.85,
          letterSpacing: 0.1,
        ),
      ),
    ],
  ),
)
```

**Legend Items:**
- IBOV: Color #5FB3D3
- Sua carteira: Color #BADBC1

### Recommended Implementation

**Option 1: fl_chart (Recommended)**
```yaml
dependencies:
  fl_chart: ^0.66.0
```

**Pros:**
- Free and open source
- Well-maintained
- Extensive customization
- Good performance
- Built-in touch interactions

**Example Implementation:**
```dart
LineChart(
  LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: true,
      horizontalInterval: 1,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white.withOpacity(0.1),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: Colors.white.withOpacity(0.1),
          strokeWidth: 1,
        );
      },
    ),
    lineBarsData: [
      // Portfolio line
      LineChartBarData(
        spots: portfolioDataPoints,
        color: Color(0xFFBADBC1),
        barWidth: 2,
        isCurved: true,
        dotData: FlDotData(show: false),
      ),
      // IBOV line
      LineChartBarData(
        spots: ibovDataPoints,
        color: Color(0xFF5FB3D3),
        barWidth: 2,
        isCurved: true,
        dotData: FlDotData(show: false),
      ),
    ],
    // ... more configuration
  ),
)
```

**Option 2: syncfusion_flutter_charts**
```yaml
dependencies:
  syncfusion_flutter_charts: ^24.2.9
```

**Pros:**
- More features out of the box
- Professional-grade
- Better animations

**Cons:**
- Requires commercial license for production
- Larger package size

## 2. Pie Chart (Portfolio Composition)

### Primary Use Case
Display portfolio asset allocation breakdown by type or sector.

### Location
Home screen - Portfolio section (Composição tab)

### Expected Data Structure
```dart
class CompositionData {
  final String category;  // e.g., "Ações", "FIIs", "Renda Fixa"
  final double percentage;
  final double value;
  final Color color;

  CompositionData({
    required this.category,
    required this.percentage,
    required this.value,
    required this.color,
  });
}
```

### Visual Specifications (Estimated)

**Chart Style:**
- Donut chart (pie chart with center hole)
- Center shows total portfolio value
- Segments colored by category

**Typical Colors:**
- Ações (Stocks): #5FB3D3 (blue)
- FIIs (Real Estate Funds): #BADBC1 (teal)
- Renda Fixa (Fixed Income): #F4A261 (orange)
- Outros (Others): #E76F51 (red)

**Legend:**
- List below or beside chart
- Each item: colored square + category name + percentage

**Center Label:**
```dart
Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text(
      'R\$ 50.000,00',  // Total value
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    Text(
      'Total',
      style: TextStyle(
        color: Color(0xFFDFDFE0),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    ),
  ],
)
```

### Recommended Implementation

**Using fl_chart:**
```dart
PieChart(
  PieChartData(
    centerSpaceRadius: 60,
    sections: compositionData.map((data) {
      return PieChartSectionData(
        value: data.percentage,
        color: data.color,
        title: '${data.percentage.toStringAsFixed(1)}%',
        radius: 50,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      );
    }).toList(),
  ),
)
```

## 3. Sparkline Charts (Economy Indicators)

### Primary Use Case
Show quick trend visualization for economy indicators.

### Location
Home screen - Economy section cards

### Technical Specifications

**Dimensions:**
- Width: ~50px
- Height: ~20-25px
- Positioned in bottom-right of economy card

**Data Structure:**
```dart
class SparklineData {
  final List<double> values;
  final bool isPositive;

  SparklineData({
    required this.values,
    required this.isPositive,
  });
}
```

**Visual Style:**
- Simple line or area chart
- No axes or labels
- Color based on trend direction:
  - Positive trend: Green (#39DDA2 or similar)
  - Negative trend: Red (#FF6B6B or similar)

**Implementation (Custom or Library):**

**Option 1: Custom Painter**
```dart
class SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - (data[i] * size.height);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
```

**Option 2: flutter_sparkline package**
```yaml
dependencies:
  flutter_sparkline: ^0.1.0
```

## 4. Bar Chart (Not Yet Identified)

### Potential Use Cases
Based on typical financial apps, bar charts may be used for:
- Monthly spending breakdown
- Asset performance comparison
- Historical returns by period

### Specifications (To Be Determined)
**Status:** Not explicitly shown in current Figma designs reviewed.

**If needed, typical specifications:**
```dart
class BarChartData {
  final String label;
  final double value;
  final Color color;

  BarChartData({
    required this.label,
    required this.value,
    required this.color,
  });
}
```

## Color Palette for Charts

### Primary Chart Colors
```dart
class ChartColors {
  // Line chart colors
  static const Color portfolioLine = Color(0xFFBADBC1);  // Teal/green
  static const Color ibovLine = Color(0xFF5FB3D3);       // Blue

  // Positive/negative indicators
  static const Color positive = Color(0xFF39DDA2);       // Green
  static const Color negative = Color(0xFFFF6B6B);       // Red

  // Composition chart (estimated)
  static const Color stocks = Color(0xFF5FB3D3);         // Blue
  static const Color realEstate = Color(0xFFBADBC1);     // Teal
  static const Color fixedIncome = Color(0xFFF4A261);    // Orange
  static const Color others = Color(0xFFE76F51);         // Red-orange

  // UI elements
  static const Color gridLines = Color(0x1AFFFFFF);      // White @ 10%
  static const Color tooltipBackground = Color(0xFF15254E);
  static const Color legendBackground = Color(0xFF15254E);
}
```

## Package Recommendations

### Primary Recommendation: fl_chart

**Installation:**
```yaml
dependencies:
  fl_chart: ^0.66.0
```

**Reasons:**
1. ✅ Free and open source (MIT license)
2. ✅ Covers all chart types needed:
   - Line charts
   - Pie/donut charts
   - Bar charts
3. ✅ Highly customizable
4. ✅ Good performance
5. ✅ Active maintenance
6. ✅ Built-in touch interactions
7. ✅ Extensive documentation and examples

**Official Repository:** https://github.com/imaNNeo/fl_chart

### Alternative: syncfusion_flutter_charts

**Installation:**
```yaml
dependencies:
  syncfusion_flutter_charts: ^24.2.9
```

**Pros:**
- More chart types
- Better animations
- Professional support

**Cons:**
- Requires commercial license (free for small businesses/personal use)
- Larger package size
- More complex API

### For Sparklines Only: flutter_sparkline

**Installation:**
```yaml
dependencies:
  flutter_sparkline: ^0.1.0
```

**Use if:**
- Only need simple sparklines
- Want minimal package size
- Don't need full chart library

## Implementation Priority

### Phase 1: Core Charts
1. **Line Chart (Portfolio Performance)** - High priority
   - Most prominent chart on home screen
   - Critical for portfolio tracking feature
   - Status: Placeholder exists (`portfolio_chart.dart`)

### Phase 2: Composition Visualization
2. **Pie/Donut Chart (Portfolio Composition)** - Medium priority
   - Needed for Composição tab
   - Status: Not yet implemented

### Phase 3: Micro Visualizations
3. **Sparklines (Economy Indicators)** - Low priority
   - Nice-to-have enhancement
   - Can use text-only initially
   - Status: Not implemented

### Phase 4: Additional Charts
4. **Bar Charts** (if needed) - As required
   - Implement if/when Figma designs show them
   - Status: Not identified in current designs

## Testing Recommendations

### Test Data Sets

**For Line Charts:**
```dart
// Trending up
List<double> growthData = [100, 102, 105, 103, 108, 112, 115];

// Trending down
List<double> declineData = [100, 98, 95, 97, 92, 88, 85];

// Volatile
List<double> volatileData = [100, 105, 98, 110, 95, 115, 108];
```

### Performance Considerations

**Data Point Limits:**
- Line charts: Optimal < 100 points, max 500
- Pie charts: Optimal < 10 segments, max 20
- Sparklines: Optimal 7-30 points

**Optimization Tips:**
1. Use `const` constructors where possible
2. Cache chart data calculations
3. Debounce touch interactions
4. Consider data sampling for large datasets
5. Use `RepaintBoundary` for static charts

## Accessibility

### Requirements
- Provide alternative text descriptions of chart data
- Ensure touch targets meet minimum size (44x44px)
- Support screen reader announcements
- Provide data table alternative for complex charts

**Example:**
```dart
Semantics(
  label: 'Portfolio performance chart showing 9.21% return compared to IBOV 7.13% return over the selected period',
  child: LineChart(...),
)
```

## Next Steps

1. ✅ **Document requirements** - Complete
2. **Add fl_chart dependency** - `pubspec.yaml`
3. **Replace CustomPainter in portfolio_chart.dart** - Use fl_chart LineChart
4. **Create reusable chart components** - In `lib/common/widgets/charts/`
5. **Implement pie chart** - For Composição tab
6. **Add sparklines** - For economy cards (optional)
7. **Test with real data** - Once backend integration available

## Files to Modify

### 1. pubspec.yaml
Add fl_chart dependency

### 2. lib/screens/home/widgets/portfolio_chart.dart
Replace CustomPainter with fl_chart implementation

### 3. lib/common/widgets/charts/ (new directory)
Create reusable chart components:
- `line_chart_widget.dart`
- `pie_chart_widget.dart`
- `sparkline_widget.dart`

### 4. lib/utils/constants/chart_colors.dart (new file)
Centralize chart color definitions

## References

- Figma Design: https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=3-6384
- fl_chart Documentation: https://github.com/imaNNeo/fl_chart
- Flutter Charts Guide: https://docs.flutter.dev/cookbook/animation/physics-simulation
