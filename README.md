# Finovate Flutter App

## 🏗️ Architecture Overview

- **State Management:** GetX
- **Navigation:** Named routes (see main.dart getPages)
- **Auth:** Supabase (handled by SessionManager)
- **Backend API:** Node.js at localhost:5001 (see finovate_api_service.dart)

## 📁 Project Structure
```
lib/
├── config/          # Environment configuration
├── services/        # Business logic (auth, API calls, session)
├── screens/         # UI screens (feature-based folders)
├── controllers/     # GetX controllers (state management)
├── common/          # Reusable widgets
└── utils/           # Helpers, constants, theme
```
## 🎯 Feature Status

**✅ Fully Functional:**
- Splash & Onboarding - Some bugs!
- Authentication (Login/Signup) - Some bugs!
- Session management with biometric - Some bugs!
- Activity tracking 

**🚧 In Progress:**
- SofIA AI Chat (backend integration)

**📋 Mocked (No Backend Yet):**
- Home screen widgets
- Portfolio (Carteira)
- Economy (Conjuntura)
- Profile (Perfil)

## 🔐 Environment Setup

1. Copy `.env.example` to `.env`
2. Get Supabase credentials from team
3. Ensure backend is running on port 5001

## 🚀 Getting Started
```bash
flutter pub get
flutter run
```

## 🧪 Testing
```bash
flutter test
```

# Navigation Standards

## Preferred Pattern: Direct Navigation
```dart
// Use this for all navigation:
Get.to(() => const SomeScreen());       // Push new screen
Get.off(() => const SomeScreen());      // Replace current screen
Get.offAll(() => const SomeScreen());   // Clear stack and go to screen
Get.back();                              // Go back
```