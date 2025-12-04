# Figma Design Review: Conjuntura (Economic Context)

**Review Date:** 2025-12-04
**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=260-4009
**Status:** In Progress (Part 1 Complete)

## Overview

Conjuntura is a premium feature providing economic analysis and indicators. Due to the large number of screens, this review is organized into parts:

| Part | Sections Covered | Status |
|------|------------------|--------|
| Part 1 | Free Plan Paywall, Expectativas, Desempenho Econômico | ✅ Reviewed |
| Part 2 | Inflação (IGP-M, IPCA) | ✅ Reviewed |
| Part 3 | Mercado Internacional, Mercados Financeiros | ✅ Reviewed |
| Part 4 | Setor Público | ✅ Reviewed |

**Review Complete** - All Conjuntura sections documented.

**Note:** Info Bottom Sheet is a global app-wide component - see [global-components.md](./global-components.md).

### Info Icon (ⓘ) Locations in Conjuntura

The info icon appears in the following locations across Conjuntura screens:

| Section | Location | Trigger | Info Content |
|---------|----------|---------|--------------|
| **Header** | Top right of screen header | Tap (ⓘ) icon | General section explanation |
| **Expectativas** | Bottom of content | "O que é Taxa de desemprego?" link | Term definition |
| **Expectativas** | Next to "Variações" header | Tap (ⓘ) icon | YTD/YoY/MoM explanation |
| **Desempenho Econômico** | Bottom of indicator list | "O que é Atividade econômica?" link | Category explanation |
| **Inflação (IGP-M)** | Next to "Variações" header | Tap (ⓘ) icon | YTD/YoY/MoM explanation |
| **Inflação (IGP-M)** | Bottom of content | "O que é IGP-M?" link | Index definition |
| **Inflação (IPCA)** | Bottom of content | "O que é IPCA?" link | Index definition |
| **Mercado Internacional** | Bottom of currency list | "O que é o Mercado Internacional?" link | Section explanation |
| **Mercados Financeiros** | Bottom of indices list | "O que é Comércio Internacional?" link | Section explanation |
| **Setor Público** | Bottom of indicator list | "O que é o Setor público?" link | Section explanation |
| **Detail Modals** | Next to "Variações" section | Tap (ⓘ) icon | YTD/YoY/MoM explanation |

---

## Part 1: Free Plan Paywall + Expectativas + Desempenho Econômico

**Figma Node:** `260:4009`
**Screens Reviewed:** 5

### Section 1.1: Free Plan Access Denied

**Screen Name:** `conjuntura-access-denied-free-plan`

**Purpose:** Paywall screen shown to free plan users when accessing Conjuntura

#### Layout Structure
```
├── Status Bar
├── Header
│   ├── Back Arrow (left)
│   ├── Title: "Conjuntura" (center)
│   └── Info Icon (right)
├── Content (centered)
│   ├── Star/Lock Icon (premium indicator)
│   ├── Title Text
│   ├── Description Text
│   ├── CTA Text
│   └── "Assinar Premium" Button
└── Background (starfield gradient)
```

#### Typography Specifications

| Element | Specification |
|---------|--------------|
| Header Title "Conjuntura" | Size: 20px, Weight: 600, Color: White |
| Premium Title | Size: 16px, Weight: 600, Color: White |
| Description | Size: 14px, Weight: 400, Color: #DFDFE0, Line height: 1.5 |
| CTA "Assine agora" | Size: 14px, Weight: 600 (bold), Color: White |
| Button Text | Size: 16px, Weight: 600, Color: White |

#### Text Content (Portuguese)
```
Title: "Esta área é exclusiva para assinantes do Plano Premium."

Description: "Tenha acesso completo a análises de conjuntura econômica,
incluindo expectativas, desempenho, inflação, setor público,
mercado internacional e muito mais."

CTA: "Assine agora e tenha acesso a insights exclusivos."

Button: "Assinar Premium"
```

#### Component Specifications

**Header:**
- Height: 56px (content area, excluding status bar)
- Back arrow: 32x32px touch target
- Info icon: 32x32px touch target with circular border

