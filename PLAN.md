# Finovate App - Complete Implementation Plan

## Overview

This plan covers all requirements from `specs/initial-requirements.md`, organized by feature area with UI work prioritized first. Each section indicates current status and required work.

**Important Constraints:**
- **Figma-First:** All UI must match Figma designs exactly (charts, layouts, colors, spacing)
- **Dark Theme Only:** Force dark mode, prevent light mode from breaking UI
- **Iterative Approach:** Manual testing after each phase, requirements may shift
- **Keep It Simple:** Avoid overcomplication, focus on core functionality
- **Sofia:** Skip conversation persistence (using Zep later) and search (post-MVP)

---

## Code Style Guidelines

**IMPORTANT:** All code must follow these guidelines for consistency and maintainability.

### Folder Structure & Separation of Concerns
- **Screen Structure:** Follow the `screen`, `controller`, and `widgets` directory approach:
  ```
  lib/screens/<feature>/
  ├── <feature>_screen.dart       # Main screen widget
  ├── <feature>_controller.dart   # GetX controller for state
  └── widgets/                    # Small, composable widgets
      ├── widget_one.dart
      └── widget_two.dart
  ```
- **Controller:** State management and business logic
- **Screen:** Layout composition using widgets
- **Widgets:** Small, reusable, single-responsibility components

### Widget Design
- **Prefer small composable widgets** over large monolithic ones
- **Prefer flex values** (`Expanded`, `Flexible`, `Spacer`) over hardcoded sizes in Rows/Columns
- This ensures the UI adapts to various screen sizes
- Extract repeated UI patterns into separate widget classes

### Logging
- **Use `log` from `dart:developer`** rather than `print` or `debugPrint`
- Example: `import 'dart:developer'; log('message');`
- Never leave `print()` statements in production code

### Utils & Constants
- **Always use utils directory** to avoid inline code for:
  - Colors: `lib/utils/constants/colors.dart` (FinColors)
  - Sizes: `lib/utils/constants/sizes.dart` (FinSizes)
  - Text strings: `lib/utils/constants/text_strings.dart`
  - Routes: `lib/utils/constants/routes.dart`
  - Images: `lib/utils/constants/image_strings.dart`
- **Never hardcode** colors, sizes, or strings inline
- Add new constants to the appropriate file when needed

### Common Widgets
- **Track reusable patterns** in `lib/common/widgets/`
- When similar code appears in multiple places, extract to common widget
- Document common widgets in `docs/global-components.md`
- Current common widgets:
  - `primary_button.dart` - Primary, secondary, text buttons
  - `custom_card.dart` - Card variants
  - `skeleton_loader.dart` - Skeleton loading placeholders
  - `loading_state.dart` - Centered loading spinner (uses `loading_indicator` package with `ballSpinFadeLoader`)
  - `empty_state.dart` - Empty state displays
  - `error_state.dart` - Error state with retry
  - `section_header.dart` - Section headers with "Ver mais"
  - `scrollable_header.dart` - Header with back button for scrollable screens (unlike `custom_appbar.dart` which is fixed)
  - `segmented_tabs.dart` - Tab navigation with pop-out effect
  - `toast_notification.dart` - Toast messages
  - `info_bottom_sheet.dart` - Info sheets
  - `charts/` - Chart components (line, pie, bar, legends)

### Code Quality Checklist
Before committing code, verify:
- [ ] No `print()` statements (use `log()` instead)
- [ ] No hardcoded colors (use `FinColors.*`)
- [ ] No hardcoded sizes (use `FinSizes.*`)
- [ ] No hardcoded strings for UI text
- [ ] Widgets are small and composable
- [ ] Flex values used instead of fixed sizes where appropriate
- [ ] Similar code extracted to common widgets
- [ ] Follows screen/controller/widgets structure

---

## Technical Debt: Code Style Violations

**Note:** The following violations were identified during code review. These should be addressed incrementally.

### 1. print()/debugPrint() Usage (Replace with log())
Files with `print()` statements to refactor:
- `lib/services/auth_service.dart` (1 occurrence)
- `lib/controllers/bottom_navigation_controller.dart` (3 occurrences)
- `lib/services/finovate_api_service.dart` (3 occurrences)
- `lib/screens/splash/splash_controller.dart` (8 occurrences)
- `lib/screens/sofia/sofia_home_controller.dart` (5 occurrences - uses kDebugMode)
- `lib/screens/signup/signup_controller.dart` (12 occurrences)
- `lib/config/env_config.dart` (11 occurrences)

Files with `debugPrint()` statements to refactor:
- `lib/services/session_manager.dart` (50+ occurrences)
- `lib/services/biometric_service.dart` (15+ occurrences)
- `lib/services/activity_tracker.dart` (15+ occurrences)
- `lib/services/centralized_email_service.dart` (4 occurrences)
- `lib/controllers/bottom_navigation_controller.dart` (6 occurrences)
- `lib/screens/sofia/sofia_chat_controller.dart` (8 occurrences)
- `lib/screens/login/login_controller.dart` (1 occurrence)
- `lib/screens/home/home_controller.dart` (3 occurrences)
- `lib/screens/forgot_password/forgot_password_controller.dart` (2 occurrences)
- Multiple other files

### 2. Hardcoded Colors (Replace with FinColors.*)
**Status:** ✅ Complete (31/31 screen files + common widgets refactored)

**All Screen Files Refactored:**
- ✅ `lib/screens/feedback/widgets/*.dart` (5 files)
- ✅ `lib/screens/home/widgets/*.dart` (5 files)
- ✅ `lib/screens/sofia/*.dart` (4 files)
- ✅ `lib/screens/signup/widgets/*.dart` (8 files)
- ✅ `lib/screens/forgot_password/widgets/*.dart` (4 files)
- ✅ `lib/screens/login/widgets/login_header.dart`
- ✅ `lib/screens/perfil/perfil_screen.dart`
- ✅ `lib/screens/carteira/carteria_screen.dart`
- ✅ `lib/screens/conjuntura/conjuntura_screen.dart`

**Common Widgets Refactored:**
- ✅ `lib/common/widgets/primary_button.dart`
- ✅ `lib/common/widgets/segmented_tabs.dart`
- ✅ `lib/common/widgets/toast_notification.dart`
- ✅ `lib/common/widgets/info_bottom_sheet.dart`
- ✅ `lib/common/widgets/custom_text_field.dart`

**FinColors Constants (Complete Set):**

