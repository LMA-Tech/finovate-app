# Figma Design Review: Carteira (Wallet/Portfolio)

**Review Date:** 2025-12-04
**Screens Reviewed:** Home states, Manual wallet, B3 connected wallet

This review is organized into 3 parts:
1. **Part 1: Home States** - Different wallet states on the home screen
2. **Part 2: Wallet-Manual** - Manual portfolio management (no B3 connection)
3. **Part 3: Wallet-B3** - B3 connected portfolio

---

# Part 1: Home States

**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=261-51364

## Overview

The home screen displays the user's wallet/portfolio in different states depending on their account setup:

1. **State 1: No Portfolio** - User hasn't connected B3 or added manual assets (shows B3 connection banner only)
2. **State 2: Manual Portfolio** - User has manually added assets (shows portfolio with chart + B3 connection banner)
3. **State 3: B3 Connected** - User has connected B3 account (full portfolio view, no B3 banner)

---

## State 1: No Portfolio (B3 Connection Prompt Only)

This is the default state for new users who haven't set up their portfolio.

### "Minha carteira" Section
Shows only the B3 connection banner prompting users to connect their account.

**B3 Connection Banner:**
| Property | Value |
|----------|-------|
| Background | Semi-transparent green/teal gradient |
| Border Radius | 12px |
| Padding | 16px |
| Text | "Conecte sua conta B3 para aproveitar todos os recursos." |
| Text Size | 14px |
| Text Weight | 400 |
| Text Color | White |
| Arrow Icon | Right arrow, white |
| Height | ~56px |

---

## State 2: Manual Portfolio (With B3 Banner)

User has manually added assets but hasn't connected B3. Shows portfolio data with the B3 connection banner still visible.

### Section Header
| Element | Specification |
|---------|--------------|
| Title | "Minha carteira" |
| Title Size | 16px, Weight 500, Color: White |
| "Ver mais" Link | 14px, Weight 500, Color: #BADBC1 |

### B3 Connection Banner
Same as State 1 - still prompting user to connect B3 for full features.

### Portfolio Tabs (Segmented Control)
| Property | Value |
|----------|-------|
| Container Background | #2D3245 |
| Container Height | 48px |
| Container Border Radius | 12px |
| Selected Tab Background | #1B6FFF |
| Selected Tab Border Radius | 8px |
| Tab Options | Rentabilidade, Risco, Composição |
| Tab Text Size | 16px |
| Tab Text Weight | 500 |
| Selected Text Color | White |
| Unselected Text Color | #DFDFE0 |

