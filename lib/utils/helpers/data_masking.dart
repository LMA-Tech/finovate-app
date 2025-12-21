// Utility functions for masking sensitive personal data.
//
// Used in profile screens to hide sensitive information while
// still showing partial data for user recognition.

/// Masks an email address.
/// Example: "sofia@example.com" → "s***@*****.com"
String maskEmail(String email) {
  if (email.isEmpty) return email;

  final parts = email.split('@');
  if (parts.length != 2) return email;

  final username = parts[0];
  final domain = parts[1];
  final domainParts = domain.split('.');

  // Mask username: keep first char, mask rest
  final maskedUsername = username.length > 1
      ? '${username[0]}${'*' * (username.length - 1)}'
      : username;

  // Mask domain: replace with *****
  final extension = domainParts.length > 1 ? domainParts.last : 'com';

  return '$maskedUsername@*****.$extension';
}

/// Masks a CPF or CNPJ number.
/// CPF Example: "12345678901" → "***.***. 084-**"
/// CNPJ Example: "12345678000195" → "**.***.***/ 0001-**"
/// Handles both formatted and unformatted values
String maskTaxId(String taxId) {
  // Remove formatting
  final digits = taxId.replaceAll(RegExp(r'[^\d]'), '');

  if (digits.length == 11) {
    // CPF: ***.***.084-**
    return '***.***.${digits.substring(6, 9)}-**';
  } else if (digits.length == 14) {
    // CNPJ: **.***.***/ 0001-**
    return '**.***.***/${digits.substring(8, 12)}-**';
  }

  return taxId;
}

/// Alias for maskTaxId for backwards compatibility
String maskCPF(String taxId) => maskTaxId(taxId);

/// Masks a phone number.
/// Example: "(11) 91234-5678" → "(11) 9****-****"
String maskPhone(String phone) {
  if (phone.isEmpty) return phone;

  // Remove formatting
  final digits = phone.replaceAll(RegExp(r'[^\d]'), '');

  if (digits.length < 10) return phone;

  // Handle both 10-digit (landline) and 11-digit (mobile) numbers
  final ddd = digits.substring(0, 2);

  if (digits.length == 11) {
    // Mobile: (XX) 9****-****
    final firstDigit = digits[2];
    return '($ddd) $firstDigit****-****';
  } else {
    // Landline: (XX) ****-****
    return '($ddd) ****-****';
  }
}

/// Masks a full name, keeping only the first name visible.
/// Example: "Sofia Maria Santos" → "Sofia ********"
String maskName(String name) {
  if (name.isEmpty) return name;

  final parts = name.trim().split(' ');
  if (parts.isEmpty) return name;

  if (parts.length == 1) {
    // Single name - mask partial
    if (parts[0].length <= 3) return parts[0];
    return '${parts[0].substring(0, 3)}${'*' * (parts[0].length - 3)}';
  }

  // Keep first name, mask the rest
  final firstName = parts[0];
  final restLength = name.length - firstName.length - 1; // -1 for space
  return '$firstName ${'*' * restLength.clamp(4, 8)}';
}

/// Masks a birth date.
/// Example: DateTime(1990, 5, 15) → "**/**/1990"
String maskBirthDate(DateTime? date) {
  if (date == null) return '';

  return '**/**/${date.year}';
}

/// Formats a birth date for display (unmasked).
/// Example: DateTime(1990, 5, 15) → "15/05/1990"
String formatBirthDate(DateTime? date) {
  if (date == null) return '';

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();

  return '$day/$month/$year';
}

/// Formats a CPF for display (unmasked).
/// Example: "12345678901" → "123.456.789-01"
String formatCPF(String cpf) {
  final digits = cpf.replaceAll(RegExp(r'[^\d]'), '');

  if (digits.length != 11) return cpf;

  return '${digits.substring(0, 3)}.${digits.substring(3, 6)}.${digits.substring(6, 9)}-${digits.substring(9, 11)}';
}

/// Formats a phone for display (unmasked).
/// Example: "11912345678" → "(11) 91234-5678"
String formatPhone(String phone) {
  final digits = phone.replaceAll(RegExp(r'[^\d]'), '');

  if (digits.length == 11) {
    // Mobile
    return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7, 11)}';
  } else if (digits.length == 10) {
    // Landline
    return '(${digits.substring(0, 2)}) ${digits.substring(2, 6)}-${digits.substring(6, 10)}';
  }

  return phone;
}
