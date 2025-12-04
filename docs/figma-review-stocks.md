# Figma Design Review: Stocks Screens

**Review Date:** 2025-12-04
**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=3-42904
**Screens Reviewed:** Stocks list, Stock detail, Favorite toggle states

---

## Summary

The Stocks section provides a searchable list of stocks with filtering capabilities and detailed individual stock views with price history charts and financial indicators.

---

## Screen 1: Stocks List ("Ações")

### Header
| Element | Specification |
|---------|--------------|
| Title | "Ações" |
| Title Size | 24px, Weight 600, Color: White |
| Back Button | Left arrow icon |
| Close Button | X icon (top right) |

### Search Bar
| Property | Value |
|----------|-------|
| Background | #2D3245 |
| Border Radius | 12px |
| Height | 56px |
| Placeholder Text | "Encontre uma ação ou empresa" |
| Placeholder Color | #7C7C83 |
| Search Icon | Magnifying glass, left side, #9E9E9E |

### Filter Tabs (Segmented Pills)
| Property | Value |
|----------|-------|
| Layout | Horizontal scroll |
| Selected Tab Background | #1B6FFF (primary blue) |
| Selected Tab Border Radius | 20px |
| Unselected Tab | Transparent with border |
| Border Color | #7C7C83 |
| Tab Height | 48px |
| Tab Text Size | 16px |
| Tab Text Weight | 500 |

**Filter Options:**
- "Todas" (All) - default selected
- "Maiores altas" (Biggest gains)
- "Menores baixas" (Smallest losses)

### Stock List Items
Each stock row contains:

| Element | Specification |
|---------|--------------|
| Row Height | 66px |
| Horizontal Padding | 16px |
| Divider | None visible (seamless list) |

**Left Section:**
| Element | Specification |
|---------|--------------|
| Company Logo | 40x40px, rounded rectangle (8px radius) |
| Logo Spacing | 8px from edge, 8px to text |
| Stock Symbol | 16px, Weight 600, Color: White |
| Company Name | 13px, Weight 400, Color: #DFDFE0 |

**Right Section:**
| Element | Specification |
|---------|--------------|
| Price | 16px, Weight 600, Color: White |
| Price Format | "R$ X.XXX,XX" (Brazilian Real) |
| Change Percentage | 14px, Weight 500 |
| Change Color (positive) | #BADBC1 (green) |
| Change Color (negative) | #FF6B6B (red) |
| Arrow Icon | Up/down trend arrow matching change color |
| Chevron | Right arrow, #7C7C83, for navigation |

### Sample Stock Data
| Symbol | Company | Price | Change |
|--------|---------|-------|--------|
| MSFT | Microsoft Corp. | R$ 2.002,42 | +1,88% |
| AAPPL | Apple Inc. | R$ 1.171,00 | +1,75% |
| SPOT | Adobe Inc | R$ 2.992,91 | +1,62% |
| GOOGL | Alphabet Inc. | R$ 833,46 | +3,65% |
| AMZN | Amazon Inc. | R$ 1.031,37 | +5,69% |
| LYFT | Lyft Inc. | R$ 67,08 | +5,48% |
| ADBE | Adobe Inc. | R$ 2.017,60 | +0,58% |

### Load More Button
| Property | Value |
|----------|-------|
| Text | "Carregar mais" |
| Style | Text button (no background) |
| Text Size | 14px |
| Text Weight | 500 |
| Text Color | White |
| Alignment | Center |
| Padding | 40px top |

---

## Screen 2: Stock Detail

### Header
| Element | Specification |
|---------|--------------|
| Back Button | Left arrow, left side |
| Stock Symbol | Center, 18px, Weight 600, White |
| Bookmark Icon | Right side, outline style (unfavorited) |
| Bookmark Icon (favorited) | Filled icon |

### Stock Info Section
| Element | Specification |
|---------|--------------|
| Company Logo | 40x40px, rounded |
| Company Name | "Apple Inc." - 16px, Weight 500, White |
| Stock Type | "Ação ordinária" - 13px, Weight 400, #DFDFE0 |
| Current Price | "R$ 1.475,24" - 24px, Weight 700, White |
| Price Change | "+R$ 2,06 (0,39%)" - 14px, Weight 500 |
| Change Color (positive) | #BADBC1 |
| Change Background | Semi-transparent green pill |

### Price History Chart Section

**Section Header:**
| Element | Specification |
|---------|--------------|
| Title | "Gráfico do histórico de preços" |
| Title Size | 16px, Weight 500, White |
| Info Icon (ⓘ) | Right side, #9E9E9E |

**Chart Specifications:**
| Property | Value |
|----------|-------|
| Chart Type | Line chart |
| Chart Height | ~150px |
| Line Color | #BADBC1 (green/teal) |
| Line Width | 2px |
| Grid Lines | Horizontal only, #FFFFFF @ 10% opacity |
| Y-Axis Labels | Right side, price values (600, 800, 1.100, 1.400) |
| X-Axis Labels | Bottom, months (Dez, Jan, Fev, Mar, Abr) |
| Label Color | #7C7C83 |
| Label Size | 12px |