### Period Filter Pills
| Property | Value |
|----------|-------|
| Options | Semana, No mês, 1 mês, 12 meses |
| Selected State | Filled background (#2D3245) |
| Unselected State | Border only (#7C7C83) |
| Border Radius | 18px |
| Height | 36px |
| Text Size | 13px |
| Text Weight | 500 (unselected), 600 (selected) |

### Portfolio Performance Chart

**Chart Container:**
| Property | Value |
|----------|-------|
| Height | ~145px |
| Width | Full width (with padding) |

**Chart Lines:**
| Line | Color | Description |
|------|-------|-------------|
| IBOV | #5FB3D3 (blue) | Benchmark index |
| Sua carteira | #BADBC1 (green/teal) | User's portfolio |

**Grid Lines:**
- 5 vertical lines, evenly spaced
- 1 horizontal line (baseline)
- Color: White @ 10% opacity

**Data Tooltip (on hover/tap):**
| Property | Value |
|----------|-------|
| Background | #15254E |
| Border Radius | 8px |
| Date Text | "5 de Fev 2025" - 12px, #DFDFE0 |
| Performance Values | Row with colored dots + percentages |
| IBOV Value | "9,21%" with blue dot |
| Portfolio Value | "7,13%" with green dot |

### Chart Legend
| Property | Value |
|----------|-------|
| Layout | Horizontal row, centered below chart |
| Background | #15254E |
| Border Radius | 6px |
| Padding | 6px 10px |
| Dot Size | 10x10px circle |
| Text Size | 13px |
| Text Weight | 500 |
| Spacing | 8px between items |

**Legend Items:**
- IBOV (blue dot #5FB3D3)
- Sua carteira (green dot #BADBC1)

---

## State 3: B3 Connected Portfolio (Full View)

User has connected their B3 account. No B3 connection banner - full portfolio experience.

### Differences from State 2:
- **No B3 Connection Banner** - Banner is removed
- **Same Tab Navigation** - Rentabilidade, Risco, Composição
- **Same Period Filters** - Semana, No mês, 1 mês, 12 meses
- **Same Chart** - Dual-line comparison chart
- **Same Legend** - IBOV vs Sua carteira

---

## Common Components Across All States

### Home Header
| Element | Specification |
|---------|--------------|
| Profile Picture | 32x32px, circular |
| Greeting | "Olá, [Name]" - 14px, Weight 400, #DFDFE0 |
| Welcome Text | "Bem vindo" - 20px, Weight 600, White |
| Notification Bell | 24x24px icon with red badge indicator |

### Bolsa (Stocks) Section
| Element | Specification |
|---------|--------------|
| Section Header | "Bolsa" with "Ver mais" link |
| Layout | Horizontal scroll of stock cards |
| Card Width | 212px |
| Card Height | 130px |
| Card Background | #2D3245 |
| Card Border Radius | 12px |

**Stock Card Content:**
- Company logo (40x40px)
- Stock symbol (16px, Weight 600)
- Company name (13px, Weight 400, #DFDFE0)
- Trend arrow (up green / down red)
- Price (16px, Weight 500)
- Change amount and percentage

### Economia (Economy) Section
| Element | Specification |
|---------|--------------|
| Section Header | "Economia" with "Ver mais" link |
| Layout | Horizontal scroll of economy cards |
| Card Width | 212px |
| Card Height | 106px |
| Card Background | #2D3245 |
| Card Border Radius | 12px |

**Economy Card Content:**
- Indicator title (e.g., "Dólar", "Taxa de juros")
- Subtitle/description
- Trend arrow
- Value/percentage change
- Optional: Mini sparkline chart

### Feedback Button
| Property | Value |
|----------|-------|
| Text | "Enviar Feedback" |
| Style | Outlined button |
| Border | 1px, #7C7C83 |
| Border Radius | 12px |
| Height | 56px |
| Text Size | 16px |
| Text Weight | 500 |
| Arrow Icon | Right arrow |

---

## State Management Logic

```dart
// Determine which home state to show
enum PortfolioState {
  noPortfolio,      // State 1: Show B3 banner only
  manualPortfolio,  // State 2: Show portfolio + B3 banner
  b3Connected,      // State 3: Show full portfolio, no banner
}

PortfolioState getPortfolioState(User user) {
  if (user.hasB3Connection) {
    return PortfolioState.b3Connected;
  } else if (user.hasManualAssets) {
    return PortfolioState.manualPortfolio;
  } else {
    return PortfolioState.noPortfolio;
  }
}
```

---

## Implementation Notes

1. **B3 Connection Banner** should be a separate widget that can be conditionally shown/hidden
2. **Portfolio Section** visibility depends on whether user has any assets
3. **Chart** should handle empty state gracefully
4. **Period Filters** should update chart data when changed
5. **Tab Navigation** switches between Rentabilidade (returns), Risco (risk), and Composição (composition) views

---

## Color Reference

| Element | Color Code |
|---------|------------|
| Primary Blue (tabs) | #1B6FFF |
| Portfolio Line | #BADBC1 |
| IBOV Line | #5FB3D3 |
| Positive Change | #BADBC1 |
| Negative Change | #FF6B6B |
| Card Background | #2D3245 |
| Tooltip Background | #15254E |
| Secondary Text | #DFDFE0 |
| Muted Text | #7C7C83 |

---

## Files to Create/Update

```
lib/screens/home/
├── home_screen.dart                    # Main home screen
├── home_controller.dart                # State management
└── widgets/
    ├── home_header.dart                # Header with greeting
    ├── b3_connection_banner.dart       # B3 connection prompt
    ├── portfolio_section.dart          # Portfolio tabs + filters
    ├── portfolio_chart.dart            # Dual-line chart
    ├── portfolio_legend.dart           # Chart legend
    ├── stocks_section.dart             # Bolsa horizontal scroll
    ├── stock_card.dart                 # Individual stock card
    ├── economy_section.dart            # Economia horizontal scroll
    ├── economy_card.dart               # Individual economy card
    └── feedback_button.dart            # Feedback CTA
```

---

# Part 2: Wallet-Manual (No B3 Connection)

**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=261-58832

## Overview

The manual wallet flow allows users to add and manage their portfolio without connecting to B3. This includes:

1. **Portfolio Setup Bottom Sheet** - Initial choice between manual entry or B3 connection
2. **Add New Asset Form** - Form to manually add assets
3. **Manual Portfolio View** - Full portfolio screen with charts and distribution

---

## Screen 1: Portfolio Setup Bottom Sheet

A bottom sheet that appears when user first accesses the wallet or taps to set up their portfolio.

### Bottom Sheet Container
| Property | Value |
|----------|-------|
| Background | #1A1A2E or #0D1B2A |
| Border Radius (top) | 24px |
| Padding | 24px |

### Title
| Property | Value |
|----------|-------|
| Text | "Vamos montar sua carteira!" |
| Size | 20px |
| Weight | 600 |
| Color | White |
| Alignment | Center |

### Option 1: Manual Entry Card
| Property | Value |
|----------|-------|
| Background | #2D3245 |
| Border Radius | 12px |
| Padding | 16px |
| Title | "Adicione seus ativos manualmente" |
| Title Size | 16px, Weight 600, White |
| Description | "Ideal para quem está começando e quer montar a carteira aos poucos." |
| Description Size | 14px, Weight 400, #DFDFE0 |
| Arrow Icon | Right chevron, #7C7C83 |

### Option 2: B3 Connection Card (Recommended)
| Property | Value |
|----------|-------|
| Background | #2D3245 |
| Border Radius | 12px |
| Padding | 16px |
| Border | 1px solid #1B6FFF (highlighted) |
| Title | "Conecte sua conta B3" |
| Title Size | 16px, Weight 600, White |
| Description | "Sincronize seus investimentos automaticamente e aproveite todos os recursos do app." |
| Description Size | 14px, Weight 400, #DFDFE0 |
| Badge | "Mais recomendada" |
| Badge Background | #1B6FFF |
| Badge Text | 12px, Weight 500, White |
| Badge Border Radius | 4px |
| Arrow Icon | Right chevron, #7C7C83 |

### Continue Button
| Property | Value |
|----------|-------|
| Background | #1B6FFF |
| Text | "Continuar" |
| Text Size | 16px |
| Text Weight | 600 |
| Text Color | White |
| Height | 56px |
| Border Radius | 12px |
| Width | Full width |

---

## Screen 2: Add New Asset Form ("Novo ativo")

Form screen for manually adding a new asset to the portfolio.

### Header
| Element | Specification |
|---------|--------------|
| Back Button | Left arrow icon |
| Title | "Novo ativo" - 18px, Weight 600, White, Center |

### Form Fields

All form fields follow the same base styling:

| Property | Value |
|----------|-------|
| Background | #2D3245 |
| Border Radius | 12px |
| Height | 56px |
| Padding | 16px |
| Label Color | #DFDFE0 |
| Label Size | 13px |
| Input Text Color | White |
| Input Text Size | 16px |
| Placeholder Color | #7C7C83 |

#### Field 1: Código do ativo (Asset Code)
| Property | Value |
|----------|-------|
| Label | "Código do ativo" |
| Placeholder | "Exemplo: PETR4, ITUB3, KNRI11..." |
| Type | Text input with autocomplete |

#### Field 2: Tipo do ativo (Asset Type)
| Property | Value |
|----------|-------|
| Label | "Tipo do ativo" |
| Type | Dropdown/Select |
| Default Value | "Ação" |
| Dropdown Icon | Chevron down, right side |
| Options | Ação, FII, ETF, BDR, Renda Fixa, etc. |

#### Field 3: Quantidade (Quantity)
| Property | Value |
|----------|-------|
| Label | "Quantidade" |
| Placeholder | "Número de cotas/ações compradas" |
| Type | Numeric input |

#### Field 4: Preço médio por compra (Average Purchase Price)
| Property | Value |
|----------|-------|
| Label | "Preço médio por compra" |
| Placeholder | "R$" |
| Type | Currency input |
| Format | Brazilian Real (R$ X.XXX,XX) |

#### Field 5: Data da compra (Purchase Date)
| Property | Value |
|----------|-------|
| Label | "Data da compra" |
| Type | Two dropdowns side by side |
| Left Dropdown | "Mês" (Month) |
| Right Dropdown | "Ano" (Year) |
| Dropdown Width | ~50% each with gap |

### Submit Button
| Property | Value |
|----------|-------|
| Background | #BADBC1 (green) |
| Text | "Adicionar ativo" |
| Text Size | 16px |
| Text Weight | 600 |
| Text Color | #0D1B2A (dark) |
| Height | 56px |
| Border Radius | 12px |
| Width | Full width |

---

## Screen 3: Manual Portfolio View ("Minha carteira")

Full portfolio screen showing manually added assets with charts and distribution.

### Header
| Element | Specification |
|---------|--------------|
| Back Button | Left arrow icon |
| Title | "Minha carteira" - 18px, Weight 600, White, Center |
| Menu Button | Three dots (more options), right side |

### B3 Connection Banner
Same banner as home screen prompting user to connect B3 for full features.

### Total Return Section ("Rentabilidade total")
| Element | Specification |
|---------|--------------|
| Section Title | "Rentabilidade total" - 14px, Weight 400, #DFDFE0 |
| Info Icon (ⓘ) | Right side of title, #9E9E9E |
| Total Value | "R$ 191.475,24" - 28px, Weight 700, White |
| Eye Icon | Toggle visibility, next to value |
| Change Amount | "+ R$ 2,06 (0,39%)" - 14px, Weight 500 |
| Positive Color | #BADBC1 |
| Negative Color | #FF6B6B |

**Change Display Variants:**
- Positive: Green text with up arrow "↑ + R$ 2,06 (0,39%)"
- Negative: Red text with down arrow "↓ -R$ 2,06 (0,39%)" (shown in red pill on right)

### Portfolio Tabs
Same as home screen:
- Rentabilidade (selected by default)
- Risco
- Composição

### Period Filters
Same as home screen:
- Semana (selected by default)
- No mês
- 1 mês
- 12 meses

### Performance Chart
Same dual-line chart as home screen:
- IBOV line (blue #5FB3D3)
- Sua carteira line (green #BADBC1)
- Tooltip with date and values
- Source: "Fonte: Banco central"

### Chart Legend
| Element | Specification |
|---------|--------------|
| Layout | Horizontal, right-aligned |
| IBOV | Blue dot + "IBOV" |
| Sua carteira | Green dot + "Sua carteira" |

---

## Portfolio Distribution Section ("Distribuição da carteira")

### Section Header
| Element | Specification |
|---------|--------------|
| Title | "Distribuição da carteira" - 16px, Weight 500, White |
| Info Icon (ⓘ) | Right side, #9E9E9E |

### Donut/Pie Chart
| Property | Value |
|----------|-------|
| Size | ~150x150px |
| Style | Donut chart (hollow center) |
| Stroke Width | ~30px |

**Chart Segments (Sample Data):**
| Category | Color | Percentage |
|----------|-------|------------|
| Renda Fixa | #5FB3D3 (blue) | 25% |
| Ações | #BADBC1 (green) | 40% |
| FIIs | #F5A623 (orange) | 20% |
| ETFs | #1B6FFF (blue) | 10% |

### Legend (Right side of chart)
| Property | Value |
|----------|-------|
| Layout | Vertical list |
| Dot Size | 10x10px circle |
| Text Size | 14px |
| Text Color | White |
| Percentage | Right-aligned |

### Source
| Property | Value |
|----------|-------|
| Text | "Fonte: Banco central" |
| Size | 11px |
| Color | #7C7C83 |

---

## Proventos (Dividends) Section

### Section Header
| Element | Specification |
|---------|--------------|
| Title | "Proventos" - 16px, Weight 500, White |
| Info Icon (ⓘ) | Right side, #9E9E9E |

### Filter Dropdowns
Two dropdown filters side by side:

| Dropdown | Specification |
|----------|--------------|
| Left | "Classe de ativos" with chevron |
| Right | "Produtos" with chevron |
| Background | #2D3245 |
| Border Radius | 8px |
| Height | 40px |
| Text Size | 14px |
| Text Color | White |

### Events Section ("Eventos da carteira")
| Element | Specification |
|---------|--------------|
| Title | "Eventos da carteira" - 14px, Weight 500, White |
| Year Legend | Colored dots for 2026 (orange), 2027 (blue) |

### Bar Chart
| Property | Value |
|----------|-------|
| Type | Stacked/Grouped bar chart |
| X-Axis | Months (Jan, Fev, Mar, Abr) |
| Y-Axis | Values (0, R$ 50, R$ 100, R$ 150, R$ 200) |
| Bar Colors | Orange (#F5A623) for 2026, Blue (#5FB3D3) for 2027 |
| Bar Border Radius | 4px (top) |

**Tooltip on hover:**
| Property | Value |
|----------|-------|
| Background | #2D3245 |
| Border Radius | 8px |
| Title | "Evolução" |
| Value | "R$ 10.234,99" |

### Period Toggle
| Property | Value |
|----------|-------|
| Options | "Por ano", "Por mês" |
| Selected State | Filled background (#2D3245) |
| Unselected State | Transparent |
| Border Radius | 8px |
| Text Size | 13px |

### Source
| Property | Value |
|----------|-------|
| Text | "Fonte: Banco central" |
| Size | 11px |
| Color | #7C7C83 |

---

## Info Icon (ⓘ) Locations

| Location | Trigger | Info Content |
|----------|---------|--------------|
| Rentabilidade total | Tap (ⓘ) | Explanation of total return calculation |
| Distribuição da carteira | Tap (ⓘ) | Explanation of portfolio distribution |
| Proventos | Tap (ⓘ) | Explanation of dividends/proventos |

**Note:** Use global `showInfoBottomSheet()` from `docs/global-components.md`.

---

## Data Models

```dart
// lib/models/manual_asset.dart

class ManualAsset {
  final String id;
  final String code;           // e.g., "PETR4"
  final AssetType type;        // Ação, FII, ETF, etc.
  final int quantity;          // Number of shares/units
  final double averagePrice;   // Average purchase price
  final DateTime purchaseDate;
  final DateTime createdAt;

  ManualAsset({
    required this.id,
    required this.code,
    required this.type,
    required this.quantity,
    required this.averagePrice,
    required this.purchaseDate,
    required this.createdAt,
  });
}

enum AssetType {
  acao,       // Stock
  fii,        // Real Estate Fund
  etf,        // ETF
  bdr,        // BDR
  rendaFixa,  // Fixed Income
}

class PortfolioDistribution {
  final String category;
  final double percentage;
  final Color color;

  PortfolioDistribution({
    required this.category,
    required this.percentage,
    required this.color,
  });
}

class DividendEvent {
  final DateTime date;
  final double amount;
  final String assetCode;
  final String type; // "dividendo", "JCP", etc.

  DividendEvent({
    required this.date,
    required this.amount,
    required this.assetCode,
    required this.type,
  });
}
```

---

## Files to Create

```
lib/screens/carteira/
├── carteira_screen.dart              # Main portfolio screen
├── carteira_controller.dart          # State management
├── add_asset_screen.dart             # Add new asset form
└── widgets/
    ├── portfolio_setup_sheet.dart    # Setup bottom sheet
    ├── total_return_card.dart        # Rentabilidade total section
    ├── distribution_chart.dart       # Donut/pie chart
    ├── distribution_legend.dart      # Chart legend
    ├── proventos_section.dart        # Dividends section
    ├── proventos_filters.dart        # Filter dropdowns
    ├── events_bar_chart.dart         # Bar chart for events
    └── asset_form_fields.dart        # Form field components
```

---

## Implementation Notes

1. **Asset Code Autocomplete:** Consider implementing autocomplete for asset codes (PETR4, ITUB3, etc.)
2. **Form Validation:** Validate all fields before enabling submit button
3. **Currency Formatting:** Use Brazilian Real format (R$ X.XXX,XX)
4. **Chart Library:** Use `fl_chart` for both donut chart and bar chart
5. **Data Persistence:** Store manual assets in local storage or backend
6. **Visibility Toggle:** Eye icon should mask/unmask the total value

---

# Part 3: Wallet-B3 (B3 Connected Portfolio)

**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=261-66300

## Overview

The B3 wallet flow allows users to connect their Brazilian stock exchange (B3) account to automatically sync their investments. This includes:

1. **B3 Data Consent Screen** - Terms and consent for data sharing
2. **B3 Connection Success Screen** - Confirmation after successful connection
3. **B3 Connected Portfolio View** - Full portfolio screen with synced data

---

## Screen 1: B3 Data Consent Screen ("Vincular à minha conta B3")

This screen appears when user chooses to connect their B3 account.

### Header
| Element | Specification |
|---------|--------------|
| Back Button | Left arrow icon, top left |
| Title | "Vincular à minha conta B3" - 18px, Weight 600, White, Center |
| Partner Text | "Vinculando com: Finovate" - 14px, Weight 400, #DFDFE0 |

### Legal Notice Section
| Property | Value |
|----------|-------|
| Section Title | "AVISO DE TRATAMENTO DE DADOS E TERMO DE CONSENTIMENTO" |
| Title Size | 12px, Weight 600, White, ALL CAPS |
| Content Background | #2D3245 |
| Content Border Radius | 12px |
| Content Padding | 16px |
| Content Height | ~200px (scrollable) |
| Text Size | 13px |
| Text Color | #DFDFE0 |
| Line Height | 1.5 |

**Legal Text Preview:**
> "Olá Investidor!
>
> Para permitir que as empresas gerenciadoras de carteiras de investimento e as calculadoras privadas de imposto de renda possam prestar serviços escolhidos por você, é necessário que você autorize o compartilhamento de alguns dos seus dados, inclusive pessoais, mediante o aceite no checkbox abaixo que representará o seu consentimento. O compartilhamento é livre, voluntário e está subordinado à sua vontade."

### Consent Checkbox
| Property | Value |
|----------|-------|
| Checkbox Size | 24x24px |
| Checkbox Color (unchecked) | #2D3245 border, transparent fill |
| Checkbox Color (checked) | #1B6FFF fill, white checkmark |
| Border Radius | 4px |
| Text | "Autorizo o envio dos meus dados para esta empresa gerenciadora de carteiras de investimento e/ou calculadora privada de imposto de renda." |
| Text Size | 14px |
| Text Weight | 400 |
| Text Color | White |
| Line Height | 1.4 |

### Continue Button
| Property | Value |
|----------|-------|
| Background (disabled) | #2D3245 |
| Background (enabled) | #1B6FFF |
| Text | "Continuar" |
| Text Size | 16px |
| Text Weight | 600 |
| Text Color (disabled) | #7C7C83 |
| Text Color (enabled) | White |
| Height | 56px |
| Border Radius | 12px |
| Width | Full width |

**Button State:**
- Disabled until checkbox is checked
- Enabled with primary blue when checkbox is checked

---

## Screen 2: B3 WebView/External Authorization

### Header
| Property | Value |
|----------|-------|
| Logo | [B]³ logo |
| Title | "Vincular à minha conta B3" |
| Subtitle | "Vinculando com: TradeMap" |

**Note:** This is an external WebView provided by B3/TradeMap for secure authorization. The app embeds this view.

### WebView Content
| Property | Value |
|----------|-------|
| Background | Dark theme matching app |
| Title | "AVISO DE TRATAMENTO DE DADOS E TERMO DE CONSENTIMENTO" |
| Update Date | "Última atualização em 01/02/2022" |
| Scrollable Content | Legal terms |
| Checkbox | Same consent pattern |
| Button | "CONTINUAR" - green/teal (#BADBC1) |

---

## Screen 3: B3 Connection Success ("Sua conta B3 foi conectada!")

This screen appears after successful B3 authorization.

### Success Icon/Animation
| Property | Value |
|----------|-------|
| Icon | Checkmark in circle or connection icon |
| Icon Color | #BADBC1 (green) |
| Icon Size | 64x64px |
| Position | Center, above text |

### Success Message
| Element | Specification |
|---------|--------------|
| Title | "Sua conta B3 foi conectada!" |
| Title Size | 20px |
| Title Weight | 600 |
| Title Color | White |
| Title Alignment | Center |

### Information Text
| Property | Value |
|----------|-------|
| Primary Text | "Agora é só acompanhar seus ativos da bolsa aqui na Finovate." |
| Primary Size | 14px |
| Primary Weight | 400 |
| Primary Color | #DFDFE0 |
| Secondary Text | "Lembrete: as novas operações aparecerão na carteira sempre no próximo dia útil." |
| Secondary Style | Regular |

### Sync Notice Card
| Property | Value |
|----------|-------|
| Background | #2D3245 |
| Border Radius | 12px |
| Padding | 16px |
| Text | "O B3 pode levar até 2 dias úteis para refletir suas operações na Finovate." |
| Highlight | "até 2 dias úteis" in orange/yellow (#F5A623) |
| Text Size | 14px |
| Text Color | White/highlighted |

### Action Button
| Property | Value |
|----------|-------|
| Background | #BADBC1 (green) |
| Text | "Ir para minha carteira" |
| Text Size | 16px |
| Text Weight | 600 |
| Text Color | #0D1B2A (dark) |
| Height | 56px |
| Border Radius | 12px |
| Width | Full width |

---

## Screen 4: B3 Connected Portfolio View ("Minha carteira")

Full portfolio screen with all data synced from B3. This is the complete wallet view without the B3 connection banner.

### Header
| Element | Specification |
|---------|--------------|
| Back Button | Left arrow icon |
| Title | "Minha carteira" - 18px, Weight 600, White, Center |
| Menu Button | Three dots (more options), right side |

### Rentabilidade Total Section
| Element | Specification |
|---------|--------------|
| Section Title | "Rentabilidade total" - 14px, Weight 400, #DFDFE0 |
| Info Icon (ⓘ) | Right side of title, #9E9E9E |
| Total Value | "R$ 191.475,24" - 28px, Weight 700, White |
| Eye Icon | Toggle visibility, next to value |
| Change Badge | Green pill with positive change |
| Change Text | "↑ + R$ 2,06 (0,39%)" |
| Change Color | #BADBC1 (positive) |
| Badge Background | Semi-transparent green |

### Portfolio Tabs (Same as Manual)
| Property | Value |
|----------|-------|
| Container Background | #2D3245 |
| Container Height | 48px |
| Container Border Radius | 12px |
| Selected Tab Background | #1B6FFF |
| Tab Options | Rentabilidade, Risco, Composição |
| Selected: | "Rentabilidade" |

### Period Filters (Same as Manual)
| Property | Value |
|----------|-------|
| Options | Semana, No mês, 1 mês, 12 meses |
| Selected State | Filled background (#2D3245) |
| Selected: | "Semana" |

### Performance Chart
Same dual-line comparison chart:
| Property | Value |
|----------|-------|
| IBOV Line | #5FB3D3 (blue) |
| Portfolio Line | #BADBC1 (green/teal) |
| Grid Lines | White @ 10% opacity |
| Tooltip Date | "5 de Fev 2025" |
| IBOV Value | "9,21%" |
| Portfolio Value | "7,13%" |

### Chart Legend
| Element | Specification |
|---------|--------------|
| Layout | Horizontal, right-aligned |
| IBOV | Blue dot (#5FB3D3) + "IBOV" |
| Sua carteira | Green dot (#BADBC1) + "Sua carteira" |

### Source Footer
| Property | Value |
|----------|-------|
| Text | "Fonte: Banco central" |
| Size | 11px |
| Color | #7C7C83 |

---

## Distribution Section ("Distribuição da carteira")

### Section Header
| Element | Specification |
|---------|--------------|
| Title | "Distribuição da carteira" - 16px, Weight 500, White |
| Info Icon (ⓘ) | Right side, #9E9E9E |

### Donut Chart
| Property | Value |
|----------|-------|
| Size | ~150x150px |
| Style | Donut chart (hollow center) |
| Stroke Width | ~30px |

**Sample Distribution:**
| Category | Color | Percentage |
|----------|-------|------------|
| Renda Fixa | #5FB3D3 (blue) | 25% |
| Ações | #BADBC1 (green) | 40% |
| FIIs | #F5A623 (orange) | 20% |
| ETFs | #1B6FFF (blue) | 10% |

### Legend (Right side)
| Property | Value |
|----------|-------|
| Layout | Vertical list |
| Dot Size | 10x10px circle |
| Text Size | 14px |
| Text Color | White |
| Percentage | Right-aligned |

---

## Proventos Section (Same as Manual)

Same structure as Part 2 Manual Portfolio.

---

## B3 Connection Flow Summary

```
Portfolio Setup Bottom Sheet
├── Option 1: Manual Entry → Part 2 Flow
└── Option 2: Connect B3 (Recommended)
    └── B3 Data Consent Screen
        └── User checks consent checkbox
            └── Tap "Continuar"
                └── B3 WebView Authorization
                    └── User authorizes in B3/TradeMap
                        └── Success Screen
                            └── Tap "Ir para minha carteira"
                                └── B3 Connected Portfolio View
```

---

## Data Models (B3 Specific)

```dart
// lib/models/b3_connection.dart

class B3Connection {
  final String id;
  final String userId;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;
  final B3SyncStatus syncStatus;
  final String? errorMessage;

  B3Connection({
    required this.id,
    required this.userId,
    required this.connectedAt,
    this.lastSyncAt,
    required this.syncStatus,
    this.errorMessage,
  });
}

enum B3SyncStatus {
  pending,      // Waiting for initial sync
  syncing,      // Currently syncing
  synced,       // Successfully synced
  error,        // Sync failed
}

class B3Asset {
  final String id;
  final String code;           // e.g., "PETR4"
  final AssetType type;        // Ação, FII, ETF, etc.
  final int quantity;
  final double averagePrice;
  final double currentPrice;
  final double totalValue;
  final double profitLoss;
  final double profitLossPercent;
  final DateTime lastUpdated;
  final String source;         // "B3"

  B3Asset({
    required this.id,
    required this.code,
    required this.type,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.totalValue,
    required this.profitLoss,
    required this.profitLossPercent,
    required this.lastUpdated,
    this.source = 'B3',
  });
}

class B3Transaction {
  final String id;
  final String assetCode;
  final TransactionType type;
  final int quantity;
  final double price;
  final DateTime transactionDate;
  final DateTime syncedAt;

  B3Transaction({
    required this.id,
    required this.assetCode,
    required this.type,
    required this.quantity,
    required this.price,
    required this.transactionDate,
    required this.syncedAt,
  });
}

enum TransactionType {
  buy,
  sell,
  dividend,
  jcp,        // Juros sobre Capital Próprio
  split,
  grouping,
}
```

---

## Files to Create (B3 Specific)

```
lib/screens/carteira/
├── b3_consent_screen.dart            # Data consent screen
├── b3_webview_screen.dart            # WebView for B3 authorization
├── b3_success_screen.dart            # Connection success screen
├── carteira_b3_screen.dart           # B3 connected portfolio view
└── widgets/
    ├── b3_consent_checkbox.dart      # Consent checkbox component
    ├── b3_sync_notice.dart           # Sync notice card
    └── b3_connection_status.dart     # Connection status indicator

lib/services/
└── b3_service.dart                   # B3 connection and sync service

lib/models/
├── b3_connection.dart                # B3 connection model
├── b3_asset.dart                     # B3 synced asset model
└── b3_transaction.dart               # B3 transaction model
```

---

## Implementation Notes

1. **B3 Authorization:** Uses OAuth-like flow via TradeMap WebView
2. **Data Consent:** Must be explicitly accepted before proceeding
3. **Sync Delay:** User should be informed that sync may take up to 2 business days
4. **Error Handling:** Handle connection failures gracefully with retry option
5. **Refresh:** Add pull-to-refresh to manually trigger sync
6. **Disconnect:** Provide option to disconnect B3 in settings/profile

---

## Color Reference (B3 Specific)

| Element | Color Code |
|---------|------------|
| Primary Button | #1B6FFF |
| Success/CTA Button | #BADBC1 |
| Button Text (on green) | #0D1B2A |
| Highlight Text | #F5A623 (orange) |
| Checkbox Checked | #1B6FFF |
| Disabled State | #2D3245 bg, #7C7C83 text |

---

## Next Steps

1. Implement B3 consent screen with legal text
2. Set up WebView for B3 authorization
3. Create success screen with navigation
4. Build B3 connected portfolio view
5. Implement B3 service for sync logic
6. Add disconnect B3 option in profile settings
7. Handle sync states and errors
