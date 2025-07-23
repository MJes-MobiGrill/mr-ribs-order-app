import 'package:flutter/material.dart';

class AppTheme {
  // Hauptfarben - Sehr dezent
  static const Color primaryDark = Color(0xFF2C2C2C); // Fast Schwarz
  static const Color primaryRed = Color(0xFF8B0000); // Dunkles Rot (nur für kleine Akzente)
  static const Color backgroundGrey = Color(0xFFF8F8F8); // Sehr helles Grau
  
  // Grautöne für UI
  static const Color grey900 = Color(0xFF212121);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey100 = Color(0xFFF5F5F5);
  
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      
      // Farbschema
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryDark,
        primary: primaryDark,
        secondary: grey700,
        surface: Colors.white,
        background: backgroundGrey,
        error: primaryRed,
      ),
      
      // Hintergrundfarbe
      scaffoldBackgroundColor: backgroundGrey,
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Card Theme - Korrigiert zu CardThemeData
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: grey300, width: 1),
        ),
      ),
      
      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: grey900,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: grey300),
          ),
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: grey700, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(color: grey900, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: grey900, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: grey900, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: grey900, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: grey800),
        titleSmall: TextStyle(color: grey800),
        bodyLarge: TextStyle(color: grey700),
        bodyMedium: TextStyle(color: grey700),
        bodySmall: TextStyle(color: grey600),
      ),
    );
  }
  
  // Helper Methoden für Order Types - Alle in Grautönen
  static Color getOrderTypeColor(String orderType) {
    // Alle Order Types bekommen die gleiche dezente Farbe
    return grey700;
  }
  
  static IconData getOrderTypeIcon(String orderType) {
    switch (orderType) {
      case 'dine_in':
        return Icons.restaurant;
      case 'takeaway':
        return Icons.takeout_dining;
      case 'delivery':
        return Icons.delivery_dining;
      case 'reservation':
        return Icons.event_seat;
      default:
        return Icons.restaurant_menu;
    }
  }
}