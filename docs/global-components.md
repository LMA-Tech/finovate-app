# Global Reusable Components

This document defines app-wide reusable components that appear across multiple screens and features.

---

## Info Bottom Sheet

**This component is used throughout the entire app wherever an info icon (ⓘ) or "O que é X?" link appears.**

### Purpose
Explain terms, concepts, or features to users in a simple, dismissible bottom sheet.

### Trigger Points
- Tapping (ⓘ) icon (e.g., next to "Variações" header, in screen headers)
- Tapping "O que é X?" links at bottom of lists
- Any other place where contextual help is needed

### Layout Structure
```
├── Title: Term name (e.g., "Taxa de desemprego")
└── Description: Plain text explanation
```

### Modal Style
- Background: Dark (#1A1A2E or #2D3245)
- Border radius (top): 16px
- Padding: 24px
- Dismiss: Tap outside or swipe down (no close button)

### Typography
| Element | Specification |
|---------|--------------|
| Title | Size: 18px, Weight: 600, Color: White |
| Description | Size: 14px, Weight: 400, Color: #DFDFE0, Line height: 1.5 |

### Content Examples

**Taxa de desemprego:**
> "Percentual da população que está procurando trabalho e não encontra."

**PIB:**
> "Soma de tudo que o país produz. Mostra se a economia está crescendo ou não."

**IGP-M:**
> "Outro índice de inflação, usado principalmente para reajuste de aluguéis."

### Implementation

```dart
// lib/common/widgets/info_bottom_sheet.dart

import 'package:flutter/material.dart';

/// Shows a simple info bottom sheet with title and description.
/// Use this anywhere in the app where (ⓘ) icon or "O que é X?" links appear.
void showInfoBottomSheet({
  required BuildContext context,
  required String title,
  required String description,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: const Color(0xFF1A1A2E),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFDFDFE0),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24), // Bottom safe area padding
        ],
      ),
    ),
  );
}
```

### Data Model

```dart
// lib/models/info_content.dart

class InfoContent {
  final String key;
  final String title;
  final String description;

  const InfoContent({
    required this.key,
    required this.title,
    required this.description,
  });
}

// Content can be stored in a central location or fetched from backend
class InfoContentRepository {
  static const Map<String, InfoContent> terms = {
    'taxa_desemprego': InfoContent(
      key: 'taxa_desemprego',
      title: 'Taxa de desemprego',
      description: 'Percentual da população que está procurando trabalho e não encontra.',
    ),
    'pib': InfoContent(
      key: 'pib',
      title: 'PIB',
      description: 'Soma de tudo que o país produz. Mostra se a economia está crescendo ou não.',
    ),
    'igpm': InfoContent(
      key: 'igpm',
      title: 'IGP-M',
      description: 'Outro índice de inflação, usado principalmente para reajuste de aluguéis.',
    ),
    'ipca': InfoContent(
      key: 'ipca',
      title: 'IPCA',
      description: 'Índice oficial de inflação do Brasil, medido pelo IBGE.',
    ),
    'variacoes': InfoContent(
      key: 'variacoes',
      title: 'Variações',
      description: 'YTD (Year to Date): Do início do ano até hoje.\n\n'
          'YoY (Year over Year): Comparação com o mesmo período do ano anterior.\n\n'
          'MoM (Month over Month): Comparação com o mês anterior.',
    ),
    'atividade_economica': InfoContent(
      key: 'atividade_economica',
      title: 'Atividade econômica',
      description: 'Indicadores que medem a produção e o desempenho da economia.',
    ),
    'mercado_internacional': InfoContent(
      key: 'mercado_internacional',
      title: 'Mercado Internacional',
      description: 'Cotações de moedas estrangeiras em relação ao Real.',
    ),
    'setor_publico': InfoContent(
      key: 'setor_publico',
      title: 'Setor público',
      description: 'Indicadores fiscais do governo, incluindo déficit e dívida pública.',
    ),
    // Add more terms as needed...
  };

  static InfoContent? get(String key) => terms[key];
}
```

### Usage Example

```dart
// In any screen/widget - with repository
IconButton(
  icon: Icon(Icons.info_outline, size: 20, color: Color(0xFF9E9E9E)),
  onPressed: () {
    final content = InfoContentRepository.get('variacoes');
    if (content != null) {
      showInfoBottomSheet(
        context: context,
        title: content.title,
        description: content.description,
      );
    }
  },
)

// Or inline for "O que é X?" links
GestureDetector(
  onTap: () => showInfoBottomSheet(
    context: context,
    title: 'PIB',
    description: 'Soma de tudo que o país produz. Mostra se a economia está crescendo ou não.',
  ),
  child: Row(
    children: [
      Icon(Icons.info_outline, size: 16, color: Color(0xFF9E9E9E)),
      SizedBox(width: 8),
      Text('O que é PIB?', style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 13)),
    ],
  ),
)
```

### File Location
```
lib/common/widgets/info_bottom_sheet.dart   # The showInfoBottomSheet function
lib/models/info_content.dart                 # InfoContent model + repository
```

---

## App Background Gradient

**Used on:** All screens (Onboarding, Login, Signup, Home, Conjuntura, Sofia, Carteira, Perfil)

### Specification
The entire app uses a consistent dark gradient background.

| Property | Value |
|----------|-------|
| Type | Linear Gradient |
| Direction | Top to Bottom |
| Start Color | #0D1B2A (very dark blue) |
| End Color | #1B2838 (dark blue-gray) |
| Alternative | Solid #0D1421 or #0E1726 |

### Implementation
```dart
// lib/common/widgets/app_background.dart

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D1B2A),
            Color(0xFF1B2838),
          ],
        ),
      ),
      child: child,
    );
  }
}
```

### File Location
```
lib/common/widgets/app_background.dart
```

---

## Primary Button

**Used on:** Login, Signup, Onboarding, Settings, Dialogs, Forms

### Specification

| Property | Value |
|----------|-------|
| Background Color | #1B6FFF (primary blue) |
| Text Color | White |
| Font Size | 16px |
| Font Weight | 600 |
| Height | 56px |
| Border Radius | 12px |
| Disabled Opacity | 0.5 |

### Variants
- **Full Width:** Spans container width (default for forms)
- **Inline:** Auto-width based on content
- **Loading State:** Shows circular progress indicator

### Implementation
```dart
// lib/common/widgets/primary_button.dart

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;

  const PrimaryButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1B6FFF),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFF1B6FFF).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(text),
      ),
    );
  }
}
```

### File Location
```
lib/common/widgets/primary_button.dart
```

---

## Custom Text Field

**Used on:** Login, Signup, Profile Edit, Search, Chat Input

### Specification

| Property | Value |
|----------|-------|
| Background | #2D3245 or #1A1A2E |
| Border Color (inactive) | Transparent or #3D4255 |
| Border Color (focused) | #1B6FFF |
| Border Color (error) | #D32F2F |
| Border Radius | 12px |
| Height | 56px |
| Text Color | White |
| Hint Text Color | #7C7C83 |
| Label Color | #DFDFE0 |
| Icon Color | #9E9E9E |

### Features
- Floating label animation
- Error state with message
- Password visibility toggle
- Prefix/suffix icons
- Character counter (optional)

### Implementation
```dart
// lib/common/widgets/custom_text_field.dart

class CustomTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? errorText;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    required this.label,
    this.hint,
    this.controller,
    this.errorText,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFF2D3245),
        labelStyle: const TextStyle(color: Color(0xFFDFDFE0)),
        hintStyle: const TextStyle(color: Color(0xFF7C7C83)),
        errorStyle: const TextStyle(color: Color(0xFFD32F2F)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1B6FFF), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
```

### File Location
```
lib/common/widgets/custom_text_field.dart
```

---

## Section Header with "Ver mais" Link

**Used on:** Home (Bolsa, Economia sections), Conjuntura, Carteira

### Specification

| Element | Specification |
|---------|--------------|
| Section Title | Size: 16px, Weight: 500, Color: White |
| "Ver mais" Link | Size: 14px, Weight: 500, Color: #BADBC1 |
| Layout | Row with SpaceBetween alignment |
| Spacing | 8px vertical margin |

### Implementation
```dart
// lib/common/widgets/section_header.dart

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    required this.title,
    this.actionText,
    this.onActionTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        if (actionText != null)
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFFBADBC1),
              ),
            ),
          ),
      ],
    );
  }
}
```

### File Location
```
lib/common/widgets/section_header.dart
```

---

## Tab Navigation (Segmented Control)

**Used on:** Home (Rentabilidade/Risco/Composição), Perfil tabs

### Specification

| Property | Value |
|----------|-------|
| Container Background | #2D3245 |
| Container Height | 48px |
| Container Border Radius | 12px |
| Selected Tab Background | #1B6FFF (primary) |
| Selected Tab Border Radius | 8px |
| Tab Text Size | 16px |
| Tab Text Weight | 500 |
| Selected Text Color | White |
| Unselected Text Color | #DFDFE0 |

### Implementation
```dart
// lib/common/widgets/segmented_tabs.dart

class SegmentedTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const SegmentedTabs({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final isSelected = entry.key == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(entry.key),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1B6FFF) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFFDFDFE0),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

### File Location
```
lib/common/widgets/segmented_tabs.dart
```

---

## Period Filter Pills

**Used on:** Home (chart filters), Conjuntura (date ranges)

### Specification

| Property | Value |
|----------|-------|
| Inactive Border | #7C7C83, 1px |
| Active Border | #BADBC1, 2px |
| Border Radius | 16px |
| Height | 32px |
| Horizontal Padding | 16px |
| Text Size | 13px |
| Inactive Text Weight | 500 |
| Active Text Weight | 600 |
| Text Color | White |

### Common Values
- Semana
- No mês
- 1 mês
- 12 meses
- YTD / YoY / MoM

### Implementation
```dart
// lib/common/widgets/period_filter.dart

class PeriodFilter extends StatelessWidget {
  final List<String> periods;
  final int selectedIndex;
  final ValueChanged<int> onPeriodChanged;

  const PeriodFilter({
    required this.periods,
    required this.selectedIndex,
    required this.onPeriodChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: periods.asMap().entries.map((entry) {
          final isSelected = entry.key == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: entry.key < periods.length - 1 ? 8 : 0),
            child: GestureDetector(
              onTap: () => onPeriodChanged(entry.key),
              child: Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? const Color(0xFFBADBC1) : const Color(0xFF7C7C83),
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(
                  entry.value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

### File Location
```
lib/common/widgets/period_filter.dart
```

---

## AI Disclaimer Text

**Used on:** Sofia chat screen, any AI-powered features

### Specification

| Property | Value |
|----------|-------|
| Text Color | #9E9E9E |
| Font Size | 12px |
| Font Weight | 400 |
| Line Height | 1.4 |
| Alignment | Center |

### Standard Text
```
"A SofIA é uma assistente de IA e pode cometer erros. Verifique informações importantes."
```

### Implementation
```dart
// lib/common/widgets/ai_disclaimer.dart

class AiDisclaimer extends StatelessWidget {
  final String? customText;

  const AiDisclaimer({this.customText, super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      customText ?? 'A SofIA é uma assistente de IA e pode cometer erros. Verifique informações importantes.',
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF9E9E9E),
        height: 1.4,
      ),
    );
  }
}
```

### File Location
```
lib/common/widgets/ai_disclaimer.dart
```

---

## Upgrade/Premium Banner

**Used on:** Sofia (free tier limit), Conjuntura (paywall), Feature gates

### Specification

| Property | Value |
|----------|-------|
| Background | Gradient or semi-transparent overlay |
| Border Radius | 12px |
| Padding | 16px |
| Icon | Lock or Star icon |
| Title Size | 16px, Weight 600 |
| Description Size | 14px, Weight 400 |
| Button | Primary button style |

### Variants
1. **Inline Banner:** Small banner within content
2. **Full Screen Overlay:** Blocks content with upgrade prompt
3. **Modal:** Bottom sheet with upgrade options

### Implementation
```dart
// lib/common/widgets/upgrade_banner.dart

class UpgradeBanner extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onUpgrade;

  const UpgradeBanner({
    required this.title,
    required this.description,
    required this.onUpgrade,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D3245),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1B6FFF).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_outline, color: Color(0xFF1B6FFF), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFFDFDFE0),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onUpgrade,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B6FFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Fazer upgrade'),
            ),
          ),
        ],
      ),
    );
  }
}
```

### File Location
```
lib/common/widgets/upgrade_banner.dart
```

---

## Data Masking Utilities

**Used on:** Perfil (CPF, email, phone display), Security screens

### Specification
Used to partially hide sensitive user data for privacy.

| Data Type | Mask Pattern | Example |
|-----------|-------------|---------|
| CPF | Show first 3 + last 2 | `123.***.***-89` |
| Email | Show first 2 chars + domain | `ar***@email.com` |
| Phone | Show last 4 digits | `(**) *****-1234` |

### Implementation
```dart
// lib/utils/data_masking.dart

class DataMasking {
  /// Masks CPF: 123.456.789-00 → 123.***.***-00
  static String maskCpf(String cpf) {
    final clean = cpf.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.length != 11) return cpf;
    return '${clean.substring(0, 3)}.***.***-${clean.substring(9)}';
  }

  /// Masks email: ariel@email.com → ar***@email.com
  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '***@$domain';
    return '${name.substring(0, 2)}***@$domain';
  }

  /// Masks phone: (11) 98765-4321 → (**) *****-4321
  static String maskPhone(String phone) {
    final clean = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (clean.length < 4) return phone;
    return '(**) *****-${clean.substring(clean.length - 4)}';
  }
}
```

### File Location
```
lib/utils/data_masking.dart
```

---

## Security Notice Widget

**Used on:** Perfil (data security section), Settings, Privacy screens

### Specification

| Property | Value |
|----------|-------|
| Background | #15254E or #1A1A2E |
| Border Radius | 12px |
| Padding | 16px |
| Icon | Shield icon (Icons.shield_outlined) |
| Icon Color | #BADBC1 |
| Title | 16px, Weight 600, White |
| Description | 14px, Weight 400, #DFDFE0 |

### Implementation
```dart
// lib/common/widgets/security_notice.dart

class SecurityNotice extends StatelessWidget {
  final String title;
  final String description;

  const SecurityNotice({
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF15254E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: Color(0xFFBADBC1),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFDFDFE0),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### File Location
```
lib/common/widgets/security_notice.dart
```

---

## Toast Notification (Success)

**Used on:** Stocks (favorite toggle), Form submissions, Action confirmations

### Specification

| Property | Value |
|----------|-------|
| Background | #BADBC1 (green) |
| Text Color | #0D1B2A (dark) |
| Text Size | 14px |
| Text Weight | 500 |
| Icon | Checkmark, left side |
| Icon Size | 18px |
| Border Radius | 8px |
| Padding | 12px horizontal, 10px vertical |
| Position | Top of screen, below header |
| Duration | 3 seconds (auto-dismiss) |

### Implementation

```dart
// lib/common/widgets/toast_notification.dart

import 'package:flutter/material.dart';

enum ToastType { success, error, info }

class ToastNotification {
  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);

    Color backgroundColor;
    Color textColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        backgroundColor = const Color(0xFFBADBC1);
        textColor = const Color(0xFF0D1B2A);
        icon = Icons.check;
        break;
      case ToastType.error:
        backgroundColor = const Color(0xFFFF6B6B);
        textColor = Colors.white;
        icon = Icons.error_outline;
        break;
      case ToastType.info:
        backgroundColor = const Color(0xFF1B6FFF);
        textColor = Colors.white;
        icon = Icons.info_outline;
        break;
    }

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 60,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, color: textColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      overlayEntry.remove();
    });
  }
}
```

### Usage Examples

```dart
// Success toast (e.g., add to favorites)
ToastNotification.show(
  context: context,
  message: 'Ação adicionada aos favoritos.',
  type: ToastType.success,
);

// Error toast
ToastNotification.show(
  context: context,
  message: 'Erro ao salvar. Tente novamente.',
  type: ToastType.error,
);

// Info toast
ToastNotification.show(
  context: context,
  message: 'Dados atualizados.',
  type: ToastType.info,
);
```

### File Location
```
lib/common/widgets/toast_notification.dart
```

---

## Future Components

_Additional components to be added as they are identified:_

- Loading indicators / Skeleton screens
- Error states
- Empty states
- Confirmation dialogs
- Bottom navigation bar
- Page title typography pattern
- Card container styles
