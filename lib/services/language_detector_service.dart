import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class LanguageDetectorService {
  /// Erkennt die beste Sprache für den User basierend auf verschiedenen Quellen
  static Locale detectUserLanguage() {
    try {
      // 1. Web: Browser-Sprache erkennen
      if (kIsWeb) {
        return _detectWebLanguage();
      }
      
      // 2. Mobile: System-Sprache erkennen
      return _detectMobileLanguage();
      
    } catch (e) {
      print('Language detection error: $e');
      return _getDefaultLanguage();
    }
  }
  
  /// Web-Browser Sprache erkennen
  static Locale _detectWebLanguage() {
    try {
      // Browser-Sprache aus Platform Dispatcher
      final platformLocale = ui.PlatformDispatcher.instance.locale;
      
      if (_isSupportedLanguage(platformLocale.languageCode)) {
        return Locale(platformLocale.languageCode);
      }
      
      // Fallback: Prüfe weitere Browser-Sprachen
      final locales = ui.PlatformDispatcher.instance.locales;
      for (final locale in locales) {
        if (_isSupportedLanguage(locale.languageCode)) {
          return Locale(locale.languageCode);
        }
      }
      
      return _getDefaultLanguage();
    } catch (e) {
      return _getDefaultLanguage();
    }
  }
  
  /// Mobile System-Sprache erkennen
  static Locale _detectMobileLanguage() {
    try {
      final platformLocale = ui.PlatformDispatcher.instance.locale;
      
      if (_isSupportedLanguage(platformLocale.languageCode)) {
        return Locale(platformLocale.languageCode);
      }
      
      return _getDefaultLanguage();
    } catch (e) {
      return _getDefaultLanguage();
    }
  }
  
  /// Prüft ob Sprache unterstützt wird
  static bool _isSupportedLanguage(String languageCode) {
    const supportedLanguages = ['de', 'en'];
    return supportedLanguages.contains(languageCode.toLowerCase());
  }
  
  /// Standard-Sprache (Deutsch für Mr. Ribs)
  static Locale _getDefaultLanguage() {
    return const Locale('de');
  }
  
  /// Gibt alle unterstützten Sprachen zurück
  static List<Locale> getSupportedLanguages() {
    return const [
      Locale('de'),
      Locale('en'),
    ];
  }
  
  /// Gibt Sprach-Namen zurück
  static Map<String, String> getLanguageNames() {
    return {
      'de': 'Deutsch',
      'en': 'English',
    };
  }
  
  /// Gibt Sprach-Flags zurück
  static Map<String, String> getLanguageFlags() {
    return {
      'de': '🇩🇪',
      'en': '🇬🇧',
    };
  }
  
  /// Erkennt Sprache aus QR-Code URL (falls Parameter vorhanden)
  static Locale? detectLanguageFromUrl(Uri url) {
    try {
      final langParam = url.queryParameters['lang'] ?? url.queryParameters['language'];
      
      if (langParam != null && _isSupportedLanguage(langParam)) {
        return Locale(langParam.toLowerCase());
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Gibt lokalisierte Sprach-Namen zurück
  static String getLocalizedLanguageName(String languageCode, String currentLanguage) {
    const names = {
      'de': {
        'de': 'Deutsch',
        'en': 'German',
      },
      'en': {
        'de': 'Englisch',
        'en': 'English',
      },
    };
    
    return names[languageCode]?[currentLanguage] ?? 
           names[languageCode]?['de'] ?? 
           languageCode.toUpperCase();
  }
}