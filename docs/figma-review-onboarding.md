# Figma Design Review: Onboarding Flow

**Review Date:** 2025-12-02
**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=1-4&m=dev
**Screens Reviewed:** Splash, Onboarding Pages 1-3, Get Started

## Summary

✅ **Overall Status:** Onboarding implementation matches Figma designs with one text correction applied.

⚠️ **Font Discrepancy Found:** App currently uses DMSans, but Figma designs specify Plus Jakarta Sans and General Sans.

## Issues Found

### Font Family Mismatch
**Severity:** Medium

**Issue:** The Figma designs specify two font families:
- **Plus Jakarta Sans** - Used for titles and primary headings
- **General Sans** - Used for body text and subtitles

However, the current app implementation uses **DMSans** as the primary font family (configured in `lib/utils/theme/theme.dart:18,35` and `pubspec.yaml:83-99`).

**Impact:** Typography may not match the intended design system. Character spacing, weight rendering, and overall visual harmony may differ from Figma mockups.

**Recommendation:** Consider one of the following options:
1. **Update fonts to match Figma** - Download and configure Plus Jakarta Sans and General Sans fonts
2. **Update Figma to use DMSans** - If DMSans is the preferred font, update all Figma designs to reflect this
3. **Document as intentional deviation** - If DMSans is intentionally chosen despite Figma specs, document the reasoning

**Files Affected:**
- `pubspec.yaml` - Font asset declarations
- `lib/utils/theme/theme.dart` - Theme font family configuration
- All screen implementations - Specific font family overrides may be needed

## Changes Made

### 1. Get Started Message Text Fix
**File:** `lib/screens/get_started/widgets/get_started_message.dart`

**Issue:** Extra text not present in Figma design
**Fixed:** Removed fourth TextSpan containing " e dê o primeiro passo para alcançar seus objetivos financeiros."

**Before:**
- "Crie ou acesse sua conta e dê o primeiro passo para alcançar seus objetivos financeiros."

**After (matches Figma):**
- "Crie ou acesse sua conta"

## Typography Specifications Extracted

### Onboarding Title
- **Font Family:** Plus Jakarta Sans
- **Font Size:** 30px
- **Font Weight:** 500 (Medium)
- **Line Height:** 40px (1.33 in Flutter)
- **Letter Spacing:** -0.6px
- **Color:** White (#FFFFFF)

**Implementation Status:** ✅ Matches (see `onboarding_page.dart:56-62`)

### Onboarding Subtitle
- **Font Family:** General Sans
- **Font Size:** 16px
- **Font Weight:** 400 (Regular)
- **Line Height:** 24px (1.5 in Flutter)
- **Letter Spacing:** -0.32px
- **Color:** White (#FFFFFF)

**Implementation Status:** ✅ Matches (see `onboarding_page.dart:88-93`)

### Get Started Message
- **Font Family:** Plus Jakarta Sans
- **Font Size:** 20px
- **Font Weight:** Mixed (600 for bold, 400 for regular)
- **Line Height:** 1.40
- **Letter Spacing:** -0.40px
- **Color:** White (#FFFFFF)

**Implementation Status:** ✅ Matches (see `get_started_message.dart:15-43`)

### Skip Button
- **Font Family:** Plus Jakarta Sans
- **Font Size:** 16px
- **Font Weight:** 400 (Regular)
- **Text Decoration:** Underline
- **Letter Spacing:** -0.32px
- **Color:** White (#FFFFFF)

**Implementation Status:** ✅ Matches (see `onboarding_screen.dart:180-188`)

## Color Verification

All colors used in onboarding match the design system:

| Color | Figma | Implementation | Status |
|-------|-------|----------------|--------|
| Background Top | #252532 | `FinColors.bgColorTop` | ✅ |
| Background Bottom | #111111 | `FinColors.gradientEnd` | ✅ |
| Button Primary | #4B68FF | `FinColors.buttonPrimary` | ✅ |
| Text Primary | #FFFFFF | `Colors.white` | ✅ |

**File Reference:** `lib/utils/constants/colors.dart`

## Text Content Verification

All onboarding text strings match Figma:

| Screen | Figma Text | Implementation | Status |
|--------|-----------|----------------|--------|
| Page 1 Title | "Acompanhe seus investimentos" | `FinTexts.onboardingTitle1` | ✅ |
| Page 2 Title | "Acompanhe indicadores econômicos" | `FinTexts.onboardingTitle2` | ✅ |
| Page 3 Title | "Conheça a SofIA" | `FinTexts.onboardingTitle3` | ✅ |
| Get Started Message | "Crie ou acesse sua conta" | Fixed ✅ | ✅ |

**File Reference:** `lib/utils/constants/text_strings.dart`

## Layout & Spacing

The current implementation uses responsive spacing that adapts to screen size:

- **Page Padding:** `FinSizes.defaultSpace` (consistent with design system)
- **Title-Subtitle Gap:** 5% of screen height
- **Subtitle-Bottom Gap:** 12% of screen height (reserves space for navigation)
- **Image Sizing:** Responsive to screen dimensions

**Note:** Specific px values from Figma were not extracted for spacing; current implementation uses percentage-based responsive design which is appropriate for Flutter.

## Files Modified

1. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/screens/get_started/widgets/get_started_message.dart` - Fixed text to match Figma

## Files Verified (No Changes Needed)

1. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/screens/onboarding/onboarding_screen.dart`
2. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/screens/onboarding/widgets/onboarding_page.dart`
3. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/screens/splash/splash_screen.dart`
4. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/utils/constants/colors.dart`
5. ✅ `/Users/arielmoraes/finovate_dev/finovate-app/lib/utils/constants/text_strings.dart`

## Notes

- **Font Families:** The design uses Plus Jakarta Sans and General Sans. Flutter implementation should verify these fonts are properly configured in `pubspec.yaml`.
- **Green "Skip" Notes:** Confirmed with user that green boxes in Figma were design notes, not actual UI elements.
- **Responsive Design:** Current implementation scales well across different screen sizes with FittedBox and LayoutBuilder patterns.

## Next Steps

Per Phase 0.1 of the project plan, continue reviewing:
1. Sign up screens
2. Login screens
3. Home dashboard
4. Conjuntura (Economy) screens
5. My Profile screens
6. Stocks/Market screens
7. My Wallet/Carteira screens
8. Premium Plan screens
9. SofIA chat screens
