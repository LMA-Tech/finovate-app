# Summary

I want to build a MVP mobile investment companion app (iOS/Android) called Finovate that empowers Brazilian retail investors—particularly those aged 25-39 with small to medium portfolios—to make informed investment decisions through three core capabilities: real-time market intelligence (Conjuntura), B3 portfolio consolidation (Carteira), and an AI financial assistant (SofIA).
The app should be built with Flutter.

ALL REQUIREMENTS HERE CAN BE SUBJECTED TO CHANGES OR DESIGN PATTERNS

## Success Criteria:

MVP is complete when a user can:

```
1. Register & authenticate using email/password with biometric login option
2. Connect their B3 account and view consolidated portfolio holdings with basic performance
metrics
3. Browse economic indicators (Conjuntura tab) covering IPCA, SELIC, FX rates, and major
indices without leaving the app, users will access within their 7-day trial or active Pro
subscription
4. Ask SofIA 5 questions daily (free) or unlimited (Pro) and receive intelligent, conversational
responses (non-advisory)
5. Upgrade to Pro via in-app purchase flow and have entitlements applied immediately
6. Navigate seamlessly between features with consistent UX and sub-3 second load times
```

## Business Model:

Subscription-based with freemium entry:
```
Free Tier: 5 daily SofIA prompts, 7-day Conjuntura trial, unlimited B3 portfolio access
Pro Tier: Unlimited SofIA prompts, full Conjuntura access, all future premium features
Pricing to be defined during MVP validation phase
```

## Technical Requirements 

Reference: Detailed technical architecture documented in separate ADDs (Architecture Design
Documents):

```
Frontend ADD: Flutter
Backend ADD: Node.js/Express API, Supabase integration, JWT auth, rate limiting (TBA)
ETL ADD: S3 Buckets, Lambda, EC2, PostgresSQL (Supabase)
AI ADD: Langflow integration, SofIA training, prompt engineering (TBA)
```

Critical Integration Points for MVP:

```
1. Supabase Auth → JWT tokens with 1hr expiry, auto-refresh at 5min threshold
2. B3 API → Authorization method TBD (OAuth vs link-based), portfolio data sync
3. Langflow → Proxied through backend (localhost:7860), <5sec response target (for now until host somewhere else)
4. ETL Gold Layer → D-1 market data for pricing, indicators served via backend API
5. In-App Purchases → Deferred post-MVP, manual Pro upgrades during testing
```

# Features 

## UI Navigation & UX Foundation
Description: Core navigation structure, loading states, and consistent design system.

### Bottom Navigation (5 Tabs):

```
1. Home (Tab 0): Dashboard with portfolio summary, market highlights, quick actions
2. Carteira (Tab 1): B3 portfolio with performance charts
3. SofIA (Tab 2): AI chat interface
4. Conjuntura (Tab 3): Economic indicators and market intelligence
5. Perfil (Tab 4): Profile and settings
```
### Onboarding Flow:

```
Splash screen with Finovate branding (max 3 seconds)
First-time onboarding carousel (3-5 screens, skippable)
"Get Started" CTA leading to signup/login
Returning users skip onboarding, go directly to biometric auth or home
```

### Loading & Error States:

```
Skeleton screens for data-heavy sections (Carteira, Conjuntura)
Spinner/loading indicator for short waits (< 3 seconds)
Empty states with helpful CTAs (e.g., "Connect B3 to see portfolio")
Error messages with retry button and clear explanation
Offline mode indicator when no internet connection
```
### UI Screens

- According to the designs are in Figma.
- Reference: All detailed user flows are documented in Figma.

Key Flows Covered in Figma:

```
1. Onboarding
2. Sign up
3. Login
4. Home
5. Conjuntura
6. My Profile
7. Stocks
8. My Wallet
9. Premium Plan
```

### Notes:

