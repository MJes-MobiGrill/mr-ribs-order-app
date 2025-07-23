import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'screens/terminal_order_screen.dart';
import 'screens/on_site_order_type_screen.dart';
import 'screens/online_order_type_screen.dart';
import 'services/location_service.dart';
import 'services/language_detector_service.dart';
import 'services/device_service.dart';
import 'models/location.dart';
import 'utils/url_helper.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MrRibsOrderApp());
}

class MrRibsOrderApp extends StatefulWidget {
  const MrRibsOrderApp({super.key});

  @override
  State<MrRibsOrderApp> createState() => _MrRibsOrderAppState();
}

class _MrRibsOrderAppState extends State<MrRibsOrderApp> {
  Locale _locale = const Locale('de'); // Standard: Deutsch
  DeviceDetectionResult? _deviceResult;
  bool _hasDetectedDevice = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // 1. Smart Language Detection (immer gesetzt, nie null)
      final detectedLocale = LanguageDetectorService.detectUserLanguage();
      
      // 2. URL-Parameter prüfen (QR-Code)
      final qrParameter = UrlHelper.getLocationParameter();
      
      // 3. Intelligente Device Detection
      final deviceResult = await DeviceService.detectDeviceType(
        qrParameter: qrParameter,
      );
      
      // 4. Sprache aus URL überschreiben falls vorhanden
      Locale finalLocale = detectedLocale;
      if (qrParameter != null) {
        final currentUrl = Uri.base;
        final urlLanguage = LanguageDetectorService.detectLanguageFromUrl(currentUrl);
        finalLocale = urlLanguage ?? detectedLocale;
      }
      
      if (mounted) {
        setState(() {
          _deviceResult = deviceResult;
          _locale = finalLocale; // Nie null
          _hasDetectedDevice = true;
          _isLoading = false;
        });
        
        // Debug Output
        _printDebugInfo(deviceResult);
      }
    } catch (e) {
      print('❌ Error initializing app: $e');
      if (mounted) {
        setState(() {
          _locale = const Locale('de'); // Fallback zu Deutsch
          _isLoading = false;
        });
      }
    }
  }

  void _printDebugInfo(DeviceDetectionResult result) {
    print('🔍 Device Detection Result:');
    print('   Type: ${result.deviceType}');
    print('   Device ID: ${result.deviceId}');
    print('   Location: ${result.location?.name ?? 'None'}');
    print('   QR Parameter: ${result.qrParameter ?? 'None'}');
    print('   Flow: ${_getFlowDescription(result)}');
  }

  String _getFlowDescription(DeviceDetectionResult result) {
    switch (result.deviceType) {
      case DeviceType.terminal:
        return '🖥️ Terminal → TerminalOrderScreen (keine Kontaktdaten)';
      case DeviceType.external:
        return '📱 External → OnlineOrderTypeScreen (mit Kontaktdaten)';
      case DeviceType.qrCode:
        return '📷 QR-Code → OnSiteOrderTypeScreen (Restaurant vor Ort)';
    }
  }

  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Loading Screen
    if (_isLoading || !_hasDetectedDevice) {
      return MaterialApp(
        theme: AppTheme.getTheme(),
        home: _buildLoadingScreen(),
      );
    }

    return MaterialApp(
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: LanguageDetectorService.getSupportedLanguages(),
      theme: AppTheme.getTheme(),
      home: _getHomeScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/Logo_inapp.png',
              width: 120,
              height: 120,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Detecting device...',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.grey600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getHomeScreen() {
    // Fehlerbehandlung
    if (_deviceResult == null) {
      return _buildErrorScreen();
    }

    // 🚀 Direkter Router basierend auf Device Type
    switch (_deviceResult!.deviceType) {
      case DeviceType.terminal:
        // 🖥️ TERMINAL: Registriertes Restaurant-Gerät
        // → Direkt zur TerminalOrderScreen (OHNE Kontaktdaten)
        return TerminalOrderScreen(
          location: _deviceResult!.location!,
          onLanguageChange: _setLocale,
        );

      case DeviceType.qrCode:
        // 📷 QR-CODE: Fremdgerät hat QR-Code gescannt
        // → OnSiteOrderTypeScreen (im Restaurant, MIT Kontaktdaten-Option)
        if (_deviceResult!.location != null) {
          return OnSiteOrderTypeScreen(
            location: _deviceResult!.location!,
            onLanguageChange: _setLocale,
          );
        } else {
          // QR-Code ungültig → Fallback zu Online
          return OnlineOrderTypeScreen(
            onLanguageChange: _setLocale,
          );
        }

      case DeviceType.external:
        // 📱 EXTERNAL: Normales Kundengerät von außerhalb
        // → OnlineOrderTypeScreen (mit vollem Service)
        return OnlineOrderTypeScreen(
          onLanguageChange: _setLocale,
        );
    }
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 64,
              color: AppTheme.primaryRed,
            ),
            const SizedBox(height: 16),
            Text(
              'Device detection failed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.grey900,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Please restart the app',
              style: TextStyle(
                color: AppTheme.grey600,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasDetectedDevice = false;
                });
                _initializeApp();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryDark,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Debug Widget für Development (optional, kann entfernt werden)
class DebugInfoWidget extends StatelessWidget {
  final DeviceDetectionResult deviceResult;

  const DebugInfoWidget({super.key, required this.deviceResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.grey100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.grey300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'DEBUG INFO',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text('Type: ${deviceResult.deviceType}', style: const TextStyle(fontSize: 11)),
          Text('Device: ${deviceResult.deviceId}', style: const TextStyle(fontSize: 11)),
          if (deviceResult.location != null)
            Text('Location: ${deviceResult.location!.name}', style: const TextStyle(fontSize: 11)),
          if (deviceResult.qrParameter != null)
            Text('QR: ${deviceResult.qrParameter}', style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}