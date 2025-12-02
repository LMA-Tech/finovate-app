# Finovate App - Complete Implementation Plan

## Overview

This plan covers all requirements from `specs/initial-requirements.md`, organized by feature area with UI work prioritized first. Each section indicates current status and required work.

**Important Constraints:**
- **Figma-First:** All UI must match Figma designs exactly (charts, layouts, colors, spacing)
- **Dark Theme Only:** Force dark mode, prevent light mode from breaking UI
- **Iterative Approach:** Manual testing after each phase, requirements may shift
- **Keep It Simple:** Avoid overcomplication, focus on core functionality
- **Sofia:** Skip conversation persistence (using Zep later) and search (post-MVP)

**Status Legend:**
- ✅ Complete
- ⚠️ Needs Fixes/Enhancement
- ❌ Not Implemented
- 🔄 In Progress

---

## Phase 0: Pre-Implementation Setup

### 0.1 Figma Design Review
**Status:** ❌ Required Before Any UI Work

**Purpose:**
- Review all Figma designs before implementing any visual changes
- Ensure all UI components match Figma specifications exactly
- Understand expected chart styles, colors, and layouts
- Extract design tokens (colors, spacing, typography) from Figma

**Tasks:**
- [ ] Use Figma MCP to access and review all screens:
  - Onboarding flow
  - Sign up flow
  - Login flow
  - Home dashboard
  - Conjuntura sections
  - My Profile
  - Stocks/Market view
  - My Wallet/Carteira
  - Premium Plan
  - SofIA chat interface
- [ ] Document chart requirements from Figma:
  - Line chart styles (colors, grid, labels)
  - Pie chart styles (colors, labels, interactions)
  - Bar chart styles (colors, spacing, labels)
- [ ] Extract color palette and verify against `colors.dart`
- [ ] Document spacing/sizing and verify against `sizes.dart`
- [ ] Note any typography differences
- [ ] Create implementation checklist per screen matching Figma

**Critical:** No UI implementation work begins until Figma review is complete and documented

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

### 1.2 Common UI Components - Missing Components
**Status:** ❌ Not Implemented

**Current State:**
- Basic components exist (CustomAppBar, CustomTextField, AppBackground)
- Missing: Cards, Error states, Empty states, Skeleton screens

**Tasks:**

#### 1.2.1 Generic Card Component
- [ ] Create `lib/common/widgets/custom_card.dart`
- [ ] Support variants: default, elevated, outlined
- [ ] Add optional header/footer sections
- [ ] Support gradients for special cards
- [ ] Make responsive with proper padding

#### 1.2.2 Error State Component
- [ ] Create `lib/common/widgets/error_state.dart`
- [ ] Display error icon, message, and retry button
- [ ] Support custom error messages
- [ ] Include empty state variant

#### 1.2.3 Empty State Component
- [ ] Create `lib/common/widgets/empty_state.dart`
- [ ] Display icon, title, subtitle, and CTA button
- [ ] Context-aware (portfolio not connected, no data, etc.)

#### 1.2.4 Skeleton Loading Screens
- [ ] Create `lib/common/widgets/skeleton_loader.dart`
- [ ] Implement shimmer effect
- [ ] Create variants for: cards, lists, charts
- [ ] Use in all data-loading screens

#### 1.2.5 Chart Components (Using fl_chart)
**Decision:** Use fl_chart library (free, customizable, well-maintained)
**Critical:** All chart styling MUST match Figma designs exactly

- [ ] Add fl_chart package to pubspec.yaml: `fl_chart: ^0.68.0`
- [ ] **Review Figma chart designs before implementation:**
  - Extract exact colors, grid styles, label formats
  - Note tooltip styles and interactions
  - Document legend positioning and styling
- [ ] Create `lib/common/widgets/charts/custom_line_chart.dart`
  - Match Figma line chart design (colors, thickness, grid)
  - Pre-configured for dark theme
  - Support multiple data series
  - Interactive tooltips matching Figma style
- [ ] Create `lib/common/widgets/charts/custom_pie_chart.dart`
  - Match Figma pie chart design (colors, spacing, labels)
  - Support tap-to-select sections per Figma interaction
  - Animated transitions
