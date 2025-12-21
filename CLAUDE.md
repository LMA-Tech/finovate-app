# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Finovate is a cross-platform Flutter investment app with AI assistant (SofIA). Built with GetX for state management, Supabase for authentication, and a custom Node.js backend for AI features.

**Stack:** Flutter 3.5.4, Dart, GetX, Supabase Auth, Custom Node.js API (api.finovate.com.br)

A complete plan for the project has been written to @plan.md.

## Development Commands

### Running the App
```bash
flutter pub get              # Install dependencies
flutter run                  # Run app (auto-selects device)
flutter run -d <device-id>   # Run on specific device
```

### Testing
```bash
flutter test                 # Run all tests
flutter test test/path/to/file_test.dart  # Run specific test file
```

### Code Quality
```bash
flutter analyze              # Static analysis
flutter format lib/          # Format code
```

### Building
```bash
flutter build apk           # Build Android APK
flutter build ios           # Build iOS (requires macOS)
```

### Debugging
```bash
flutter clean               # Clean build artifacts
flutter pub get             # Re-fetch dependencies
flutter doctor              # Check Flutter setup
```

## Environment Setup

1. Copy `.env.example` to `.env` in project root
2. Configure required variables:
   - `SUPABASE_URL` - Supabase project URL
   - `SUPABASE_ANON_KEY` - Supabase anonymous key
   - `API_BASE_URL` - Backend API URL (default: `http://localhost:3000`)
   - `ALLOW_BIOMETRIC_TEST_MODE` - Enable biometric testing (dev only)

3. Backend API: `https://api.finovate.com.br/api/v1` (see `finovate_api_service.dart:17`)

## Architecture

### State Management Pattern

**GetX Controllers** are used for all state management. Key singleton controllers:

- `SessionManager` - Auth state, user info, token refresh (lib/services/session_manager.dart)
- `ActivityTracker` - Biometric timeout, app lifecycle (lib/services/activity_tracker.dart)
- `BottomNavigationController` - Tab state (lib/controllers/bottom_navigation_controller.dart)

**Reactive Observables:**
```dart
// Controllers expose observable state
final RxBool isAuthenticated = false.obs;
final Rx<User?> currentUser = Rx<User?>(null);

// UI components use Obx() to auto-update
Obx(() => Text(sessionManager.currentUser.value?.email ?? 'Guest'))
```

### Navigation Pattern

**Always use direct navigation** (preferred pattern documented in README.md:56-63):
```dart
Get.to(() => const SomeScreen());       // Push new screen
Get.off(() => const SomeScreen());      // Replace current screen
Get.offAll(() => const SomeScreen());   // Clear stack and go to screen
Get.back();                              // Go back
```

**Route constants** are defined in `lib/utils/constants/routes.dart` and registered in `main.dart` getPages.

### Authentication Flow

1. **Supabase handles auth operations:** signup/login/OTP (see `auth_service.dart`)
2. **SessionManager tracks state:** JWT token, user object, biometric availability
3. **Token refresh:** Auto-refreshes tokens at 5min threshold (see `session_manager.dart`)
4. **Biometric timeout:** Managed by `ActivityTracker` for re-authentication

**Auth flow sequence:**
```
SplashScreen → AuthGate (checks auth state)
├─ Not Authenticated → OnboardingScreen → GetStartedScreen → LoginScreen
└─ Authenticated → HomeScreen (with BottomNav)
```

### Service Layer Architecture

**Core Services** (all in `lib/services/`):

- `auth_service.dart` - Supabase auth operations (signup, login, validation)
- `session_manager.dart` - Auth state + token lifecycle management
- `finovate_api_service.dart` - Backend API client with correlation IDs
- `activity_tracker.dart` - Session timeout and app lifecycle
- `biometric_service.dart` - Biometric authentication
- `auth_gate.dart` - Route guard for authentication
- `asset_cache_manager.dart` - Preload critical assets
- `centralized_email_service.dart` - Email operations
- `onboarding_service.dart` - First-time user experience

**API Service Pattern:**
```dart
// All backend calls use correlation IDs for request tracing
final headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $token',
  'X-Correlation-Id': correlationId,
};
```

### Project Structure