Already implemented: Basic navigation structure exists (see ARCHITECTURE.md - App

---

## Authentication & User Management

### Registration (6 Steps):

- Email + Password entry
- Personal info (First/Middle/Last name)
- CPF + Phone + Birthdate
- Verification method selection (Email only for MVP)
- Email OTP verification
- Post-verification questionnaire (4 questions)

### Login & Security:
- Email/password authentication
- Biometric re-auth after 30min inactivity (Face ID/Touch ID)
- Full logout after 7 days without sign-in
- Password reset via email OTP

### Must Have:
- Real-time form validation with user-friendly error messages
- Duplicate email/CPF checks before submission
- Email verification via Supabase-managed email service (OTP codes)
- Session management with JWT token refresh
- Biometric authentication for returning users (device-dependent)
- LGPD-compliant data collection

### Dependencies:
- The email service is using Hostinger’s custom SMTP
- Supabase Auth for JWT tokens and for email delivery (currently centralized_email_service)
- Biometric hardware support (device-dependent) -- Local biometric hardware (device capability check at runtime)
- Supabase PostgresSQL user created in table after verification
- Supabase PostgresSQL user choices created in user_onboarding_questionnaire table after choosing options

---

## B3 Portfolio Integration (Carteira)

Description: Connect user's B3 brokerage account to display consolidated portfolio with
performance analytics and income tracking.

MVP Scope - 4 Core Sections:

### Section 1: Rentabilidade (Performance)

Metrics:
```
Total portfolio value
Daily change indicator
Tabs: Rentabilidade / Risco / Composição
Performance chart comparing: Portfolio vs IBOV/IFIX/IPCA/CDI
Time period filters: Semana, No mês, 1 mês, 12 meses
Source attribution: "Fonte: Banco central"
```
Uncertainties:

```
Portfolio total return (%)
Benchmark comparison (IBOV, any others?)
Time period returns (1W, 1M, 1Y, All-time)
```

### Section 2: Riscos (Risks)

```
Define what goes here (VaR, volatility, Sharpe ratio, portfolio beta?)
Source:?
```
Uncertainties:

```
If we do stocks + FIIs only, pie chart shows: Ações / FIIs / Caixa (cash)
Or expand to include Renda Fixa if B3 provides that data
```

### Section 3: Composição (Allocation)

```
Pie chart: Breakdown of wallet (Example: Renda Fixa (25%), Ações (40%), FIIs (20%), ETFs
(10%))
Source: "Fonte: Banco central"
```
Uncertainties:

```
If we do stocks + FIIs only, pie chart shows: Ações / FIIs / Caixa (cash)
Or expand to include Renda Fixa if B3 provides that data
```

### Section 4: Proventos (Dividends/Income)

```
Filter dropdowns: "Classe de ativos" / "Produtos" / etc...
Stacked bar chart: "Eventos da carteira" by month or year
2026 (next year) vs 2027 (2 years after) comparisons
```

```
Toggle: "Por ano" / "Por mês"
Source: "Fonte: Banco central"
```
Uncertainties:

```
Do we track historical dividends received, or future projected income?
Is this data coming from B3 API, or do we calculate it ourselves from corporate actions?
```

### Must Have:

```
B3 connection via authorization flow (OAuth/link TBD)
B3 connection status indicator (connected/disconnected)
Error handling for failed sync with clear user messaging
Manual refresh button or scheduled syncs
Portfolio data persists locally between sessions
Portfolio summary: total value, daily change, overall P&L percentage
Show holdings with: ticker, quantity, average cost, current value, P&L
"Last updated" timestamp (D-1 data acceptable for MVP)
Asset allocation breakdown by type (visual pie chart or bar chart)
Source attribution ("Fonte: B3" or similar)
Empty states when not connected
Asset Types for MVP:
✅ Stocks (Ações)
✅ FIIs (Fundos Imobiliários)
❌ ETFs (post-MVP)
❌ BDRs (post-MVP)
Uncertainties: Does "Renda Fixa" come from B3 sync, or separate integration?
```
### Dependencies:

```
B3 API integration (authorization method under investigation)
Defined list of needed B3 APIs
Backend service to securely store B3 tokens/credentials
ETL Gold layer providing D-1 market prices for valuation
Supabase table for storing user portfolio holdings and B3 tokens
Corporate actions data for Proventos section (source TBD)
```
Critical Uncertainties:

```
Auth flow: B3 OAuth vs authorization link → user login → token retrieval (needs technical
validation)
Sync frequency: Daily automatic vs manual-only refresh (needt o evaluate)
Data scope: Which B3 asset types are supported by API (stocks confirmed, FIIs/ETFs/BDRs
TBD)
```
---
## Market Intelligence (Conjuntura)

Description: Curated economic indicators and market data organized into 6 thematic sections,
providing investors with consolidated macro information in one place.

MVP Scope - 6 Core Sections:

### Section 1 : Expectativas (Expectations)

```
Projections from major institutions (BACEN Focus Report, market consensus)
Key indicators: SELIC projection, IPCA forecast, GDP growth expectations, USD/BRL year-
end forecast
```
### Section 2 : Desempenho Econômico (Economic Performance)

```
GDP growth (quarterly/annual)
Employment data (unemployment rate, job creation)
Industrial production index
Retail sales performance
```
### Section 3 : Preços e Inflação (Prices & Inflation)

```
IPCA (monthly/annual)
IGPM index
Producer price index (IPA)
Inflation breakdown by category (food, housing, transport)
```
### Section 4 : Setor Externo (Foreign Sector)

```
USD/BRL exchange rate (current + historical chart)
Trade balance (exports vs imports)
International reserves
Foreign direct investment flows
```
### Section 5 : Mercados Financeiros (Financial Markets)

```
IBOV index (current + chart)
Global indices (S&P 500 , Dow Jones, others TBD)
Major commodities (oil, gold, iron ore)
Interest rates (Brazil vs US/EU comparison)
```
### Section 6 : Finanças Públicas (Public Finance)

```
Federal debt as % of GDP
Primary fiscal balance
```

```
Government revenue vs expenditure
Debt service costs
```
### Must Have:

```
Tab or card-based navigation between 6 sections (Follow Figma designs)
Line/bar charts for key indicators with historical data (Follow Figma designs)
Time period filters: 1 month, 3 months, 1 year, All-time
"Last updated" timestamp per indicator
Data source attribution (IBGE, BACEN, B3, etc.)
7-day free trial, then Pro subscription required
MVP Exception: Trial tracked but NOT enforced (honor system for testers)
```
### Dependencies:

```
ETL pipeline ingesting from: IBGE, BACEN, CVM, B3, Yahoo Finance (or similar)
Gold layer Supabase tables with aggregated indicator data
Backend API endpoints serving indicator data to frontend
Data source table in ETL ADD defines exact APIs (partially documented)
Reliable charting library
```
### Data Update Frequency:

```
Most indicators: Daily (end of day)
Some (GDP, employment): Monthly/quarterly as published
Market data (IBOV, FX): D-1 closing prices (real-time post-MVP)
```
### Critical Uncertainties:

```
Exact indicators per section: Need finalized list (3-5 key indicators per section minimum)
Data sources: ETL ADD shows infrastructure, but exact API endpoints per indicator TBD
```
### Notes:

```
ETL Dependency: This feature is heavily dependent on ETL pipeline completion
Data lag acceptable: D-1 data is fine for MVP; communicate clearly in UI
Trial enforcement: Deferred until in-app purchases are implemented
Chart library: Need to select/confirm good charting library.
```

---

## AI Financial Assistant (SofIA)

Description: Conversational AI bot that simplifies complex financial information and guides
users through their investment journey with clarity, empathy, and data-driven insights—without
providing regulated financial advice.

### Core Functionality:

```
Natural language Q&A about investments, market context, and financial concepts
Context-aware responses using market data and investment best practices
Conversation history saved and accessible across sessions (Not in scope for MVP - but
sessions are being handled)
Typing indicators and smooth message animations
Prominent disclaimer: "SofIA provides educational information only, not financial advice"
(footer placement)
```
### SofIA's Personality (per brand guide):

```
Didactic & trustworthy: Explains without complicating
Welcoming & accessible: Friendly tone that removes fear of investing
Available & efficient: Responds with precision, no fluff
Data-driven: Supports strategic decisions with concrete information
```

```
First-person communication: "Deixa comigo! Eu analiso os números..." vs robotic third-
person
```
### Question Types SofIA Should Handle:

```
Market context: "Por que o IBOV está caindo?" "O que está movendo o dólar?"
Asset information: "Me conta sobre PETR4" "O que são FIIs?"
Investment concepts: "O que é diversificação?" "Como funciona juros compostos?"
Portfolio-related (future): "Como está minha carteira?" "Estou bem diversificado?"
Economic indicators: "O que a SELIC impacta?" "Por que inflação importa?"
```
### Tone Examples (from brand guide):

```
Friendly helper: "Pode perguntar! Eu tô aqui pra te ajudar a entender o mercado sem
complicação."
Simplifier: "O mercado pode ser complicado, mas eu traduzo tudo pra você de um jeito
simples."
Reassuring: "Você nunca investe sozinho(a). Eu tô aqui pra te apoiar em cada escolha."
Educational: "Aprender a investir não precisa ser difícil. Eu te ensino no caminho!"
```
### Must Have:

```
Clean, conversational UI with differentiated user/SofIA bubbles
Empty state with example starter questions
Persistent chat history (locally stored, survives app restarts)
Typing indicator or logo while SofIA "thinks"
Error handling with fallback messages
5 free daily prompts for basic users, unlimited for Pro
MVP Exception: Prompt limit tracked but NOT enforced for testers
Copy message text functionality
Scroll to latest message
```
### Dependencies:

```
Backend Langflow integration (host proxied through Node.js backend)
Backend API endpoints for chat message routing and response handling
Future: Gold layer data access for personalized, data-driven responses (not MVP critical)
Rate limiting infrastructure in backend (for post-MVP enforcement)
```
### Data Sources for SofIA (evolving):

```
Langflow's base training data
Future integration: Gold layer market data (economic indicators, prices)
Future integration: User's B3 portfolio data for personalized insights
Public financial education content
```
### Critical Uncertainties:

```
Langflow training scope: What specific knowledge does SofIA have? (Brazilian tax rules,
asset classes, etc.) - Not yet defined
Response quality: Needs extensive testing for accuracy and tone before launch
Latency: Target response time < 5 seconds—needs load testing
Data integration timeline: When will SofIA access Gold layer market data? TBD
```

### Notes:

```
Current status: Mock responses implemented; Langflow integration in progress
Tone calibration: Review brand guide Section 7 (Dialeto da SofIA) before launch - tone must
be warm, first-person, and conversational
Prompt limit: Free users get 5/day, Pro unlimited—enforcement deferred until IAP ready
Testing priority: Response quality, tone consistency, and error handling need heavy
validation
Future enhancement: Portfolio-specific insights once B3 sync is mature and Gold layer
connected
```
---
### Home Dashboard:

Description: Unified dashboard providing quick overview of portfolio, market highlights, and
economic indicators with quick access to detailed views.

MVP Scope - 6 Core Sections:

1. Header

```
User greeting: "Olá, [First Name]" with "Bem vindo" subtitle
Profile avatar (top left)
Notification bell icon (top right)
```
2. B3 Connection Banner

```
Prominent CTA: "Conecte sua conta B3 para aproveitar todos os recursos"
Dismiss/collapse functionality after connection
Shows only when B3 not connected
```
3. Portfolio Summary (Minha carteira)

```
Quick-view performance metrics:
Tabs: Rentabilidade / Risco / Composição
Time period filters: Semana / No mês / 1 mês / 12 meses
Mini chart showing portfolio vs IBOV comparison
Performance percentages displayed on chart
"Ver mais" link → navigates to Carteira Tab
```
4. Market Snapshot (Bolsa)


```
Featured stocks/assets (2 visible cards - scrollable to right):
"Ver mais" link → navigates to market section in expanded view
```
5. Economic Indicators (Economia)

```
Key indicators in card format (2 visible):
Dólar (USD/BRL rate)
Taxa de juros (SELIC or similar)
Percentage change indicators
"Ver mais" link → navigates to Conjuntura Tab
```
6. Feedback Button: Opens in-app feedback form

```
"Enviar Feedback" button at bottom
Opens feedback 3 feedback screens
```
### Must Have:

```
Pull-to-refresh to update all data
Smooth scrolling through sections
All "Ver mais" links navigate to appropriate tabs
Data refreshes on app foreground (when user returns)
Skeleton loading states while fetching data
```
### Dependencies:

```
B3 portfolio data (when connected)
ETL Gold layer for market data (stocks, indicators)
Backend API endpoints serving dashboard aggregated data
Navigation controller to switch between tabs
```
#### Data Update Strategy:

```
Portfolio data: Refresh from last B3 sync timestamp
Market stocks: D-1 closing prices (or live if available)
Economic indicators: D-1 or latest available
```
### Notes:

```
Design matches Figma: Implement exactly as shown in mockup for MVP
Data priority: Portfolio summary most critical—ensure this loads first
Empty states: When B3 not connected, show placeholder for portfolio section with CTA
```
---

## Profile & Settings

Description: User profile display and app configuration options.

### Must Have:

```
Profile Information:
- Avatar pic
- Display name (from signup)
- Email address
- Subscription tier badge ("Free" or "Pro")
- Account creation date
App Settings:
- Language preference (Portuguese only for MVP)
- Biometric authentication toggle (enable/disable Face ID or Touch ID)
- Notification preferences (placeholder for future)
Account Actions:
- Logout button
- Delete account option (with confirmation)
Legal Links:
- Terms of Service (web view or PDF)
- Privacy Policy (web view or PDF)
- About Finovate / App version number
```
### Dependencies:

```
Supabase user profile table (users or user_preferences)
Local storage for theme preference (GetX reactive state)
Backend API for account deletion
```
### Notes:

Already implemented: Basic profile structure exists in current codebase (see perfil/screens)

```
Theme persistence: Should survive app restarts using local storage
LGPD compliance: Delete account must remove all user data per Brazilian data protection law
```

--- 

## Subscription Management

Description: Freemium subscription system with in-app upgrade flow, allowing users to unlock
unlimited SofIA prompts and full Conjuntura access.

### Subscription Tiers:

```
Feature - Free - Pro
B3 Portfolio Sync - ✅ Unlimited - ✅ Unlimited
SofIA Prompts - 5/day - ✅ Unlimited
Conjuntura Access - 7-day trial - ✅ Full access
Priority Support - ❌ - ✅
Price - Free - TBD
```
### Core (Post-MVP):

```
In-app purchase flow (iOS App Store, Google Play Store)
Subscription status display in Profile tab
"Upgrade to Pro" prompts at limit touchpoints (5th SofIA prompt, day 8 of Conjuntura)
Backend subscription validation and entitlement sync
Grace period handling for payment failures
Subscription management (cancel, reactivate)
```
### MVP Strategy:

```
Phase 1 (MVP Launch): Manual Pro upgrades via backend for early testers
Phase 2 (Post-MVP Priority 1): Implement IAP once core features are stable and tested
```

#### Upgrade Touchpoints:

- SofIA chat: After 5th daily prompt, show "Você atingiu o limite diário. Upgrade para Pro para prompts ilimitados."
- Conjuntura: On day 8, show "Seu trial expirou. Upgrade para continuar acessando análises econômicas."
- Profile tab: "Upgrade to Pro" card with benefits list
- Onboarding: Optional Pro pitch after signup completion (not mandatory)

### MVP Workaround:

- Backend flag: user_subscriptions.plan_id = 'pro_manual' for testers
- No IAP UI shown during MVP testing phase
- Track desired pricing during beta feedback

### Notes:

```
Pricing strategy: TBD based on market research and competitor analysis (Status Invest,
Kinvo, TradeMap pricing)
Launch blocker: IAP is NOT required for MVP launch—manual upgrades sufficient for early
testing
Post-MVP timeline: Implement IAP within 30-60 days of MVP launch based on user
feedback
```

## Other requirements

### Theming

- The app uses dark mode only (we were planning on having ligh mode but changed out minds)
- Theming should be done by setting the `theme` in the `lib/theme/theme.dart`, rather than hardcoding colors and sizes in the widgets themselves `lib/theme/widget_themes.dart`
- There are directories under the utils folder for constants, device, helpers, and navigation

### Code Style

- Ensure proper separation of concerns by creating a suitable folder structure 
- Prefer small composable widgets over large ones
- Prefer using flex values over hardcoded sizes when creating widgets inside rows/columns, ensuring the UI adapts to various screen sizes
- Use `log` from `dart:developer` rather than `print` or `debugPrint` for logging