- [ ] Create `lib/common/widgets/charts/custom_bar_chart.dart`
  - Match Figma bar chart design (colors, spacing, labels)
  - Support grouped/stacked bars as shown in Figma
  - Time-based x-axis formatting per Figma
- [ ] Create `lib/common/widgets/charts/time_period_selector.dart`
  - Match Figma design exactly (Semana, No mês, 1 mês, 12 meses)
- [ ] Create `lib/common/widgets/charts/chart_legend.dart`
  - Match Figma legend style (colors, positioning, labels)
- [ ] Test all charts in dark mode with exact Figma colors and styling

**Estimated Components:** 8-10 new widget files

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
**Status:** ⚠️ 70% Complete - UI done, needs real data

**Current State:**
- All UI sections built with mocked data
- Navigation stubs in place
- No API integration

**Tasks:**

#### 3.1.1 Header Section
- [✅] User greeting - Already implemented
- [✅] Notification bell - Already implemented
- [ ] Connect notifications to backend (post-MVP)

#### 3.1.2 B3 Connection Banner
- [✅] Banner UI - Already implemented
- [ ] Connect to B3 connection status from backend
- [ ] Dismiss functionality persists in user preferences
- [ ] Show only when B3 not connected

#### 3.1.3 Portfolio Summary Section
- [✅] Tabs UI (Rentabilidade/Risco/Composição) - Already implemented
- [✅] Time period filters - Already implemented
- [ ] Replace mock portfolio data with B3 API data
- [ ] Implement real portfolio vs IBOV comparison chart
- [ ] Connect "Ver mais" to Carteira tab navigation
- [ ] Add last updated timestamp
- [ ] Add pull-to-refresh for portfolio data

#### 3.1.4 Portfolio Chart Enhancement
- [ ] Replace CustomPaint chart with fl_chart LineChart
- [ ] Fetch real portfolio performance data from backend
- [ ] Fetch benchmark data (IBOV) from ETL Gold layer
- [ ] Implement time period filtering (Semana, No mês, 1 mês, 12 meses)
- [ ] Add interactive tooltips on hover/tap
- [ ] Show percentage labels on chart

#### 3.1.5 Stock Cards Section
- [ ] Replace mock stock data with real market data
- [ ] Fetch from ETL Gold layer via backend API
- [ ] Implement horizontal scroll with 2+ visible cards
- [ ] Add real-time price updates (D-1 acceptable for MVP)
- [ ] Connect "Ver mais" to market section navigation
- [ ] Show trending stocks based on user portfolio/preferences

#### 3.1.6 Economy Indicators Section
- [ ] Fetch real indicators from backend (Dólar, SELIC, IPCA)
- [ ] Source from ETL Gold layer
- [ ] Implement horizontal scroll
- [ ] Add last updated timestamp per indicator
- [ ] Connect "Ver mais" to Conjuntura tab navigation
- [ ] Add skeleton loading states

#### 3.1.7 Feedback Button
- [ ] Implement 3-screen feedback flow
- [ ] Create feedback form screens
- [ ] Add backend API endpoint for feedback submission
- [ ] Show success confirmation after submission

#### 3.1.8 General Home Improvements
- [ ] Add pull-to-refresh for all sections
- [ ] Implement skeleton loading states for each section
- [ ] Add error states with retry buttons
- [ ] Optimize data refresh on app foreground
- [ ] Cache data locally for offline viewing

**Files:**
- `lib/screens/home/home_screen.dart`
- `lib/screens/home/widgets/portfolio_chart.dart` (replace)
- `lib/screens/home/widgets/stock_card.dart`
- `lib/screens/home/widgets/economy_section.dart`
- Create: `lib/screens/home/home_controller.dart` for state management
- Create: `lib/screens/feedback/` directory with 3 screens

---

## Phase 4: Carteira (Portfolio) Screen Implementation

### 4.1 Carteira Screen - Complete Rebuild
**Status:** ❌ 60% Complete - UI stub only, needs full implementation

**Current State:**
- Basic UI with mocked data
- No tabs for Rentabilidade/Riscos/Composição/Proventos
- No real charts
- No B3 integration