**Premium Icon:**
- Star icon (similar to SofIA branding)
- Color: Orange/Gold (#FFA726 or similar)
- Size: ~20x20px

**CTA Button:**
- Width: 345px (full width minus 24px padding each side)
- Height: 56px
- Border radius: 12px
- Background: Primary Blue (#1B6FFF)
- Text: White, centered

#### Colors
- Background: Dark gradient with star pattern (same as other screens)
- Text primary: White (#FFFFFF)
- Text secondary: #DFDFE0
- Button: Primary Blue (#1B6FFF)
- Premium icon: Orange/Gold

---

### Section 1.2: Expectativas (Market Expectations)

**Purpose:** First tab - Market expectations with chart and yearly comparison

**Dropdown Options:** TBD (need to confirm dropdown contents - includes "Taxa de desemprego" and others)

#### Layout Structure
```
├── Status Bar
├── Header
│   ├── Back Arrow
│   ├── Title: "Conjuntura"
│   └── Info Icon
├── Tab Bar
│   ├── "Expectativas" (pill, selected)
│   ├── "Desempenho econômico" (pill)
│   ├── "Inflação" (pill)
│   └── "M..." (truncated, more tabs)
├── Dropdown: "Taxa de desemprego" (or other indicator)
├── Chart Section
│   ├── Label: "Expectativas de mercado - mediana em %"
│   ├── Line Chart (multi-year)
│   │   ├── 2025 line (blue)
│   │   ├── 2026 line (red/orange)
│   │   └── 2027 line (yellow)
│   ├── Tooltip: "Fevereiro 3.2%"
│   ├── Legend: • 2025  • 2026  • 2027
│   └── Source: "Fonte: Banco central"
├── Year Comparison Section
│   ├── Header: "Anos" | "Atualizado em 17 de março"
│   └── Year Rows
│       ├── ✓ 2025 | 4.26% | +0.2%
│       ├── ✓ 2026 | 4.26% | +0.2%
│       └── ✗ 2027 | 4.26% | -0.2%
└── Info Link: "O que é Taxa de desemprego?"
```

#### Tab Bar Component

**Container:**
- Horizontal scroll enabled
- Padding: 16px horizontal
- Gap between tabs: 8px

**Tab Pills:**
- Padding: 8px 16px
- Border radius: 20px (fully rounded)
- Background (inactive): Transparent or subtle dark
- Background (active): Primary Blue (#1B6FFF)
- Border (inactive): 1px solid #7C7C83
- Text size: 14px
- Text weight: 500
- Text color: White

#### Dropdown Component

**Style:**
- Full width (minus padding)
- Height: 48px
- Background: #2D3245 or similar dark
- Border radius: 12px
- Border: 1px solid #7C7C83
- Text: White, 14px, weight 500
- Chevron icon: Right side

#### Line Chart Specifications

**Container:**
- Height: ~180px
- Width: Full width minus padding
- Background: Transparent

**Chart Lines:**
| Year | Color | Style |
|------|-------|-------|
| 2025 | #5FB3D3 (blue) | Solid, 2px stroke |
| 2026 | #FF6B6B (red/coral) | Solid, 2px stroke |
| 2027 | #FFD93D (yellow) | Solid, 2px stroke |

**Grid:**
- Horizontal lines: 4-5 lines
- Color: White @ 10% opacity
- No vertical grid lines visible

**Tooltip:**
- Appears on touch/hover
- Background: Dark (#15254E)
- Border radius: 6px
- Text: Month + value (e.g., "Fevereiro 3.2%")
- Arrow pointing to data point

**Legend:**
- Horizontal layout
- Colored dots: 8x8px circles
- Gap between items: 16px
- Text: 12px, weight 400

#### Year Comparison Table

**Row Structure:**
```
┌──────────────────────────────────────────────────────┐
│ [Status Icon] [Year]          [Value]    [Change]    │
└──────────────────────────────────────────────────────┘
```

**Status Icons:**
- Checkmark (✓): Green circle with white check
- X mark (✗): Red circle with white X
- Size: 24x24px

**Row Specifications:**
- Height: 48px
- Background: #2D3245 or card background
- Border radius: 8px
- Margin bottom: 8px
- Padding: 12px 16px

**Typography:**
| Element | Specification |
|---------|--------------|
| Year | Size: 14px, Weight: 600, Color: White |
| Value | Size: 14px, Weight: 500, Color: White |
| Change (positive) | Size: 12px, Weight: 500, Color: #4CAF50, Background: rgba(76,175,80,0.2) |
| Change (negative) | Size: 12px, Weight: 500, Color: #F44336, Background: rgba(244,67,54,0.2) |

**Change Badge:**
- Padding: 4px 8px
- Border radius: 4px
- Background: Semi-transparent color matching text

#### Info Link

**Style:**
- Icon: Info circle (ⓘ)
- Text: "O que é [Indicator Name]?"
- Size: 13px
- Weight: 400
- Color: #9E9E9E
- Positioned at bottom of content

---

### Section 1.3: Desempenho Econômico (Economic Performance)

**Purpose:** Second tab - List of economic performance indicators with expandable details

#### Layout Structure
```
├── Status Bar
├── Header
│   ├── Back Arrow
│   ├── Title: "Conjuntura"
│   └── Info Icon
├── Tab Bar
│   ├── "Expectativas" (pill)
│   ├── "Desempenho econômico" (pill, selected)
│   ├── "Inflação" (pill)
│   └── "M..." (truncated, more tabs)
├── Dropdown: "Atividade econômica"
├── Indicator List (scrollable)
│   ├── PIB
│   ├── PIB Serviços
│   ├── PIB Comércio
│   ├── PIB Agro (expanded in one variant)
│   ├── FBCF
│   ├── Consumo das famílias
│   ├── Consumo do governo
│   └── Taxa de desemprego
└── Info Link: "O que é Atividade econômica?"
```

#### Dropdown Options
Under "Atividade econômica" dropdown - TBD (need to confirm full list)

#### Indicator List Item

**Layout:**
```
┌─────────────────────────────────────────────────────┐
│ [Indicator Name]                    [▲/▼] [±X.X%] ▼│
│ [Value]                                             │
└─────────────────────────────────────────────────────┘
```

**Specifications:**
- Height: ~64px per item
- Padding: 16px
- Background: Transparent or subtle container
- Border bottom: 1px solid #2D3245 (separator)

**Typography:**
| Element | Specification |
|---------|--------------|
| Indicator name | Size: 14px, Weight: 500, Color: White |
| Value subtitle | Size: 12px, Weight: 400, Color: #9E9E9E |
| Percentage change | Size: 14px, Weight: 600 |
| Percentage color (positive) | #4CAF50 (green) |
| Percentage color (negative) | #F44336 (red) |

**Change Indicator:**
- Arrow up (▲): Green (#4CAF50)
- Arrow down (▼): Red (#F44336)
- Positioned before percentage

**Expand Chevron:**
- Right side
- Size: 24x24px
- Color: #9E9E9E
- Rotates 180° when expanded

#### Indicator List Items (Atividade econômica)
| Indicator | Example Value | Description |
|-----------|---------------|-------------|
| PIB | R$ 11.7 Trilhões | Gross Domestic Product |
| PIB Serviços | R$ 11.7 Trilhões | Services GDP |
| PIB Comércio | R$ 11.7 Trilhões | Commerce GDP |
| PIB Agro | R$ 3.5 Bilhões | Agricultural GDP |
| FBCF | R$ 11.7 Trilhões | Gross Fixed Capital Formation |
| Consumo das famílias | R$ 11.7 Trilhões | Household Consumption |
| Consumo do governo | R$ 11.7 Trilhões | Government Consumption |
| Taxa de desemprego | R$ 11.7 Trilhões | Unemployment Rate |

---

#### Detail Modal: PIB Agro Example

**Purpose:** Expanded view of a specific indicator

##### Layout Structure (Bottom Sheet/Modal)
```
├── Header: "PIB Agro"
├── Value: "R$ 3.5 Bilhões"
├── Change Badge: "2% ↑" (green)
├── Line Chart
├── Variações Section
│   ├── YTD | +0.52%
│   ├── YoY | +3.49%
│   └── MoM | -0.05%
├── Source: "Fonte: IBGE"
├── Date: "Data da última variação: 2 de Fevereiro"
└── "Fechar" Button
```

##### Modal Container
- Background: Dark (#1A1A2E or similar)
- Border radius (top): 24px
- Padding: 24px
- Max height: 80% of screen

##### Header Section
**Typography:**
| Element | Specification |
|---------|--------------|
| Title (e.g., "PIB Agro") | Size: 20px, Weight: 600, Color: White |
| Value | Size: 16px, Weight: 400, Color: #9E9E9E |
| Change badge | Size: 14px, Weight: 600 |

**Change Badge:**
- Positive: Green text (#4CAF50), arrow up
- Negative: Red text (#F44336), arrow down

##### Chart (Same specs as Expectativas chart)
- Single line (indicator trend)
- Color: #5FB3D3 or indicator-specific
- Height: ~120px

##### Variações (Variations) Section

**Row Layout:**
```
┌─────────────────────────────────────────┐
│ [Period Label]              [Value]     │
└─────────────────────────────────────────┘
```

**Specifications:**
- Row height: 40px
- Separator: 1px solid #2D3245

**Typography:**
| Element | Specification |
|---------|--------------|
| Period (YTD, YoY, MoM) | Size: 14px, Weight: 500, Color: White |
| Value (positive) | Size: 14px, Weight: 600, Color: #4CAF50 |
| Value (negative) | Size: 14px, Weight: 600, Color: #F44336 |

**Period Labels:**
- YTD = Year to Date
- YoY = Year over Year
- MoM = Month over Month

##### Footer
**Source Text:**
- Size: 12px
- Weight: 400
- Color: #9E9E9E

**Close Button:**
- Width: Full width
- Height: 48px
- Background: #2D3245
- Border radius: 12px
- Text: "Fechar", 16px, weight 600, White

---

## Reusable Components Identified

### 1. ConjunturaHeader
Standard header with back button, title, and info icon.

### 2. PillTabBar
Horizontal scrollable tab bar with pill-style selection.

### 3. DropdownSelector
Full-width dropdown for category/indicator selection.

### 4. IndicatorListItem
Expandable list item showing indicator name, value, and change.

### 5. MultiYearLineChart
Line chart with multiple series (years) and legend.

### 6. YearComparisonRow
Row showing year, value, and change with status icon.

### 7. IndicatorDetailModal
Bottom sheet with chart, variations, and metadata.

### 8. VariationRow
Simple row showing period label and colored value.

### 9. PremiumPaywall
Full-screen paywall for premium features.

---

## Data Models Needed

```dart
// Economic indicator
class EconomicIndicator {
  final String id;
  final String name;
  final String? subtitle;
  final double value;
  final String formattedValue;
  final double changePercent;
  final bool isPositive;
  final String? unit;

  EconomicIndicator({...});
}

// Time series data point
class TimeSeriesPoint {
  final DateTime date;
  final double value;

  TimeSeriesPoint({required this.date, required this.value});
}

// Year comparison data
class YearComparison {
  final int year;
  final double value;
  final double changePercent;
  final bool isSelected;

  YearComparison({...});
}

// Variation data
class VariationData {
  final String period; // YTD, YoY, MoM
  final double value;
  final bool isPositive;

  VariationData({...});
}

// Chart series
class ChartSeries {
  final String label;
  final Color color;
  final List<TimeSeriesPoint> data;

  ChartSeries({...});
}
```

---

## Implementation Notes

### Tab Navigation
The Conjuntura screen uses horizontal pill tabs, different from Home's container tabs. Consider creating a separate `PillTabBar` widget or parameterizing the existing tab component.

### Charts
Multiple chart types needed:
1. Multi-series line chart (expectations)
2. Single-series line chart (indicator detail)
3. Consider using `fl_chart` package for consistency with Home screen

### Expandable List Items
Indicator list items expand to show more details. Use `ExpansionTile` or custom animated container.

### Premium Gating
Check user's subscription status before showing content. If free plan, redirect to paywall screen.

### API Integration
Endpoints needed:
- GET /conjuntura/indicators - List all indicators
- GET /conjuntura/indicators/{id} - Indicator detail with time series
- GET /conjuntura/expectations - Market expectations data

---

## Part 2: Inflação

**Figma Node:** `260:20093`
**Review Date:** 2025-12-04
**Screens Reviewed:** 6

### Section 2.1: IGP-M View

**Purpose:** Display IGP-M (Índice Geral de Preços do Mercado) inflation data with line chart

#### Layout Structure
```
├── Status Bar
├── Header: "Conjuntura"
├── Tab Bar (Inflação selected)
├── Sub-tabs
│   ├── "IGP-M" (selected)
│   └── "IPCA"
├── Chart Section
│   ├── Title: "Evolução do IGP-M"
│   ├── Line Chart
│   └── Tooltip: "Fevereiro YTD: 3.2%, YoY: 4.5%, MoM: 0.6%"
├── Source: "Fonte: IBGE"
├── Date Selectors
│   ├── Month Dropdown: "Março"
│   └── Year Dropdown: "2025"
├── Variações Section
│   ├── Header: "Variações" + Info icon (ⓘ)
│   ├── YTD | 3.2%
│   ├── YoY | 4.5%
│   └── MoM | 0.6%
├── Last Update: "Data da última variação: 2 de Fevereiro"
└── Info Link: "O que é IGP-M?"
```

#### Sub-tabs Component (IGP-M / IPCA)

**Container:**
- Two equal-width tabs
- Background: #2D3245
- Border radius: 8px
- Height: 40px

**Tab:**
- Width: 50% each
- Selected background: Primary Blue (#1B6FFF)
- Selected border radius: 8px
- Text: 14px, weight 500, White

#### Line Chart (IGP-M)

**Specifications:**
- Single line showing trend over time
- Color: #5FB3D3 (blue) or similar
- Height: ~150px
- Background: Transparent

**Tooltip:**
- Shows on data point hover/touch
- Background: Dark (#2D3245)
- Border radius: 8px
- Content: Month name + YTD/YoY/MoM values
- Multi-line format

#### Date Selector Dropdowns

**Layout:** Two dropdowns side by side

**Month Dropdown:**
- Width: ~50% minus gap
- Shows month name (e.g., "Março")
- Opens month picker modal

**Year Dropdown:**
- Width: ~50% minus gap
- Shows year (e.g., "2025")
- Opens year picker modal

**Style (both):**
- Height: 40px
- Background: #2D3245
- Border radius: 8px
- Border: 1px solid #7C7C83
- Text: 14px, weight 500, White
- Chevron icon on right

#### Variações Section

**Header Row:**
- Text: "Variações"
- Info icon (ⓘ) - tappable, opens explanation modal
- Font: 14px, weight 600, White

**Variation Rows:**
| Period | Value | Color |
|--------|-------|-------|
| YTD | 3.2% | White (neutral) |
| YoY | 4.5% | White (neutral) |
| MoM | 0.6% | White (neutral) |

**Row Style:**
- Height: 40px
- Separator: 1px solid #2D3245
- Label: 14px, weight 400, White
- Value: 14px, weight 600, White (right-aligned)

---

### Section 2.2: Variações Info Modal

**Purpose:** Explain what YTD, YoY, and MoM mean

#### Layout Structure
```
├── Title: "Variações"
├── YTD Section
│   ├── Header: "YTD (Year to Date)"
│   └── Explanation text
├── YoY Section
│   ├── Header: "YoY (Year over Year)"
│   └── Explanation text
└── MoM Section
    ├── Header: "MoM (Month over Month)"
    └── Explanation text
```

#### Modal Style
- Background: #1A1A2E or similar dark
- Border radius (top): 16px
- Padding: 24px

#### Content

**YTD (Year to Date):**
- "Significa: Do início do ano até hoje."
- "Exemplo: A rentabilidade YTD mostra quanto sua carteira cresceu desde 1º de janeiro até agora."

**YoY (Year over Year):**
- "Significa: Comparação com o mesmo período do ano anterior."
- "Exemplo: Se a inflação YoY está em 4%, quer dizer que os preços subiram 4% em relação ao mesmo mês do ano passado."

**MoM (Month over Month):**
- "Significa: Comparação com o mês anterior."
- "Exemplo: Se um ativo subiu 2% MoM, ele cresceu 2% em relação ao mês passado."

#### Typography
| Element | Specification |
|---------|--------------|
| Modal title | Size: 18px, Weight: 600, Color: White |
| Section header | Size: 14px, Weight: 600, Color: White |
| Explanation text | Size: 13px, Weight: 400, Color: #DFDFE0, Line height: 1.5 |

---

### Section 2.3: IPCA View (Donut Chart)

**Purpose:** Display IPCA (Índice de Preços ao Consumidor Amplo) breakdown by category

#### Layout Structure
```
├── Status Bar
├── Header: "Conjuntura"
├── Tab Bar (Inflação selected)
├── Sub-tabs
│   ├── "IGP-M"
│   └── "IPCA" (selected)
├── Donut Chart
│   ├── Center: "Índice geral 0,25%"
│   ├── Below center: "Variação +40%"
│   └── Segments (categories)
├── Side Panel (on some variants)
│   ├── "Despesas pessoais"
│   ├── YTD: 3.2%
│   ├── YoY: 4.5%
│   └── MoM: 0.6%
├── Source: "Fonte: IBGE"
├── Date Selectors (Month + Year)
├── Instruction: "Clique na legenda para visualizar mais detalhes."
├── Category Legend (2 columns)
│   ├── Alimentação      │ Saúde
│   ├── Habitação        │ Despesas pessoais
│   ├── Artigos de residência │ Educação
│   ├── Vestuário        │ Comunicação
│   └── Transportes
└── Info Link: "O que é IPCA?"
```

#### Donut Chart Specifications

**Container:**
- Size: ~200x200px
- Center hole: ~60% of diameter

**Center Text:**
- "Índice geral" - 12px, weight 400, #9E9E9E
- "0,25%" - 24px, weight 700, White
- "Variação" - 12px, weight 400, #9E9E9E
- "+40%" - 16px, weight 600, Green (#4CAF50) or Red based on value

**Segments (Categories with colors):**
| Category | Color (approximate) |
|----------|---------------------|
| Alimentação | Blue (#5FB3D3) |
| Habitação | Purple (#9C7CF4) |
| Artigos de residência | Pink (#F47C9C) |
| Vestuário | Red (#F4647C) |
| Transportes | Yellow (#FFD93D) |
| Saúde | Teal (#4ECDC4) |
| Despesas pessoais | Orange (#FFA726) |
| Educação | Light blue (#64B5F6) |
| Comunicação | Green (#81C784) |

#### Category Legend

**Layout:**
- 2 columns grid
- 5 rows

**Legend Item:**
- Colored dot: 10x10px circle
- Category name: 12px, weight 400, White
- Gap between dot and text: 8px
- Row height: 32px

**Selected State:**
- Background: Primary Blue (#1B6FFF) with opacity
- Border radius: 4px
- Shows expanded details in side panel

#### Side Panel (Category Detail)

**Appears when category selected:**
- Category name as header
- YTD, YoY, MoM values
- Same typography as IGP-M variations

---

### Section 2.4: Month Picker Modal

**Purpose:** Select month for date filter

#### Layout Structure
```
├── Header: "Mês"
└── Month Grid (2 columns x 6 rows)
    ├── Janeiro    │ Fevereiro
    ├── Março      │ Abril
    ├── Maio       │ Junho
    ├── Julho      │ Agosto
    ├── Setembro   │ Outubro
    └── Novembro   │ Dezembro
```

#### Modal Style
- Background: #1A1A2E
- Border radius (top): 16px
- Padding: 24px

#### Month Grid

**Grid Layout:**
- 2 columns
- Gap: 12px
- Full width

**Month Button:**
- Height: 44px
- Background (unselected): #2D3245
- Background (selected): Primary Blue (#1B6FFF)
- Border radius: 8px
- Text: 14px, weight 500, White, centered

---

### Section 2.5: Year Picker Modal

**Purpose:** Select year for date filter

#### Layout Structure
```
├── Header: "Ano"
└── Year Grid (2 columns x 2 rows)
    ├── 2022    │ 2023
    └── 2024    │ 2025
```

#### Modal Style
- Same as Month Picker

#### Year Grid

**Grid Layout:**
- 2 columns
- Gap: 12px

**Year Button:**
- Same style as Month buttons
- Height: 44px
- Background (unselected): #2D3245
- Background (selected): Primary Blue (#1B6FFF)
- Border radius: 8px
- Text: 14px, weight 500, White, centered

---

### Reusable Components (Inflação Section)

1. **InflationSubTabs** - IGP-M / IPCA toggle
2. **DateSelectorRow** - Month + Year dropdown pair
3. **MonthPickerModal** - Month selection grid
4. **YearPickerModal** - Year selection grid
5. **VariacoesSection** - YTD/YoY/MoM display with info button
6. **VariacoesInfoModal** - Explanation of variation terms
7. **DonutChart** - Pie/donut chart with center text
8. **CategoryLegend** - Two-column legend with selection state
9. **CategoryDetailPanel** - Side panel showing selected category details

---

### Data Models (Inflação)

```dart
// Inflation index data (IGP-M or IPCA)
class InflationIndexData {
  final String indexName; // "IGP-M" or "IPCA"
  final double currentValue;
  final double ytdChange;
  final double yoyChange;
  final double momChange;
  final DateTime lastUpdate;
  final List<TimeSeriesPoint> historicalData;

  InflationIndexData({...});
}

// IPCA category breakdown
class InflationCategory {
  final String name;
  final Color color;
  final double percentage; // Share of total
  final double ytdChange;
  final double yoyChange;
  final double momChange;

  InflationCategory({...});
}

// Date selection
class MonthYear {
  final int month; // 1-12
  final int year;

  MonthYear({required this.month, required this.year});

  String get monthName => [
    'Janeiro', 'Fevereiro', 'Março', 'Abril',
    'Maio', 'Junho', 'Julho', 'Agosto',
    'Setembro', 'Outubro', 'Novembro', 'Dezembro'
  ][month - 1];
}
```

---

### Implementation Notes (Inflação)

1. **Sub-tab state** - Track whether IGP-M or IPCA is selected
2. **Date selection** - Shared between both views, affects data displayed
3. **Donut chart library** - `fl_chart` supports PieChart which can render as donut
4. **Category selection** - Tapping legend item highlights segment and shows detail panel
5. **Modals** - Use bottom sheet pattern consistent with other modals
6. **Variation colors** - In IPCA view, variation shows colored (+green/-red); in IGP-M view appears neutral white

---

## Part 3: Mercado Internacional + Mercados Financeiros

**Figma Node:** `260:36177`
**Review Date:** 2025-12-04
**Screens Reviewed:** 4

### Section 3.1: Mercado Internacional (International Market)

**Purpose:** Display currency exchange rates against BRL

#### Layout Structure
```
├── Status Bar
├── Header: "Conjuntura"
├── Tab Bar (Mercado Internacional selected)
├── Dropdown: "Importações e Exportações"
├── Currency List
│   ├── 🇺🇸 USD | R$ 5.10 | ↓ -0.14%
│   ├── 🇪🇺 EUR | R$ 5.55 | ↑ +0.40%
│   ├── 🇬🇧 GBP | R$ 6.45 | ↑ +0.31%
│   ├── 🇯🇵 JPY | R$ 0.034 | ↑ +0.02%
│   ├── 🇨🇦 CAD | R$ 5.34 | ↓ -5.32%
│   └── 🇦🇺 AUD | R$ 6.32 | ↓ -6.35%
└── Info Link: "O que é o Mercado Internacional?"
```

#### Currency List Item

**Layout:**
```
┌─────────────────────────────────────────────────────┐
│ [Flag] [Code]     [Value]     [▲/▼] [±X.XX%]    ▼  │
└─────────────────────────────────────────────────────┘
```

**Specifications:**
- Height: ~56px per item
- Padding: 16px
- Background: #2D3245 or card background
- Border radius: 8px
- Margin bottom: 8px

**Flag Icon:**
- Country flag emoji or image
- Size: 24x24px (or emoji size)

**Typography:**
| Element | Specification |
|---------|--------------|
| Currency code (USD, EUR, etc.) | Size: 14px, Weight: 600, Color: White |
| Value (R$ X.XX) | Size: 14px, Weight: 500, Color: White |
| Percentage (positive) | Size: 14px, Weight: 500, Color: #4CAF50 |
| Percentage (negative) | Size: 14px, Weight: 500, Color: #F44336 |

**Arrow Indicators:**
- Up arrow (↑): Green (#4CAF50)
- Down arrow (↓): Red (#F44336)

**Expand Chevron:**
- Right side
- Opens detail modal on tap

#### Currencies Displayed
| Flag | Code | Description |
|------|------|-------------|
| 🇺🇸 | USD | US Dollar |
| 🇪🇺 | EUR | Euro |
| 🇬🇧 | GBP | British Pound |
| 🇯🇵 | JPY | Japanese Yen |
| 🇨🇦 | CAD | Canadian Dollar |
| 🇦🇺 | AUD | Australian Dollar |

---

### Section 3.2: Currency Detail Modal

**Purpose:** Show detailed currency information with chart

#### Layout Structure
```
├── Header: Currency Code (e.g., "USD")
├── Value Row
│   ├── "R$ 5.10"
│   └── "↓ -0.14%" (colored)
├── Line Chart
│   ├── Y-axis labels (5.95, 5.26, 5.15)
│   └── Tooltip: "R$ 890.89"
├── Time Period Filters
│   ├── "Semana" (selected)
│   ├── "No mês"
│   ├── "1 mês"
│   └── "12 meses"
├── Variações Section
│   ├── YTD | +0.52% (green)
│   ├── YoY | +3.69% (green)
│   └── MoM | -4.05% (red)
├── Footer
│   ├── Source: "Fonte: IBGE"
│   └── Date: "Data da última variação: 2 de Fevereiro"
└── "Fechar" Button
```

#### Modal Style
- Background: Dark (#1A1A2E)
- Border radius (top): 16px
- Padding: 24px

#### Header Section
- Currency code: 20px, weight 600, White, centered
- Value: 16px, weight 500, White
- Change: 14px, weight 600, colored (green/red)

#### Line Chart
- Single line trend
- Color: #5FB3D3
- Height: ~150px
- Y-axis labels on right side
- Tooltip on hover showing value

#### Time Period Filters

**Layout:** Horizontal row of pill buttons

**Filter Button:**
- Padding: 8px 12px
- Border radius: 16px (fully rounded)
- Background (unselected): Transparent
- Border (unselected): 1px solid #7C7C83
- Background (selected): White or light
- Text (unselected): 13px, weight 500, White
- Text (selected): 13px, weight 500, Dark

**Options:**
- Semana (Week)
- No mês (This month)
- 1 mês (1 month)
- 12 meses (12 months)

#### Variações Section
Same as Inflação section - YTD/YoY/MoM with colored values

#### Close Button
- Width: Full width
- Height: 48px
- Background: #2D3245
- Border radius: 12px
- Text: "Fechar", 16px, weight 600, White

---

### Section 3.3: Mercados Financeiros (Financial Markets)

**Purpose:** Display interest rates and major market indices

#### Layout Structure
```
├── Status Bar
├── Header: "Conjuntura"
├── Tab Bar (Mercados financeiros selected)
├── Section: "Taxas de Juros" (Interest Rates)
│   ├── 🇧🇷 BRA | ↑ +13.75%
│   ├── 🇺🇸 EUA | ↓ -5.25%
│   └── 🇪🇺 EUR | ↑ +4.50%
├── Section: "Principais índices de mercado" (Main Market Indices)
│   ├── 🟢 IBOVESPA | ↑ +0.29%
│   ├── 🟢 IFIX | ↑ +0.62%
│   ├── 🟡 NASDAQ | ↑ +1.22%
│   ├── 🔵 DOW JONES | ↓ -0.20%
│   ├── 🔴 S&P 500 | ↑ +0.49%
│   ├── 🟠 DAX | ↑ +0.28%
│   └── 🇬🇧 FTSE 100 | ↑ +0.42%
└── Info Link: "O que é Comércio Internacional?"
```

#### Section Header
- Text: "Taxas de Juros" or "Principais índices de mercado"
- Size: 14px, weight 600, Color: #9E9E9E
- Margin bottom: 12px

#### Rate/Index List Item

**Layout:**
```
┌─────────────────────────────────────────────────────┐
│ [Icon] [Name]                   [▲/▼] [±X.XX%]  ▼  │
└─────────────────────────────────────────────────────┘
```

**Specifications:**
- Height: ~48px per item
- Padding: 12px 16px
- Background: #2D3245
- Border radius: 8px
- Margin bottom: 8px

**Icon:**
- Country flag for rates (BRA, EUA, EUR)
- Colored circle/logo for indices

**Index Icons (colors):**
| Index | Icon Color |
|-------|------------|
| IBOVESPA | Green circle |
| IFIX | Green circle |
| NASDAQ | Yellow/Gold circle |
| DOW JONES | Blue circle |
| S&P 500 | Red circle |
| DAX | Orange circle |
| FTSE 100 | UK flag 🇬🇧 |

#### Interest Rates Data
| Code | Country | Description |
|------|---------|-------------|
| BRA | Brazil | Selic rate |
| EUA | USA | Fed Funds rate |
| EUR | Eurozone | ECB rate |

#### Market Indices Data
| Index | Description |
|-------|-------------|
| IBOVESPA | Brazilian stock index |
| IFIX | Brazilian real estate fund index |
| NASDAQ | US tech stock index |
| DOW JONES | US industrial index |
| S&P 500 | US large cap index |
| DAX | German stock index |
| FTSE 100 | UK stock index |

---

### Section 3.4: Index Detail Modal (IBOVESPA Example)

**Purpose:** Show detailed index information with chart

#### Layout Structure
```
├── Header: Index Name (e.g., "IBOVESPA")
├── Icon + Change
│   ├── Green circle icon
│   └── "↑ +0.29%" (green)
├── Line Chart
├── Variações Section
│   ├── YTD | +0.52% (green)
│   ├── YoY | +3.69% (green)
│   └── MoM | -4.05% (red)
├── Footer
│   ├── Source: "Fonte: IBGE"
│   └── Date: "Data da última variação: 2 de Fevereiro"
└── "Fechar" Button
```

#### Modal Style
- Same as Currency Detail Modal
- Index-specific icon shown near header

#### Chart
- Single line trend
- Color matches index icon color or #5FB3D3
- Height: ~150px

---

### Reusable Components (Mercado Internacional + Financeiros)

1. **CurrencyListItem** - Flag + code + value + change with expand
2. **CurrencyDetailModal** - Chart + time filters + variations
3. **TimePeriodFilters** - Horizontal pill button row (Semana, No mês, etc.)
4. **RateIndexListItem** - Icon + name + change with expand
5. **IndexDetailModal** - Similar to currency but for indices
6. **SectionHeader** - Gray label for grouping (Taxas de Juros, etc.)

---

### Data Models (Mercado Internacional + Financeiros)

```dart
// Currency exchange rate
class CurrencyRate {
  final String code; // USD, EUR, GBP, etc.
  final String countryFlag; // Emoji or asset path
  final double valueInBRL;
  final double changePercent;
  final bool isPositive;
  final List<TimeSeriesPoint> historicalData;

  CurrencyRate({...});
}

// Interest rate
class InterestRate {
  final String code; // BRA, EUA, EUR
  final String countryFlag;
  final String countryName;
  final double rate;
  final double changePercent;
  final bool isPositive;

  InterestRate({...});
}

// Market index
class MarketIndex {
  final String name; // IBOVESPA, NASDAQ, etc.
  final Color iconColor;
  final String? flagEmoji; // For FTSE 100
  final double currentValue;
  final double changePercent;
  final bool isPositive;
  final double ytdChange;
  final double yoyChange;
  final double momChange;
  final List<TimeSeriesPoint> historicalData;

  MarketIndex({...});
}

// Time period for filtering
enum TimePeriod {
  week,      // Semana
  thisMonth, // No mês
  oneMonth,  // 1 mês
  twelveMonths, // 12 meses
}
```

---

### Implementation Notes (Mercado Internacional + Financeiros)

1. **Flag handling** - Can use emoji flags or country flag package
2. **Index icons** - Simple colored circles, can be implemented with Container + BoxDecoration
3. **Time period filters** - Shared component, can be reused from Home screen period filters
4. **Chart component** - Same line chart as other sections, reuse existing
5. **Detail modals** - Very similar structure to Inflação detail, consider shared base widget
6. **Section grouping** - "Taxas de Juros" and "Principais índices" are logical groups within same screen

---

## Part 4: Setor Público

**Figma Node:** `260:43260`
**Review Date:** 2025-12-04
**Screens Reviewed:** 2

### Section 4.1: Setor Público (Public Sector)

**Purpose:** Display fiscal indicators for public sector finances

#### Layout Structure
```
├── Status Bar
├── Header: "Conjuntura"
├── Tab Bar (Setor público selected)
├── Dropdown: "Indicadores Fiscais"
├── Indicator List
│   ├── Déficit Primário | R$ -80 bilhões | -0.8%
│   ├── Déficit Nominal | R$ -500 bilhões | -5.2%
│   ├── Juros da Dívida | R$ 420 bilhões | +4.4%
│   └── Dívida/PIB | R$ 7.8 trilhões | 78.5%
└── Info Link: "O que é o Setor público?"
```

#### Fiscal Indicators List

| Indicator | Example Value | Change | Description |
|-----------|---------------|--------|-------------|
| Déficit Primário | R$ -80 bilhões | -0.8% | Primary deficit |
| Déficit Nominal | R$ -500 bilhões | -5.2% | Nominal deficit |
| Juros da Dívida | R$ 420 bilhões | +4.4% | Debt interest |
| Dívida/PIB | R$ 7.8 trilhões | 78.5% | Debt to GDP ratio |

#### Indicator List Item

**Layout:**
```
┌─────────────────────────────────────────────────────┐
│ [Indicator Name]                        [±X.X%]  ▼ │
│ [Value]                                            │
└─────────────────────────────────────────────────────┘
```

**Specifications:**
- Height: ~64px per item
- Padding: 16px
- Background: #2D3245
- Border radius: 8px
- Margin bottom: 8px

**Typography:**
| Element | Specification |
|---------|--------------|
| Indicator name | Size: 14px, Weight: 600, Color: White |
| Value (R$ X bilhões/trilhões) | Size: 12px, Weight: 400, Color: #9E9E9E |
| Percentage change | Size: 14px, Weight: 600 |
| Percentage (positive) | Color: #4CAF50 |
| Percentage (negative) | Color: #F44336 |

**Note:** Dívida/PIB shows percentage (78.5%) instead of change percentage

---

### Section 4.2: Fiscal Indicator Detail Modal (Déficit Primário)

**Purpose:** Show detailed fiscal indicator with chart

#### Layout Structure
```
├── Header: "Déficit Primário"
├── Value Row
│   ├── "R$ -80 bilhões"
│   └── "-0.8%" (colored)
├── Line Chart
├── Variações Section
│   ├── YTD | +0.52% (green)
│   ├── YoY | +3.69% (green)
│   └── MoM | -4.05% (red)
├── Footer
│   ├── Source: "Fonte: IBGE"
│   └── Date: "Data da última variação: 2 de Fevereiro"
└── "Fechar" Button
```

#### Modal Style
- Same as other detail modals
- Background: Dark (#1A1A2E)
- Border radius (top): 16px
- Padding: 24px

#### Chart
- Single line trend
- Color: #5FB3D3
- Height: ~150px
- Shows historical deficit values

---

### Reusable Components (Setor Público)

1. **FiscalIndicatorListItem** - Same structure as other indicator items
2. **FiscalDetailModal** - Chart + variations (reuses existing pattern)

---

### Data Models (Setor Público)

```dart
// Fiscal indicator
class FiscalIndicator {
  final String name;
  final double value;
  final String formattedValue; // "R$ -80 bilhões"
  final double changePercent;
  final bool isPositive;
  final bool isPercentageValue; // For Dívida/PIB which shows % as main value
  final double ytdChange;
  final double yoyChange;
  final double momChange;
  final List<TimeSeriesPoint> historicalData;

  FiscalIndicator({...});
}
```

---

### Implementation Notes (Setor Público)

1. **Consistent indicator pattern** - Setor Público uses same list item structure as Desempenho Econômico
2. **Detail modal reuse** - Same modal pattern across all sections

---

## Part 5: Additional Sections - Complete

All main Conjuntura tabs have been reviewed:
1. ✅ Expectativas
2. ✅ Desempenho Econômico
3. ✅ Inflação
4. ✅ Mercado Internacional
5. ✅ Mercados Financeiros
6. ✅ Setor Público

---

## Known Issues (Same as Other Screens)

1. **Primary Color:** #1B6FFF vs current implementation
2. **Font Family:** Plus Jakarta Sans/General Sans vs DMSans
3. **Chart Library:** Need to integrate `fl_chart` or similar

---

## Files to Create/Modify

### New Files (Suggested Structure)
```
lib/screens/conjuntura/
├── conjuntura_screen.dart           # Main screen with tab navigation
├── conjuntura_controller.dart       # GetX controller
├── conjuntura_paywall_screen.dart   # Premium paywall
├── widgets/
│   ├── pill_tab_bar.dart           # Horizontal pill tabs
│   ├── indicator_dropdown.dart      # Category selector
│   ├── indicator_list_item.dart     # Expandable indicator row
│   ├── indicator_detail_modal.dart  # Bottom sheet detail view
│   ├── expectations_chart.dart      # Multi-year line chart
│   ├── year_comparison_row.dart     # Year/value/change row
│   └── variation_row.dart           # YTD/YoY/MoM row
├── models/
│   ├── economic_indicator.dart
│   ├── time_series_point.dart
│   └── year_comparison.dart
└── services/
    └── conjuntura_service.dart      # API calls
```

### Existing Files to Modify
- `lib/utils/constants/routes.dart` - Add Conjuntura routes
- `lib/main.dart` - Register Conjuntura routes

---

## Review Checklist

### Part 1
- [x] Free Plan Paywall screen
- [x] Expectativas tab (chart + year comparison)
- [x] Desempenho Econômico tab (indicator list)
- [x] Indicator detail modal (PIB Agro example)
- [x] Component specifications documented
- [x] Data models defined
- [ ] Expectativas dropdown options - TBD
- [ ] Desempenho Econômico dropdown options - TBD

### Part 2: Inflação
- [x] IGP-M view (line chart + variations)
- [x] IPCA view (donut chart + category legend)
- [x] Variações info modal
- [x] Month picker modal
- [x] Year picker modal
- [x] Component specifications documented
- [x] Data models defined

### Part 3: Mercado Internacional + Mercados Financeiros
- [x] Mercado Internacional - Currency list (USD, EUR, GBP, JPY, CAD, AUD)
- [x] Currency detail modal with chart + time filters
- [x] Mercados Financeiros - Interest rates (BRA, EUA, EUR)
- [x] Mercados Financeiros - Market indices (IBOVESPA, IFIX, NASDAQ, etc.)
- [x] Index detail modal (IBOVESPA example)
- [x] Component specifications documented
- [x] Data models defined

### Part 4: Setor Público
- [x] Setor Público main list (Déficit Primário, Déficit Nominal, Juros da Dívida, Dívida/PIB)
- [x] Fiscal indicator detail modal
- [x] Component specifications documented
- [x] Data models defined

### Global Component
- [x] Info Bottom Sheet pattern documented (see [global-components.md](./global-components.md))

### Overall Status: ✅ COMPLETE
All Conjuntura sections have been reviewed and documented.

---

## Notes

- Conjuntura is a premium-only feature, ensure proper access control
- Heavy use of charts - consider performance for large datasets
- Multiple dropdown categories suggest backend filtering needed
- Year comparison feature is unique to this section
- Info links ("O que é X?") may need help/glossary content
