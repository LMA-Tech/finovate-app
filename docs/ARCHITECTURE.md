# Finovate Flutter App Architecture

## Overview
Cross-platform investment app with AI assistant. Uses GetX for state management, Supabase for auth/data, and custom backend for AI features.

## Stack
- **Framework:** Flutter 3.5.4
- **Language:** Dart
- **State Management:** GetX
- **Auth:** Supabase Auth (JWT)
- **Backend:** Custom Node.js API (localhost:5001)
- **UI Library:** flutter_chat_ui for chat interface

## Key Design Decisions

### Why GetX?
- Lightweight reactive state management
- Built-in dependency injection
- Simple navigation
- Minimal boilerplate

### Why Custom Backend?
- Hide AI API keys from client
- Server-side validation
- Rate limiting and cost control
- Session management

### Authentication Flow
- Supabase handles signup/login/OTP
- JWT token stored in Supabase client
- SessionManager tracks auth state reactively
- Auto-refresh tokens at 5min threshold

## Project Structure

```
lib/
├── config/
│   └── env_config.dart         # Environment variables (.env)
├── services/
│   ├── auth_service.dart       # Supabase auth operations
│   ├── session_manager.dart    # Auth state + token refresh
│   ├── activity_tracker.dart   # Session timeout tracking
│   ├── biometric_service.dart  # Biometric auth
│   ├── finovate_api_service.dart  # Backend API client
│   └── asset_cache_manager.dart   # Image preloading
├── screens/
│   ├── splash/                 # Splash/Boot screen (Testing)
│   ├── onboarding/             # Onboarding screens (Testing)
│   ├── login/                  # Login screens (Testing)
│   ├── signup/                 # Signup screens (Testing)
│   ├── home/                   # Home screens (MOCKED)
│   ├── sofia/                  # AI chat screens (In Progress)
│   ├── carteira/               # Portfolio (MOCKED)
│   ├── conjuntura/             # Economy (MOCKED)
│   └── perfil/                 # Profile (MOCKED)
├── controllers/
│   ├── bottom_navigation_controller.dart
│   └── (screen-specific controllers)
├── common/widgets/
│   └── app_background.dart
├── utils/
│   ├── constants/
│   │   ├── colors.dart
│   │   ├── sizes.dart
│   │   └── text_strings.dart
│   └── theme/
│       └── theme.dart
└── main.dart
```
---
## App Flow
```
main.dart
↓ Load .env
↓ Initialize Supabase
↓ Initialize GetX controllers
↓
SplashScreen
↓
AuthGate (checks auth state)
↓
├─ Not Authenticated → OnboardingScreen → GetStartedScreen → LoginScreen
└─ Authenticated → HomeScreen (BottomNav)
├─ Home (Tab 0)
├─ Carteira (Tab 1)
├─ SofIA (Tab 2)
├─ Conjuntura (Tab 3)
└─ Perfil (Tab 4)
```
---
## State Management

### GetX Controllers (Singletons)
- `SessionManager` - Auth state, user info, token management
- `ActivityTracker` - Biometric timeout, app lifecycle
- `BottomNavigationController` - Tab state
- `SofiaController` - AI chat state (mock responses)

### Reactive Observables
```dart
// Example from SessionManager
final RxBool isAuthenticated = false.obs;
final Rx<User?> currentUser = Rx<User?>(null);

// UI automatically updates when these change
Obx(() => Text(sessionManager.currentUser.value?.email ?? 'Guest'))
```