**Data Point Tooltip:**
| Element | Specification |
|---------|--------------|
| Background | #2D3245 |
| Border Radius | 8px |
| Price Text | "R$ 890,89" - 14px, Weight 500, White |
| Vertical Line | Dashed, #BADBC1 |

**Last Updated:**
| Element | Specification |
|---------|--------------|
| Text | "Última atualização: 1 de Abril 2025" |
| Size | 12px |
| Color | #7C7C83 |

### About Company Section ("Sobre a empresa")

| Element | Specification |
|---------|--------------|
| Section Title | "Sobre a empresa" - 16px, Weight 500, White |
| Industry Tag | "Tecnologia" - pill/chip style |
| Tag Background | #2D3245 |
| Tag Border | 1px, #7C7C83 |
| Tag Border Radius | 16px |
| Tag Text | 13px, Weight 500, White |
| Description | 14px, Weight 400, #DFDFE0, Line height 1.5 |

**Sample Description:**
> "A Apple Inc. projeta, fabrica e comercializa dispositivos de comunicação móvel e mídia, computadores pessoais e dispositivos portáteis de música digital."

### Financial Indicators Section ("Indicadores financeiros")

**Section Header:**
| Element | Specification |
|---------|--------------|
| Title | "Indicadores financeiros" - 16px, Weight 500, White |
| Info Icon (ⓘ) | Right side, #9E9E9E |

**Indicator List:**
Each row is a key-value pair:

| Property | Value |
|----------|-------|
| Row Height | ~44px |
| Label | Left-aligned, 14px, Weight 400, #DFDFE0 |
| Value | Right-aligned, 14px, Weight 500, White |
| Divider | 1px, #2D3245 (subtle) |

**Financial Indicators Displayed:**
| Indicator | Sample Value |
|-----------|-------------|
| Preço sobre Lucro (P/E Ratio) | 33,87 |
| Preço/Valor Patrimonial (P/B Ratio) | 47,92 |
| Dividend Yield | 0,47% |
| Payout Ratio | 15,92% |
| ROE (Retorno sobre Patrimônio Líquido) | 136,52% |
| Capex/D&A | -- |
| CAGR (Taxa de Crescimento Anual Composta) do Lucro - 5 anos | 18,15% |
| Margem Líquida | 24,30% |
| Dívida Líquida/EBITDA | 0,63 |
| Liquidez Corrente | 0,92 |
| Beta | 1,18 |

**Source Footer:**
| Element | Specification |
|---------|--------------|
| Text | "Fonte: Finovate LTDA" |
| Size | 11px |
| Color | #7C7C83 |

---

## Screen 3: Stock Detail with Toast Notifications

Shows the same detail screen with toast notifications for favorite actions:

### Toast Notification (Add to Favorites)
| Property | Value |
|----------|-------|
| Background | #BADBC1 (green) |
| Text | "Ação adicionada aos favoritos." |
| Text Size | 14px |
| Text Weight | 500 |
| Text Color | #0D1B2A (dark) |
| Icon | Checkmark, left side |
| Border Radius | 8px |
| Position | Top of screen, below header |
| Padding | 12px horizontal, 10px vertical |

### Toast Notification (Remove from Favorites)
| Property | Value |
|----------|-------|
| Background | #BADBC1 (green) |
| Text | "Ação retirada dos favoritos." |
| Text Size | 14px |
| Text Weight | 500 |
| Text Color | #0D1B2A (dark) |
| Icon | Checkmark, left side |
| Border Radius | 8px |

---

## Info Icon (ⓘ) Locations

| Location | Trigger | Info Content |
|----------|---------|--------------|
| Price History Chart header | Tap (ⓘ) | Explanation of price history chart |
| Financial Indicators header | Tap (ⓘ) | Explanation of financial indicators |

**Note:** These should use the global `showInfoBottomSheet()` component defined in `docs/global-components.md`.

---

## Component Specifications

### Stock List Item Component

```dart
// lib/screens/stocks/widgets/stock_list_item.dart

class StockListItem extends StatelessWidget {
  final String symbol;
  final String companyName;
  final String logoUrl;
  final String price;
  final String changePercent;
  final bool isPositive;
  final VoidCallback onTap;

  // Implementation...
}
```

**Layout Structure:**
```
Row
├── Logo (40x40 rounded)
├── SizedBox(width: 8)
├── Column (Expanded)
│   ├── Text (Symbol - bold)
│   └── Text (Company name - secondary)
├── Column (crossAxisAlignment: end)
│   ├── Text (Price - bold)
│   └── Row
│       ├── Icon (arrow up/down)
│       └── Text (Change %)
└── Icon (chevron right)
```

### Stock Detail Header Component