**Tasks:**

#### 4.1.1 Portfolio Summary Header
- [✅] Total patrimony display - Already implemented UI
- [✅] Daily change indicator - Already implemented UI
- [ ] Connect to real B3 portfolio data
- [ ] Add last sync timestamp
- [ ] Add manual refresh button
- [ ] Show sync status (syncing/success/error)

#### 4.1.2 Tab Navigation System
- [ ] Implement 4-tab system: Rentabilidade / Riscos / Composição / Proventos
- [ ] Create tab bar with proper styling
- [ ] Implement swipe-to-switch-tabs functionality
- [ ] Maintain tab state across app sessions

#### 4.1.3 Rentabilidade Tab (Performance)
- [ ] Total portfolio value and P&L display
- [ ] Performance chart comparing Portfolio vs IBOV/IFIX/IPCA/CDI
- [ ] Implement time period filters: Semana, No mês, 1 mês, 12 meses
- [ ] Show portfolio return percentages for each period
- [ ] Add benchmark comparison table
- [ ] Display source attribution: "Fonte: B3 / Banco Central"
- [ ] Implement fl_chart for performance visualization

#### 4.1.4 Riscos Tab (Risk Analysis)
- [ ] Define risk metrics to display:
  - Portfolio volatility
  - Sharpe ratio (if data available)
  - Beta vs IBOV
  - VaR (Value at Risk) - optional
- [ ] Create risk gauge/meter visualization
- [ ] Show risk classification (Conservative/Moderate/Aggressive)
- [ ] Display sector concentration risk
- [ ] Add explanatory tooltips for each metric

#### 4.1.5 Composição Tab (Asset Allocation)
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

#### 4.1.6 Proventos Tab (Dividends/Income)
- [ ] Filter dropdowns: "Classe de ativos" / "Produtos"
- [ ] Implement stacked bar chart for income events
- [ ] Toggle view: "Por ano" / "Por mês"
- [ ] Show projected income for next year
- [ ] Display historical income received
- [ ] Add export to CSV functionality (optional)
- [ ] Source: "Fonte: B3 / Banco Central"

#### 4.1.7 Holdings List Enhancement
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

#### 4.1.8 B3 Connection Status
- [ ] Add connection status indicator in AppBar
- [ ] Show "Conectar B3" button when disconnected
- [ ] Display empty state with CTA when not connected
- [ ] Handle connection errors gracefully
- [ ] Add reconnection flow

#### 4.1.9 Data & API Integration
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

## Phase 5: Conjuntura (Market Intelligence) Screen Implementation

### 5.1 Conjuntura Screen - Major Rebuild Required
**Status:** ❌ 30% Complete - Missing 5 of 6 sections

**Current State:**
- Basic structure with 3 mocked indicators
- No sectional organization
- No charts
- No ETL integration

**Tasks:**

#### 5.1.1 Navigation Structure
- [ ] Implement 6-section tab/card navigation system
- [ ] Create section headers with icons
- [ ] Add swipe-to-navigate between sections
- [ ] Implement scroll-to-section from header tap

#### 5.1.2 Section 1: Expectativas (Expectations)
- [ ] SELIC projection display with source (BACEN Focus)
- [ ] IPCA forecast (consensus)
- [ ] GDP growth expectations
- [ ] USD/BRL year-end forecast
- [ ] Show institution sources
- [ ] Display forecast ranges (min/max/average)
- [ ] Add update timestamp

#### 5.1.3 Section 2: Desempenho Econômico (Economic Performance)
- [ ] GDP growth chart (quarterly/annual)
- [ ] Unemployment rate tracker
- [ ] Job creation metrics
- [ ] Industrial production index chart
- [ ] Retail sales performance chart
- [ ] Time period filters for each metric
- [ ] Source attribution (IBGE)

#### 5.1.4 Section 3: Preços e Inflação (Prices & Inflation)
- [ ] IPCA monthly/annual display with chart
- [ ] IGPM index tracker
- [ ] Producer price index (IPA)
- [ ] Inflation breakdown by category:
  - Food
  - Housing
  - Transport
  - Health
  - Education
