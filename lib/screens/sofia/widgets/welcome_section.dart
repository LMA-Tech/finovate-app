// lib/common/widgets/welcome_section.dart

import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';
import 'action_cards.dart';

/// Welcome Section Component for SofIA AI interface
///
/// This widget displays the personalized greeting and suggestion action cards
/// that users can tap to start conversations with the AI assistant.
class WelcomeSection extends StatelessWidget {
  /// User's name for personalized greeting
  final String userName;

  /// Callback function when an action card is tapped
  final Function(String suggestion) onSuggestionTap;

  /// Whether the interface is currently loading
  final bool isLoading;

  const WelcomeSection({
    super.key,
    required this.userName,
    required this.onSuggestionTap,
    this.isLoading = false, required bool useCompactLayout,
  });

  /// Predefined suggestion data with icons and text
  List<Map<String, dynamic>> get _suggestions => [
    {
      'icon': Icons.trending_up,
      'text': FinTexts.sofiaSuggestion1,
      'iconColor': FinColors.success,
    },
    {
      'icon': Icons.security,
      'text': FinTexts.sofiaSuggestion2,
      'iconColor': FinColors.info,
    },
    {
      'icon': Icons.local_offer,
      'text': FinTexts.sofiaSuggestion3,
      'iconColor': FinColors.warning,
    },
    {
      'icon': Icons.help_outline,
      'text': FinTexts.sofiaSuggestion4,
      'iconColor': FinColors.primary,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Personalized greeting
          _buildGreeting(),

          const SizedBox(height: FinSizes.spaceBtwSections),

          Flexible(
            child: _buildActionCardsGrid(),
          ),
        ],
      ),
    );
  }

  /// Build the personalized greeting section
  Widget _buildGreeting() {
    return Column(
      children: [
        Text(
          '${FinTexts.sofiaGreetingHello} $userName,',
          style: const TextStyle(
            fontSize: FinSizes.fontSizeXXLg + 4,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: FinSizes.sm),

        const Text(
          FinTexts.sofiaGreetingQuestion,
          style: TextStyle(
            fontSize: FinSizes.fontSizeXXLg + 4,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build the action cards in vertical layout for better text display
  Widget _buildActionCardsGrid() {
    return Column(
      children: _suggestions.map((suggestion) {
        return Padding(
          padding: const EdgeInsets.only(bottom: FinSizes.md), // Space between cards
          child: SizedBox(
            width: double.infinity, // Full width for each card
            height: 100, // Increased height to accommodate 2-3 lines of text
            child: ActionCard(
              icon: suggestion['icon'] as IconData,
              text: suggestion['text'] as String,
              iconColor: suggestion['iconColor'] as Color,
              onTap: isLoading
                  ? () {} // Disable taps when loading
                  : () => onSuggestionTap(suggestion['text'] as String),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Alternative layout with vertical stacking for smaller screens
class WelcomeSectionVertical extends StatelessWidget {
  /// User's name for personalized greeting
  final String userName;

  /// Callback function when an action card is tapped
  final Function(String suggestion) onSuggestionTap;

  /// Whether the interface is currently loading
  final bool isLoading;

  const WelcomeSectionVertical({
    super.key,
    required this.userName,
    required this.onSuggestionTap,
    this.isLoading = false,
  });

  /// Predefined suggestion data with icons and text
  List<Map<String, dynamic>> get _suggestions => [
    {
      'icon': Icons.trending_up,
      'text': 'Quais ativos apresentaram maior rentabilidade',
      'iconColor': FinColors.success,
    },
    {
      'icon': Icons.security,
      'text': 'Quais são as opções com menos risco',
      'iconColor': FinColors.info,
    },
    {
      'icon': Icons.local_offer,
      'text': 'Quais ações estão mais descontadas',
      'iconColor': FinColors.warning,
    },
    {
      'icon': Icons.help_outline,
      'text': 'Perguntas frequentes',
      'iconColor': FinColors.primary,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(FinSizes.defaultSpace),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Personalized greeting
          _buildGreeting(),

          const SizedBox(height: FinSizes.spaceBtwSections),

          // Action cards in vertical layout
          _buildActionCardsVertical(),
        ],
      ),
    );
  }

  /// Build the personalized greeting section
  Widget _buildGreeting() {
    return Column(
      children: [
        Text(
          '${FinTexts.sofiaGreetingHello} $userName,',
          style: const TextStyle(
            fontSize: FinSizes.fontSizeXXLg + 2,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: FinSizes.sm),

        const Text(
          FinTexts.sofiaGreetingQuestion,
          style: TextStyle(
            fontSize: FinSizes.fontSizeXXLg + 2,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Build action cards in vertical layout
  Widget _buildActionCardsVertical() {
    return Column(
      children: _suggestions.map((suggestion) {
        return Padding(
          padding: const EdgeInsets.only(bottom: FinSizes.md),
          child: ActionCard(
            icon: suggestion['icon'] as IconData,
            text: suggestion['text'] as String,
            iconColor: suggestion['iconColor'] as Color,
            onTap: isLoading
                ? () {} // Disable taps when loading
                : () => onSuggestionTap(suggestion['text'] as String),
          ),
        );
      }).toList(),
    );
  }
}