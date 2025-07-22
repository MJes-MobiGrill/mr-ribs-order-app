import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/language_selection_screen.dart';
import 'screens/order_type_selection_screen.dart';

void main() {
  runApp(const MrRibsOrderApp());
}

class MrRibsOrderApp extends StatefulWidget {
  const MrRibsOrderApp({super.key});

  @override
  State<MrRibsOrderApp> createState() => _MrRibsOrderAppState();
}

class _MrRibsOrderAppState extends State<MrRibsOrderApp> {
  Locale? _locale;

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('de', ''),
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: _locale == null 
          ? LanguageSelectionScreen(onLanguageSelected: _setLocale)
          : OrderTypeSelectionScreen(onLanguageChange: _setLocale),
    );
  }
}