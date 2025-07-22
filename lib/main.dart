import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/language_selection_screen.dart';
import 'screens/order_type_selection_screen.dart';
import 'screens/on_site_order_type_screen.dart';
import 'services/location_service.dart';
import 'models/location.dart';
import 'utils/url_helper.dart';

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
  Location? _directLocation;

  @override
  void initState() {
    super.initState();
    _checkUrlParameters();
  }

  void _checkUrlParameters() async {
    // Prüfe URL-Parameter für direkte Navigation
    final locationParam = UrlHelper.getLocationParameter();
    
    if (locationParam != null) {
      // Versuche Location zu finden
      final location = await _findLocationByParam(locationParam);
      if (location != null && mounted) {
        setState(() {
          _directLocation = location;
          _locale = const Locale('de', ''); // Standard-Sprache für QR-Code Zugriff
        });
      }
    }
  }

  Future<Location?> _findLocationByParam(String param) async {
    try {
      final locations = await LocationService.getAllLocations();
      
      // Suche nach verschiedenen Parametern
      for (final location in locations) {
        if (location.id.contains(param.replaceAll('-', '_')) ||
            location.qrCode.toLowerCase().contains(param.toLowerCase())) {
          return location;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

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
      home: _getHomeScreen(),
  );
  }
  Widget _getHomeScreen() {
    // Direkte Navigation zu Restaurant falls QR-Code gescannt
    if (_directLocation != null) {
      return OnSiteOrderTypeScreen(location: _directLocation!);
    }
    
    // Normale Navigation
    if (_locale == null) {
      return LanguageSelectionScreen(onLanguageSelected: _setLocale);
    } else {
      return OrderTypeSelectionScreen(onLanguageChange: _setLocale);
    }
  }
}
