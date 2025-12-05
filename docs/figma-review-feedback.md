# Figma Design Review: Feedback Flow

**Review Date:** 2025-12-04
**Figma URL:** https://www.figma.com/design/9NT1VLOeG3ye4eymwOxLa1/Dark-Theme---Full?node-id=267-74388&m=dev
**Screens Reviewed:** 4-screen feedback flow (rating, focus areas, comments, success)

## Summary

The feedback flow consists of 4 screens that collect user feedback:
1. **Rating Screen** - Star rating with greeting
2. **Focus Areas Screen** - Multi-select checkboxes
3. **Comments Screen** - Text input for additional feedback
4. **Success Screen** - Thank you confirmation

---

## Screen 1: Rating Screen

### Layout
- Status bar at top
- Back arrow (left) navigation
- Progress indicator (3 steps, first highlighted)
- Greeting with user name
- 5-star rating system
- "Ruim" and "Ótimo" labels at extremes
- Primary button at bottom

### Typography

#### Greeting Title ("Olá, Lucas! Gostaríamos de saber sua opinião sobre o nosso aplicativo.")
- **Font Size:** 20px (estimated)
- **Font Weight:** 600 (SemiBold)
- **Color:** White (#FFFFFF)
- **Line Height:** ~28px

#### Subtitle ("Sua opinião é muito importante para tornar sua experiência com o Finovate cada vez melhor.")
- **Font Size:** 14px
- **Font Weight:** 400 (Regular)
- **Color:** #DFDFE0 (neutral/gray-200)
- **Line Height:** ~20px

#### Rating Labels ("Ruim", "Ótimo")
- **Font Size:** 12px
- **Font Weight:** 400 (Regular)
- **Color:** #9A9A9A (light gray)

### Components

#### Progress Indicator
- 3 rounded rectangles
- Active step: Blue (#1B6FFF)
- Inactive steps: Dark gray (#3D4255)
- Height: 6px
- Corner radius: 3px
- Gap between steps: 8px

#### Star Rating
- 5 stars in a row
- Unselected: Outlined star, light gray
- Selected: Filled star, gold (#FFD700)
- Star size: ~40px
- Spacing: 8px between stars

#### Primary Button ("Próxima pergunta →")
- Background: Blue (#1B6FFF)
- Text: White
- Height: 56px
- Corner radius: 12px
- Arrow icon on right

### Interactions
- Tapping a star selects it and all stars before it
- Button disabled until at least one star selected
- First button always disabled per annotation (need at least 1 star)

---

## Screen 2: Focus Areas Screen

### Layout
- Status bar at top
- Back arrow (left) and forward arrow (right) navigation
- Progress indicator (3 steps, second highlighted)
- Question title
- Scrollable list of checkbox options
- Primary button at bottom

### Typography

#### Question Title ("Em quais aspectos você acha que devemos focar?")
- **Font Size:** 20px
- **Font Weight:** 600 (SemiBold)
- **Color:** White (#FFFFFF)
- **Line Height:** ~28px

#### Checkbox Label
- **Font Size:** 16px
- **Font Weight:** 500 (Medium)
- **Color:** White (#FFFFFF) when unselected
- **Color:** Blue (#1B6FFF) when selected

### Components

#### Progress Indicator
- Same as Screen 1
- Second step active

#### Checkbox Items
Available options from Figma:
1. Aprimoramento de gráficos
2. Navegação
3. Criptoativos
4. Imposto de renda
5. Análises sobre seu portfólio
6. IA
7. Mercado internacional
8. Notícias

#### Checkbox Card
- Background: #2D3245 (unselected), #1B6FFF10 (selected - 10% blue)
- Border: None (unselected), 2px #1B6FFF (selected)
- Height: 56px
- Corner radius: 12px
- Padding: 16px horizontal
- Gap between items: 12px

#### Checkbox Icon
- Unselected: Empty square with border (#7C7C83), 18x18px
- Selected: Filled blue square with white checkmark, 24x24px
- Position: Right side of card

### Interactions
- Multiple selection allowed
- Tapping card toggles selection
- Button enabled when at least one item selected

---

## Screen 3: Comments Screen

### Layout
- Status bar at top
- Back arrow navigation
- Progress indicator (3 steps, third highlighted)
- Question title and subtitle
- Large text input area
- Primary button at bottom

### Typography

#### Question Title ("Há algo mais que deseja falar? Nos conte!")
- **Font Size:** 20px
- **Font Weight:** 600 (SemiBold)
- **Color:** White (#FFFFFF)
- **Line Height:** ~28px

#### Input Placeholder
- **Font Size:** 16px
- **Font Weight:** 400 (Regular)
- **Color:** #7C7C83 (placeholder gray)

### Components

#### Progress Indicator
- Same as previous screens
- Third step active

#### Text Input Area
- Background: #2D3245
- Corner radius: 12px
- Height: ~160px (expandable)
- Padding: 16px
- Border: None (unfocused), 2px #1B6FFF (focused)
- Placeholder: "I" cursor visible

#### Primary Button ("Finalizar feedback")
- Background: Blue (#1B6FFF)
- Text: White
- Height: 56px
- Corner radius: 12px

### Interactions
- Text input is optional (per annotation)
- Button always enabled on this screen
- Keyboard appears when input focused

### Designer Notes (from annotations)
- "Não adicione a caixa de texto aqui por dois motivos:"
  1. "Já há bastante informação nesta etapa, e uma caixa adicional poderia causar a sensação de excesso"
  2. "Na próxima tela, já existe uma caixa de texto livre para o usuário"
- "Combine 'Sugestão de melhoria' e 'Primeiro qualquer outro feedback' em uma única caixa de texto para simplificar a experiência"

---

## Screen 4: Success Screen

### Layout
- Status bar at top
- No navigation arrows (final screen)
- Finovate logo/icon centered
- Success message
- Toast notification at bottom

### Typography

#### Toast Message ("Obrigado pelo feedback!")
- **Font Size:** 14px
- **Font Weight:** 500 (Medium)
- **Color:** White (#FFFFFF)

### Components

#### Logo/Icon
- Finovate "X" logo
- Blue gradient colors
- Size: ~100x100px
- Centered horizontally and vertically

#### Toast Notification
- Background: Semi-transparent dark
- Border: 1px light border
- Corner radius: 8px
- X close button on right
- Position: Bottom of screen
- Auto-dismiss after delay

### Designer Notes (from annotations)
- "A ideia é retornar automaticamente para a tela anterior, agradecendo pelo feedback, enquanto o usuário mantém o controle para fechar a interação quando desejar."

---

## Color Palette

| Element | Color | Hex |
|---------|-------|-----|
| Primary Blue | Button, selected states | #1B6FFF |
| Background Dark | Card background | #2D3245 |
| Star Gold | Selected stars | #FFD700 |
| Text Primary | White text | #FFFFFF |
| Text Secondary | Subtitle, labels | #DFDFE0 |
| Placeholder | Input placeholder | #7C7C83 |
| Progress Inactive | Unselected steps | #3D4255 |
| Selected Border | Selected checkbox | #1B6FFF |
| Selected Background | 10% opacity blue | #1B6FFF10 |

---

## Implementation Files

### Created Files
```
lib/screens/feedback/
├── feedback_controller.dart     # State management for 4-step flow
├── feedback_screen.dart         # Main screen with step navigation
└── widgets/
    ├── rating_step.dart         # Screen 1: Star rating
    ├── focus_areas_step.dart    # Screen 2: Checkbox selection
    ├── comments_step.dart       # Screen 3: Text input
    └── success_step.dart        # Screen 4: Thank you
```

### Routes
- Route constant: `AppRoutes.feedback = '/feedback'`
- Registered in: `main.dart`

---

## Implementation Checklist

### Screen 1: Rating Step
- [x] Greeting with user's first name from session
- [x] 5-star rating system
- [x] "Ruim" and "Ótimo" labels
- [x] Continue button (disabled until rating selected)
- [x] Progress indicator (3 steps)
- [x] Navigation arrows (close on first step, back arrow on others)
- [x] Updated text to match Figma

### Screen 2: Focus Areas Step
- [x] Question title
- [x] Multi-select checkbox list
- [x] Checkbox styling (selected/unselected with animated transitions)
- [x] Continue/Back buttons
- [x] Progress indicator
- [x] Focus area options match Figma (8 options)

### Screen 3: Comments Step
- [x] Question title
- [x] Text input area
- [x] Submit/Back buttons
- [x] Progress indicator
- [x] Input styling

### Screen 4: Success Step
- [x] Finovate branded logo with custom painter
- [x] Animated logo appearance (scale + fade)
- [x] Toast notification with slide animation
- [x] Auto-dismiss toast after 4 seconds
- [x] Tap to return functionality

---

## Completed Updates (2025-12-04)

All discrepancies from the initial review have been resolved:

### Focus Areas List ✅
Updated `feedback_controller.dart` to match all 8 Figma options:
1. Aprimoramento de gráficos
2. Navegação
3. Criptoativos
4. Imposto de renda
5. Análises sobre seu portfólio
6. IA
7. Mercado internacional
8. Notícias

### Progress Indicator ✅
- Created `FeedbackProgressIndicator` widget
- Added to all 3 input screens (rating, focus areas, comments)
- 3-step bar with active state highlighting (#1B6FFF)

### Navigation Arrows ✅
- Close button on first step
- Back arrow (iOS style) on steps 2 and 3
- Forward arrow appears when can proceed on steps 1 and 2

### Success Screen ✅
- Custom `_FinovateLogoPainter` draws the branded X logo
- Animated appearance with scale and fade effects
- Toast notification slides up from bottom
- Auto-dismisses after 4 seconds
- Tap anywhere to return to previous screen

### Checkbox Styling ✅
- Selected background: 10% opacity blue (#1B6FFF10)
- Selected border: 2px blue (#1B6FFF)
- Animated transitions between states
- Checkbox on right side matching Figma layout
