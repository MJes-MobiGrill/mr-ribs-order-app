import 'package:flutter/material.dart';

// Einfacher AppBar Button - zeigt aktuelle Sprache
class SimpleAppBarLanguageButton extends StatelessWidget {
  final Function(Locale) onLanguageChanged;

  const SimpleAppBarLanguageButton({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final currentLanguage = currentLocale.languageCode;
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        onPressed: () => _toggleLanguage(context),
        icon: Text(
          _getCurrentFlag(currentLanguage),
          style: const TextStyle(fontSize: 24),
        ),
        tooltip: _getTooltip(currentLanguage),
      ),
    );
  }

  String _getCurrentFlag(String languageCode) {
    switch (languageCode) {
      case 'de':
        return '🇩🇪';
      case 'en':
        return '🇬🇧';
      default:
        return '🌍';
    }
  }

  String _getTooltip(String languageCode) {
    switch (languageCode) {
      case 'de':
        return 'Sprache ändern';
      case 'en':
        return 'Change Language';
      default:
        return 'Change Language';
    }
  }

  void _toggleLanguage(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final newLanguage = currentLocale.languageCode == 'de' ? 'en' : 'de';
    onLanguageChanged(Locale(newLanguage));
  }
}

// Einfacher FloatingActionButton - Text mit Flagge
class SimpleFloatingLanguageButton extends StatelessWidget {
  final Function(Locale) onLanguageChanged;

  const SimpleFloatingLanguageButton({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final currentLanguage = currentLocale.languageCode;
    
    return FloatingActionButton.extended(
      onPressed: () => _toggleLanguage(context),
      backgroundColor: Colors.blue.shade600,
      foregroundColor: Colors.white,
      elevation: 6,
      icon: const Icon(Icons.language, size: 20),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getTargetFlag(currentLanguage),
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 8),
          Text(
            _getButtonText(currentLanguage),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonText(String languageCode) {
    switch (languageCode) {
      case 'de':
        return 'Change Language';
      case 'en':
        return 'Sprache ändern';
      default:
        return 'Change Language';
    }
  }

  String _getTargetFlag(String languageCode) {
    // Zeigt die Flagge der Zielsprache (zu der gewechselt wird)
    switch (languageCode) {
      case 'de':
        return '🇬🇧'; // Deutsch → Englisch
      case 'en':
        return '🇩🇪'; // Englisch → Deutsch
      default:
        return '🇬🇧';
    }
  }

  void _toggleLanguage(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final newLanguage = currentLocale.languageCode == 'de' ? 'en' : 'de';
    onLanguageChanged(Locale(newLanguage));
  }
}

// Einfacher Inline Button
class SimpleInlineLanguageButton extends StatelessWidget {
  final Function(Locale) onLanguageChanged;
  final EdgeInsets? margin;

  const SimpleInlineLanguageButton({
    super.key,
    required this.onLanguageChanged,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final currentLanguage = currentLocale.languageCode;
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8),
      child: TextButton(
        onPressed: () => _toggleLanguage(context),
        style: TextButton.styleFrom(
          backgroundColor: Colors.blue.shade50,
          foregroundColor: Colors.blue.shade700,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blue.shade200),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language, size: 20),
            const SizedBox(width: 8),
            Text(
              _getTargetFlag(currentLanguage),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(width: 8),
            Text(
              _getButtonText(currentLanguage),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getButtonText(String languageCode) {
    switch (languageCode) {
      case 'de':
        return 'Change Language';
      case 'en':
        return 'Sprache ändern';
      default:
        return 'Change Language';
    }
  }

  String _getTargetFlag(String languageCode) {
    // Zeigt die Flagge der Zielsprache (zu der gewechselt wird)
    switch (languageCode) {
      case 'de':
        return '🇬🇧'; // Deutsch → Englisch
      case 'en':
        return '🇩🇪'; // Englisch → Deutsch
      default:
        return '🇬🇧';
    }
  }

  void _toggleLanguage(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final newLanguage = currentLocale.languageCode == 'de' ? 'en' : 'de';
    onLanguageChanged(Locale(newLanguage));
  }
}