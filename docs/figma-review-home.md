# Figma Design Review: Home Screen

**Review Date:** 2025-12-02
**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=3-6384
**Screens Reviewed:** Home dashboard with tabs (Rentabilidade, Risco, Composição)

## Summary

✅ **Overall Status:** Home screen implementation closely matches Figma design with good component structure.

✅ **Layout:** Component hierarchy matches Figma specifications.

⚠️ **Charts:** Currently using placeholder CustomPainter - needs proper chart library integration.

⚠️ **Button Color:** Same issue as other screens (#4B68FF vs #1B6FFF).

⚠️ **Font Family:** Same DMSans vs Plus Jakarta Sans/General Sans discrepancy.

## Component Breakdown

### 1. Header Section (HomeHeader)

**Figma Structure:**
- User avatar (profile picture)
- Greeting: "Olá, [Name]"
- Welcome message: "Bem vindo"
- Notification bell with red indicator badge

**Implementation:** `home_header.dart`

**Typography Specifications:**

| Element | Figma Spec | Implementation | Status |
|---------|-----------|----------------|--------|
| Greeting text ("Olá, [Name]") | Font: General Sans<br>Size: 14px<br>Weight: 400<br>Line height: 1.29<br>Letter spacing: -0.28px | Matches | ✅ |
| Welcome text ("Bem vindo") | Font: Plus Jakarta Sans<br>Size: 20px<br>Weight: 600<br>Line height: 1.6<br>Letter spacing: -0.4px | Matches | ✅ |
| Notification badge | Color: Red (#D32F2F)<br>Size: 14x14px | `FinColors.error` | ✅ |

**Note:** Profile picture missing from implementation - only shows text greeting.

### 2. B3 Connection Banner

**Figma:** Green-tinted banner with text "Conecte sua conta B3 para aproveitar todos os recursos." + arrow icon

**Implementation:** `b3_connection_banner.dart`

**Status:** ✅ Component exists and matches design intent

**Colors:**
- Background: Appears to be semi-transparent or overlaid
- Text: White
- Arrow icon: White

### 3. Portfolio Section ("Minha carteira")

**Figma Structure:**
- Section title: "Minha carteira"
- "Ver mais" link (green color)
- Three tabs in container: Rentabilidade, Risco, Composição
- Four time period filters: Semana, No mês, 1 mês, 12 meses

**Implementation:** `portfolio_section.dart:25-108`

**Typography:**

| Element | Figma Spec | Implementation | Status |
|---------|-----------|----------------|--------|
| Section title | Size: 16px<br>Weight: 500<br>Letter spacing: 0.1px | Matches (`portfolio_section.dart:35-40`) | ✅ |
| "Ver mais" link | Color: #BADBC1<br>Size: 14px<br>Weight: 500 | Matches (`portfolio_section.dart:47-53`) | ✅ |
| Tab text | Size: 16px<br>Weight: 500<br>Letter spacing: 0.1px | Matches (`portfolio_section.dart:132-136`) | ✅ |
| Period filters | Size: 13px<br>Weight: 500/600 (selected) | Matches (`portfolio_section.dart:161-165`) | ✅ |

**Layout Specifications:**
- **Tab container background:** #2D3245 ✅
- **Tab container height:** 48px ✅
- **Tab border radius:** 12px ✅
- **Selected tab background:** Primary color ⚠️ (wrong blue - see Color Issues)
- **Period filter border (inactive):** #7C7C83, 1px
- **Period filter border (active):** #BADBC1, 2px ✅

**Status:** ✅ Structure and layout match well

### 4. Portfolio Chart

**Figma Chart Specifications:**
- **Type:** Line chart
- **Lines:**
  - IBOV (blue): #5FB3D3
  - Sua carteira (green/teal): #BADBC1
- **Grid lines:** Vertical (5 lines) + Horizontal (implied)
- **Height:** ~145px
- **Legend:** Pills with colored dots + labels
- **Performance indicators:** Percentage values above chart

**Implementation:** `portfolio_chart.dart`

**Current Status:** ⚠️ **Placeholder Implementation**
- Using `CustomPainter` with hardcoded path points
- Grid lines implemented ✅
- Colors match Figma ✅
- Legend styling matches ✅
- Performance indicators match ✅

**Recommendation:** Replace with proper chart library
```dart
// Consider using fl_chart package
dependencies:
  fl_chart: ^0.66.0
```

**Chart Features Needed:**
- Real data binding
- Smooth line animations
- Touch interactions (optional)
- Data point tooltips (Figma shows date "5 de Fev 2025" on hover)
- Responsive scaling

**Chart Colors (Verified):**
```dart
final portfolioColor = Color(0xFFBADBC1); // ✅ Matches Figma
final ibovColor = Color(0xFF5FB3D3);      // ✅ Matches Figma
final gridColor = Colors.white.withOpacity(0.1); // ✅ Appropriate
```

### 5. Stocks Section ("Bolsa")

**Figma Structure:**
- Section title: "Bolsa"
- "Ver mais" link
- Horizontal scrollable cards with stock information
- Each card shows:
  - Company logo/icon
  - Stock symbol (e.g., "AMZN")
  - Company name (e.g., "Amazon Inc")
  - Trend arrow (up/down)
  - Current price
  - Change amount and percentage

**Implementation:** `stock_card.dart` (referenced in `home_screen.dart:84-88`)

**Sample Data Provided:**
```dart
StockData(
  symbol: 'AMZN',
  companyName: 'Amazon Inc',
  price: '\$ 443.01',
  change: '+ \$ 9.45',
  changePercent: '1.89%',
  isPositive: true,
)
```

**Card Specifications (from Figma):**
- **Background:** #2D3245 (or similar dark container)
- **Border radius:** 12px
- **Padding:** 12px
- **Height:** ~130px
- **Width:** ~212px
- **Company logo size:** ~40px circle
- **Trend arrow:** Green (up) or Red (down)
- **Price typography:** Size 16px, Weight 500
- **Change typography:** Size 16px, Weight 400, colored by direction

**Status:** ✅ Component structure exists

### 6. Economy Section ("Economia")

**Figma Structure:**
- Section title: "Economia"
- "Ver mais" link
- Horizontal scrollable cards with economy indicators
- Each card shows:
  - Indicator title (e.g., "Dólar", "Taxa de juros", "Expectativa do PIB")
  - Subtitle/description
  - Trend arrow
  - Value/change percentage
  - Optional mini chart/sparkline

**Implementation:** `economy_section.dart` (referenced in `home_screen.dart:93-96`)

**Sample Data Provided:**
```dart
EconomyIndicatorData(
  title: 'Dólar',
  change: '+ \$ 2.45',
  changePercent: '1.89%',
  isPositive: true,
)
```

**Card Specifications (from Figma):**
- **Background:** #2D3245 (or similar dark container)
- **Border radius:** 12px
- **Padding:** 12px
- **Height:** ~106px
- **Width:** ~212px
- **Mini chart:** Small vector path showing trend (optional)

**Status:** ✅ Component structure exists

**Note:** Figma shows small vector charts/sparklines in some economy cards - implementation may need mini chart component.

### 7. Feedback Button

**Figma:**
- Text: "Enviar Feedback"
- Icon: Arrow right
- Style: Text button with minimal styling

**Implementation:** `feedback_button.dart` (referenced in `home_screen.dart:101-103`)

**Status:** ✅ Component exists

## Typography Verification

### Header Text
- **Greeting text:** 14px, weight 400, -0.28px letter spacing ✅ (`home_header.dart:34-40`)
- **Welcome text:** 20px, weight 600, 1.6 line height, -0.4px letter spacing ✅ (`home_header.dart:46-53`)

### Section Titles
- **"Minha carteira":** 16px, weight 500, 1.5 line height, 0.1px letter spacing ✅
- **"Ver mais" links:** 14px, weight 500, color #BADBC1 ✅

### Tab Text
- **Tabs:** 16px, weight 500, 1.5 line height, 0.1px letter spacing ✅
- **Period filters:** 13px, weight 500/600 (when selected), 1.5 line height ✅

### Chart Legend
- **Legend text:** 13px, weight 500, 1.85 line height, 0.1px letter spacing ✅ (`portfolio_chart.dart:119-125`)

## Color Verification

### Backgrounds
- **Tab container:** #2D3245 ✅ (`portfolio_section.dart:65`)
- **Legend container:** #15254E ✅ (`portfolio_chart.dart:102`)
- **Card backgrounds (implied):** #2D3245 ✅

### Text Colors
- **Primary text:** White (#FFFFFF or #FEFEFE) ✅
- **Secondary text:** #DFDFE0 ✅
- **Link text:** #BADBC1 ✅

### Chart Colors
- **Portfolio line:** #BADBC1 ✅
- **IBOV line:** #5FB3D3 ✅
- **Grid lines:** White @ 10% opacity ✅

### Button/Tab Colors
- **Selected tab background:** Primary color ⚠️ **ISSUE:** Using wrong blue
  - Current: #1355FF or #4B68FF
  - Should be: #1B6FFF (see colors.dart issue)

### Period Filter Colors
- **Inactive border:** #7C7C83, 1px ✅
- **Active border:** #BADBC1, 2px ✅

## Layout & Spacing

### Screen Structure
```
├── SafeArea
│   ├── SingleChildScrollView
│   │   ├── HomeHeader (greeting + notification)
│   │   ├── B3ConnectionBanner
│   │   ├── PortfolioSection (tabs + filters)
│   │   ├── PortfolioChart
│   │   ├── StocksGrid
│   │   ├── EconomySection
│   │   └── FeedbackButton
│   └── FinBottomNavigation
```

### Spacing (from implementation)
- **Top padding:** 16px ✅
- **Between header and banner:** 32px ✅
- **Between banner and portfolio:** 32px ✅
- **Within portfolio (header to tabs):** 16px ✅
- **Within portfolio (tabs to filters):** 24px ✅
- **Between portfolio and chart:** 24px ✅
- **Between sections:** 32px ✅
- **Bottom padding:** 24px ✅
- **Horizontal padding:** 24px (FinSizes.defaultSpace) ✅

**Status:** ✅ Spacing appears consistent with Figma

## Issues Found

### 1. Primary Button/Tab Color (Same as Other Screens)
**Severity:** Medium

**Issue:** Selected tab uses wrong primary color
- **Current:** #1355FF or #4B68FF (from `FinColors.primary`)
- **Figma:** #1B6FFF

**Location:** `portfolio_section.dart:118`
```dart
color: isSelected ? FinColors.primary : Colors.transparent,
```

**Impact:** All selected tabs use wrong blue color

**Fix:** Same as previous screens - update `colors.dart:13,37`

### 2. Chart Implementation (Placeholder)
**Severity:** Medium

**Issue:** Chart is currently a placeholder using `CustomPainter` with hardcoded points

**Location:** `portfolio_chart.dart:133-214`

**Recommendation:** Integrate proper chart library
```yaml
dependencies:
  fl_chart: ^0.66.0
```

**Features to implement:**
- Real data binding
- Smooth animations
- Interactive tooltips
- Date labels on hover
- Responsive grid scaling

### 3. Profile Picture Missing
**Severity:** Low

**Issue:** Figma shows user profile picture/avatar in header, implementation only shows text

**Location:** `home_header.dart:26-57`

**Current:** Text greeting only

**Figma:** Profile picture (32x32px circular) + text greeting

**Recommendation:** Add optional avatar parameter
```dart
final String? avatarUrl;

// In build:
Row(
  children: [
    if (avatarUrl != null)
      CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(avatarUrl),
      ),
    const SizedBox(width: 12),
    Column(...),
  ],
)
```

### 4. Mini Charts/Sparklines in Economy Cards
**Severity:** Low

**Issue:** Figma shows small vector charts in economy indicator cards (especially "Taxa de juros" and "Expectativa do PIB")

**Status:** Not implemented yet (cards show text only)

**Recommendation:** Add optional mini chart component or use sparkline package
```yaml
dependencies:
  fl_chart: ^0.66.0  # Can also render small sparklines
```

### 5. Font Family (Same as All Screens)
**Severity:** Medium

**Issue:** App uses DMSans, Figma specifies Plus Jakarta Sans and General Sans

**Impact:** All typography rendering differs slightly from design

**Status:** Project-wide decision needed (see previous reviews)

## Chart Requirements Documentation

### Line Chart Specifications

**Chart Type:** Dual-line comparison chart (portfolio vs benchmark)

**Dimensions:**
- Height: ~200px (configurable via parameter)
- Width: Full container width minus padding
- Aspect ratio: Approximately 16:9

**Data Structure Needed:**
```dart
class ChartDataPoint {
  final DateTime date;
  final double portfolioValue;
  final double benchmarkValue;

  ChartDataPoint({
    required this.date,
    required this.portfolioValue,
    required this.benchmarkValue,
  });
}
```

**Visual Elements:**

1. **Grid Lines:**
   - Vertical: 5 lines evenly spaced
   - Horizontal: 4 lines evenly spaced
   - Color: White @ 10% opacity
   - Stroke width: 1px

2. **Data Lines:**
   - Portfolio line:
     - Color: #BADBC1 (teal/green)
     - Stroke width: 2px
     - Style: Solid, smooth curves
   - IBOV line:
     - Color: #5FB3D3 (blue)
     - Stroke width: 2px
     - Style: Solid, smooth curves

3. **Interactive Elements:**
   - Touch/hover reveals tooltip with:
     - Date (e.g., "5 de Fev 2025")
     - Portfolio percentage
     - IBOV percentage
   - Tooltip background: Dark (#15254E or similar)
   - Tooltip text: White

4. **Performance Indicators (above chart):**
   - Two percentage displays
   - Left: Portfolio return (green color #BADBC1)
   - Right: IBOV return (varies)
   - Font size: 18px, weight 600

5. **Legend (below chart):**
   - Pills/badges style
   - Background: #15254E
   - Border radius: 6px
   - Colored dot (10x10px circle) + label
   - Text: 13px, weight 500

**Recommended Library:** `fl_chart`
```yaml
dependencies:
  fl_chart: ^0.66.0
```

**Alternative:** `syncfusion_flutter_charts` (more features, commercial license)

## Files Reviewed

1. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/screens/home/home_screen.dart`
2. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/screens/home/widgets/home_header.dart`
3. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/screens/home/widgets/portfolio_section.dart`
4. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/screens/home/widgets/portfolio_chart.dart`

## Files Mentioned (Not Yet Reviewed)

1. `lib/screens/home/widgets/b3_connection_banner.dart`
2. `lib/screens/home/widgets/stock_card.dart`
3. `lib/screens/home/widgets/economy_section.dart`
4. `lib/screens/home/widgets/feedback_button.dart`
5. `lib/screens/home/home_controller.dart`

## Tab Variants in Figma

The Figma canvas shows multiple variants:
1. **home-rentabilidade-tab** (default view) ✅ Reviewed
2. **home-risco-tab** (risk view) - Structure similar, different chart data
3. **home-composicao-tab** (composition view) - May show pie chart or different visualization

**Note:** These variants use the same tab component with different content. Implementation supports tab switching ✅ (`home_screen.dart:69-73`)

## Comparison with Other Screens

### Consistent Elements
- ✅ Background gradient (same as onboarding, login, signup)
- ✅ White text on dark background
- ✅ Border radius patterns (12px for containers, 6-8px for smaller elements)
- ⚠️ Primary color issue (same as all other screens)
- ⚠️ Font family discrepancy (same as all other screens)

### Home-Specific Elements
- Tab navigation (unique to home)
- Period filters (unique to home/portfolio context)
- Line chart visualization
- Stock/economy cards with trend indicators
- Performance percentage displays

## Next Steps

1. **Fix primary color** - Same fix as other screens (`colors.dart`)
2. **Integrate chart library** - Replace CustomPainter with `fl_chart`
3. **Review remaining widgets** - Stock card, economy section, feedback button
4. **Add profile picture support** - Optional avatar in header
5. **Implement mini charts** - For economy indicators (optional)
6. **Test tab switching** - Verify different content shows for Risco and Composição tabs
7. **Continue reviews** - Conjuntura, Perfil, Carteira screens

## Notes

- Home screen implementation is well-structured with reusable components ✅
- Placeholder chart is functional for demo but needs proper library for production
- Component hierarchy matches Figma design well
- Color and typography mostly match (except known global issues)
- Good use of GetX reactive state management for tab/filter selections
- Sample data is reasonable for prototype/demo purposes
- Missing some visual polish elements (avatars, mini charts) but core functionality is solid