```
lib/
├── config/
│   └── env_config.dart          # .env file loader
├── services/                     # Business logic layer
│   ├── auth_service.dart        # Supabase auth operations
│   ├── session_manager.dart     # Auth state management
│   ├── finovate_api_service.dart # Backend API client
│   └── (other services)
├── screens/                      # Feature-based UI screens
│   ├── splash/                  # ✅ Functional (has bugs)
│   ├── onboarding/              # ✅ Functional (has bugs)
│   ├── login/                   # ✅ Functional (has bugs)
│   ├── signup/                  # ✅ Functional (has bugs)
│   ├── sofia/                   # 🚧 In Progress (AI chat)
│   ├── home/                    # ✅ Functional (API integrated)
│   ├── stocks/                  # ✅ Functional (list + detail screens)
│   ├── carteira/                # 📋 Mocked (Portfolio)
│   ├── conjuntura/              # 📋 Mocked (Economy)
│   └── perfil/                  # 📋 Mocked (Profile)
├── controllers/                  # GetX state controllers
├── common/widgets/               # Reusable UI components
└── utils/
    ├── constants/               # Colors, sizes, strings, routes
    └── theme/                   # App theme configuration
```

## Key Implementation Details

### Email Validation
- Email checking uses `users` table query (not auth.admin API)
- See `auth_service.dart:9-24` for pattern

### CPF Validation
- CPF formatting is stripped before database queries
- Pattern: `cpf.replaceAll(RegExp(r'[^\d]'), '')`
- See `auth_service.dart:27-45`

### Signup Flow
- Multi-step process tracked by `isInSignupFlow` observable
- User metadata stored in Supabase `auth.users.raw_user_meta_data`
- See `session_manager.dart:28` for signup flow flag

### Bottom Navigation
- 5 tabs: Home, Conjuntura, SofIA, Carteira, Perfil
- Managed by `BottomNavigationController`
- Route list in `routes.dart:90-96`

### API Communication
- All requests include correlation ID for tracing
- Auth token from Supabase session automatically included
- 30-second timeout on all API calls
- See `finovate_api_service.dart` for header pattern and timeout configuration

## Common Patterns

### Adding a New Screen

1. Create screen file in appropriate `lib/screens/<feature>/` directory
2. Add route constant to `lib/utils/constants/routes.dart`
3. Register route in `main.dart` getPages array
4. Use direct navigation: `Get.to(() => const NewScreen())`

### Creating a GetX Controller

```dart
class MyController extends GetxController {
  final RxString myState = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize
  }

  @override
  void onClose() {
    // Cleanup
    super.onClose();
  }
}
```

### Backend API Call Pattern

```dart
final response = await FinovateApiService.post(
  endpoint: '/chat/send',
  body: {'message': 'Hello'},
);
```

## Feature Status Reference

- **✅ Functional (with bugs):** Splash, Onboarding, Login, Signup, Session management, Activity tracking
- **✅ Functional (API integrated):** Home (dashboard summary), Stocks (list + detail with chart, indicators, company info)
- **🚧 In Progress:** SofIA AI Chat (backend integration)
- **📋 Mocked (no backend):** Portfolio, Economy, Profile

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
- Current common widgets include:
  - `primary_button.dart` - Primary, secondary, text buttons
  - `custom_card.dart` - Card variants
  - `skeleton_loader.dart` - Skeleton loading placeholders
  - `loading_state.dart` - Centered loading spinner (uses `loading_indicator` package with `ballSpinFadeLoader`)
  - `empty_state.dart` - Empty state displays
  - `error_state.dart` - Error state with retry
  - `section_header.dart` - Section headers with "Ver mais"
  - `scrollable_header.dart` - Header with back button for scrollable screens (unlike `custom_appbar.dart` which is fixed)
  - `segmented_tabs.dart` - Segmented tab control with pop-out effect
  - `info_bottom_sheet.dart` - Info icon button with bottom sheet modal
  - `stock_logo.dart` - Stock logo with network image support and fallback
  - `trend_change_pill.dart` - Price change pill with positive/negative styling
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

## Important Notes

- Backend API: `https://api.finovate.com.br/api/v1` (hosted on Railway)
- GetX dependency injection used throughout - controllers are singletons
- All user-facing strings should go in `utils/constants/text_strings.dart`
- Theme colors defined in `utils/constants/colors.dart`
- Navigation should always use `Get.to()` pattern, not named routes
- Please remember to use @lib/utils/ directory and @lib/common/ for reuseable widgets
- remember not to use in line text use fintexts and if not there add it in organized manner