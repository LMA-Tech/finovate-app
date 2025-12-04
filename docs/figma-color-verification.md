# Figma Color Palette Verification

**Review Date:** 2025-12-02
**Source:** Colors extracted from Figma designs (Onboarding, Signup, Login screens)
**Implementation File:** `lib/utils/constants/colors.dart`

## Summary

⚠️ **Critical Issue Found:** The correct primary blue color (#1B6FFF) exists in `colors.dart` as `FinColors.blue`, but the app is using incorrect values in `FinColors.primary` and `FinColors.buttonPrimary`.

✅ **Background colors match** Figma specifications
⚠️ **Primary/button colors need correction** - simple fix available

## Color Verification Results

### 1. Primary Brand Colors

| Color Name | Usage | Figma Spec | colors.dart | Status | Notes |
|------------|-------|------------|-------------|--------|-------|
| Primary Blue | Buttons, CTAs | #1B6FFF | `blue`: #1B6FFF ✅<br>`primary`: #1355FF ❌<br>`buttonPrimary`: #4B68FF ❌ | ⚠️ **CONFLICT** | Correct color exists as `blue` but wrong values used in `primary` and `buttonPrimary` |
| Cyan | Accents | Not specified | `cyan`: #00C9FF | - | Not yet verified in Figma |
| Royal Blue | - | Not specified | `royalBlue`: #1559CC | - | Not yet verified in Figma |
| Navy | - | Not specified | `navy`: #0D377F | - | Not yet verified in Figma |
| Dark Navy | - | Not specified | `darkNavy`: #071735 | - | Not yet verified in Figma |
| Secondary | - | Not specified | `secondary`: #FFE24B | - | Not yet verified in Figma |
| Accent | - | Not specified | `accent`: #b0c7ff | - | Not yet verified in Figma |

**Critical Finding:**
- `FinColors.blue` = #1B6FFF ✅ **CORRECT** - matches Figma exactly
- `FinColors.primary` = #1355FF ❌ **WRONG** - should be #1B6FFF
- `FinColors.buttonPrimary` = #4B68FF ❌ **WRONG** - should be #1B6FFF

**Impact:** Buttons and primary UI elements throughout the app are using the wrong blue color.

**Recommendation:**
```dart
// OPTION 1: Update existing values (breaking change if used elsewhere)
static const Color primary = Color(0xFF1B6FFF);        // Update from 0xFF1355FF
static const Color buttonPrimary = Color(0xFF1B6FFF);  // Update from 0xFF4b68ff

// OPTION 2: Alias to existing correct value (safer)
static const Color primary = blue;                     // Reuse correct value
static const Color buttonPrimary = blue;               // Reuse correct value
```

### 2. Background Colors

| Color Name | Usage | Figma Spec | colors.dart | Status | Files Verified |
|------------|-------|------------|-------------|--------|----------------|
| Background Top | Gradient start | #252532 | `bgColorTop`: #252532<br>`gradientStart`: #252532 | ✅ **MATCH** | Onboarding, Signup, Login |
| Background Bottom (Dark) | Gradient end | #030D2C | `bgColorBottom`: #030D2C | ✅ **MATCH** | Signup, Login |
| Background Bottom (Light) | Gradient end | #111111 | `gradientEnd`: #111111 | ✅ **MATCH** | Onboarding |
| Dark Background | - | - | `dark`: #272727 | - | Not yet verified |
| Light Background | - | - | `light`: #F6F6F6 | - | Not yet verified |

**Status:** ✅ All verified background colors match Figma specifications.

**Note:** App uses different gradient endings for different screens:
- **Onboarding:** #252532 → #111111
- **Signup/Login:** #252532 → #030D2C

### 3. Text Colors

| Color Name | Usage | Figma Spec | colors.dart | Status | Files Verified |
|------------|-------|------------|-------------|--------|----------------|
| White Text | Titles, headings | #FFFFFF | `white`: #FFFFFF<br>`textWhite`: #FFFFFF | ✅ **MATCH** | All screens |
| Gray 200 | Labels, subtitles | #DFDFE0 | `lightGray`: #DCDCDC | ⚠️ **CLOSE** | Signup, Login labels |
| Gray 100 | Checkbox labels | #EFEFF0 | `neutralGray`: #EFEFF0 | ✅ **MATCH** | Signup checkboxes |
| Primary Text | - | - | `textPrimary`: #333333 | - | Not yet verified |
| Secondary Text | - | - | `textSecondary`: #6C757D | - | Not yet verified |

**Finding:**
- `lightGray` (#DCDCDC) is very close to Figma's gray-200 (#DFDFE0) but not exact
- Difference: 3 RGB units (#DCDCDC vs #DFDFE0) - visually imperceptible
- Consider updating for pixel-perfect accuracy

**Recommendation:**
```dart
static const Color lightGray = Color(0xFFDFDFE0);  // Update from 0xFFDCDCDC (closer to Figma gray-200)
```

### 4. Input Field Colors

| Element | Usage | Figma Spec | Implementation | Status | Location |
|---------|-------|------------|----------------|--------|----------|
| Input Background | Text fields | #2D3245 | Hardcoded in widget | ✅ **MATCH** | `custom_text_field.dart` |
| Input Border (Normal) | Text field outline | #E4ECFF @ 30% opacity | `Color(0xFFE3EBFF).withOpacity(0.3)` | ✅ **MATCH** | `custom_text_field.dart` |
| Input Border (Focused) | Active field outline | #E4ECFF | `Color(0xFFE3EBFF)` | ✅ **MATCH** | `custom_text_field.dart` |
| Input Text | User input | #E4ECFF or White | `FinColors.white` | ⚠️ **VARIES** | See note below |

**Note:** Input field colors are hardcoded in `custom_text_field.dart` rather than using `colors.dart` constants. Consider adding these to `colors.dart` for consistency:

```dart
// Input field colors
static const Color inputBackground = Color(0xFF2D3245);
static const Color inputBorder = Color(0xFFE3EBFF);
static const Color inputText = Color(0xFFE4ECFF);
```

### 5. Button Colors

| Color Name | Usage | Figma Spec | colors.dart | Status | Impact |
|------------|-------|------------|-------------|--------|--------|
| Button Primary | All primary buttons | #1B6FFF | `buttonPrimary`: #4B68FF | ❌ **WRONG** | High - affects all CTAs |
| Button Secondary | - | - | `buttonSecondary`: #6C757D | - | Not yet verified |
| Button Disabled | Inactive buttons | - | `buttonDisabled`: #C4C4C4` | - | Not yet verified |
| Button Text | Text on buttons | #EFEFF0 | `white`: #FFFFFF | ⚠️ **CLOSE** | Low - barely visible difference |

**Critical:** Button primary color is incorrect throughout the app. See Primary Brand Colors section above for fix.

### 6. Border Colors

| Color Name | colors.dart | Status |
|------------|-------------|--------|
| Border Primary | `borderPrimary`: #D9D9D9 | Not yet verified in Figma |
| Border Secondary | `borderSecondary`: #E6E6E6 | Not yet verified in Figma |

### 7. Error & Validation Colors

| Color Name | colors.dart | Status |
|------------|-------------|--------|
| Error | `error`: #D32F2F | Not yet verified in Figma |
| Success | `success`: #388E3C | Not yet verified in Figma |
| Warning | `warning`: #F57C00 | Not yet verified in Figma |
| Info | `info`: #1976D2 | Not yet verified in Figma |

**Note:** These colors appear in Figma's error states but need detailed verification.

### 8. Neutral Shades

| Color Name | colors.dart | Status |
|------------|-------------|--------|
| Black | `black`: #232323 | Not yet verified |
| Neutral Gray | `neutralGray`: #EFEFF0 | ✅ Matches gray-100 |
| Darker Grey | `darkerGrey`: #4F4F4F | Not yet verified |
| Dark Grey | `darkGrey`: #939393 | Not yet verified |
| Grey | `grey`: #E0E0E0 | Not yet verified |
| Soft Grey | `softGrey`: #F4F4F4 | Not yet verified |
| Light Grey | `lightGrey`: #F9F9F9 | Not yet verified |
| White | `white`: #FFFFFF | ✅ Verified |

## Issues Summary

### High Priority

1. **Button/Primary Color Mismatch (Critical)**
   - **Issue:** `buttonPrimary` (#4B68FF) and `primary` (#1355FF) don't match Figma (#1B6FFF)
   - **Correct value exists:** `FinColors.blue` = #1B6FFF
   - **Impact:** All buttons and primary UI elements use wrong color
   - **Files affected:** All screens with buttons (login, signup, onboarding)
   - **Fix:** Update `colors.dart` lines 13 and 37

### Medium Priority

2. **Input Field Colors Hardcoded**
   - **Issue:** Colors are hardcoded in `custom_text_field.dart` instead of using constants
   - **Impact:** Difficult to maintain consistency, harder to update globally
   - **Recommendation:** Add input field colors to `colors.dart`

3. **Label Color Close But Not Exact**
   - **Issue:** `lightGray` (#DCDCDC) vs Figma gray-200 (#DFDFE0)
   - **Impact:** Low - 3 RGB unit difference, visually imperceptible
   - **Recommendation:** Update for pixel-perfect accuracy

### Low Priority

4. **Button Text Color**
   - **Issue:** Using white (#FFFFFF) instead of #EFEFF0
   - **Impact:** Minimal - barely visible difference
   - **Recommendation:** Add `buttonTextColor` constant if pixel-perfect accuracy needed

## Recommendations

### Immediate Actions (colors.dart:13, 37)

```dart
// Line 13: Update primary color
static const Color primary = Color(0xFF1B6FFF);  // Changed from 0xFF1355FF

// Line 37: Update button primary color
static const Color buttonPrimary = Color(0xFF1B6FFF);  // Changed from 0xFF4b68ff
```

**OR** (safer approach - reuse existing correct value):

```dart
// Line 13: Alias to correct blue
static const Color primary = blue;  // Reuse correct #1B6FFF

// Line 37: Alias to correct blue
static const Color buttonPrimary = blue;  // Reuse correct #1B6FFF
```

### Additional Improvements

1. **Add Input Field Colors**
```dart
// Input field colors (currently hardcoded in custom_text_field.dart)
static const Color inputBackground = Color(0xFF2D3245);
static const Color inputBorder = Color(0xFFE3EBFF);
static const Color inputBorderActive = inputBorder;  // Same color
static const Color inputText = Color(0xFFE4ECFF);
```

2. **Add Figma-Specific Color Aliases**
```dart
// Figma design system colors (for reference)
static const Color gray100 = Color(0xFFEFEFF0);  // Neutral-gray-100
static const Color gray200 = Color(0xFFDFDFE0);  // Neutral-gray-200
static const Color primaryLighter = Color(0xFFE4ECFF);  // Brand-primary-lighter
```

3. **Update Close-But-Not-Exact Colors**
```dart
// Line 5: Update to match Figma gray-200
static const Color lightGray = Color(0xFFDFDFE0);  // Changed from 0xFFDCDCDC
```

## Color Usage Consistency

### Colors Verified Across Multiple Screens

| Color | Onboarding | Signup | Login | Status |
|-------|------------|--------|-------|--------|
| Background Gradient Top | ✅ | ✅ | ✅ | Consistent |
| Background Gradient Bottom | ✅ (#111111) | ✅ (#030D2C) | ✅ (#030D2C) | **Intentionally Different** |
| Button Primary | ✅ | ❌ (#4B68FF) | ❌ (#4B68FF) | **Needs Fix** |
| Input Background | N/A | ✅ | ✅ | Consistent |
| Input Border | N/A | ✅ | ✅ | Consistent |
| White Text | ✅ | ✅ | ✅ | Consistent |
| Label Gray | N/A | ⚠️ Close | ⚠️ Close | Minor adjustment |

## Files Referencing Colors

Based on Figma reviews, these files reference colors from `colors.dart`:

1. `lib/common/widgets/custom_text_field.dart` - Input field colors (some hardcoded)
2. `lib/screens/onboarding/widgets/onboarding_page.dart` - Background, text colors
3. `lib/screens/signup/widgets/signup_form_email_password.dart` - Background, text, button colors
4. `lib/screens/login/widgets/login_header.dart` - Text colors
5. `lib/screens/login/widgets/login_form.dart` - Button, text colors
6. `lib/common/widgets/app_background.dart` - Background gradient colors
7. `lib/utils/theme/theme.dart` - Global theme colors

## Next Steps

1. ✅ **Critical:** Fix `primary` and `buttonPrimary` colors in `colors.dart`
2. **Test:** Verify button colors across all screens after fix
3. **Optional:** Add input field color constants to `colors.dart`
4. **Optional:** Update `lightGray` to match Figma gray-200 exactly
5. **Continue:** Verify remaining colors when more Figma screens are reviewed (home, conjuntura, profile, etc.)

## Notes

- The fact that `FinColors.blue` already has the correct value (#1B6FFF) suggests this was known at some point
- Someone may have added the correct color but forgot to update usages in `primary` and `buttonPrimary`
- This makes the fix straightforward - either update the values or alias to the existing correct `blue` constant
- Most background and input colors are correctly implemented
- The primary issue is specifically with button/primary colors
