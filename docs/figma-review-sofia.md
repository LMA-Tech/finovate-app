# Figma Design Review: SofIA AI Chat Screens

**Review Date:** 2025-12-02
**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=250-5578
**Screens Reviewed:** SofIA AI chat interface (welcome, chat conversation, frequent questions)

## Summary

✅ **Overall Status:** SofIA implementation has good structure but differs significantly from Figma designs in layout and component styling.

⚠️ **Layout Differences:** Action cards layout differs (vertical vs horizontal grid in Figma)

⚠️ **Typography:** Greeting text size needs adjustment to match Figma

⚠️ **Button Colors:** Same primary color issue as other screens (#4B68FF vs #1B6FFF)

⚠️ **Missing Features:** Frequent questions modal/screen not implemented

## Screen Variants in Figma

The Figma canvas shows 6 screen variants:

1. **Initial welcome screen** - "Olá {user's first name}, como posso ajudar?" with suggested prompts
2. **Chat conversation screen** - Messages with user/AI bubbles
3. **Frequent questions screen** - "Perguntas frequentes" with Q&A list
4. **Selected choice screen** - After user selects a frequent question
5. **Keyboard variants** - Input field with keyboard visible
6. **Upgrade prompt variant** - "Mensagens diárias limitadas no Plano Gratuito" banner

## 1. Welcome Screen (Initial State)

### Figma Structure

**AppBar:**
- Back button (left)
- Title: "SofIA" (centered)
- Menu button (right, more_vert icon)

**Content:**
- Greeting: "Olá Lucas," (line 1)
- Question: "como posso ajudar?" (line 2)
- 4 suggestion cards/buttons in 2x2 grid:
  - Top left: File icon + "Projeções de taxas de juros"
  - Top right: Check icon + "Explicação de conjuntura brasileira"
  - Bottom left: Building icon + "Empresas"
  - Bottom right: Question icon + "Perguntas frequentes"

**Bottom Section:**
- Input field: "Converse com SofIA"
- Blue circular send button with arrow icon
- Disclaimer: "A {Nome IA} pode cometer erros. Verifique as respostas."

### Current Implementation

**File:** `sofia_home_screen.dart`

**AppBar:** ✅ Matches structure
```dart
// sofia_home_screen.dart:52-70
AppBar(
  leading: IconButton(...), // Back button ✅
  centerTitle: true,
  title: null, // ⚠️ Missing "SofIA" title
  actions: [
    IconButton(icon: Icons.more_vert), // Menu button ✅
  ],
)
```

**Greeting Section:** ⚠️ Needs adjustment
```dart
// welcome_section.dart:78-100
Text(
  style: TextStyle(
    fontSize: FinSizes.fontSizeXXLg + 4, // ~30px
    fontWeight: FontWeight.w600,
    height: 1.2,
  ),
)
Text(
  FinTexts.sofiaGreetingQuestion, // "como posso ajudar?"
  style: TextStyle(
    fontSize: FinSizes.fontSizeXXLg + 4, // ~30px
    fontWeight: FontWeight.w600,
    height: 1.2,
  ),
)
```

**Action Cards:** ❌ Layout differs
- **Implementation:** Vertical list (action_cards.dart:107-126)
- **Figma:** 2x2 grid layout
- **Recommendation:** Create grid layout with `GridView` or `Wrap` widget

**Input Field:** ✅ Component exists (chat_input.dart)

## Typography Specifications

### App Bar Title ("SofIA")
- **Font Family:** General Sans (assumed)
- **Font Size:** 16-18px (estimated)
- **Font Weight:** 500-600 (Medium/SemiBold)
- **Color:** White (#FFFFFF)
- **Status:** ❌ **Missing** - title is null in implementation

### Greeting Text ("Olá Lucas,")
- **Font Family:** Plus Jakarta Sans
- **Font Size:** 28-32px (estimated from visual inspection)
- **Font Weight:** 600 (SemiBold)
- **Line Height:** 1.2-1.3
- **Color:** White (#FFFFFF)

**Current Implementation:** `welcome_section.dart:78-86`
```dart
fontSize: FinSizes.fontSizeXXLg + 4, // ~30px
fontWeight: FontWeight.w600, // ✅ Correct
height: 1.2, // ✅ Correct
```

**Status:** ✅ **Close enough** - size appears reasonable

### Action Card Text
- **Font Family:** General Sans
- **Font Size:** 13-14px
- **Font Weight:** 500 (Medium)
- **Color:** White (#FFFFFF or #DFDFE0)

**Current Implementation:** `action_cards.dart:74-84`
```dart
Text(
  text,
  style: TextStyle(
    fontSize: FinSizes.fontSizeMd, // 16px ⚠️ Slightly large
    fontWeight: FontWeight.w500, // ✅ Correct
    height: 1.4,
  ),
  maxLines: 3,
)
```

**Recommendation:** Reduce font size to 13-14px

### Input Field Placeholder
- **Font Family:** General Sans
- **Font Size:** 16px
- **Font Weight:** 400 (Regular)
- **Color:** White @ 60% opacity
- **Text:** "Qual sua dúvida?" (Figma) vs "Converse com {nome da IA}" (visible in some variants)

**Current Implementation:** `chat_input.dart:122-127`
```dart
hintText: widget.hintText, // FinTexts.sofiaChatInputHint
hintStyle: TextStyle(
  color: Colors.white.withOpacity(0.6), // ✅ Correct
  fontSize: FinSizes.fontSizeMd, // 16px ✅ Correct
  fontWeight: FontWeight.w400, // ✅ Correct
)
```

**Status:** ✅ **Matches**

### Disclaimer Text
- **Font Family:** General Sans
- **Font Size:** 12px (estimated)
- **Font Weight:** 400 (Regular)
- **Color:** #DFDFE0 or similar light gray
- **Text:** "A {Nome IA} pode cometer erros. Verifique as respostas."

**Status:** ❌ **Not implemented** in current version

## Color Specifications

| Element | Figma Color | Current Implementation | Status |
|---------|-------------|------------------------|--------|
| Background Gradient Top | #252532 | `FinColors.bgColorTop` | ✅ |
| Background Gradient Bottom | #030D2C | `FinColors.bgColorBottom` | ✅ |
| App Bar Background | Transparent | `Colors.transparent` | ✅ |
| Greeting Text | #FFFFFF | `Colors.white` | ✅ |
| Action Card Background | #2D3245 | `Color(0xFF2D3245)` | ✅ |
| Action Card Border | White @ 10% | `Colors.white.withOpacity(0.1)` | ✅ |
| Action Card Text | #FFFFFF | `Colors.white` | ✅ |
| Input Field Background | #2D3245 or similar | `Color(0xFF2D3245)` | ✅ |
| Input Field Border | White @ 20% | `Colors.white.withOpacity(0.2)` | ✅ |
| Input Field Focus Border | #1B6FFF | `FinColors.primary` (#4B68FF) | ❌ |
| Send Button | #1B6FFF | `FinColors.primary` (#4B68FF) | ❌ |
| Send Button Disabled | #1B6FFF @ 30% | `FinColors.primary.withOpacity(0.3)` | ⚠️ |
| Disclaimer Text | #DFDFE0 | Not implemented | - |

**Critical Issues:**
- Send button uses wrong blue (#4B68FF instead of #1B6FFF)
- Same primary color issue as all other screens

## 2. Chat Conversation Screen

### Figma Structure

**AppBar:**
- Back button
- Title: "SofIA"
- Close button (X icon)

**Content:**
- Message bubbles alternating between user (right) and AI (left)
- User messages: Blue background (#1B6FFF)
- AI messages: Dark background (#2D3245 or similar)
- Timestamps visible on messages
- Optional upgrade banner at top: "Mensagens diárias limitadas no Plano Gratuito" + "Upgrade" button

**Bottom Section:**
- Same input field + send button as welcome screen
- Disclaimer text below input

### Current Implementation

**File:** `sofia_chat_screen.dart`

**Note:** Current implementation is labeled as "Backend Chat Test" and appears to be a work-in-progress integration test version.

**Message Bubbles:** ✅ Basic structure matches
```dart
// sofia_chat_screen.dart:113-173
Container(
  margin: const EdgeInsets.only(bottom: FinSizes.md),
  padding: const EdgeInsets.all(FinSizes.md),
  constraints: BoxConstraints(maxWidth: Get.width * 0.75),
  decoration: BoxDecoration(
    color: message.isUser
        ? FinColors.primary // ⚠️ Wrong blue
        : const Color(0xFF2D3245), // ✅ Correct
    borderRadius: BorderRadius.circular(FinSizes.borderRadiusLg),
  ),
)
```

**Status:** ⚠️ Implementation exists but uses wrong primary color

**Upgrade Banner:** ❌ Not implemented

## 3. Frequent Questions Screen

### Figma Structure

**AppBar:**
- Back button
- Title: "Perguntas frequentes" (centered)
- Close button (X icon)

**Content:**
- Banner: "Mensagens diárias limitadas no Plano Gratuito" + "Upgrade" button
- List of question options:
  - "O que é tesouro direto?"
  - "Qual o melhor investimento para iniciantes?"
  - "Como funcionam as ações?"
  - "Qual sua dúvida?" (custom input option)
  - (More questions...)

**Bottom Section:**
- Same input field + disclaimer as other screens

### Current Implementation

**Status:** ❌ **Not implemented**

**Recommendation:** Create new screen `frequent_questions_screen.dart` with:
- AppBar with back button and close button
- ListView of question cards
- Bottom input field
- Optional upgrade banner component

## Layout & Spacing Specifications

### Action Cards Grid (From Figma)

**Layout Type:** 2x2 Grid

**Card Dimensions:**
- Width: ~45% of screen width (allowing for spacing)
- Height: ~80-100px (estimated)
- Gap between cards: 12-16px

**Current Implementation:** Vertical list (full width cards)

**Recommendation:**
```dart
GridView.count(
  crossAxisCount: 2,
  mainAxisSpacing: FinSizes.md,
  crossAxisSpacing: FinSizes.md,
  childAspectRatio: 1.5, // Adjust for card proportions
  children: _buildActionCards(),
)
```

### Input Field Container

**From Figma:**
- Background: #2D3245 or similar dark
- Padding: 12-16px all sides
- Top border: White @ 10% opacity, 1px width

**Current Implementation:** `chat_input.dart:87-97`
```dart
Container(
  padding: const EdgeInsets.all(FinSizes.md), // 16px ✅
  decoration: BoxDecoration(
    color: const Color(0xFF2D3245), // ✅ Matches
    border: Border(
      top: BorderSide(
        color: Colors.white.withOpacity(0.1), // ✅ Matches
        width: 0.5, // ⚠️ Figma shows 1px
      ),
    ),
  ),
)
```

**Status:** ✅ **Very close**, minor border width adjustment

### Send Button

**From Figma:**
- Shape: Circle
- Size: 44x44px (estimated)
- Background: #1B6FFF (primary blue)
- Icon: Arrow up, white
- Position: Right of input field

**Current Implementation:** `chat_input.dart:160-198`
```dart
Container(
  width: 44, // ✅ Correct
  height: 44, // ✅ Correct
  decoration: BoxDecoration(
    color: _canSend && widget.isEnabled && !widget.isLoading
        ? FinColors.primary // ⚠️ Wrong blue
        : FinColors.primary.withOpacity(0.3),
    shape: BoxShape.circle, // ✅ Correct
  ),
  child: Icon(
    Icons.arrow_upward, // ✅ Correct
    color: Colors.white,
    size: FinSizes.iconMd,
  ),
)
```

**Status:** ✅ **Structure correct**, ❌ **wrong color**

## Issues Found

### 1. Missing AppBar Title
**Severity:** Low

**File:** `sofia_home_screen.dart:62`

**Issue:** AppBar title is null, but Figma shows "SofIA" centered

**Current:**
```dart
AppBar(
  centerTitle: true,
  title: null, // ❌ Missing
)
```

**Recommendation:**
```dart
AppBar(
  centerTitle: true,
  title: const Text(
    'SofIA',
    style: TextStyle(
      color: Colors.white,
      fontSize: FinSizes.fontSizeLg,
      fontWeight: FontWeight.w600,
    ),
  ),
)
```

### 2. Action Cards Layout Mismatch
**Severity:** Medium

**File:** `welcome_section.dart:106-126`

**Issue:** Cards are arranged vertically (full width), Figma shows 2x2 grid

**Current:**
```dart
Column(
  children: _suggestions.map((suggestion) {
    return Padding(
      padding: const EdgeInsets.only(bottom: FinSizes.md),
      child: SizedBox(
        width: double.infinity, // Full width
        height: 100,
        child: ActionCard(...),
      ),
    );
  }).toList(),
)
```

**Recommendation:**
```dart
GridView.count(
  crossAxisCount: 2,
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  mainAxisSpacing: FinSizes.md,
  crossAxisSpacing: FinSizes.md,
  childAspectRatio: 1.5,
  children: _suggestions.map((suggestion) {
    return ActionCard(
      icon: suggestion['icon'] as IconData,
      text: suggestion['text'] as String,
      iconColor: suggestion['iconColor'] as Color,
      onTap: isLoading ? () {} : () => onSuggestionTap(suggestion['text'] as String),
    );
  }).toList(),
)
```

### 3. Action Card Text Size
**Severity:** Low

**File:** `action_cards.dart:74-84`

**Issue:** Font size slightly larger than Figma specification

**Current:**
```dart
Text(
  text,
  style: const TextStyle(
    fontSize: FinSizes.fontSizeMd, // 16px
    fontWeight: FontWeight.w500,
  ),
)
```

**Recommendation:**
```dart
Text(
  text,
  style: const TextStyle(
    fontSize: 13, // Reduced from 16px
    fontWeight: FontWeight.w500,
  ),
)
```

### 4. Button/Input Focus Color Mismatch
**Severity:** Medium

**File:** `chat_input.dart:160-198`, `colors.dart:13,37`

**Issue:** Uses wrong primary blue (#4B68FF instead of #1B6FFF)

**Impact:**
- Send button color wrong
- Input field focus border color wrong

**Recommendation:** Same as all other screens - update `colors.dart` lines 13 and 37

### 5. Missing Disclaimer Text
**Severity:** Low

**Issue:** Disclaimer "A {Nome IA} pode cometer erros. Verifique as respostas." not shown below input

**Recommendation:** Add disclaimer text component below chat input
```dart
Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: FinSizes.md,
    vertical: FinSizes.sm,
  ),
  child: Text(
    'A SofIA pode cometer erros. Verifique as respostas.',
    style: TextStyle(
      color: Color(0xFFDFDFE0),
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    textAlign: TextAlign.center,
  ),
)
```

### 6. Frequent Questions Screen Not Implemented
**Severity:** Medium

**Issue:** "Perguntas frequentes" screen shown in Figma is not implemented

**Recommendation:** Create new screen with:
- AppBar: "Perguntas frequentes" title
- ListView of predefined questions
- Bottom input field
- Optional upgrade banner

**Suggested file:** `lib/screens/sofia/frequent_questions_screen.dart`

### 7. Upgrade Banner Not Implemented
**Severity:** Low

**Issue:** "Mensagens diárias limitadas no Plano Gratuito" + "Upgrade" button not implemented

**Recommendation:** Create reusable upgrade banner component
```dart
// lib/screens/sofia/widgets/upgrade_banner.dart
Container(
  padding: const EdgeInsets.all(FinSizes.md),
  decoration: BoxDecoration(
    color: Color(0xFF2D3245),
    borderRadius: BorderRadius.circular(FinSizes.borderRadiusMd),
  ),
  child: Row(
    children: [
      Expanded(
        child: Text(
          'Mensagens diárias limitadas no Plano Gratuito',
          style: TextStyle(
            color: Color(0xFFDFDFE0),
            fontSize: 13,
          ),
        ),
      ),
      ElevatedButton(
        onPressed: () {/* Navigate to upgrade */},
        child: Text('Upgrade'),
        style: ElevatedButton.styleFrom(
          backgroundColor: FinColors.primary,
        ),
      ),
    ],
  ),
)
```

### 8. Font Family Discrepancy (Same as All Screens)
**Severity:** Medium

**Issue:** App uses DMSans, Figma specifies Plus Jakarta Sans and General Sans

**Impact:** All typography rendering differs slightly from design

**Status:** Project-wide decision needed (see previous reviews)

## Component File Structure

### Existing Files ✅
1. `sofia_home_screen.dart` - Main welcome screen
2. `sofia_chat_screen.dart` - Chat conversation screen (test version)
3. `welcome_section.dart` - Greeting + action cards
4. `action_cards.dart` - Individual action card component
5. `chat_input.dart` - Input field + send button
6. `sofia_home_controller.dart` - Home screen state management
7. `sofia_chat_controller.dart` - Chat screen state management

### Missing Files ❌
1. `frequent_questions_screen.dart` - Q&A screen
2. `upgrade_banner.dart` - Premium upgrade prompt
3. `disclaimer_text.dart` - Warning text component (optional)

## Comparison with Figma Variants

### Welcome Screen (Initial)
- ✅ Greeting text structure matches
- ⚠️ Action cards layout differs (vertical vs grid)
- ❌ AppBar title missing
- ✅ Input field component exists
- ❌ Disclaimer text missing

### Chat Conversation
- ✅ Message bubble structure matches
- ⚠️ User message color wrong (#4B68FF vs #1B6FFF)
- ✅ AI message color correct
- ❌ Upgrade banner not implemented
- ✅ Timestamps shown
- ❌ Disclaimer text missing

### Frequent Questions
- ❌ Screen not implemented
- ❌ Question list not implemented
- ❌ Custom input option not implemented

### Keyboard Variants
- ✅ Input field handles keyboard properly with `SafeArea`
- ✅ ScrollController in chat screen for auto-scroll

## Next Steps

### High Priority
1. **Fix primary color** - Update `colors.dart` lines 13 and 37 to #1B6FFF
2. **Add AppBar title** - Show "SofIA" in app bar (`sofia_home_screen.dart:62`)
3. **Change action cards to grid layout** - 2x2 grid instead of vertical list (`welcome_section.dart:106-126`)

### Medium Priority
4. **Reduce action card text size** - Change from 16px to 13-14px (`action_cards.dart:76`)
5. **Add disclaimer text** - Below input field in all screens
6. **Implement frequent questions screen** - New screen with Q&A list
7. **Adjust input border width** - Change from 0.5 to 1.0 (`chat_input.dart:94`)

### Low Priority
8. **Add upgrade banner component** - For premium prompts
9. **Font family decision** - Address DMSans vs Plus Jakarta Sans/General Sans (project-wide)

## Files to Modify

### High Priority Updates
1. `lib/utils/constants/colors.dart:13,37` - Fix primary color
2. `lib/screens/sofia/sofia_home_screen.dart:62` - Add AppBar title
3. `lib/screens/sofia/widgets/welcome_section.dart:106-126` - Grid layout

### Medium Priority Updates
4. `lib/screens/sofia/widgets/action_cards.dart:76` - Text size
5. `lib/screens/sofia/widgets/chat_input.dart:87-202` - Add disclaimer wrapper
6. Create `lib/screens/sofia/frequent_questions_screen.dart` - New screen

### Low Priority Updates
7. Create `lib/screens/sofia/widgets/upgrade_banner.dart` - New component
8. `pubspec.yaml` - Font configuration (if needed)

## Notes

- SofIA implementation is functional but needs visual refinements to match Figma
- Core chat functionality is working (backend integration in progress)
- The "Backend Chat Test" label in `sofia_chat_screen.dart` suggests this is still under development
- Action cards have good component structure, just need layout change
- Input field component is well-implemented with proper state management
- Missing frequent questions feature is likely planned but not yet built
- Same primary color issue affects this screen as all others

## References

- Figma Design: https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=250-5578
- Related Reviews: `figma-color-verification.md`, `figma-review-home.md`
- Backend Integration: `finovate_api_service.dart`
