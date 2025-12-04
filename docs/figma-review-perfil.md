# Figma Design Review: Perfil (Profile) Screen

**Review Date:** 2025-12-03
**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=3-33710
**Screens Reviewed:** Profile screen with tabs (Meu plano, Perfil, Preferências)

## Summary

✅ **Overall Status:** Profile screen design shows clear three-tab structure with personal information management.

⚠️ **Tab Structure:** Three main sections - Meu plano (subscription), Perfil (personal info), Preferências (settings)

⚠️ **Data Privacy:** Personal information shown with masking/censoring for security

⚠️ **Common Issues:** Same button color and font family issues as other screens

## Screen Structure

### Navigation Hierarchy
```
ProfileScreen
├── Header
│   ├── Back/Close button
│   ├── Title: "Meu perfil"
│   └── Action button (right)
├── Profile Header
│   ├── Profile Photo (80x80px circular)
│   └── User Name Display
├── Tab Navigation
│   ├── "Meu plano" tab
│   ├── "Perfil" tab (active)
│   └── "Preferências" tab
└── Tab Content Area
    └── (Dynamic content based on selected tab)
```

## Component Breakdown

### 1. Screen Header

**Figma Structure:**
- Left: Back/Close button (chevron or X icon)
- Center: Title "Meu perfil"
- Right: Action button (appears to be menu or settings icon)
- Background: Transparent (uses main app gradient background)

**Typography Specifications:**

| Element | Figma Spec | Status |
|---------|-----------|--------|
| Title "Meu perfil" | Font: Plus Jakarta Sans<br>Size: 20px<br>Weight: 600<br>Color: White | To be verified |

**Layout:**
- Height: ~56px (standard app bar)
- Padding: Horizontal 16-24px
- Icon size: 24x24px
- Title centered or left-aligned (needs verification)

**Status:** To be implemented

### 2. Profile Header Section

**Figma Structure:**
- Profile photo: Circular avatar
- User name: Displayed below or next to photo
- Optional edit button/icon

**Profile Photo Specifications:**
- **Size:** 80x80px
- **Shape:** Circle
- **Border:** Optional border (color TBD)
- **Position:** Centered horizontally
- **Placeholder:** Initials or default avatar icon if no photo