```dart
// lib/screens/stocks/widgets/stock_detail_header.dart

class StockDetailHeader extends StatelessWidget {
  final String symbol;
  final String companyName;
  final String stockType;
  final String logoUrl;
  final String price;
  final String priceChange;
  final String changePercent;
  final bool isPositive;
  final bool isFavorited;
  final VoidCallback onFavoriteToggle;

  // Implementation...
}
```

### Price History Chart Component

```dart
// lib/screens/stocks/widgets/price_history_chart.dart

class PriceHistoryChart extends StatelessWidget {
  final List<PricePoint> priceHistory;
  final DateTime lastUpdated;

  // Uses fl_chart package for line chart
  // Implementation...
}

class PricePoint {
  final DateTime date;
  final double price;

  PricePoint({required this.date, required this.price});
}
```

### Financial Indicator Row Component

```dart
// lib/screens/stocks/widgets/financial_indicator_row.dart

class FinancialIndicatorRow extends StatelessWidget {
  final String label;
  final String value;

  const FinancialIndicatorRow({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF2D3245), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFFDFDFE0),
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
```

---

## Color Palette (Stocks-specific)

| Element | Color |
|---------|-------|
| Positive Change | #BADBC1 |
| Negative Change | #FF6B6B |
| Chart Line | #BADBC1 |
| Filter Tab Selected | #1B6FFF |
| Card/Container Background | #2D3245 |
| Toast Background | #BADBC1 |
| Toast Text | #0D1B2A |

---

## Typography Summary

| Element | Size | Weight | Color |
|---------|------|--------|-------|
| Screen Title | 24px | 600 | White |
| Section Header | 16px | 500 | White |
| Stock Symbol | 16px | 600 | White |
| Company Name | 13px | 400 | #DFDFE0 |
| Price (list) | 16px | 600 | White |
| Price (detail) | 24px | 700 | White |
| Change Percent | 14px | 500 | #BADBC1/#FF6B6B |
| Indicator Label | 14px | 400 | #DFDFE0 |
| Indicator Value | 14px | 500 | White |
| Description | 14px | 400 | #DFDFE0 |
| Chart Labels | 12px | 400 | #7C7C83 |
| Footer/Source | 11px | 400 | #7C7C83 |

---

## Navigation Flow

```
Home Screen
└── "Bolsa" section → "Ver mais"
    └── Stocks List Screen ("Ações")
        └── Tap stock row
            └── Stock Detail Screen
                ├── Tap bookmark → Toggle favorite (show toast)
                ├── Tap (ⓘ) on chart → Show info bottom sheet
                ├── Tap (ⓘ) on indicators → Show info bottom sheet
                └── Tap back → Return to list
```

---

## Implementation Notes

1. **Chart Library:** Use `fl_chart` package for the price history line chart
2. **Favorites:** Store favorited stocks in local storage or sync with backend
3. **Toast Notifications:** Use global toast/snackbar component (add to global-components.md)
4. **Data Source:** Financial indicators should come from backend API
5. **Price Formatting:** Use Brazilian Real format (R$ X.XXX,XX)
6. **Logo Loading:** Handle missing logos with placeholder/initials fallback

---

## Files to Create

```
lib/screens/stocks/
├── stocks_screen.dart              # Main stocks list
├── stock_detail_screen.dart        # Individual stock detail
├── stocks_controller.dart          # GetX controller
└── widgets/
    ├── stock_list_item.dart        # List row component
    ├── stock_search_bar.dart       # Search input
    ├── stock_filter_tabs.dart      # Filter pills
    ├── stock_detail_header.dart    # Detail header with price
    ├── price_history_chart.dart    # Line chart
    ├── company_info_section.dart   # About company
    └── financial_indicators.dart   # Indicators list
```

---

## Data Models

```dart
// lib/models/stock.dart

class Stock {
  final String symbol;
  final String companyName;
  final String? logoUrl;
  final double currentPrice;
  final double priceChange;
  final double changePercent;
  final bool isPositive;

  Stock({
    required this.symbol,
    required this.companyName,
    this.logoUrl,
    required this.currentPrice,
    required this.priceChange,
    required this.changePercent,
    required this.isPositive,
  });
}

class StockDetail extends Stock {
  final String stockType;
  final String? description;
  final String? industry;
  final List<PriceHistoryPoint> priceHistory;
  final Map<String, String> financialIndicators;
  final DateTime lastUpdated;
  final String dataSource;

  StockDetail({
    // ... inherited fields
    required this.stockType,
    this.description,
    this.industry,
    required this.priceHistory,
    required this.financialIndicators,
    required this.lastUpdated,
    required this.dataSource,
  });
}

class PriceHistoryPoint {
  final DateTime date;
  final double price;

  PriceHistoryPoint({required this.date, required this.price});
}
```

---

## Next Steps

1. Create stocks screen files
2. Implement stock list with search and filters
3. Implement stock detail screen with chart
4. Add favorites functionality with local storage
5. Integrate with backend API for real stock data
6. Add toast notification component to global-components.md
