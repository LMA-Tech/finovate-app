/// Brazilian locale formatters for currency, percentage, and numbers
class FinFormatters {
  FinFormatters._();

  /// Format a number as percentage with Brazilian locale
  /// Example: -3.81 → "-3,81%", 1.5 → "+1,50%"
  /// [value] The percentage value
  /// [decimals] Number of decimal places (default: 2)
  /// [showSign] Whether to show + for positive values (default: true)
  static String formatPercent(
    double value, {
    int decimals = 2,
    bool showSign = true,
  }) {
    final sign = showSign && value > 0 ? '+' : '';
    final formatted = value.toStringAsFixed(decimals).replaceAll('.', ',');
    return '$sign$formatted%';
  }

  /// Format a number as Brazilian Real currency
  /// Example: 19100.00 → "R$ 19.100,00", -234.50 → "-R$ 234,50"
  /// [value] The currency value
  /// [decimals] Number of decimal places (default: 2)
  /// [showSign] Whether to show sign (default: false)
  static String formatCurrency(
    double value, {
    int decimals = 2,
    bool showSign = false,
  }) {
    final isNegative = value < 0;
    final absValue = value.abs();

    // Split into integer and decimal parts
    final parts = absValue.toStringAsFixed(decimals).split('.');

    // Add thousand separators to integer part
    final intPart = _addThousandSeparators(parts[0]);
    final decPart = parts.length > 1 ? parts[1] : '00';

    // Build the formatted string
    String result = 'R\$ $intPart,$decPart';

    if (isNegative) {
      result = '-$result';
    } else if (showSign && value > 0) {
      result = '+$result';
    }

    return result;
  }

  /// Format a number with thousand separators (Brazilian locale)
  /// Example: 164456 → "164.456", 1234567.89 → "1.234.567,89"
  /// [value] The number to format
  /// [decimals] Number of decimal places (default: 0)
  static String formatNumber(
    double value, {
    int decimals = 0,
  }) {
    final parts = value.toStringAsFixed(decimals).split('.');
    final intPart = _addThousandSeparators(parts[0]);

    if (decimals > 0 && parts.length > 1) {
      return '$intPart,${parts[1]}';
    }
    return intPart;
  }

  /// Add thousand separators (dots) to an integer string
  static String _addThousandSeparators(String integerPart) {
    // Handle negative sign
    final isNegative = integerPart.startsWith('-');
    final digits = isNegative ? integerPart.substring(1) : integerPart;

    // Add separators from right to left
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }

    return isNegative ? '-${buffer.toString()}' : buffer.toString();
  }

  /// Format a DateTime as relative time in Portuguese
  /// Example: "há 15 minutos", "há 2 horas", "há 1 dia"
  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'agora';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return 'há $minutes ${minutes == 1 ? 'minuto' : 'minutos'}';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return 'há $hours ${hours == 1 ? 'hora' : 'horas'}';
    } else {
      final days = difference.inDays;
      return 'há $days ${days == 1 ? 'dia' : 'dias'}';
    }
  }
}