*UI Components:*
- `cardBackground` (#2D3245) - Card/input background
- `inputBackground` (#2D3245) - Input field background
- `dialogBackground` (#1A1A2E) - Modal/dialog background
- `bottomNavBackground` (#242432) - Bottom nav bar
- `bottomNavBorder` (#2A2A3A) - Nav bar top border
- `tooltipBackground` (#15254E) - Chart tooltip background

*Text Colors:*
- `textWhite` (Colors.white) - Primary text on dark
- `textGray200` (#DFDFE0) - Secondary text
- `textGray300` (#7C7C83) - Placeholder/muted text
- `textSubtitle` (#CAD7F8) - Light blue subtitle

*Border Colors:*
- `borderMint` (#BADBC1) - Mint/teal accent border
- `borderBlue` (#1B6FFF) - Selected state blue
- `otpInputBorder` (#E3EBFF) - OTP/input field border

*Trend Indicators:*
- `trendPositive` (#0CB97B) - Positive green
- `trendNegative` (#E02244) - Negative red
- `trendPositiveBg` (#BADBC1) - Positive background
- `trendNegativeBg` (#FFD7DE) - Negative background

*UI Elements:*
- `avatarBorder` (#39DDA2) - Green avatar border
- `starGold` (#FFD700) - Rating stars
- `radioUnselected` (#6B6C70) - Unselected radio
- `progressInactive` (#3D4255) - Inactive progress
- `shimmerHighlight` (#3D4255) - Skeleton loader
- `iconGray` (#9E9E9E) - Generic gray icon
- `checkmarkGreen` (#00C853) - Success checkmark

*Segmented Tabs:*
- `segmentUnselectedText` (#FEFEFE) - Unselected text
- `segmentShadow` (#3D1A2F5C) - Tab shadow (24% opacity)

*Toast Notifications:*
- `toastSuccess` (#BADBC1) - Success background
- `toastSuccessText` (#0D1B2A) - Success text
- `toastError` (#FF6B6B) - Error background
- `toastInfo` (#1B6FFF) - Info background

*Banner:*
- `bannerText` (#F0F5EF) - Banner text
- `bannerGradientStart` (#013ACB) - Gradient start
- `bannerGradientEnd` (#477552) - Gradient end

**ChartColors Constants:**
- `ibovStroke` (#68686E) - IBOV legend stroke
- `portfolioStroke` (#39DDA2) - Portfolio legend stroke

### 3. Folder Structure Violations
Screens missing proper structure (controller + widgets directory):
- `lib/screens/carteira/` - Only has `carteria_screen.dart` (also typo in filename)
- `lib/screens/conjuntura/` - Only has `conjuntura_screen.dart`
- `lib/screens/perfil/` - Only has `perfil_screen.dart`
- `lib/screens/splash/` - Missing widgets directory

Screens with proper structure ✅:
- `lib/screens/home/` - Has screen, controller, widgets/
- `lib/screens/signup/` - Has screen, controller, widgets/
- `lib/screens/login/` - Has screen, controller, widgets/
- `lib/screens/feedback/` - Has screen, controller, widgets/
- `lib/screens/sofia/` - Has screens, controller, widgets/
- `lib/screens/forgot_password/` - Has controller, widgets/
- `lib/screens/onboarding/` - Has controller, widgets/
- `lib/screens/get_started/` - Has controller, widgets/

### 4. Priority for Refactoring
1. **High Priority:** New code must follow guidelines
2. **Medium Priority:** Feedback flow files (recently created)
3. **Low Priority:** Legacy files (refactor during feature work)

**Status Legend:**
- ✅ Complete
- ⚠️ Needs Fixes/Enhancement
- ❌ Not Implemented
- 🔄 In Progress

---

## Phase 0: Pre-Implementation Setup

### 0.1 Figma Design Review
**Status:** ✅ 100% Complete - All screens reviewed

**Purpose:**
- Review all Figma designs before implementing any visual changes
- Ensure all UI components match Figma specifications exactly
- Understand expected chart styles, colors, and layouts
- Extract design tokens (colors, spacing, typography) from Figma

**Tasks:**
- [x] Use Figma MCP to access and review all screens:
  - [x] Onboarding flow - **Complete** (`docs/figma-review-onboarding.md`)
  - [x] Sign up flow - **Complete** (`docs/figma-review-signup.md`)
  - [x] Login flow - **Complete** (`docs/figma-review-login.md`)
  - [x] Home dashboard - **Complete** (`docs/figma-review-home.md`)
  - [x] Conjuntura sections - **Complete** (`docs/figma-review-conjuntura.md`)
  - [x] My Profile - **Complete** (`docs/figma-review-perfil.md`)
  - [x] Stocks/Market view - **Complete** (`docs/figma-review-stocks.md`)
  - [x] My Wallet/Carteira - **Complete** (`docs/figma-review-carteira.md`)
  - [x] SofIA chat interface - **Complete** (`docs/figma-review-sofia.md`)
- [x] Document chart requirements from Figma - **Complete** (`docs/figma-chart-requirements.md`)
  - [x] Line chart styles (colors, grid, labels)
  - [x] Pie chart styles (colors, labels, interactions)
  - [x] Bar chart styles (colors, spacing, labels)
  - [x] Sparkline specifications
- [x] Extract color palette and verify against `colors.dart` - **Complete** (`docs/figma-color-verification.md`)
- [x] Document spacing/sizing and verify against `sizes.dart` - **Complete** (in individual reviews)
- [x] Note any typography differences - **Complete** (in individual reviews)
- [x] Create implementation checklist per screen matching Figma - **Complete** (in individual reviews)
- [x] Document global/reusable components - **Complete** (`docs/global-components.md`)

**Key Findings:**
1. **⚠️ Critical Color Issue:** Button primary color is #4B68FF in app but should be #1B6FFF (correct color exists as `FinColors.blue`)
2. **⚠️ Font Discrepancy:** App uses DMSans, Figma specifies Plus Jakarta Sans and General Sans (project-wide decision needed)
3. **✅ Background/Text Colors:** Match Figma specifications well
4. **⚠️ Typography:** Minor adjustments needed (title sizes, letter spacing)
5. **⚠️ Charts:** Need proper library integration (fl_chart recommended)

**Documentation Created:**

| Document | Description | Use When |
|----------|-------------|----------|
| `docs/figma-review-onboarding.md` | Onboarding flow (3 slides + get started) | Building onboarding screens |
| `docs/figma-review-signup.md` | 12-step signup flow with questionnaire | Building signup screens |
| `docs/figma-review-login.md` | Login, forgot password, OTP screens | Building auth screens |
| `docs/figma-review-home.md` | Home dashboard with portfolio, stocks, economy sections | Building home screen |
| `docs/figma-review-sofia.md` | SofIA AI chat interface | Building chat screens |
| `docs/figma-review-perfil.md` | Profile/settings screens | Building profile section |
| `docs/figma-review-conjuntura.md` | Economic indicators (6 sections) | Building conjuntura tab |
| `docs/figma-review-stocks.md` | Stocks list and detail screens | Building stocks/market view |
| `docs/figma-review-carteira.md` | Portfolio/wallet (3 parts: home states, manual, B3) | Building carteira tab |
| `docs/figma-review-feedback.md` | 4-screen feedback flow (rating, focus areas, comments, success) | Building feedback screens |
| `docs/figma-chart-requirements.md` | All chart specifications (line, pie, bar) | Implementing any chart |
| `docs/figma-color-verification.md` | Color palette verification and issues | Fixing color issues |
| `docs/global-components.md` | Reusable components (buttons, inputs, toasts, bottom sheets) | Building any UI component |

**How to Use These Documents:**
1. Before implementing any screen, **read the corresponding figma-review-*.md file**
2. Reference `docs/global-components.md` for reusable component specs
3. Reference `docs/figma-chart-requirements.md` when implementing any chart
4. Check `docs/figma-color-verification.md` for correct color values
5. Each review includes: typography specs, spacing, colors, component structure, data models, and files to create

**Next:** Proceed with Phase 1.2 (Common UI Components)

---

## Phase 1: UI Foundation & Common Components

### 1.1 Theme System - Force Dark Mode
**Status:** ✅ Complete

**Current State:**
- Both light and dark themes implemented
- MVP will use dark theme only
- **Fixed:** App now forces dark theme regardless of device system settings

**Decision:**
- Keep both themes in codebase (very low priority to expose light theme post-MVP)
- **Force dark mode regardless of device system settings**
- Light theme remains dormant but available for future

**Tasks:**
- [x] **PRIORITY:** Force `ThemeMode.dark` in GetMaterialApp in main.dart
- [x] Remove `ThemeMode.system` to prevent automatic theme switching
- [x] Ensure all screens use dark theme colors consistently
- [x] Verify background gradients (#252532 to #111111) applied everywhere
- [x] Test with device in light mode to confirm dark theme stays consistent

**Files Modified:**
- `lib/main.dart` - Changed `themeMode: ThemeMode.system` to `themeMode: ThemeMode.dark`
- `lib/screens/sofia/sofia_chat_screen.dart` - Replaced hardcoded background with `AppBackground` widget
- `lib/utils/theme/theme.dart` - Verified
- `lib/utils/constants/colors.dart` - Verified
- `lib/utils/constants/background_decorations.dart` - Verified

---

### 1.2 Common UI Components
**Status:** ✅ Complete

**Current State:**
- All common UI components implemented
- Chart components using fl_chart library
- Export files for easy importing

**Completed Tasks:**

#### 1.2.1 Generic Card Component ✅
- [x] Created `lib/common/widgets/custom_card.dart`
- [x] Support variants: default, elevated, outlined
- [x] Add optional header/footer sections
- [x] Make responsive with proper padding

#### 1.2.2 Error State Component ✅
- [x] Created `lib/common/widgets/error_state.dart`
- [x] Display error icon, message, and retry button
- [x] Support custom error messages
- [x] Include inline error variant

#### 1.2.3 Empty State Component ✅
- [x] Created `lib/common/widgets/empty_state.dart`
- [x] Display icon, title, subtitle, and CTA button
- [x] Context-aware factories (portfolioNotConnected, noData, noSearchResults, featureNotEnabled)

#### 1.2.4 Skeleton Loading Screens ✅
- [x] Created `lib/common/widgets/skeleton_loader.dart`
- [x] Implement shimmer effect with animation
- [x] Create variants for: cards, lists, charts (SkeletonListItem, SkeletonChart, SkeletonCardGrid)

#### 1.2.5 Chart Components (Using fl_chart) ✅
- [x] Added fl_chart package to pubspec.yaml: `fl_chart: ^0.69.2`
- [x] Created `lib/utils/constants/chart_colors.dart` - Centralized chart colors
- [x] Created `lib/common/widgets/charts/custom_line_chart.dart`
  - Support multiple data series
  - Interactive tooltips
  - Configurable grid
- [x] Created `lib/common/widgets/charts/custom_pie_chart.dart`
  - Donut chart with center content
  - Tap-to-select sections
  - Legend component included
- [x] Created `lib/common/widgets/charts/custom_bar_chart.dart`
  - Support single, grouped, and stacked bars
  - Interactive tooltips
- [x] Created `lib/common/widgets/charts/time_period_selector.dart`
  - Portfolio periods (Semana, No mês, 1 mês, 12 meses)
  - Variation periods (YTD, YoY, MoM)
  - View toggle selector
- [x] Created `lib/common/widgets/charts/chart_legend.dart`
  - Pill-style legends
  - Performance indicators component
  - ChartWithHeader combined component

#### 1.2.6 Additional Global Components ✅
- [x] Created `lib/common/widgets/toast_notification.dart` - Success/error/info toasts
- [x] Created `lib/common/widgets/section_header.dart` - Section headers with "Ver mais" link
- [x] Created `lib/common/widgets/info_bottom_sheet.dart` - Info sheets for (ⓘ) icons
- [x] Created `lib/common/widgets/primary_button.dart` - Primary, secondary, text buttons
- [x] Created `lib/common/widgets/segmented_tabs.dart` - Tab navigation component

#### 1.2.7 Export Files ✅
- [x] Created `lib/common/widgets/charts/charts.dart` - Export all chart components
- [x] Created `lib/common/widgets/widgets.dart` - Export all common widgets

**Files Created:** 16 new widget files

---

## Phase 2: Authentication & Onboarding Fixes

### 2.1 Splash & Onboarding
**Status:** ✅ Complete

**Current State:** Fully functional - no changes needed

---

### 2.2 Login Screen - Biometric Issues
**Status:** ⚠️ Needs Fixes

**Current State:**
- Login works but biometric preference not persisted
- Always offers biometric enrollment

**Tasks:**
- [ ] Implement biometric preference storage using secure storage
- [ ] Add check on login: if user has biometric enabled, skip offer dialog
- [ ] Persist biometric choice in Supabase user preferences table
- [ ] Update LoginController line 115: implement TODO
- [ ] Update LoginController line 139: implement TODO

**Files:**
- `lib/screens/login/login_screen.dart`
- `lib/services/biometric_service.dart`
- Add: flutter_secure_storage package

---

### 2.3 Signup Flow - Code Quality
**Status:** ⚠️ Needs Enhancement

**Current State:**
- Fully functional 12-step flow
- Has debug print statements
- Manual signup flow flag management

**Tasks:**
- [ ] Replace all `print()` statements with `log()` from dart:developer
- [ ] Add automatic cleanup if app crashes during signup (session recovery)
- [ ] Improve error handling for questionnaire submission failures
- [ ] Add analytics tracking for signup completion rate

**Files:**
- `lib/screens/signup/signup_controller.dart`
- `lib/screens/signup/signup_screen.dart`

---

### 2.4 Forgot Password
**Status:** ✅ Complete

**Current State:** Fully functional - no changes needed

---

## Phase 3: Home Screen Implementation

### 3.1 Home Screen - Data Integration
**Status:** ✅ 97% Complete - UI and API integration done, pull-to-refresh and error states added

**Current State:**
- All UI sections built and integrated with backend API
- **Refactored:** Home widgets now use common chart components (fl_chart)
- **Refactored:** PortfolioSection uses SectionHeader, SegmentedTabs, TimePeriodSelector
- **Refactored:** PortfolioChart uses CustomLineChart with proper legends
- **Refactored:** StockCard and EconomySection use common components
- **Added:** Skeleton loading states for all sections
- **Added:** "Ver mais" navigation to appropriate tabs
- **Added:** 4-screen feedback flow (rating → focus areas → comments → success)
- **Integrated:** Dashboard API providing stocks, indicators, indices, portfolio data
- **Models:** Stock, MarketIndicator, MarketIndex, DashboardSummary created in lib/models/

**Tasks:**

#### 3.1.1 Header Section
- [✅] User greeting - Already implemented
- [✅] Notification bell - Already implemented
- [✅] User avatar with green border (#39DDA2) - 32x32 per Figma
- [✅] Display full name from Supabase metadata (first_name + last_name)
- [✅] Initials fallback when no profile photo
- [ ] Connect notifications to backend (post-MVP)

#### 3.1.2 B3 Connection Banner
- [✅] Banner UI - Already implemented
- [ ] Connect to B3 connection status from backend
- [ ] Dismiss functionality persists in user preferences
- [ ] Show only when B3 not connected

#### 3.1.3 Portfolio Summary Section
- [✅] Tabs UI (Rentabilidade/Risco/Composição) - Refactored with SegmentedTabs
- [✅] Time period filters - Refactored with TimePeriodSelector
- [✅] Section header - Refactored with SectionHeader component
- [✅] Connect "Ver mais" to Carteira tab navigation - **DONE**
- [ ] Replace mock portfolio data with B3 API data
- [ ] Implement real portfolio vs IBOV comparison chart
- [ ] Add last updated timestamp
- [ ] Add pull-to-refresh for portfolio data

#### 3.1.4 Portfolio Chart Enhancement
- [✅] Replace CustomPaint chart with fl_chart LineChart - **DONE**
- [✅] Add interactive tooltips on hover/tap - **DONE** (via CustomLineChart)
- [✅] Chart legend with proper colors - **DONE** (ChartLegend component)
- [✅] Fetch real portfolio performance data from backend - **DONE** (via /dashboard/summary)
- [✅] Fetch benchmark data (IBOV) from API - **DONE** (real IBOV data from brapi.dev)
- [✅] Wire PortfolioChart to use API data - **DONE**
- [ ] Implement time period filtering with /portfolio/performance endpoint
- [ ] Show percentage labels on chart

#### 3.1.5 Stock Cards Section
- [✅] Stock card UI - Refactored with common styling
- [✅] Connect "Ver mais" to Conjuntura tab navigation - **DONE**
- [✅] Replace mock stock data with real market data - **DONE** (from brapi.dev via /dashboard/summary)
- [✅] Fetch from backend API - **DONE** (/market/stocks endpoint)
- [✅] Implement horizontal scroll with 2+ visible cards - **DONE**
- [✅] Show real stock prices (D-1 data from brapi.dev) - **DONE**
- [ ] Show logo_url from API response
- [ ] Show trending stocks based on user portfolio/preferences

#### 3.1.6 Economy Indicators Section
- [✅] Economy section UI - Refactored with common styling
- [✅] Connect "Ver mais" to Conjuntura tab navigation - **DONE**
- [✅] Fetch real indicators from backend (Dólar, EUR, SELIC, IPCA) - **DONE** (from brapi.dev)
- [✅] Implement horizontal scroll - **DONE**
- [✅] Add skeleton loading states - **DONE**
- [ ] Add last updated timestamp per indicator
- [ ] Show indicator source attribution

#### 3.1.7 Feedback Button
- [✅] Implement 4-screen feedback flow - **DONE** (restructured to match Figma)
- [✅] Create feedback form screens - **DONE** (rating, focus areas, comments, success)
- [✅] Create Figma review document - **DONE** (`docs/figma-review-feedback.md`)
- [✅] Show success confirmation after submission - **DONE**
- [✅] Add progress indicator (3 steps) per Figma - **DONE**
- [✅] Add navigation arrows per Figma - **DONE** (back arrow in app bar, no forward arrow)
- [✅] Update focus areas to match Figma (8 options) - **DONE**
- [✅] Update success screen to use Finovate branded icon - **DONE** (uses `FinImages.tealStripWhite` SVG)
- [✅] Success screen button with "Obrigado pelo feedback!" and close icon - **DONE**
- [✅] Checkbox styling matches signup questionnaire (mint border `#BADBC1`) - **DONE**
- [✅] All titles centered per Figma - **DONE**
- [✅] Single "Próxima pergunta" button (no "Voltar" - back arrow in app bar) - **DONE**
- [✅] PrimaryButton icon position fixed (icon AFTER text) - **DONE**
- [✅] Text box fixed height (56px min, 200px max) - **DONE**
- [✅] Star rating positioned 48px below text - **DONE**
- [✅] Refactor hardcoded colors to use FinColors constants - **DONE**
- [ ] Add backend API endpoint for feedback submission

#### 3.1.8 General Home Improvements
- [✅] Add pull-to-refresh for all sections - **DONE** (RefreshIndicator wrapping content)
- [✅] Implement skeleton loading states for each section - **DONE**
- [✅] Add error states with retry buttons - **DONE** (ErrorState component with FinTexts)
- [ ] Optimize data refresh on app foreground
- [ ] Cache data locally for offline viewing

**Files:**
- `lib/screens/home/home_screen.dart`
- `lib/screens/home/widgets/portfolio_chart.dart` (replace)
- `lib/screens/home/widgets/stock_card.dart`
- `lib/screens/home/widgets/economy_section.dart`
- `lib/screens/home/home_controller.dart` ✅ Created
- `lib/screens/feedback/` directory ✅ Created with 4-screen flow:
  - `feedback_controller.dart` - State management
  - `feedback_screen.dart` - Main screen with step navigation
  - `widgets/rating_step.dart` - Screen 1: Star rating
  - `widgets/focus_areas_step.dart` - Screen 2: Multi-select checkboxes
  - `widgets/comments_step.dart` - Screen 3: Text input
  - `widgets/success_step.dart` - Screen 4: Thank you confirmation

---

## Phase 4: Perfil (Profile) Screen Implementation

### 4.1 Perfil Screen - Functionality Implementation
**Status:** ✅ 90% Complete - UI done, core features implemented

**Current State:**
- 3-tab structure: Meu Plano, Perfil, Preferências
- Profile info with masked values (email, phone, CPF/CNPJ)
- Edit functionality for name, nickname, phone (via bottom sheet) - empty initial value
- Biometric toggle with availability check and SharedPreferences + metadata dual storage
- Notification toggle with SharedPreferences + metadata dual storage
- Support email integration (mailto link to suporte@finovate.com.br)
- Logout with confirmation dialog
- Gradient tab styling based on subscription status (Free/Pro)
- Plan type display (currently set to 'free' for testing)

**Tasks:**

#### 4.1.1 Profile Information Display
- [✅] User name - Implemented with masked display
- [✅] Email - Implemented with masked display
- [✅] Phone - Implemented with masked display
- [✅] CPF/CNPJ - Implemented with masked display (auto-detects 11 or 14 digits)
- [✅] Birth date - Displayed (not editable by design)
- [✅] Nickname/Apelido - Editable via bottom sheet
- [ ] Add profile photo upload functionality
- [ ] Show subscription tier badge (Free/Pro) - UI ready, needs backend

#### 4.1.2 Account Settings - Personal Information
- [✅] Created edit bottom sheet with field validation (empty initial value)
- [✅] Display: Full name, Nickname, Email (masked), Phone (masked), CPF/CNPJ (masked), Birth date
- [✅] Allow name editing with validation
- [✅] Allow nickname editing with validation
- [✅] Allow phone editing with Brazilian format validation
- [✅] Save changes to Supabase auth metadata + users table
- [✅] Show success toast feedback
- [✅] Email change flow (OTP) - UI ready, deferred until Supabase email link configured
- [✅] CPF/CNPJ not editable (by design)
- [✅] Birth date not editable (by design)

#### 4.1.3 Account Settings - Security
- [ ] Create "Segurança" screen
- [ ] Implement change password flow:
  - Current password verification
  - New password + confirmation
  - Strength indicator
- [ ] Add 2FA setup (future enhancement)
- [ ] Show last login information
- [ ] Add session management (view active sessions)

#### 4.1.4 Account Settings - Bank Accounts
- [ ] Create "Contas Bancárias" screen
- [ ] Display linked B3 accounts
- [ ] Add "Connect B3" button
- [ ] Show connection status
- [ ] Allow disconnection with confirmation
- [ ] Display last sync timestamp

#### 4.1.5 Account Settings - Transaction History
- [ ] Create "Histórico de Transações" screen
- [ ] Fetch transaction data from backend
- [ ] Display: date, type, asset, quantity, price
- [ ] Add filters: date range, transaction type
- [ ] Add export to CSV functionality
- [ ] Implement pagination for long history

#### 4.1.6 App Settings - Notifications
- [ ] Implement notification preferences toggle
- [ ] Create notification categories:
  - Portfolio changes
  - Market alerts
  - Sofia responses
  - System updates
- [ ] Save preferences to backend
- [ ] Connect to push notification system (future)

#### 4.1.7 App Settings - Theme
- [ ] If keeping both themes: Implement theme toggle
- [ ] If dark-only: Remove theme option entirely
- [ ] Persist theme preference locally
- [ ] Apply theme change immediately

#### 4.1.8 App Settings - Language
- [ ] Add language selector (Portuguese only for MVP)
- [ ] Prepare i18n structure for future languages
- [ ] Keep UI as placeholder for now

#### 4.1.9 App Settings - Biometric Toggle
- [✅] Implement functional biometric enable/disable toggle
- [✅] Check device capability before showing option
- [✅] Save preference to SharedPreferences (local) + Supabase metadata (backup)
- [✅] Authenticate user when enabling biometric
- [ ] Show setup instructions if biometric not enrolled

#### 4.1.10 Support Section
- [ ] Create "Central de Ajuda" screen with FAQ
- [ ] Add help topics: Account, Portfolio, Sofia, Subscriptions
- [ ] Create "Fale Conosco" contact form
- [✅] Implement "Ajuda" - Opens mailto link (suporte@finovate.com.br)
- [ ] Add "Avaliar App" deep link to App Store/Play Store
- [ ] Create "Sobre" screen with:
  - App version
  - Terms of Service link
  - Privacy Policy link
  - Open source licenses

#### 4.1.11 Subscription Management
- [ ] Add "Upgrade to Pro" card (when on Free tier)
- [ ] Display subscription benefits comparison
- [ ] Show current plan status
- [ ] Display next billing date (when Pro)
- [ ] Add cancel subscription option (future)
- [ ] Implement upgrade flow (manual for MVP)

#### 4.1.12 Account Deletion (LGPD Compliance)
- [ ] Add "Excluir Conta" option in settings
- [ ] Show confirmation dialog with warnings
- [ ] Require password verification
- [ ] Create backend endpoint for account deletion
- [ ] Delete all user data from Supabase
- [ ] Send confirmation email
- [ ] Logout and clear local data

**Files Created:**
- ✅ `lib/screens/perfil/perfil_controller.dart` - State management, preferences, user data
- ✅ `lib/screens/perfil/perfil_screen.dart` - Main screen with 3 tabs
- ✅ `lib/screens/perfil/widgets/perfil_info_tab.dart` - Personal info display with edit
- ✅ `lib/screens/perfil/widgets/preferencias_tab.dart` - Biometric/notifications toggles
- ✅ `lib/screens/perfil/widgets/meu_plano_tab.dart` - Subscription status display
- ✅ `lib/screens/perfil/widgets/edit_field_bottom_sheet.dart` - Edit modal for fields
- ✅ `lib/screens/perfil/widgets/email_change_bottom_sheet.dart` - OTP email change (deferred)
- ✅ `lib/common/widgets/gradient_border_box.dart` - Reusable gradient border widget
- ✅ `lib/utils/helpers/data_masking.dart` - Masking utilities (email, phone, CPF/CNPJ)
- ✅ `lib/services/auth_service.dart` - Added updateUserPreference method

**Files Still Needed:**
- `lib/screens/perfil/screens/security_screen.dart`
- `lib/screens/perfil/screens/bank_accounts_screen.dart`
- `lib/screens/perfil/screens/transaction_history_screen.dart`
- `lib/screens/perfil/screens/help_center_screen.dart`
- `lib/screens/perfil/screens/about_screen.dart`
- `lib/screens/perfil/widgets/subscription_card.dart`

---

## Phase 5: Sofia (AI Assistant) Screen Enhancement

### 5.1 Sofia Screen - Polish & Features
**Status:** ⚠️ 75% Complete - Core works, needs rework

**Current State:**
- Chat interface functional
- Real backend integration working
- Missing conversation persistence and some UI features
- **Needs rework** per user request

**Tasks:**

#### 5.1.1 Sofia Home Screen
- [✅] Welcome section - Already implemented
- [✅] Suggestion cards - Already implemented
- [ ] Load suggestions from text_strings.dart
- [ ] Implement "Limpar histórico" functionality
- [ ] Add conversation history preview cards

#### 5.1.2 Sofia Chat Screen
- [✅] Message display - Already implemented
- [✅] Streaming responses - Already implemented
- [✅] Session management - Already implemented
- [ ] Add copy message functionality
- [ ] Improve typing indicator (replace spinner) if needed
- [ ] Add message timestamps toggle if in Figma design
- **Note:** Conversation history persistence will use Zep for chat memory (future implementation)
- **Note:** Message search functionality not needed for MVP

#### 5.1.3 Prompt Limit Tracking
- [ ] Track daily prompt count per user
- [ ] Create backend endpoint for prompt tracking
- [ ] Display remaining prompts for free users
- [ ] Show "X/5 prompts used today" indicator
- [ ] On 6th prompt: Show upgrade dialog (not enforced for MVP)
- [ ] Reset counter daily at midnight

#### 5.1.4 Educational Disclaimer
- [ ] Add footer disclaimer: "SofIA provides educational information only, not financial advice"
- [ ] Display in chat screen (sticky footer)
- [ ] Add info icon with expanded explanation

#### 5.1.5 Personality & Tone
- [ ] Review sample responses for tone consistency
- [ ] Ensure first-person communication ("Deixa comigo!")
- [ ] Add personality to error messages
- [ ] Test Portuguese language quality

#### 5.1.6 Data Integration (Future)
- [ ] Connect to Gold layer for real-time market data
- [ ] Integrate user's B3 portfolio for personalized insights
- [ ] Add RAG system for Brazilian tax rules
- [ ] Implement context-aware responses

**Files to Modify:**
- `lib/screens/sofia/sofia_chat_screen.dart`
- `lib/screens/sofia/sofia_home_screen.dart`
- `lib/screens/sofia/controllers/sofia_chat_controller.dart`
- Create: `lib/services/sofia_prompt_tracker.dart`

---

## Phase 6: Conjuntura (Market Intelligence) Screen Implementation

### 6.1 Conjuntura Screen - Major Rebuild Required
**Status:** ❌ 30% Complete - Missing 5 of 6 sections

**Current State:**
- Basic structure with 3 mocked indicators
- No sectional organization
- No charts
- No ETL integration

**Reference Documents:**
- Variable Dictionary: `specs/dicionario_variaveis_conjuntura.md` (48 variables)
- Figma Review: `docs/figma-review-conjuntura.md` (UI specifications)

**Tasks:**

#### 5.1.1 Navigation Structure
- [ ] Implement 6-tab horizontal pill navigation (per Figma)
- [ ] Tabs: Expectativas | Desempenho econômico | Inflação | Mercado Internacional | Mercados Financeiros | Setor público
- [ ] Horizontal scroll for tab bar
- [ ] Each tab has dropdown for subsection/variable selection
- [ ] Premium paywall for free plan users

#### 5.1.2 Tab 1: Expectativas (5 variables)
**UI Pattern:** Dropdown selector → Multi-year line chart (2025, 2026, 2027) + year comparison table

**Variables:**
| Variable | KPIs |
|----------|------|
| Expectativas IPCA | 3-year projections; Variação 1 semana; Variação 1 mês |
| Expectativas PIB | 3-year projections; Variação 1 semana; Variação 1 mês |
| Expectativas Taxa de Desemprego | 3-year projections; Variação 1 semana; Variação 1 mês |
| Expectativas IGPM | 3-year projections; Variação 1 semana; Variação 1 mês |
| Expectativa Dólar | 3-year projections; Variação 1 semana; Variação 1 mês |

**Tasks:**
- [ ] Create dropdown with 5 expectation variables
- [ ] Implement multi-series line chart (fl_chart) with 3 years
- [ ] Year comparison table with status icons (✓/✗)
- [ ] Info link: "O que é [variable name]?"
- [ ] Source: Banco Central

#### 5.1.3 Tab 2: Desempenho Econômico (12 variables)
**UI Pattern:** Dropdown for subsection → Expandable indicator list → Detail modal with chart

**Subsection: Atividade Econômica (9 variables)**
| Variable | KPIs |
|----------|------|
| PIB | Valor atual; Variação período; Variação YoY |
| PIB Serviços | Valor atual; Variação período; Variação YoY |
| PIB Indústria | Valor atual; Variação período; Variação YoY |
| PIB Comércio | Valor atual; Variação período; Variação YoY |
| PIB Agro | Valor atual; Variação período; Variação YoY |
| Formação Bruta de Capital Fixo (FBCF) | Valor atual; Variação período; Variação YoY |
| Consumo das famílias | Valor atual; Variação período; Variação YoY |
| Consumo do Governo | Valor atual; Variação período; Variação YoY |
| Taxa de Desemprego | Valor atual; Variação período; Variação YoY |

**Subsection: Setores (3 variables)**
| Variable | KPIs |
|----------|------|
| Volume de vendas nos Serviços | Valor atual; Variação período; Variação YoY |
| Volume de Vendas no Comércio | Valor atual; Variação período; Variação YoY |
| Produção Industrial | Valor atual; Variação período; Variação YoY |

**Tasks:**
- [ ] Create dropdown with 2 subsections (Atividade econômica, Setores)
- [ ] Expandable indicator list with name, value, change %
- [ ] Detail modal with: title, value, change badge, line chart, YTD/YoY/MoM variations
- [ ] Info link: "O que é Atividade econômica?" / "O que é Setores?"
- [ ] Source: IBGE

#### 5.1.4 Tab 3: Inflação (11 variables)
**UI Pattern:** Sub-tabs (IGP-M | IPCA) → Date selectors → Charts

**Sub-tab: IGP-M (1 variable)**
| Variable | KPIs |
|----------|------|
| IGPM | Valor atual; Variação período; Variação YoY |

**Sub-tab: IPCA (10 variables)**
| Variable | KPIs |
|----------|------|
| IPCA cheio | Valor mês; Acumulado 12m; Variação mês anterior; Variação YoY mês; Variação acumulado YoY |
| IPCA Alimentação e Bebidas | Valor mês; Representatividade; Acumulado 12m; Variações múltiplas |
| IPCA Habitação | Valor mês; Representatividade; Acumulado 12m; Variações múltiplas |
| IPCA Artigos de residência | Valor mês; Representatividade; Acumulado 12m; Variações múltiplas |
| IPCA Vestuário | Valor mês; Representatividade; Acumulado 12m; Variações múltiplas |
| IPCA Transportes | Valor mês; Representatividade; Acumulado 12m; Variações múltiplas |
| IPCA Saúde e cuidados pessoais | Valor mês; Representatividade; Acumulado 12m; Variações múltiplas |
| IPCA Despesas pessoais | Valor mês; Representatividade; Acumulado 12m; Variações múltiplas |
| IPCA Educação | Valor mês; Representatividade; Acumulado 12m; Variações múltiplas |
| IPCA Comunicação | Valor mês; Representatividade; Acumulado 12m; Variações múltiplas |

**Tasks:**
- [ ] Sub-tabs toggle (IGP-M / IPCA)
- [ ] IGP-M: Line chart + month/year selectors + YTD/YoY/MoM variations
- [ ] IPCA: Donut chart with 9 category segments
- [ ] Category legend (2 columns, tappable for details)
- [ ] Side panel showing selected category's YTD/YoY/MoM
- [ ] Month picker modal (12 months grid)
- [ ] Year picker modal (year grid)
- [ ] Variações info modal (explains YTD/YoY/MoM)
- [ ] Info links: "O que é IGP-M?" / "O que é IPCA?"
- [ ] Source: IBGE, FGV

#### 5.1.5 Tab 4: Mercado Internacional (6 variables)
**UI Pattern:** Currency list with flags → Expandable detail modal with chart + time filters

**Variables:**
| Variable | KPIs |
|----------|------|
| Importações | Valor atual; Variação período; Variação YoY |
| Exportações | Valor atual; Variação período; Variação YoY |
| USD | Valor atual; Variação período; Variação YoY |
| EUR | Valor atual; Variação período; Variação YoY |
| GBP | Valor atual; Variação período; Variação YoY |
| JPY | Valor atual; Variação período; Variação YoY |

**Tasks:**
- [ ] Dropdown for "Importações e Exportações" section
- [ ] Currency list with flag emoji, code, BRL value, change %
- [ ] Detail modal: value, change badge, line chart, time period filters (Semana, No mês, 1 mês, 12 meses)
- [ ] YTD/YoY/MoM variations in detail modal
- [ ] Info link: "O que é o Mercado Internacional?"
- [ ] Source: BACEN, MDIC

#### 5.1.6 Tab 5: Mercados Financeiros (10 variables)
**UI Pattern:** Two-section list (rates + indices) → Expandable detail modals

**Section: Taxas de Juros (3 variables)**
| Variable | KPIs |
|----------|------|
| Taxa de Juros Brasil (SELIC) | Valor atual; Variação período; Variação YoY |
| Taxa de Juros EUA | Valor atual; Variação período; Variação YoY |
| Taxa de Juros EURO | Valor atual; Variação período; Variação YoY |

**Section: Principais índices de mercado (7 variables)**
| Variable | KPIs |
|----------|------|
| IBOV (IBOVESPA) | Valor atual; Variação período; Variação YoY |
| IFIX | Valor atual; Variação período; Variação YoY |
| NASDAQ | Valor atual; Variação período; Variação YoY |
| DOW JONES | Valor atual; Variação período; Variação YoY |
| S&P 500 | Valor atual; Variação período; Variação YoY |
| DAX | Valor atual; Variação período; Variação YoY |
| FTSE 100 | Valor atual; Variação período; Variação YoY |

**Tasks:**
- [ ] Section headers: "Taxas de Juros" and "Principais índices de mercado"
- [ ] Rate items with country flag, code, rate %
- [ ] Index items with colored icon, name, change %
- [ ] Detail modal: icon, value, line chart, YTD/YoY/MoM
- [ ] Info link: "O que é Mercados Financeiros?"
- [ ] Source: B3, BACEN

#### 5.1.7 Tab 6: Setor Público (4 variables)
**UI Pattern:** Indicator list → Expandable detail modal with chart

**Variables:**
| Variable | KPIs |
|----------|------|
| Déficit Primário | Valor atual; Variação período; Variação YoY |
| Déficit Nominal | Valor atual; Variação período; Variação YoY |
| Juros da Dívida | Valor atual; Variação período; Variação YoY |
| Relação Dívida PIB | Valor atual; Variação período; Variação YoY |

**Tasks:**
- [ ] Dropdown for "Indicadores Fiscais"
- [ ] Indicator list with name, value (R$ bilhões/trilhões), change %
- [ ] Note: Dívida/PIB shows % as main value instead of R$
- [ ] Detail modal: title, value, change, line chart, YTD/YoY/MoM
- [ ] Info link: "O que é o Setor público?"
- [ ] Source: Tesouro Nacional, BACEN

#### 5.1.8 Common Features Across All Sections
- [ ] Time period filters where applicable (Semana, No mês, 1 mês, 12 meses)
- [ ] "Data da última variação: X de Mês" timestamp per indicator
- [ ] "Fonte: [source]" attribution clearly visible
- [ ] Skeleton loading states
- [ ] Error states with retry
- [ ] Pull-to-refresh functionality
- [ ] Offline mode with cached data
- [ ] Info icon (ⓘ) with InfoBottomSheet for explanations

#### 5.1.9 Subscription Trial Tracking
- [ ] Track 7-day trial start date
- [ ] Show trial countdown in UI
- [ ] Display "X days remaining" badge
- [ ] On day 8: Show upgrade prompt (not enforced for MVP)
- [ ] Add "Upgrade to Pro" button in section
- [ ] Premium paywall screen for free users

#### 5.1.10 Data Integration
- [ ] Create backend API endpoints for all 6 tabs
- [ ] Connect to ETL Gold layer tables
- [ ] Implement data refresh schedule (daily EOD)
- [ ] Handle D-1 data lag messaging
- [ ] Create Supabase tables for 48 indicator variables
- [ ] Implement caching strategy

**Variable Summary:**
| Tab | Variables |
|-----|-----------|
| Expectativas | 5 |
| Desempenho Econômico | 12 (9 Atividade + 3 Setores) |
| Inflação | 11 (1 IGP-M + 10 IPCA) |
| Mercado Internacional | 6 |
| Mercados Financeiros | 10 (3 rates + 7 indices) |
| Setor Público | 4 |
| **Total** | **48** |

**New Files Needed:**
- `lib/screens/conjuntura/conjuntura_controller.dart`
- `lib/screens/conjuntura/conjuntura_paywall_screen.dart`
- `lib/screens/conjuntura/widgets/pill_tab_bar.dart`
- `lib/screens/conjuntura/widgets/indicator_dropdown.dart`
- `lib/screens/conjuntura/widgets/indicator_list_item.dart`
- `lib/screens/conjuntura/widgets/indicator_detail_modal.dart`
- `lib/screens/conjuntura/widgets/expectations_chart.dart`
- `lib/screens/conjuntura/widgets/year_comparison_row.dart`
- `lib/screens/conjuntura/widgets/variation_row.dart`
- `lib/screens/conjuntura/widgets/inflation_sub_tabs.dart`
- `lib/screens/conjuntura/widgets/donut_chart.dart`
- `lib/screens/conjuntura/widgets/category_legend.dart`
- `lib/screens/conjuntura/widgets/date_selector_row.dart`
- `lib/screens/conjuntura/widgets/month_picker_modal.dart`
- `lib/screens/conjuntura/widgets/year_picker_modal.dart`
- `lib/screens/conjuntura/widgets/currency_list_item.dart`
- `lib/screens/conjuntura/widgets/rate_index_list_item.dart`
- `lib/screens/conjuntura/widgets/time_period_filters.dart`
- `lib/screens/conjuntura/widgets/variacoes_info_modal.dart`
- `lib/screens/conjuntura/models/economic_indicator.dart`
- `lib/screens/conjuntura/models/time_series_point.dart`
- `lib/screens/conjuntura/models/inflation_category.dart`
- `lib/screens/conjuntura/models/currency_rate.dart`
- `lib/screens/conjuntura/models/market_index.dart`
- `lib/screens/conjuntura/models/fiscal_indicator.dart`
- `lib/services/conjuntura_service.dart`

---

## Phase 7: Carteira (Portfolio) Screen Implementation

### 7.1 Carteira Screen - Complete Rebuild
**Status:** ❌ 60% Complete - UI stub only, needs full implementation

**Current State:**
- Basic UI with mocked data
- No tabs for Rentabilidade/Riscos/Composição/Proventos
- No real charts
- No B3 integration

**Tasks:**

#### 7.1.1 Portfolio Summary Header
- [✅] Total patrimony display - Already implemented UI
- [✅] Daily change indicator - Already implemented UI
- [ ] Connect to real B3 portfolio data
- [ ] Add last sync timestamp
- [ ] Add manual refresh button
- [ ] Show sync status (syncing/success/error)

#### 7.1.2 Tab Navigation System
- [ ] Implement 4-tab system: Rentabilidade / Riscos / Composição / Proventos
- [ ] Create tab bar with proper styling
- [ ] Implement swipe-to-switch-tabs functionality
- [ ] Maintain tab state across app sessions

#### 7.1.3 Rentabilidade Tab (Performance)
- [ ] Total portfolio value and P&L display
- [ ] Performance chart comparing Portfolio vs IBOV/IFIX/IPCA/CDI
- [ ] Implement time period filters: Semana, No mês, 1 mês, 12 meses
- [ ] Show portfolio return percentages for each period
- [ ] Add benchmark comparison table
- [ ] Display source attribution: "Fonte: B3 / Banco Central"
- [ ] Implement fl_chart for performance visualization

#### 7.1.4 Riscos Tab (Risk Analysis)
- [ ] Define risk metrics to display:
  - Portfolio volatility
  - Sharpe ratio (if data available)
  - Beta vs IBOV
  - VaR (Value at Risk) - optional
- [ ] Create risk gauge/meter visualization
- [ ] Show risk classification (Conservative/Moderate/Aggressive)
- [ ] Display sector concentration risk
- [ ] Add explanatory tooltips for each metric

#### 7.1.5 Composição Tab (Asset Allocation)
- [ ] Implement interactive pie chart with fl_chart
- [ ] Show breakdown by asset type:
  - Ações (Stocks)
  - FIIs (Real Estate Funds)
  - Renda Fixa (Fixed Income) - if available
  - ETFs - post-MVP
  - Caixa (Cash)
- [ ] Display percentage and monetary value per category
- [ ] Add tap-to-drill-down for each category
- [ ] Show top holdings list below chart
- [ ] Add rebalancing suggestions (optional)

#### 7.1.6 Proventos Tab (Dividends/Income)
- [ ] Filter dropdowns: "Classe de ativos" / "Produtos"
- [ ] Implement stacked bar chart for income events
- [ ] Toggle view: "Por ano" / "Por mês"
- [ ] Show projected income for next year
- [ ] Display historical income received
- [ ] Add export to CSV functionality (optional)
- [ ] Source: "Fonte: B3 / Banco Central"

#### 7.1.7 Holdings List Enhancement
- [ ] Replace mock holdings with real B3 data
- [ ] Display for each holding:
  - Ticker symbol
  - Company name
  - Quantity
  - Average cost
  - Current price
  - Current value
  - P&L (absolute and percentage)
  - Daily change
- [ ] Add sorting options: by ticker, value, P&L, change
- [ ] Add search/filter functionality
- [ ] Implement pull-to-refresh

#### 7.1.8 B3 Connection Status
- [ ] Add connection status indicator in AppBar
- [ ] Show "Conectar B3" button when disconnected
- [ ] Display empty state with CTA when not connected
- [ ] Handle connection errors gracefully
- [ ] Add reconnection flow

#### 7.1.9 Data & API Integration
**B3 Authorization:** OAuth 2.0 flow (B3 provides access package with OAuth sign-in link)

- [ ] Implement B3 OAuth authorization flow:
  - User clicks "Connect B3"
  - Open B3 OAuth sign-in URL in web view
  - Handle OAuth callback with authorization code
  - Exchange code for access token in backend
- [ ] Create backend endpoints for portfolio data
- [ ] Store B3 OAuth tokens securely in backend (encrypted)
- [ ] Implement token refresh logic
- [ ] Create Supabase tables:
  - `user_b3_connections` (connection status, encrypted tokens, refresh tokens)
  - `user_portfolio_holdings` (cached portfolio data)
  - `user_portfolio_history` (historical performance)
- [ ] Implement daily portfolio sync schedule
- [ ] Handle D-1 data lag appropriately
- [ ] Test OAuth flow in backend before frontend integration
- [ ] Add error handling for OAuth failures

**New Files Needed:**
- `lib/screens/carteira/carteira_controller.dart`
- `lib/screens/carteira/widgets/rentabilidade_tab.dart`
- `lib/screens/carteira/widgets/riscos_tab.dart`
- `lib/screens/carteira/widgets/composicao_tab.dart`
- `lib/screens/carteira/widgets/proventos_tab.dart`
- `lib/screens/carteira/widgets/performance_chart.dart`
- `lib/screens/carteira/widgets/allocation_pie_chart.dart`
- `lib/screens/carteira/widgets/income_bar_chart.dart`
- `lib/services/b3_service.dart`

---

## Phase 8: Backend API Development

### 8.1 Portfolio API Endpoints
**Status:** ❌ Not Implemented

**Tasks:**
- [ ] POST /api/v1/portfolio/connect-b3 - B3 authorization
- [ ] GET /api/v1/portfolio/holdings - Fetch portfolio holdings
- [ ] GET /api/v1/portfolio/performance - Performance metrics
- [ ] GET /api/v1/portfolio/allocation - Asset allocation data
- [ ] GET /api/v1/portfolio/income - Dividend/income history
- [ ] GET /api/v1/portfolio/transactions - Transaction history
- [ ] POST /api/v1/portfolio/sync - Manual sync trigger

---

### 8.2 Conjuntura API Endpoints
**Status:** ❌ Not Implemented

**Tasks:**
- [ ] GET /api/v1/conjuntura/expectativas - Expectations data
- [ ] GET /api/v1/conjuntura/desempenho - Economic performance
- [ ] GET /api/v1/conjuntura/precos - Prices & inflation
- [ ] GET /api/v1/conjuntura/setor-externo - Foreign sector
- [ ] GET /api/v1/conjuntura/mercados - Financial markets
- [ ] GET /api/v1/conjuntura/financas-publicas - Public finance
- [ ] GET /api/v1/conjuntura/indicator/:id - Single indicator with history

---

### 8.3 Market Data API Endpoints
**Status:** ❌ Not Implemented

**Tasks:**
- [ ] GET /api/v1/market/stocks - Stock quotes
- [ ] GET /api/v1/market/indices - Market indices (IBOV, S&P 500)
- [ ] GET /api/v1/market/currencies - Exchange rates
- [ ] GET /api/v1/market/commodities - Commodity prices

---

### 8.4 User Preferences API Endpoints
**Status:** ❌ Not Implemented

**Tasks:**
- [ ] GET /api/v1/user/preferences - Get user preferences
- [ ] PUT /api/v1/user/preferences - Update preferences
- [ ] PUT /api/v1/user/profile - Update profile info
- [ ] DELETE /api/v1/user/account - Delete account
- [ ] GET /api/v1/user/subscription - Get subscription status
- [ ] POST /api/v1/user/subscription/upgrade - Upgrade to Pro (manual)

---

### 8.5 Sofia API Endpoints
**Status:** ✅ Already Implemented

**Current:**
- POST /api/v1/chat/session - Create session
- GET /api/v1/chat/sessions - Get sessions
- POST /api/v1/chat/send - Stream message

**Additional Tasks:**
- [ ] GET /api/v1/sofia/prompts/count - Get daily prompt count
- [ ] POST /api/v1/sofia/prompts/track - Track prompt usage
- [ ] GET /api/v1/sofia/history/:sessionId - Get conversation history

---

### 8.6 Feedback API Endpoints
**Status:** ❌ Not Implemented

**Tasks:**
- [ ] POST /api/v1/feedback - Submit user feedback
- [ ] GET /api/v1/feedback/categories - Get feedback categories

---

## Phase 9: Database Schema Updates

### 9.1 Supabase Tables to Create/Update

**Tasks:**

#### User Tables
- [ ] Update `users` table with additional fields:
  - subscription_tier (free/pro)
  - subscription_start_date
  - subscription_end_date
  - trial_start_date
  - biometric_enabled
  - theme_preference
  - notification_preferences (JSONB)

#### Portfolio Tables
- [ ] Create `user_b3_connections`:
  - user_id, connection_status, b3_token_encrypted
  - last_sync_at, created_at, updated_at

- [ ] Create `user_portfolio_holdings`:
  - user_id, ticker, asset_type, quantity
  - average_cost, current_price, current_value
  - pnl_absolute, pnl_percentage, last_updated

- [ ] Create `user_portfolio_history`:
  - user_id, date, total_value, daily_change
  - benchmark_value, created_at

- [ ] Create `user_transactions`:
  - user_id, transaction_type, ticker, quantity
  - price, total_value, date, created_at

#### Conjuntura Tables
- [ ] Create `economic_indicators`:
  - indicator_id, indicator_name, category
  - value, date, source, updated_at

- [ ] Create `market_data`:
  - ticker, asset_type, price, change_pct
  - volume, date, source, updated_at

#### Sofia Tables
- [ ] Update `chat_sessions` (if not exists)
- [ ] Create `user_prompt_usage`:
  - user_id, date, prompt_count, created_at

#### Feedback Tables
- [ ] Create `user_feedback`:
  - user_id, category, message, rating
  - created_at

---

## Phase 10: ETL Integration

### 10.1 ETL Gold Layer Connection
**Status:** ❌ Not Implemented

**Tasks:**
- [ ] Define ETL data sources (per ETL ADD document)
- [ ] Create data sync schedule (daily EOD)
- [ ] Implement data transformations for app consumption
- [ ] Set up S3 buckets for data storage
- [ ] Configure Lambda functions for ETL jobs
- [ ] Populate Gold layer tables in Supabase
- [ ] Test data accuracy and completeness

**Data Sources to Integrate:**
- IBGE (economic indicators)
- BACEN (interest rates, FX, fiscal data)
- B3 (market data, indices)
- CVM (market regulations data)
- Yahoo Finance (global markets)

---

## Phase 11: Subscription & In-App Purchases (Post-MVP)

### 11.1 Subscription System
**Status:** ❌ Deferred - Manual upgrades for MVP

**Tasks:**
- [ ] Integrate App Store / Play Store IAP
- [ ] Create subscription products in store consoles
- [ ] Implement subscription verification
- [ ] Add entitlement management
- [ ] Create upgrade flow UI
- [ ] Implement grace period handling
- [ ] Add subscription management screen
- [ ] Test purchase flows on both platforms

---

## Phase 12: Testing & Quality Assurance

### 12.1 Unit Tests
**Status:** ❌ Minimal testing

**Tasks:**
- [ ] Write tests for all services
- [ ] Write tests for controllers
- [ ] Write tests for utility functions
- [ ] Achieve 70%+ code coverage

---

### 12.2 Integration Tests
**Tasks:**
- [ ] Test complete signup flow
- [ ] Test login flow with biometric
- [ ] Test B3 connection flow
- [ ] Test portfolio data sync
- [ ] Test Sofia chat flow
- [ ] Test subscription upgrade flow

---

### 12.3 UI/UX Testing
**Tasks:**
- [ ] Test on multiple screen sizes (small, medium, large)
- [ ] Test on iOS devices (iPhone SE, 12, 14 Pro)
- [ ] Test on Android devices (various manufacturers)
- [ ] Verify dark theme consistency across all screens
- [ ] Test accessibility (screen reader, font scaling)
- [ ] Verify Portuguese language quality

---

### 12.4 Performance Testing
**Tasks:**
- [ ] Test app launch time (< 3 seconds)
- [ ] Test screen transition speed
- [ ] Test API response times (< 3 seconds for critical)
- [ ] Test Sofia response time (< 5 seconds)
- [ ] Test chart rendering performance
- [ ] Profile memory usage
- [ ] Test offline mode functionality

---

## Phase 13: Polish & Launch Preparation

### 13.1 Code Quality
**Tasks:**
- [ ] Remove all debug print statements
- [ ] Replace with proper logging (log from dart:developer)
- [ ] Complete all TODO items
- [ ] Remove unused imports and code
- [ ] Run `flutter analyze` and fix all issues
- [ ] Format all code with `flutter format`
- [ ] Add code documentation for complex logic

---

### 13.2 Error Handling
**Tasks:**
- [ ] Implement global error handler
- [ ] Add Sentry or Crashlytics for error tracking
- [ ] Test all error states
- [ ] Ensure user-friendly error messages
- [ ] Add retry logic for network failures

---

### 13.3 App Store Preparation
**Tasks:**
- [ ] Update app icons (iOS & Android)
- [ ] Create app screenshots
- [ ] Write app store description
- [ ] Prepare privacy policy
- [ ] Prepare terms of service
- [ ] Set up App Store Connect
- [ ] Set up Google Play Console
- [ ] Configure app signing

---

### 13.4 Documentation
**Tasks:**
- [ ] Update README.md with complete setup instructions
- [ ] Document API endpoints
- [ ] Create user guide
- [ ] Document deployment process
- [ ] Update CLAUDE.md with new patterns

---

## Implementation Priority Order

**Confirmed Approach:** Home → Perfil → Sofia → Conjuntura → Carteira

**Development Workflow (UI-First Approach):**
For each feature/screen, follow this order:
1. **UI First** - Build/complete all UI components and screens
2. **Models & Mappers** - Create data models and API response mappers
3. **API Integration** - Add API service methods and connect to backend
4. **Testing** - Manual testing to verify functionality
5. **Done** - Feature complete when all above steps pass

This approach allows:
- Faster visual feedback during development
- Parallel backend development without blocking UI work
- Easier testing with mock data before real API integration
- Clear separation between UI and data concerns

**Iterative Process:**
- Complete each phase/feature following UI-first workflow
- Manual testing checkpoint after each feature
- Requirements may shift during integrations
- Keep it simple, avoid overcomplication

### Priority 0 (Pre-Implementation):
0. **Figma Design Review** (Phase 0.1) - MUST complete before any UI work ✅
1. **Force Dark Theme** (Phase 1.1) - Critical fix to prevent light mode issues ✅

### Priority 1 (Must Have for MVP):
2. **Common UI Components** (Phase 1.2) - Needed for all screens, must match Figma ✅
3. **Chart Library Integration with fl_chart** (Phase 1.2.5) - Must match Figma chart designs exactly ✅
4. **Home Screen Data Integration** (Phase 3) - Main dashboard ✅ 97% complete
5. **Perfil Functionality** (Phase 4) - User management ✅ 90% complete
6. **Sofia Rework** (Phase 5) - Key differentiator, needs rework
7. **Backend API Development** (Phase 8.1-8.4) - Required for data
8. **Database Schema** (Phase 9) - Foundation for data storage

### Priority 2 (Important for MVP):
9. **Conjuntura Implementation** (Phase 6) - Economic indicators, most work needed
10. **Carteira Implementation** (Phase 7) - Portfolio, requires B3 OAuth testing
11. **Auth Fixes** (Phase 2.2, 2.3) - Polish existing features

### Priority 3 (Post-MVP):
12. **ETL Integration** (Phase 10) - Can use mock data initially
13. **Subscription System** (Phase 11) - Manual workaround for MVP
14. **Testing** (Phase 12) - Continuous throughout
15. **Polish & Launch** (Phase 13) - Final touches

---

## Estimated Effort

**UI Work (Phases 1-7):**
- Phase 1: 2-3 days
- Phase 2: 1 day
- Phase 3: 3-4 days
- Phase 4: 5-7 days
- Phase 5: 7-10 days
- Phase 6: 2-3 days
- Phase 7: 4-5 days

**Backend Work (Phases 8-10):**
- Phase 8: 5-7 days
- Phase 9: 2-3 days
- Phase 10: 10-15 days (depends on ETL complexity)

**Testing & Polish (Phases 12-13):**
- Phase 12: 5-7 days
- Phase 13: 3-5 days

**Total Estimated: 50-75 days of development work**

---

## Key Dependencies

1. **B3 API Access** - OAuth 2.0 flow (B3 access package provided, needs backend testing)
2. **ETL Pipeline** - Required for Conjuntura data (can mock initially)
3. **Langflow Hosting** - Currently localhost:7860 (needs production deployment)
4. **Chart Library** - fl_chart v0.68.0 (confirmed)
5. **Backend Deployment** - Currently localhost:5001 (needs production URL)

---

## Risk Mitigation

1. **B3 Integration Uncertainty:**
   - Mitigation: Mock data for UI development, parallel investigation of B3 API

2. **ETL Data Quality:**
   - Mitigation: Start with subset of indicators, expand gradually

3. **Sofia Response Quality:**
   - Mitigation: Extensive testing, tone calibration, fallback responses

4. **Performance Issues:**
   - Mitigation: Lazy loading, pagination, efficient chart rendering

---

## Next Steps

**Confirmed Decisions:**
- ✅ Dark theme only for MVP (light theme kept in code for future, very low priority)
- ✅ Use fl_chart for all charts
- ✅ Priority: Home → Perfil → Sofia → Conjuntura → Carteira
- ✅ B3 OAuth 2.0 flow (backend testing needed)

**Completed Actions:**
1. ~~Review all Figma designs using Figma MCP (Phase 0.1)~~ ✅ **100% COMPLETE**
2. ~~Force dark theme in main.dart (Phase 1.1)~~ ✅ **COMPLETE**
3. ~~Fix critical button color issue in colors.dart~~ ✅ **COMPLETE** (Primary: #1B6FFF)
4. ~~Add fl_chart package to pubspec.yaml~~ ✅ **COMPLETE** (v0.69.2)
5. ~~Create common UI components~~ ✅ **COMPLETE** (Phase 1.2 - 16 widget files created)
6. ~~Build chart wrapper components~~ ✅ **COMPLETE** (LineChart, PieChart, BarChart + helpers)
7. ~~Refactor Home widgets to use common components~~ ✅ **COMPLETE**
8. ~~Connect Home screen to backend API~~ ✅ **COMPLETE** (dashboard, stocks, indicators)
9. ~~Add pull-to-refresh to Home~~ ✅ **COMPLETE**
10. ~~Add error state with retry to Home~~ ✅ **COMPLETE**

**Immediate Actions:**
1. **COMPLETED:** Phase 4 - Perfil screen functionality (90% complete)
2. **NEXT:** Phase 4 remaining - Meu Plano screen (subscription display/management)
3. **THEN:** Phase 5 - Sofia rework (needs redesign)
4. Parallel: Backend API development for Sofia/Conjuntura
5. Test B3 OAuth flow in backend before frontend integration
6. **Decision needed:** Font family - keep DMSans or switch to Plus Jakarta Sans/General Sans

**New Common Widget Files (Phase 1.2):**
```
lib/common/widgets/
├── custom_card.dart           # Card with variants (default, elevated, outlined)
├── empty_state.dart           # Empty state with factory constructors
├── error_state.dart           # Error state with retry button
├── info_bottom_sheet.dart     # Info sheets for (ⓘ) icons
├── loading_state.dart         # Centered loading spinner (ballSpinFadeLoader)
├── primary_button.dart        # Primary, secondary, text buttons
├── scrollable_header.dart     # Header with back button for scrollable screens
├── section_header.dart        # Section headers with "Ver mais"
├── segmented_tabs.dart        # Tab navigation with pop-out effect
├── skeleton_loader.dart       # Shimmer loading animations
├── toast_notification.dart    # Toast notifications
├── widgets.dart               # Export file
└── charts/
    ├── chart_legend.dart      # Legend + performance indicators
    ├── charts.dart            # Export file
    ├── custom_bar_chart.dart  # Bar charts (single, grouped, stacked)
    ├── custom_line_chart.dart # Line charts with multi-series
    ├── custom_pie_chart.dart  # Donut/pie charts
    └── time_period_selector.dart  # Period filters

lib/utils/constants/
└── chart_colors.dart          # Centralized chart colors
```

**Figma Review Documents (for implementation reference):**
- `docs/figma-review-*.md` - Screen-by-screen specifications
- `docs/global-components.md` - Reusable UI components (buttons, inputs, toasts, bottom sheets)
- `docs/figma-chart-requirements.md` - Chart specifications for fl_chart
- `docs/figma-color-verification.md` - Color palette with issues to fix

**Implementation Approach:**
- **UI-First Workflow:** Build UI → Models/Mappers → API Integration → Test → Done
- **Iterative with manual testing:** Complete each phase and allow manual testing before proceeding
- **Keep it simple:** Avoid overcomplication, focus on core functionality
- **Figma-first:** All UI must match Figma designs exactly - always reference the docs before building
- **Flexible:** Requirements may shift during integrations, plan will adapt

---

## Backend API Status

**Reference:** `docs/api-contracts.md` (v2.1.0)

### Implemented & Ready for Frontend Integration:

| Phase | Endpoints | Backend Status | Frontend Status |
|-------|-----------|----------------|-----------------|
| **Phase 0: B3 OAuth** | `/b3/login`, `/b3/callback`, `/b3/status`, `/b3/disconnect` | ✅ Complete | ⏳ Not integrated |
| **Phase 1: Home Screen** | `/dashboard/summary` (consolidated - includes featured_stocks, indicators), `/feedback` | ✅ Complete | ✅ Integrated |
| **Phase 1.5: Market & Favorites** | `/market/stocks` (pagination, sorting, search, type, sector), `/market/stocks/search`, `/user/favorites` | ✅ Complete | ✅ Available (not used on home) |
| **Phase 2: Portfolio** | `/portfolio/performance`, `/portfolio/allocation`, `/portfolio/income` | ✅ Complete | ⏳ Partial (needs period param) |

### Pending Backend Implementation:

| Phase | Endpoints | Status |
|-------|-----------|--------|
| **Phase 3: Conjuntura** | `/conjuntura/sections`, `/conjuntura/:sectionId` | ⏳ Defined |
| **Phase 4: Sofia** | `/sofia/prompts/usage`, `/sofia/prompts/track` | ⏳ Defined |
| **Phase 4: Preferences** | `/user/preferences` GET/PUT | ⏳ Defined |

### Frontend Integration Details:

**Home Screen API Pattern (Consolidated):**
- **Before (v1.x):** 4 API calls (`/dashboard/summary` + `/user/favorites` + `/market/stocks` + `/market/indicators`)
- **After (v2.1.0):** 1 API call (`/dashboard/summary` includes `featured_stocks` and `indicators`)

**Models Created (lib/models/):**
- ✅ `Stock` - with `logo_url`, pagination support
- ✅ `MarketIndicator` - USD, EUR, SELIC, IPCA with formatting
- ✅ `MarketIndex` - IBOV with Brazilian number formatting
- ✅ `DashboardSummary` - consolidated: user, marketOverview, portfolio, composicao, notifications, **featuredStocks**, **indicators**

**API Service (lib/services/finovate_api_service.dart):**
- ✅ `getDashboardSummary()` - **Primary home screen endpoint** (single call for all home data)
- ✅ `getMarketStocks()` - Stocks with full brapi.dev params (for stocks list screens, not home)
- ✅ `getMarketIndices()` - Market indices (for detailed views)
- ✅ `getMarketIndicators()` - Economic indicators (for conjuntura, not home)
- ✅ `getUserFavorites()` / `addFavorite()` / `removeFavorite()` - Favorites CRUD (for favorites management)
