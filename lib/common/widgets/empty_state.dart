import 'package:flutter/material.dart';

/// A reusable empty state widget that displays when there's no data.
///
/// Context-aware for different scenarios:
/// - Portfolio not connected
/// - No search results
/// - No data available
/// - Feature not enabled
class EmptyState extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final String title;
  final String? subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;
  final double iconSize;

  const EmptyState({
    this.icon,
    this.iconPath,
    required this.title,
    this.subtitle,
    this.buttonText,
    this.onButtonPressed,
    this.iconSize = 80,
    super.key,
  });

  /// Factory for portfolio not connected state
  factory EmptyState.portfolioNotConnected({
    VoidCallback? onConnect,
  }) {
    return EmptyState(
      icon: Icons.account_balance_outlined,
      title: 'Carteira não conectada',
      subtitle: 'Conecte sua conta B3 para visualizar seus investimentos.',
      buttonText: 'Conectar B3',
      onButtonPressed: onConnect,
    );
  }

  /// Factory for no data available state
  factory EmptyState.noData({
    String? message,
    VoidCallback? onRefresh,
  }) {
    return EmptyState(
      icon: Icons.inbox_outlined,
      title: 'Nenhum dado disponível',
      subtitle: message ?? 'Os dados ainda não foram carregados.',
      buttonText: onRefresh != null ? 'Atualizar' : null,
      onButtonPressed: onRefresh,
    );
  }

  /// Factory for no search results state
  factory EmptyState.noSearchResults({
    String? searchTerm,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'Nenhum resultado encontrado',
      subtitle: searchTerm != null
          ? 'Não encontramos resultados para "$searchTerm".'
          : 'Tente buscar com outros termos.',
    );
  }

  /// Factory for feature not enabled state
  factory EmptyState.featureNotEnabled({
    String? featureName,
    VoidCallback? onUpgrade,
  }) {
    return EmptyState(
      icon: Icons.lock_outline,
      title: 'Recurso Premium',
      subtitle: featureName != null
          ? '$featureName está disponível no plano Pro.'
          : 'Este recurso está disponível no plano Pro.',
      buttonText: 'Fazer upgrade',
      onButtonPressed: onUpgrade,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: const Color(0xFF7C7C83),
              ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFFDFDFE0),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B6FFF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
