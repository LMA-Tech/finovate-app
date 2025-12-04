# Figma Design Review: Signup Flow

**Review Date:** 2025-12-02
**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=1-2998&m=dev
**Screens Reviewed:** Sign Up (Email/Password step), with keyboard variants

## Summary

✅ **Overall Status:** Signup implementation closely matches Figma designs with minor typography adjustments needed.

⚠️ **Font Discrepancy:** Same issue as onboarding - app uses DMSans, Figma specifies Plus Jakarta Sans and General Sans.

## Typography Specifications Extracted

### Page Title ("Criar conta Finovate")
- **Font Family:** Plus Jakarta Sans
- **Font Size:** 20px
- **Font Weight:** 600 (SemiBold)
- **Line Height:** 32px (1.6 in Flutter)
- **Letter Spacing:** -0.4px
- **Color:** White (#FFFFFF)

**Current Implementation:** `signup_form_email_password.dart:36-41`
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

### Field Labels ("E-mail", "Senha", "Confirmar senha")
- **Font Family:** General Sans
- **Font Size:** 13px
- **Font Weight:** 500 (Medium)
- **Line Height:** 1.5
- **Letter Spacing:** -0.13px
- **Color:** #DFDFE0 (neutral/gray-200)

**Implementation Status:** ✅ **Matches** (see `custom_text_field.dart:38-45`)

### Input Field Text
- **Font Family:** General Sans
- **Font Size:** 16px
- **Font Weight:** 500 (Medium)
- **Line Height:** 22px (1.375 in Flutter)
- **Letter Spacing:** -0.16px
- **Color:** #E4ECFF (brand/primary-lighter) when filled, white for input

**Current Implementation:** `custom_text_field.dart:57-63`
```dart
fontSize: 16, // ✅ Correct
fontWeight: FontWeight.w500, // ✅ Correct
height: 1.38, // ✅ Close (should be 1.375)
letterSpacing: -0.16, // ✅ Correct
```

**Implementation Status:** ✅ **Matches**

### Checkbox Label ("Manter informações salvas")
- **Font Family:** General Sans
- **Font Size:** 13px
- **Font Weight:** 500 (Medium)
- **Line Height:** 1.5
- **Letter Spacing:** -0.13px
- **Color:** #EFEFF0 (neutral/gray-100)

**Implementation Status:** Not verified (component not reviewed in detail)

### Privacy Disclaimer Text
- **Font Family:** General Sans
- **Font Size:** 14px
- **Font Weight:** 400 (Regular)
- **Line Height:** 18px (1.286 in Flutter)
- **Letter Spacing:** Not specified
- **Color:** #DFDFE0 (neutral/gray-200)

**Implementation Status:** To be verified in disclaimers.dart

### Button Text ("Continuar")
- **Font Family:** General Sans
- **Font Size:** 16px
- **Font Weight:** 500 (Medium)
- **Line Height:** 1.5
- **Letter Spacing:** Not specified
- **Color:** #EFEFF0 (on/on-bg-1)

**Implementation Status:** To be verified in signup_continue_button.dart

## Color Specifications

| Element | Figma Color | Current Implementation | Status |
|---------|-------------|------------------------|--------|
| Background Gradient Top | #252532 | `FinColors.bgColorTop` | ✅ |
| Background Gradient Bottom | #030D2C | `FinColors.bgColorBottom` | ✅ |
| Input Field Background | #2D3245 | `Color(0xFF2D3245)` | ✅ |
| Input Field Border (Enabled) | #E4ECFF @ 30% opacity | `Color(0xFFE3EBFF)` @ 30% | ✅ |
| Input Field Border (Focused) | #E4ECFF | `Color(0xFFE3EBFF)` | ✅ |
| Label Text | #DFDFE0 | `FinColors.lightGray` (#DCDCDC) | ⚠️ Close |
| Input Text (Filled) | #E4ECFF | `FinColors.white` | ⚠️ Different |
| Button Primary | #1B6FFF | `FinColors.buttonPrimary` (#4B68FF) | ❌ Mismatch |
| Privacy Text | #DFDFE0 | To be verified | - |
| Checkbox Label | #EFEFF0 | To be verified | - |
| Button Text | #EFEFF0 | To be verified | - |

**Critical Color Mismatch:**
- Button primary color in Figma is #1B6FFF (rgb: 27, 111, 255)
- `FinColors.buttonPrimary` is #4B68FF (rgb: 75, 104, 255)
- These are visually distinct colors

**Recommendation:** Update `colors.dart` to match Figma:
```dart
static const Color buttonPrimary = Color(0xFF1B6FFF); // Changed from #4b68ff
```

## Layout & Spacing Specifications

### Input Fields
- **Height:** 56px
- **Border Radius:** 12px ✅ Matches (`custom_text_field.dart:74`)
- **Padding:** 14px (content padding)
- **Current:** 16px ✅ Close enough
- **Gap Between Fields:** Not explicitly specified, current uses 16px ✅

### Button
- **Height:** 48px
- **Border Radius:** 6px (var(--border-radius-sm))
- **Padding:** 24px horizontal, 12px vertical
- **Gap (text to icon):** 8px

### Spacing (from frame analysis)
- **Screen Padding:** 32px horizontal (from edge to content)
- **Title to Fields:** 86px (from top:78px to top:164px)
- **Fields Container Height:** 321px total
- **Fields to Disclaimer:** 12px gap
- **Disclaimer to Button:** 16px gap
- **Button from Bottom:** Variable (654px from top in 844px screen)

## Component Structure

### Step 1: Email/Password Form
**Figma Node:** 1:4535 "step-1"

**Content Order:**
1. App Bar with back button (top)
2. Page title: "Criar conta Finovate" (centered, top: 78px)
3. Form fields container (top: 164px)
   - E-mail field (with label)
   - Senha field (with label + eye icon)
   - Confirmar senha field (with label + eye icon)
4. Checkbox + "Forgot password" text (opacity: 0 in Figma)
5. Privacy disclaimer text
6. Continue button with arrow

**Current Implementation:** Matches structure ✅

## Issues Found

### 1. Title Typography Mismatch
**Severity:** Low

**File:** `lib/screens/signup/widgets/signup_form_email_password.dart:34-42`

**Issue:**
```dart
const Text(
  FinTexts.signupTitle,
  style: TextStyle(
    fontSize: FinSizes.fontSizeLg + 6, // 24px, should be 20px
    fontWeight: FontWeight.w600, // ✅ Correct
    height: 1.33, // Should be 1.6
    letterSpacing: -0.48, // Should be -0.4
  ),
),
```

**Recommendation:** Update to match Figma:
```dart
const Text(
  FinTexts.signupTitle,
  style: TextStyle(
    fontSize: 20, // Changed from 24
    fontWeight: FontWeight.w600,
    height: 1.6, // Changed from 1.33 (32px/20px)
    letterSpacing: -0.4, // Changed from -0.48
  ),
),
```

### 2. Button Color Mismatch
**Severity:** Medium

**File:** `lib/utils/constants/colors.dart:37`

**Issue:** Button color doesn't match Figma specification
- **Figma:** #1B6FFF
- **Current:** #4B68FF

**Recommendation:**
```dart
static const Color buttonPrimary = Color(0xFF1B6FFF); // Update from 0xFF4b68ff
```

### 3. Font Family Mismatch (Same as Onboarding)
**Severity:** Medium

**Issue:** App uses DMSans throughout, Figma specifies:
- **Plus Jakarta Sans** - For titles and headings
- **General Sans** - For body text, labels, inputs

**Impact:** Character shapes, spacing, and overall visual harmony differ from design

**Files Affected:**
- `pubspec.yaml:83-99` - Font declarations
- `lib/utils/theme/theme.dart:18,35` - Theme font family
- All text elements across the app

**Recommendation:** Same as onboarding review - decide whether to:
1. Update app fonts to match Figma
2. Update Figma to use DMSans
3. Document as intentional deviation

## Files Verified (Match Figma)

1. ✅ `lib/common/widgets/custom_text_field.dart` - Input field styling matches well
2. ✅ `lib/screens/signup/signup_screen.dart` - Overall structure correct
3. ✅ `lib/screens/signup/widgets/signup_form_email_password.dart` - Layout matches (typography needs adjustment)

## Files Needing Verification

1. `lib/screens/signup/widgets/disclaimers.dart` - Privacy text styling
2. `lib/screens/signup/widgets/signup_continue_button.dart` - Button styling details
3. Other signup steps (name, personal info, verification, etc.)

## Screen Variants in Figma

The Figma file shows two variants:
1. **step-1** (1:4535) - Default state, no keyboard
2. **step-1-keyboard** (1:4995) - With keyboard visible, content repositioned

**Current Implementation:** Uses `SingleChildScrollView` with keyboard handling ✅

## Additional Screens in Figma

The signup canvas (1:2998) contains many more screens beyond step-1:
- Personal information steps
- Verification method selection
- OTP code entry
- Questionnaire screens
- Success/milestone screens

**Status:** Not reviewed in this document (would require separate review sessions)

## Next Steps

1. **Fix title typography** - Update font size, line height, letter spacing
2. **Update button color** - Change `FinColors.buttonPrimary` to #1B6FFF
3. **Review disclaimer component** - Verify privacy text matches Figma
4. **Review button component** - Verify button styling matches exactly
5. **Continue signup flow review** - Review remaining signup steps
6. **Font decision** - Address DMSans vs Plus Jakarta Sans/General Sans discrepancy

## Notes

- The signup implementation is very close to Figma designs
- Main issues are minor typography adjustments and button color
- Font family discrepancy is a project-wide decision (same as onboarding)
- Input field component (`CustomTextFieldReactive`) is well-implemented and matches Figma styling
- Spacing and layout are correct