- [ ] Comparative bar chart for categories
- [ ] Historical trend line chart
- [ ] Source: IBGE, FGV

#### 5.1.5 Section 4: Setor Externo (Foreign Sector)
- [ ] USD/BRL exchange rate display (current)
- [ ] Historical FX chart with time filters
- [ ] Trade balance (exports vs imports)
- [ ] International reserves display
- [ ] Foreign direct investment flows chart
- [ ] Commodity price tracking (oil, iron ore)
- [ ] Source: BACEN, MDIC

#### 5.1.6 Section 5: Mercados Financeiros (Financial Markets)
- [ ] IBOV index with chart (current + historical)
- [ ] Global indices section:
  - S&P 500
  - Dow Jones
  - NASDAQ (optional)
  - DAX (optional)
- [ ] Major commodities:
  - Oil (Brent)
  - Gold
  - Iron ore
- [ ] Interest rate comparison (Brazil vs US vs EU)
- [ ] Currency basket (EUR, GBP, JPY)
- [ ] Source: B3, Yahoo Finance

#### 5.1.7 Section 6: Finanças Públicas (Public Finance)
- [ ] Federal debt as % of GDP (chart)
- [ ] Primary fiscal balance tracker
- [ ] Government revenue vs expenditure chart
- [ ] Debt service costs display
- [ ] Historical trend charts
- [ ] Source: Tesouro Nacional, BACEN

#### 5.1.8 Common Features Across All Sections
- [ ] Time period filters: 1 month, 3 months, 1 year, All-time
- [ ] "Last updated" timestamp per indicator
- [ ] Data source attribution clearly visible
- [ ] Skeleton loading states
- [ ] Error states with retry
- [ ] Pull-to-refresh functionality
- [ ] Offline mode with cached data

#### 5.1.9 Subscription Trial Tracking
- [ ] Track 7-day trial start date
- [ ] Show trial countdown in UI
- [ ] Display "X days remaining" badge
- [ ] On day 8: Show upgrade prompt (not enforced for MVP)
- [ ] Add "Upgrade to Pro" button in section

#### 5.1.10 Data Integration
- [ ] Create backend API endpoints for all 6 sections
- [ ] Connect to ETL Gold layer tables
- [ ] Implement data refresh schedule (daily EOD)
- [ ] Handle D-1 data lag messaging
- [ ] Create Supabase tables for indicator data
- [ ] Implement caching strategy

**New Files Needed:**
- `lib/screens/conjuntura/conjuntura_controller.dart`
- `lib/screens/conjuntura/widgets/section_navigation.dart`
- `lib/screens/conjuntura/widgets/expectativas_section.dart`
- `lib/screens/conjuntura/widgets/desempenho_section.dart`
- `lib/screens/conjuntura/widgets/precos_section.dart`
- `lib/screens/conjuntura/widgets/setor_externo_section.dart`
- `lib/screens/conjuntura/widgets/mercados_section.dart`
- `lib/screens/conjuntura/widgets/financas_publicas_section.dart`
- `lib/screens/conjuntura/widgets/indicator_card.dart`
- `lib/screens/conjuntura/widgets/chart_with_filters.dart`
- `lib/services/conjuntura_service.dart`

---

## Phase 6: Sofia (AI Assistant) Screen Enhancement

### 6.1 Sofia Screen - Polish & Features
**Status:** ⚠️ 75% Complete - Core works, needs enhancements

**Current State:**
- Chat interface functional
- Real backend integration working
- Missing conversation persistence and some UI features

**Tasks:**

#### 6.1.1 Sofia Home Screen
- [✅] Welcome section - Already implemented
- [✅] Suggestion cards - Already implemented
- [ ] Load suggestions from text_strings.dart
- [ ] Implement "Limpar histórico" functionality
- [ ] Add conversation history preview cards

#### 6.1.2 Sofia Chat Screen
- [✅] Message display - Already implemented
- [✅] Streaming responses - Already implemented
- [✅] Session management - Already implemented
- [ ] Add copy message functionality
- [ ] Improve typing indicator (replace spinner) if needed
- [ ] Add message timestamps toggle if in Figma design
- **Note:** Conversation history persistence will use Zep for chat memory (future implementation)
- **Note:** Message search functionality not needed for MVP

