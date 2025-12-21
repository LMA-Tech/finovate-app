import 'package:flutter/material.dart';

class FinColors {
  // Brand color palette
  static const Color lightGray = Color(0xFFDCDCDC);   // CMYK 13, 9, 10, 0 | RGB 220, 220, 220
  static const Color cyan = Color(0xFF00C9FF);        // CMYK 63, 0, 0, 0 | RGB 0, 201, 255
  static const Color blue = Color(0xFF1B6FFF);        // CMYK 79, 58, 0, 0 | RGB 27, 111, 255
  static const Color royalBlue = Color(0xFF1559CC);   // CMYK 86, 68, 0, 0 | RGB 21, 89, 204
  static const Color navy = Color(0xFF0D377F);        // CMYK 100, 90, 22, 7 | RGB 13, 55, 127
  static const Color darkNavy = Color(0xFF071735);    // CMYK 97, 87, 47, 60 | RGB 7, 23, 53

  // App theme colors
  static const Color primary = Color(0xFF1B6FFF);  // Figma: Primary button/tab color
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);

  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;
  static const Color textDark = Color(0xFF19191C);  // Dark text (Neutral-gray-700)

  // Background colors (Dark)
  static const Color dark = Color(0xFF272727);
  static const Color bgColorTop = Color(0xFF252532);
  static const Color bgColorBottom = Color(0xFF030D2C);
  static const Color gradientStart = Color(0xFF252532); // Top of gradient
  static const Color gradientEnd = Color(0xFF111111);   // Bottom of gradient

  // Background colors (Light)
  static const Color light = Color(0xFFF6F6F6);

  // Background Container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = FinColors.white.withValues(alpha: 0.1);

  // Button colors
  static const Color buttonPrimary = Color(0xFF1B6FFF);  // Figma: Primary button color
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);
  static const Color buttonLight = Color(0xFFE3EBFF);

  // Border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Card and container colors (Dark theme)
  static const Color cardBackground = Color(0xFF2D3245);  // Dark card background
  static const Color inputBackground = Color(0xFF2D3245);  // Input field background
  static const Color stockItemBackground = Color(0xFF1B223E);  // Stock list item background

  // Border colors (Dark theme)
  static const Color borderMint = Color(0xFFBADBC1);  // Light mint/teal border (questionnaire options)
  static const Color borderBlue = Color(0xFF1B6FFF);  // Selected state blue border

  // Text colors (Dark theme)
  static const Color textGray200 = Color(0xFFDFDFE0);  // Secondary text on dark
  static const Color textGray300 = Color(0xFF7C7C83);  // Placeholder text

  // Star rating
  static const Color starGold = Color(0xFFFFD700);  // Selected star color

  // Progress indicator
  static const Color progressInactive = Color(0xFF3D4255);  // Inactive step color

  // Trend indicator colors (stocks/economy)
  static const Color trendPositive = Color(0xFF0CB97B);  // Positive trend green
  static const Color trendNegative = Color(0xFFE02244);  // Negative trend red
  static const Color trendPositiveBg = Color(0xFFBADBC1);  // Positive trend background (green pill)
  static const Color trendNegativeBg = Color(0xFFE02244);  // Negative trend background (red pill)
  static const Color trendNeutralBg = Color(0xFFE0E0E0);   // Neutral trend background (gray pill)
  static const Color trendNegativeIconBg = Color(0xFFFFD7DE);  // Light red background for icon circles

  // Company name/subtitle text
  static const Color textSubtitle = Color(0xFFCAD7F8);  // Light blue subtitle text

  // Avatar border
  static const Color avatarBorder = Color(0xFFDFDFE0);  // Light gray for free users
  // Premium avatar uses gradient: #E02244 (red) → #F3AD43 (orange) - see ProfileAvatar widget
  static const Color starOrange = Color(0xFFF3AD43);  // Orange star badge

  // Banner colors
  static const Color bannerText = Color(0xFFF0F5EF);  // Light text for banners
  static const Color bannerGradientStart = Color(0xFF013ACB);  // B3 banner gradient start
  static const Color bannerGradientEnd = Color(0xFF477552);  // B3 banner gradient end

  // OTP/Verification input colors
  static const Color otpInputBorder = Color(0xFFE3EBFF);  // OTP field border
  static const Color radioUnselected = Color(0xFF6B6C70);  // Radio button unselected color

  // Dialog/Modal background
  static const Color dialogBackground = Color(0xFF1A1A2E);  // Dark modal background

  // Bottom navigation
  static const Color bottomNavBackground = Color(0xFF242432);  // Bottom nav bar
  static const Color bottomNavBorder = Color(0xFF2A2A3A);  // Subtle top border

  // Shimmer/Skeleton loading
  static const Color shimmerHighlight = Color(0xFF3D4255);  // Skeleton shimmer highlight

  // Toast/Notification colors
  static const Color toastSuccess = Color(0xFFBADBC1);  // Success toast background
  static const Color toastSuccessText = Color(0xFF0D1B2A);  // Success toast text
  static const Color toastError = Color(0xFFFF6B6B);  // Error toast background
  static const Color toastInfo = Color(0xFF1B6FFF);  // Info toast background

  // Icon/Indicator colors
  static const Color checkmarkGreen = Color(0xFF00C853);  // Green checkmark
  static const Color iconGray = Color(0xFF9E9E9E);  // Generic gray icon

  // Segmented control
  static const Color segmentUnselectedText = Color(0xFFFEFEFE);  // Unselected segment text
  static const Color segmentShadow = Color(0x3D1A2F5C);  // Segment shadow (24% opacity)

  // Notification message box
  static const Color notificationMessageText = Color(0xFFE3EBFF);  // Light blue notification text

  // Gradient colors (for use with LinearGradient)
  static const Color gradientRedStart = Color(0xFFE02244);  // Premium/pro gradient start
  static const Color gradientOrangeEnd = Color(0xFFF3AD43);  // Premium/pro gradient end
  static const Color gradientBlueStart = Color(0xFF62B2FD);  // Free/info gradient start
  static const Color gradientMintEnd = Color(0xFFBADBC1);  // Free/info gradient end

  // Chart tooltip background (same as card)
  static const Color tooltipBackground = Color(0xFF15254E);  // Dark blue tooltip

  // Composicao chart colors
  static const Color composicaoRendaFixa = Color(0xFFE4ECFF);  // Light blue for renda fixa

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color neutralGray = Color(0xFFEFEFF0);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
