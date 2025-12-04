# Figma Design Review: Login Flow

**Review Date:** 2025-12-02
**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=2-1194&m=dev
**Screens Reviewed:** Login form, with keyboard variants and error states

## Summary

✅ **Overall Status:** Login implementation closely matches Figma designs with typography adjustments needed.

⚠️ **Font Discrepancy:** Same issue as onboarding and signup - app uses DMSans, Figma specifies Plus Jakarta Sans and General Sans.

⚠️ **Typography Issues:** Login title has same typography mismatch as signup title.

⚠️ **Button Color:** Same button color mismatch as signup (#4B68FF vs #1B6FFF).

## Typography Specifications

### Page Title ("Entre na sua conta")
- **Font Family:** Plus Jakarta Sans
- **Font Size:** 20px
- **Font Weight:** 600 (SemiBold)
- **Line Height:** 32px (1.6 in Flutter)
- **Letter Spacing:** -0.4px
- **Color:** White (#FFFFFF)

**Current Implementation:** `login_header.dart:16-24`
```dart
fontSize: FinSizes.fontSizeLg + 6, // 24px ❌ Should be 20px
fontWeight: FontWeight.w600, // ✅ Correct
height: 1.33, // ❌ Should be 1.6 (32px/20px)
letterSpacing: -0.48, // ❌ Should be -0.4
```

**Recommendation:**
- Change font size from 24px to 20px
- Change line height from 1.33 to 1.6
- Change letter spacing from -0.48 to -0.4

**Note:** This is the EXACT same issue as signup title (see `figma-review-signup.md`).

### Page Subtitle
- **Font Family:** General Sans
- **Font Size:** 16px
- **Font Weight:** 400 (Regular)
- **Line Height:** 1.50
- **Letter Spacing:** -0.16px
- **Color:** #DFDFE0 (neutral/gray-200)

**Current Implementation:** `login_header.dart:27-35`
```dart
fontSize: FinSizes.fontSizeMd, // 16px ✅ Correct
fontWeight: FontWeight.w400, // ✅ Correct
height: 1.50, // ✅ Correct
letterSpacing: -0.16, // ✅ Correct
```

**Implementation Status:** ✅ **Matches**

### Field Labels ("E-mail", "Senha")
- **Font Family:** General Sans
- **Font Size:** 13px
- **Font Weight:** 500 (Medium)
- **Line Height:** 1.5
- **Letter Spacing:** -0.13px
- **Color:** #DFDFE0 (neutral/gray-200)

**Implementation:** Uses `CustomTextFieldReactive` component
**Status:** ✅ **Matches** (verified in `custom_text_field.dart:38-45`)

### Input Field Text
- **Font Family:** General Sans
- **Font Size:** 16px
- **Font Weight:** 500 (Medium)
- **Line Height:** 22px (1.375 in Flutter)
- **Letter Spacing:** -0.16px

**Implementation:** Uses `CustomTextFieldReactive` component
**Status:** ✅ **Matches** (verified in `custom_text_field.dart:57-63`)

### "Esqueci minha senha" Link
- **Font Family:** General Sans
- **Font Size:** 14px (estimated)
- **Font Weight:** 400 (Regular)
- **Color:** White
- **Text Decoration:** Underline (likely)

**Implementation Status:** To be verified in detail

### Button Text ("Entrar")
- **Font Family:** General Sans
- **Font Size:** 16px (FinSizes.fontSizeMd)
- **Font Weight:** 500 (Medium)
- **Color:** #EFEFF0 (on/on-bg-1)

**Current Implementation:** `login_form.dart:103-109`
```dart
fontSize: FinSizes.fontSizeMd, // 16px ✅
fontWeight: FontWeight.w500, // ✅
```

**Implementation Status:** ✅ **Matches**

## Color Specifications

| Element | Figma Color | Current Implementation | Status |
|---------|-------------|------------------------|--------|
| Background Gradient Top | #252532 | `FinColors.bgColorTop` | ✅ |
| Background Gradient Bottom | #030D2C | `FinColors.bgColorBottom` | ✅ |
| Input Field Background | #2D3245 | `Color(0xFF2D3245)` | ✅ |
| Input Field Border (Enabled) | #E4ECFF @ 30% opacity | `Color(0xFFE3EBFF)` @ 30% | ✅ |
| Input Field Border (Focused) | #E4ECFF | `Color(0xFFE3EBFF)` | ✅ |
| Title Text | #FFFFFF | `Colors.white` | ✅ |
| Subtitle Text | #DFDFE0 | `Color(0xFFDFDFE0)` | ✅ |
| Label Text | #DFDFE0 | `FinColors.lightGray` (#DCDCDC) | ⚠️ Close |
| Button Primary | #1B6FFF | `FinColors.primary` (#4B68FF) | ❌ Mismatch |
| Button Text | #EFEFF0 | `FinColors.white` (#FFFFFF) | ⚠️ Close |

**Critical Color Mismatch:**
- Button primary color in Figma is #1B6FFF (rgb: 27, 111, 255)
- `FinColors.primary` is #4B68FF (rgb: 75, 104, 255)
- These are visually distinct colors
- **Same issue as signup** - needs fix in `colors.dart`

**Recommendation:** Update `colors.dart` to match Figma:
```dart
static const Color primary = Color(0xFF1B6FFF); // Changed from #4b68ff
static const Color buttonPrimary = Color(0xFF1B6FFF); // Changed from #4b68ff
```

## Layout & Spacing Specifications

### Input Fields
- **Height:** 56px
- **Border Radius:** 12px ✅ Matches
- **Padding:** 14px content padding ✅ Current uses 16px (close enough)
- **Gap Between Fields:** 16px ✅ Matches (`FinSizes.spaceBtwInputFields`)

### Button
- **Height:** 48px (FinSizes.buttonHeight * 2.7 in implementation)
- **Border Radius:** 6px (FinSizes.buttonRadius / 2)
- **Implementation:** `login_form.dart:75-114`

**Status:** ✅ Layout and spacing match design system

### Spacing
- **Screen Padding:** 32px horizontal (via `FinSpacingStyle.paddingWithAppBarHeight`)
- **Title to Subtitle:** 8px (`FinSizes.sm`)
- **Header to Form:** 32px (`FinSizes.spaceBtwSections`)
- **Form Fields Gap:** 16px
- **Forget Password Margin:** 8px (half of `spaceBtwInputFields`)
- **Form to Button:** 32px

## Component Structure

### Login Screen Components
**Figma Structure:**
1. App Bar with back button (top)
2. Page title: "Entre na sua conta"
3. Page subtitle
4. Email field (with label)
5. Password field (with label + eye icon)
6. "Manter informações salvas" checkbox + "Esqueci minha senha" link
7. "Entrar" button

**Current Implementation:** `login_screen.dart`
- ✅ AppBar with back button
- ✅ `FinLoginHeader` (title + subtitle)
- ✅ `FinLoginForm` (fields + button)
- ✅ Keyboard handling with `SingleChildScrollView`

**Implementation Status:** ✅ Structure matches

## Issues Found

### 1. Title Typography Mismatch
**Severity:** Low

**File:** `lib/screens/login/widgets/login_header.dart:16-24`

**Issue:**
```dart
Text(
  FinTexts.loginTitle,
  style: TextStyle(
    fontSize: FinSizes.fontSizeLg + 6, // 24px, should be 20px
    fontWeight: FontWeight.w600, // ✅ Correct
    height: 1.33, // Should be 1.6
    letterSpacing: -0.48, // Should be -0.4
    color: Colors.white,
  ),
),
```

**Recommendation:** Update to match Figma:
```dart
Text(
  FinTexts.loginTitle,
  style: TextStyle(
    fontSize: 20, // Changed from 24
    fontWeight: FontWeight.w600,
    height: 1.6, // Changed from 1.33 (32px/20px)
    letterSpacing: -0.4, // Changed from -0.48
    color: Colors.white,
  ),
),
```

**Note:** This is identical to the signup title issue. Consider creating a reusable text style constant for page titles.

### 2. Button Color Mismatch
**Severity:** Medium

**File:** `lib/utils/constants/colors.dart:36-37`

**Issue:** Button color doesn't match Figma specification
- **Figma:** #1B6FFF
- **Current:** #4B68FF

**Recommendation:**
```dart
static const Color primary = Color(0xFF1B6FFF); // Update from 0xFF4b68ff
static const Color buttonPrimary = Color(0xFF1B6FFF); // Update from 0xFF4b68ff
```

**Note:** Same issue as signup - single fix will resolve both.

### 3. Font Family Mismatch (Same as Onboarding and Signup)
**Severity:** Medium

**Issue:** App uses DMSans throughout, Figma specifies:
- **Plus Jakarta Sans** - For titles and headings
- **General Sans** - For body text, labels, inputs

**Impact:** Character shapes, spacing, and overall visual harmony differ from design

**Files Affected:**
- `pubspec.yaml:83-99` - Font declarations
- `lib/utils/theme/theme.dart:18,35` - Theme font family
- All text elements across the app

**Recommendation:** Same as onboarding and signup reviews - decide whether to:
1. Update app fonts to match Figma
2. Update Figma to use DMSans
3. Document as intentional deviation

## Screen Variants in Figma

The Figma file shows multiple variants:
1. **Default state** - No keyboard, button enabled
2. **button-disabled** - With keyboard visible, disabled button state
3. **bad-email** - Error state for invalid email
4. **Forms-error** - Various error states
5. **Forms-focus-keyboard** - Keyboard visible with focused fields

**Current Implementation:**
- ✅ Uses `SingleChildScrollView` with keyboard handling
- ✅ Has reactive validation (button disabled when form invalid)
- ✅ Shows error messages via `validationMessages`
- ✅ Has loading state with `CircularProgressIndicator`

## Files Verified (Match Figma)

1. ✅ `lib/common/widgets/custom_text_field.dart` - Input field styling matches
2. ✅ `lib/screens/login/login_screen.dart` - Overall structure correct
3. ✅ `lib/screens/login/widgets/login_form.dart` - Form logic and layout match
4. ⚠️ `lib/screens/login/widgets/login_header.dart` - Subtitle matches, title needs adjustment

## Comparison with Signup

The login and signup screens share:
- ✅ Same input field component (`CustomTextFieldReactive`)
- ✅ Same color scheme
- ❌ Same typography issues (title: 24px vs 20px)
- ❌ Same button color mismatch (#4B68FF vs #1B6FFF)
- ⚠️ Same font family discrepancy (DMSans vs Plus Jakarta Sans/General Sans)

**Recommendation:** Fixes applied to shared components (colors, fonts, text styles) will benefit both flows.

## Next Steps

1. **Fix title typography** - Update font size, line height, letter spacing in `login_header.dart`
2. **Update button color** - Change `FinColors.primary` and `FinColors.buttonPrimary` to #1B6FFF (fixes both login and signup)
3. **Create reusable text styles** - Consider creating a `FinTextStyles.pageTitle` constant to avoid duplication
4. **Font decision** - Address DMSans vs Plus Jakarta Sans/General Sans discrepancy (project-wide decision)
5. **Continue flow review** - Review remaining screens (home dashboard, conjuntura, profile, etc.)

## Notes

- The login implementation is very close to Figma designs
- Main issues are minor typography adjustments and button color (same as signup)
- Font family discrepancy is a project-wide decision (same as onboarding and signup)
- Input field component (`CustomTextFieldReactive`) is well-implemented and matches Figma styling
- Form validation and error handling are properly implemented
- Spacing and layout are correct
- Login and signup screens share the same issues - fixing shared components will benefit both