**User Name Display:**
- **Font:** Plus Jakarta Sans (estimated)
- **Size:** 18-20px
- **Weight:** 600 (semibold)
- **Color:** White (#FFFFFF)
- **Position:** Below profile photo, centered

**Status:** To be implemented

### 3. Tab Navigation

**Figma Structure:**
Three tabs with equal width distribution:
1. **Meu plano** - Subscription/plan information
2. **Perfil** - Personal information and account details
3. **Preferências** - Settings and preferences

**Tab Specifications:**

| Property | Inactive Tab | Active Tab |
|----------|-------------|------------|
| Background | Transparent | Primary color (#1B6FFF) |
| Text Color | #DFDFE0 (gray) | White (#FFFFFF) |
| Font Size | 14-16px | 14-16px |
| Font Weight | 500 | 600 |
| Border Radius | 12px | 12px |
| Height | 40-48px | 40-48px |

**Tab Container:**
- **Background:** #2D3245 (dark container)
- **Border Radius:** 12px
- **Padding:** 4px (around tabs)
- **Layout:** Horizontal equal distribution

**Status:** ✅ Similar component exists in home screen (can be reused)

### 4. Tab Content Areas

#### 4.1 "Meu plano" Tab (Subscription/Plan)

**Expected Content:**
- Current plan status (Free/Premium/Pro)
- Plan features list
- Upgrade/manage subscription button
- Billing information (if applicable)
- Plan expiration date

**Status:** Not fully visible in screenshot - needs further review

**Typical Layout:**
```dart
Column(
  children: [
    // Plan status card
    Container(
      decoration: BoxDecoration(
        color: Color(0xFF2D3245),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Plan name
          // Plan features
          // CTA button
        ],
      ),
    ),
  ],
)
```

#### 4.2 "Perfil" Tab (Personal Information)

**Figma Shows:**
Form fields with masked/censored personal data for privacy:

| Field Label | Example Value | Data Type |
|-------------|---------------|-----------|
| Nome completo | "Sofia ********" | Text (partially masked) |
| Apelido / Como prefere ser chamado | "Sofia" | Text |
| E-mail | "sofia@*****.com" | Email (partially masked) |
| Telefone | "(11) 9****-****" | Phone (masked) |
| CPF | "***.456.789-**" | CPF (masked) |
| Data de nascimento | "**/**/1990" | Date (partially masked) |

**Field Specifications:**

**Field Container:**
- **Background:** #2D3245 (dark input background)
- **Border Radius:** 12px
- **Padding:** 16px vertical, 16px horizontal
- **Spacing between fields:** 16px

**Label Typography:**
- **Font:** General Sans (estimated)
- **Size:** 12px
- **Weight:** 400
- **Color:** #DFDFE0 (light gray)
- **Position:** Above input value

**Value Typography:**
- **Font:** Plus Jakarta Sans (estimated)
- **Size:** 16px
- **Weight:** 500
- **Color:** #FFFFFF (white)
- **Masked values:** Same color as normal values

**Edit Interaction:**
- Edit icon (pencil) on right side of each field
- Tapping field or icon enables editing mode
- Fields become editable text inputs

**Security Notice:**

At bottom of form:
```
🔒 Seus dados estão protegidos e serão usados apenas para personalização.
```

**Security Notice Specifications:**
- **Icon:** Lock icon (🔒 or custom SVG)
- **Icon Size:** 16x16px
- **Icon Color:** #BADBC1 (teal/green) or #DFDFE0 (gray)
- **Text Font:** General Sans
- **Text Size:** 12px
- **Text Weight:** 400
- **Text Color:** #DFDFE0
- **Background:** Optional light background (#2D3245 or transparent)
- **Padding:** 12px
- **Border Radius:** 8px

**Status:** To be implemented - form components can be adapted from signup/login forms

#### 4.3 "Preferências" Tab (Settings/Preferences)

**Expected Content:**
- Notification settings
- Privacy settings
- Display preferences (already forced dark theme)
- Language settings (Portuguese)
- Biometric authentication toggle
- Data export/download options
- Account deletion

**Status:** Not fully visible in screenshot - needs further review

**Typical Preference Item Layout:**
```dart
ListTile(
  title: Text('Setting Name'),
  subtitle: Text('Setting description'),
  trailing: Switch(value: true, onChanged: (val) {}),
)
```

**Color for Switches/Toggles:**
- **Active:** #1B6FFF (primary blue) or #BADBC1 (teal)
- **Inactive:** #7C7C83 (gray)

## Typography Verification

### Screen Title
- **"Meu perfil":** 20px, weight 600, color white

### Tab Labels
- **Tab text:** 14-16px, weight 500/600 (when selected)

### Form Fields
- **Field labels:** 12px, weight 400, color #DFDFE0
- **Field values:** 16px, weight 500, color white
- **Masked characters:** Same as normal values with asterisks (*)

### Profile Name
- **User name:** 18-20px, weight 600, color white

### Security Notice
- **Notice text:** 12px, weight 400, color #DFDFE0

## Color Verification

### Backgrounds
- **Tab container:** #2D3245 ✅ (consistent with other screens)
- **Input fields:** #2D3245 ✅ (consistent with signup/login)
- **Active tab:** Primary color ⚠️ (needs color fix #1B6FFF)
- **Screen background:** App gradient (#252532 → #030D2C) ✅

### Text Colors
- **Primary text (white):** #FFFFFF ✅
- **Secondary text (labels):** #DFDFE0 ✅
- **Masked text:** #FFFFFF (same as normal) ✅

### Interactive Elements
- **Active tab:** Primary color ⚠️ **ISSUE:** Will use wrong blue (#4B68FF) instead of #1B6FFF
- **Edit icons:** Likely #BADBC1 (teal) or white
- **Security lock icon:** #BADBC1 or #DFDFE0

## Layout & Spacing

### Screen Padding
- **Horizontal padding:** 24px (FinSizes.defaultSpace)
- **Top padding:** 16px (below header)
- **Bottom padding:** 24px

### Component Spacing
- **Header to profile photo:** 24px
- **Profile photo to tabs:** 24px
- **Tabs to content:** 24px
- **Between form fields:** 16px
- **Between sections:** 32px

### Profile Photo
- **Size:** 80x80px
- **Alignment:** Center horizontal
- **Margin bottom:** 12px

### Form Fields
- **Field height:** ~56px (with padding)
- **Border radius:** 12px
- **Internal padding:** 16px

## Issues Found

### 1. Primary Button/Tab Color (Same as All Screens)
**Severity:** Medium

**Issue:** Active tab will use wrong primary color
- **Current:** #4B68FF (from `FinColors.primary`)
- **Figma:** #1B6FFF

**Impact:** Active "Perfil" tab indicator shows wrong blue

**Fix:** Same as previous screens - update `colors.dart:13,37`

### 2. Font Family (Project-wide Issue)
**Severity:** Medium

**Issue:** App uses DMSans, Figma specifies Plus Jakarta Sans and General Sans

**Impact:** Typography rendering differs from design

**Status:** Project-wide decision needed

### 3. Data Masking Implementation
**Severity:** Low

**Issue:** Personal data masking/censoring logic needs implementation

**Recommendation:**
```dart
String maskEmail(String email) {
  final parts = email.split('@');
  if (parts.length != 2) return email;
  final username = parts[0];
  final domain = parts[1];
  final maskedUsername = username.length > 2
      ? '${username[0]}${'*' * (username.length - 2)}${username[username.length - 1]}'
      : username;
  return '$maskedUsername@*****.$domain';
}

String maskCPF(String cpf) {
  // Format: ***.456.789-**
  if (cpf.length != 11) return cpf;
  return '***${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-**';
}

String maskPhone(String phone) {
  // Format: (11) 9****-****
  return phone.replaceAllMapped(
    RegExp(r'\((\d{2})\) (\d)(\d{4})-(\d{4})'),
    (match) => '(${match[1]}) ${match[2]}****-****',
  );
}

String maskName(String name) {
  final parts = name.split(' ');
  if (parts.isEmpty) return name;
  return '${parts[0]} ${'*' * 8}';  // Keep first name, mask rest
}
```

### 4. Profile Photo Upload
**Severity:** Low

**Issue:** Profile photo upload/change functionality needs implementation

**Recommendation:**
- Use image_picker package for photo selection
- Implement camera/gallery options
- Add photo cropping functionality
- Store in Supabase storage or backend

```yaml
dependencies:
  image_picker: ^1.0.5
  image_cropper: ^5.0.0
```

### 5. Edit Mode vs View Mode
**Severity:** Low

**Issue:** Fields need toggle between view (masked) and edit (unmasked) modes

**Recommendation:**
```dart
class ProfileField extends StatefulWidget {
  final String label;
  final String value;
  final bool shouldMask;
  final Function(String) onSave;

  // Toggle between view mode (masked) and edit mode (editable)
}
```

## Implementation Status

### Existing Components That Can Be Reused

1. ✅ **Tab Navigation** - Similar to `portfolio_section.dart` tabs
2. ✅ **Input Fields** - Can adapt `custom_text_field.dart` from signup/login
3. ✅ **App Background** - Same gradient as other screens
4. ✅ **Header Pattern** - Similar to other screen headers

### New Components Needed

1. ❌ **Profile Photo Widget** with edit functionality
2. ❌ **Masked Text Field** - View/edit mode toggle
3. ❌ **Security Notice Widget** - Lock icon + text
4. ❌ **Profile Tab Content Widgets** - For each tab
5. ❌ **Data Masking Utilities** - Email, CPF, phone, name masking functions

### Backend Integration Needed

1. **Profile Data API**
   - GET `/user/profile` - Fetch user profile data
   - PUT `/user/profile` - Update profile information
   - POST `/user/profile/photo` - Upload profile photo

2. **Subscription API** (for "Meu plano" tab)
   - GET `/user/subscription` - Fetch current plan
   - POST `/subscription/upgrade` - Upgrade plan

3. **Preferences API** (for "Preferências" tab)
   - GET `/user/preferences` - Fetch user settings
   - PUT `/user/preferences` - Update settings

## Data Model

### User Profile
```dart
class UserProfile {
  final String id;
  final String fullName;
  final String? nickname;
  final String email;
  final String? phone;
  final String cpf;
  final DateTime? birthDate;
  final String? profilePhotoUrl;

  UserProfile({
    required this.id,
    required this.fullName,
    this.nickname,
    required this.email,
    this.phone,
    required this.cpf,
    this.birthDate,
    this.profilePhotoUrl,
  });

  // For display (masked version)
  String get maskedEmail => _maskEmail(email);
  String get maskedCPF => _maskCPF(cpf);
  String get maskedPhone => phone != null ? _maskPhone(phone!) : '';
  String get maskedName => _maskName(fullName);

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['full_name'],
      nickname: json['nickname'],
      email: json['email'],
      phone: json['phone'],
      cpf: json['cpf'],
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'])
          : null,
      profilePhotoUrl: json['profile_photo_url'],
    );
  }
}
```

### User Preferences
```dart
class UserPreferences {
  final bool notificationsEnabled;
  final bool emailNotifications;
  final bool pushNotifications;
  final bool biometricAuthEnabled;
  final String language;  // 'pt-BR'
  final bool marketingEmails;

  UserPreferences({
    required this.notificationsEnabled,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.biometricAuthEnabled,
    this.language = 'pt-BR',
    this.marketingEmails = false,
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      notificationsEnabled: json['notifications_enabled'] ?? true,
      emailNotifications: json['email_notifications'] ?? true,
      pushNotifications: json['push_notifications'] ?? true,
      biometricAuthEnabled: json['biometric_auth_enabled'] ?? false,
      language: json['language'] ?? 'pt-BR',
      marketingEmails: json['marketing_emails'] ?? false,
    );
  }
}
```

### Subscription Plan
```dart
class SubscriptionPlan {
  final String planType;  // 'free', 'premium', 'pro'
  final bool isActive;
  final DateTime? expiresAt;
  final List<String> features;

  SubscriptionPlan({
    required this.planType,
    required this.isActive,
    this.expiresAt,
    required this.features,
  });

  bool get isPremium => planType == 'premium' || planType == 'pro';
  bool get isExpired => expiresAt != null && expiresAt!.isBefore(DateTime.now());

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      planType: json['plan_type'] ?? 'free',
      isActive: json['is_active'] ?? true,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'])
          : null,
      features: List<String>.from(json['features'] ?? []),
    );
  }
}
```

## Files to Create

### 1. Profile Screen Files
```
lib/screens/perfil/
├── perfil_screen.dart              # Main profile screen with tabs
├── perfil_controller.dart          # GetX controller for state management
└── widgets/
    ├── profile_header.dart         # Profile photo + name
    ├── profile_tabs.dart           # Tab navigation
    ├── meu_plano_tab.dart          # Subscription/plan tab content
    ├── perfil_tab.dart             # Personal info tab content
    ├── preferencias_tab.dart       # Settings/preferences tab content
    ├── profile_field.dart          # Reusable masked field widget
    └── security_notice.dart        # Lock icon + security message
```

### 2. Utility Files
```
lib/utils/
├── helpers/
│   ├── data_masking.dart           # Email, CPF, phone masking functions
│   └── image_helper.dart           # Profile photo picker/cropper
└── validators/
    └── profile_validators.dart     # Validation for profile fields
```

### 3. Service Files
```
lib/services/
├── profile_service.dart            # Profile API calls
├── subscription_service.dart       # Subscription API calls
└── preferences_service.dart        # Preferences API calls
```

## Controller Structure

```dart
class PerfilController extends GetxController {
  final RxInt selectedTabIndex = 1.obs;  // 0: Meu plano, 1: Perfil, 2: Preferências
  final Rx<UserProfile?> userProfile = Rx<UserProfile?>(null);
  final Rx<SubscriptionPlan?> subscription = Rx<SubscriptionPlan?>(null);
  final Rx<UserPreferences?> preferences = Rx<UserPreferences?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isEditMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchSubscription();
    fetchPreferences();
  }

  Future<void> fetchUserProfile() async {
    // Fetch from backend
  }

  Future<void> updateProfile(UserProfile updatedProfile) async {
    // Update via API
  }

  Future<void> uploadProfilePhoto(File photo) async {
    // Upload to storage
  }

  void selectTab(int index) {
    selectedTabIndex.value = index;
  }

  void toggleEditMode() {
    isEditMode.value = !isEditMode.value;
  }
}
```

## Keyboard Variants in Screenshot

The Figma screenshot shows multiple keyboard input states, suggesting:
1. Text input keyboard for name/nickname fields
2. Email keyboard for email field
3. Phone number keyboard for phone field
4. Date picker for birth date field

**Implementation:** Use appropriate `TextInputType` for each field:
```dart
TextFormField(
  keyboardType: TextInputType.emailAddress,  // For email
  keyboardType: TextInputType.phone,         // For phone
  keyboardType: TextInputType.name,          // For name
)
```

## Accessibility Considerations

1. **Profile Photo:**
   - Alt text: "Profile photo of [user name]"
   - Edit button: "Change profile photo"

2. **Form Fields:**
   - Each field should have semantic labels
   - Masked values should announce as "protected" or "private"

3. **Security Notice:**
   - Should be read by screen readers
   - Lock icon should have semantic meaning

4. **Tabs:**
   - Announce current tab selection
   - Support keyboard navigation

```dart
Semantics(
  label: 'Profile photo. Tap to change',
  button: true,
  child: GestureDetector(...),
)
```

## Next Steps

1. **Create profile screen structure** with three-tab layout
2. **Implement data masking utilities** for email, CPF, phone, name
3. **Build profile field widgets** with view/edit mode toggle
4. **Add profile photo picker** with camera/gallery options
5. **Integrate with backend APIs** for profile data
6. **Implement subscription tab** (Meu plano)
7. **Implement preferences tab** (Preferências)
8. **Add form validation** for editable fields
9. **Test data privacy** - ensure sensitive data is properly masked
10. **Add loading states** and error handling

## Notes

- Profile screen follows consistent design patterns from other screens ✅
- Three-tab structure provides clear organization of profile-related content
- Data masking is critical for privacy - should mask by default, unmask only when editing
- Profile photo adds personalization - important UX feature
- Security notice builds trust and transparency
- Similar tab component to home screen can be reused/adapted
- Same color and font issues as other screens (button color, font family)
- Backend integration will be needed for all three tabs
- Consider caching profile data locally for offline viewing
- Edit mode should validate changes before saving
- Profile updates should reflect in SessionManager immediately

## Related Documentation

- `figma-review-home.md` - Similar tab navigation pattern
- `figma-review-signup.md` - Form field patterns and validation
- `figma-review-login.md` - Input field styling
- `figma-color-verification.md` - Color palette reference
- `plan.md` - Phase 7 covers Perfil implementation

## Screen Variants Observed

From the Figma screenshot, multiple variants visible:
1. **perfil-meu-plano-tab** - Subscription/plan information
2. **perfil-perfil-tab** - Personal information (main focus)
3. **perfil-preferencias-tab** - Settings and preferences
4. **Various keyboard states** - Text, email, phone, date inputs
5. **Edit states** - Fields in editable mode

All variants share the same header, profile photo section, and tab navigation structure.