#### 6.1.3 Prompt Limit Tracking
- [ ] Track daily prompt count per user
- [ ] Create backend endpoint for prompt tracking
- [ ] Display remaining prompts for free users
- [ ] Show "X/5 prompts used today" indicator
- [ ] On 6th prompt: Show upgrade dialog (not enforced for MVP)
- [ ] Reset counter daily at midnight

#### 6.1.4 Educational Disclaimer
- [ ] Add footer disclaimer: "SofIA provides educational information only, not financial advice"
- [ ] Display in chat screen (sticky footer)
- [ ] Add info icon with expanded explanation

#### 6.1.5 Personality & Tone
- [ ] Review sample responses for tone consistency
- [ ] Ensure first-person communication ("Deixa comigo!")
- [ ] Add personality to error messages
- [ ] Test Portuguese language quality

#### 6.1.6 Data Integration (Future)
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

## Phase 7: Perfil (Profile) Screen Implementation

### 7.1 Perfil Screen - Functionality Implementation
**Status:** ⚠️ 70% Complete - UI done, most features are TODOs

**Current State:**
- Profile header displays user info
- All settings are UI-only placeholders
- Only logout works

**Tasks:**

#### 7.1.1 Profile Information Display
- [✅] User name - Already implemented
- [✅] Email - Already implemented
- [ ] Add profile photo upload functionality
- [ ] Display account creation date
- [ ] Show subscription tier badge (Free/Pro)
- [ ] Add verification status indicator

#### 7.1.2 Account Settings - Personal Information
- [ ] Create "Informações Pessoais" screen
- [ ] Display: First name, Middle name, Last name
- [ ] Display: CPF (masked), Phone, Birthdate
- [ ] Allow name editing with validation
- [ ] Allow phone editing with validation
- [ ] Save changes to Supabase user table
- [ ] Show success/error feedback

#### 7.1.3 Account Settings - Security
- [ ] Create "Segurança" screen
- [ ] Implement change password flow:
  - Current password verification
  - New password + confirmation
  - Strength indicator
- [ ] Add 2FA setup (future enhancement)
- [ ] Show last login information
- [ ] Add session management (view active sessions)

#### 7.1.4 Account Settings - Bank Accounts
- [ ] Create "Contas Bancárias" screen
- [ ] Display linked B3 accounts
- [ ] Add "Connect B3" button
- [ ] Show connection status
- [ ] Allow disconnection with confirmation
- [ ] Display last sync timestamp

#### 7.1.5 Account Settings - Transaction History
- [ ] Create "Histórico de Transações" screen
- [ ] Fetch transaction data from backend
- [ ] Display: date, type, asset, quantity, price
- [ ] Add filters: date range, transaction type
- [ ] Add export to CSV functionality
- [ ] Implement pagination for long history

#### 7.1.6 App Settings - Notifications
- [ ] Implement notification preferences toggle
- [ ] Create notification categories:
  - Portfolio changes
  - Market alerts
  - Sofia responses
  - System updates
- [ ] Save preferences to backend
- [ ] Connect to push notification system (future)

#### 7.1.7 App Settings - Theme
- [ ] If keeping both themes: Implement theme toggle
- [ ] If dark-only: Remove theme option entirely
- [ ] Persist theme preference locally
- [ ] Apply theme change immediately

#### 7.1.8 App Settings - Language
- [ ] Add language selector (Portuguese only for MVP)
- [ ] Prepare i18n structure for future languages
- [ ] Keep UI as placeholder for now

#### 7.1.9 App Settings - Biometric Toggle
- [ ] Implement functional biometric enable/disable toggle
- [ ] Check device capability before showing
- [ ] Save preference to secure storage
- [ ] Test biometric authentication on toggle
- [ ] Show setup instructions if needed

#### 7.1.10 Support Section
- [ ] Create "Central de Ajuda" screen with FAQ
- [ ] Add help topics: Account, Portfolio, Sofia, Subscriptions
- [ ] Create "Fale Conosco" contact form
- [ ] Implement email submission to support
- [ ] Add "Avaliar App" deep link to App Store/Play Store
- [ ] Create "Sobre" screen with:
  - App version
  - Terms of Service link
  - Privacy Policy link
  - Open source licenses

