import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Extra colors used across the app
extension CustomColorScheme on ColorScheme {
  Color get shadowColorLight => Colors.grey.withValues(alpha: 0.08);
  Color get shadowColorDark => Colors.black.withValues(alpha: 0.12);
}

/// App-wide theme
class AppTheme {
  AppTheme._();

  // Tokopedia-inspired colors
  static const int _primaryColor = 0xFF42B883; // Tokopedia green
  static const int _secondaryColor = 0xFF03AC0E; // Darker green
  static const int _accentColor = 0xFFFF6B35; // Orange accent
  static const int _errorColor = 0xFFE53E3E;

  static const MaterialColor primarySwatch =
      MaterialColor(_primaryColor, <int, Color>{
        50: Color(0xFFE6F7F1),
        100: Color(0xFFB3E5D1),
        200: Color(0xFF80D4B1),
        300: Color(0xFF4DC291),
        400: Color(0xFF42B883),
        500: Color(_primaryColor),
        600: Color(0xFF3BA574),
        700: Color(0xFF329165),
        800: Color(0xFF2A7D56),
        900: Color(0xFF1F5E41),
      });

  // Gradient colors for modern UI
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF42B883), Color(0xFF03AC0E)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
  );

  // Spacing constants
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Border radius constants
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  static const String fontFamily = 'OpenSans';

  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
        seedColor: const Color(_primaryColor),
        brightness: Brightness.light,
        primary: const Color(_primaryColor),
        secondary: const Color(_secondaryColor),
        tertiary: const Color(_accentColor),
        surface: Colors.white,
        error: const Color(_errorColor),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1A202C),
        onError: Colors.white,
        outline: const Color(0xFFE2E8F0),
        surfaceContainerHighest: const Color(0xFFF7FAFC),
      );

  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
        seedColor: const Color(_primaryColor),
        brightness: Brightness.dark,
        primary: const Color(_primaryColor),
        secondary: const Color(_secondaryColor),
        tertiary: const Color(_accentColor),
        surface: const Color(0xFF1A202C),
        error: const Color(_errorColor),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFFF7FAFC),
        onError: Colors.white,
        outline: const Color(0xFF4A5568),
        surfaceContainerHighest: const Color(0xFF2D3748),
      );

  // --------------------
  // Typography Scale
  // --------------------
  static final TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
    fontFamily: fontFamily,
  );
  static final TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
  );
  static final TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
  );

  static final TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
  );
  static final TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
  );
  static final TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
  );

  static final TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    fontFamily: fontFamily,
  );
  static final TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );
  static final TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );
  static final TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    fontFamily: fontFamily,
  );
  static final TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    fontFamily: fontFamily,
  );

  static final TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    fontFamily: fontFamily,
  );
  static final TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );
  static final TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    fontFamily: fontFamily,
  );

  /// ===================
  /// Light Theme
  /// ===================
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    scaffoldBackgroundColor: lightColorScheme.surface,
    fontFamily: fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: lightColorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      titleTextStyle: titleLarge.copyWith(
        color: lightColorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: lightColorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: lightColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: lightColorScheme.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingM),
      hintStyle: bodyMedium.copyWith(color: const Color(0xFF9CA3AF)),
      labelStyle: bodyMedium.copyWith(color: const Color(0xFF6B7280)),
    ),
    cardTheme: CardThemeData(
       color: Colors.white,
       elevation: 4,
       shadowColor: Colors.black.withValues(alpha: 0.1),
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(radiusL),
       ),
       margin: const EdgeInsets.all(spacingS),
     ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: 3,
        shadowColor: lightColorScheme.primary.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        textStyle: labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightColorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
        textStyle: labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: displayLarge.copyWith(color: lightColorScheme.onSurface),
      displayMedium: displayMedium.copyWith(color: lightColorScheme.onSurface),
      displaySmall: displaySmall.copyWith(color: lightColorScheme.onSurface),
      headlineLarge: headlineLarge.copyWith(color: lightColorScheme.onSurface),
      headlineMedium: headlineMedium.copyWith(color: lightColorScheme.onSurface),
      headlineSmall: headlineSmall.copyWith(color: lightColorScheme.onSurface),
      titleLarge: titleLarge.copyWith(color: lightColorScheme.onSurface, fontWeight: FontWeight.w700),
      titleMedium: titleMedium.copyWith(color: lightColorScheme.onSurface, fontWeight: FontWeight.w600),
      titleSmall: titleSmall.copyWith(color: lightColorScheme.onSurface, fontWeight: FontWeight.w600),
      bodyLarge: bodyLarge.copyWith(color: lightColorScheme.onSurface),
      bodyMedium: bodyMedium.copyWith(color: lightColorScheme.onSurface),
      bodySmall: bodySmall.copyWith(color: const Color(0xFF6B7280)),
      labelLarge: labelLarge.copyWith(color: lightColorScheme.onSurface, fontWeight: FontWeight.w600),
      labelMedium: labelMedium.copyWith(color: lightColorScheme.onSurface, fontWeight: FontWeight.w500),
      labelSmall: labelSmall.copyWith(color: const Color(0xFF9CA3AF)),
    ),
    dialogTheme: DialogThemeData(
       backgroundColor: Colors.white,
       elevation: 8,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(radiusL),
       ),
     ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF1F2937),
      contentTextStyle: bodyMedium.copyWith(
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusS),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: lightColorScheme.primary,
      unselectedItemColor: const Color(0xFF9CA3AF),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: labelSmall.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: labelSmall,
    ),
  );

  /// ===================
  /// Dark Theme
  /// ===================
  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    scaffoldBackgroundColor: darkColorScheme.surface,
    fontFamily: fontFamily,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: titleLarge.copyWith(
        color: darkColorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: darkColorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: darkColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusM),
        borderSide: BorderSide(color: darkColorScheme.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingM),
      hintStyle: bodyMedium.copyWith(color: const Color(0xFF9CA3AF)),
      labelStyle: bodyMedium.copyWith(color: const Color(0xFFD1D5DB)),
    ),
    cardTheme: CardThemeData(
      color: darkColorScheme.surface,
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusL),
      ),
      margin: const EdgeInsets.all(spacingS),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        elevation: 3,
        shadowColor: darkColorScheme.primary.withValues(alpha: 0.3),
        padding: const EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusM),
        ),
        textStyle: labelLarge.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkColorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusS),
        ),
        textStyle: labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: displayLarge.copyWith(color: darkColorScheme.onSurface),
      displayMedium: displayMedium.copyWith(color: darkColorScheme.onSurface),
      displaySmall: displaySmall.copyWith(color: darkColorScheme.onSurface),
      headlineLarge: headlineLarge.copyWith(color: darkColorScheme.onSurface),
      headlineMedium: headlineMedium.copyWith(color: darkColorScheme.onSurface),
      headlineSmall: headlineSmall.copyWith(color: darkColorScheme.onSurface),
      titleLarge: titleLarge.copyWith(color: darkColorScheme.onSurface, fontWeight: FontWeight.w700),
      titleMedium: titleMedium.copyWith(color: darkColorScheme.onSurface, fontWeight: FontWeight.w600),
      titleSmall: titleSmall.copyWith(color: darkColorScheme.onSurface, fontWeight: FontWeight.w600),
      bodyLarge: bodyLarge.copyWith(color: darkColorScheme.onSurface),
      bodyMedium: bodyMedium.copyWith(color: darkColorScheme.onSurface),
      bodySmall: bodySmall.copyWith(color: const Color(0xFF9CA3AF)),
      labelLarge: labelLarge.copyWith(color: darkColorScheme.onSurface, fontWeight: FontWeight.w600),
      labelMedium: labelMedium.copyWith(color: darkColorScheme.onSurface, fontWeight: FontWeight.w500),
      labelSmall: labelSmall.copyWith(color: const Color(0xFF6B7280)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: darkColorScheme.surface,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusL),
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF374151),
      contentTextStyle: bodyMedium.copyWith(
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusS),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkColorScheme.surface,
      selectedItemColor: darkColorScheme.primary,
      unselectedItemColor: const Color(0xFF6B7280),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: labelSmall.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: labelSmall,
    ),
  );
}