#### 7.1.11 Subscription Management
- [ ] Add "Upgrade to Pro" card (when on Free tier)
- [ ] Display subscription benefits comparison
- [ ] Show current plan status
- [ ] Display next billing date (when Pro)
- [ ] Add cancel subscription option (future)
- [ ] Implement upgrade flow (manual for MVP)

#### 7.1.12 Account Deletion (LGPD Compliance)
- [ ] Add "Excluir Conta" option in settings
- [ ] Show confirmation dialog with warnings
- [ ] Require password verification
- [ ] Create backend endpoint for account deletion
- [ ] Delete all user data from Supabase
- [ ] Send confirmation email
- [ ] Logout and clear local data

**New Files Needed:**
- `lib/screens/perfil/perfil_controller.dart`
- `lib/screens/perfil/screens/personal_info_screen.dart`
- `lib/screens/perfil/screens/security_screen.dart`
- `lib/screens/perfil/screens/bank_accounts_screen.dart`
- `lib/screens/perfil/screens/transaction_history_screen.dart`
- `lib/screens/perfil/screens/help_center_screen.dart`
- `lib/screens/perfil/screens/contact_support_screen.dart`
- `lib/screens/perfil/screens/about_screen.dart`
- `lib/screens/perfil/widgets/subscription_card.dart`

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

**Confirmed Approach:** Home → Sofia → Carteira → Conjuntura (builds from most to least complete)

**Iterative Process:**
- Complete each phase/feature
- Manual testing checkpoint
- Requirements may shift during integrations
- Keep it simple, avoid overcomplication

### Priority 0 (Pre-Implementation):
0. **Figma Design Review** (Phase 0.1) - MUST complete before any UI work
1. **Force Dark Theme** (Phase 1.1) - Critical fix to prevent light mode issues

### Priority 1 (Must Have for MVP):
2. **Common UI Components** (Phase 1.2) - Needed for all screens, must match Figma
3. **Chart Library Integration with fl_chart** (Phase 1.2.5) - Must match Figma chart designs exactly
4. **Home Screen Data Integration** (Phase 3) - Main dashboard, already 70% complete
5. **Sofia Enhancements** (Phase 6) - Key differentiator, already 75% complete (skip persistence/search)
6. **Backend API Development** (Phase 8.1-8.4) - Required for data
7. **Database Schema** (Phase 9) - Foundation for data storage

### Priority 2 (Important for MVP):
7. **Carteira Implementation** (Phase 4) - Core feature, requires B3 OAuth testing
8. **Conjuntura Implementation** (Phase 5) - Core feature, most work needed
9. **Perfil Functionality** (Phase 7) - User management
10. **Auth Fixes** (Phase 2.2, 2.3) - Polish existing features

### Priority 3 (Post-MVP):
11. **ETL Integration** (Phase 10) - Can use mock data initially
12. **Subscription System** (Phase 11) - Manual workaround for MVP
13. **Testing** (Phase 12) - Continuous throughout
14. **Polish & Launch** (Phase 13) - Final touches

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
- ✅ Priority: Home → Sofia → Carteira → Conjuntura
- ✅ B3 OAuth 2.0 flow (backend testing needed)

**Immediate Actions:**
1. **FIRST:** Review all Figma designs using Figma MCP (Phase 0.1)
2. **SECOND:** Force dark theme in main.dart (Phase 1.1)
3. Add fl_chart package to pubspec.yaml
4. Create common UI components matching Figma designs
5. Build chart wrapper components matching Figma chart styles exactly
6. Begin Home screen data integration (replace mocked data)
7. Parallel: Backend API development for Home/Sofia/Carteira
8. Test B3 OAuth flow in backend before frontend integration

**Implementation Approach:**
- **Iterative with manual testing:** Complete each phase and allow manual testing before proceeding
- **Keep it simple:** Avoid overcomplication, focus on core functionality
- **Figma-first:** All UI must match Figma designs exactly
- **Flexible:** Requirements may shift during integrations, plan will adapt
