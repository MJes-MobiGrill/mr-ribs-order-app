import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/device_service.dart';
import '../services/location_service.dart';
import '../models/location.dart';
import 'on_site_order_type_screen.dart';
import 'qr_scanner_screen.dart';

class OrderTypeSelectionScreen extends StatelessWidget {
  final Function(Locale) onLanguageChange;

  const OrderTypeSelectionScreen({
    super.key,
    required this.onLanguageChange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showLanguageSelectionDialog(context, l10n),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.language),
        label: Text(_getLanguageChangeLabel(context)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            
            Text(
              l10n.selectOrderType,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Vor Ort bestellen Button
            _buildOrderTypeButton(
              context: context,
              icon: Icons.store,
              title: l10n.orderOnSite,
              subtitle: l10n.orderOnSiteDescription,
              onTap: () => _handleOnSiteOrder(context, l10n),
            ),
            
            const SizedBox(height: 16),
            
            // QR-Code scannen Button
            _buildOrderTypeButton(
              context: context,
              icon: Icons.qr_code_scanner,
              title: l10n.scanQrCode,
              subtitle: l10n.scanQrCodeDescription,
              onTap: () => _openQrScanner(context),
            ),
            
            const SizedBox(height: 16),
            
            // Tisch reservieren Button
            _buildOrderTypeButton(
              context: context,
              icon: Icons.event_seat,
              title: l10n.reserveTable,
              subtitle: l10n.reserveTableDescription,
              onTap: () => _showReservationDialog(context, l10n),
            ),
            
            const SizedBox(height: 16),
            
            // Online bestellen Button
            _buildOrderTypeButton(
              context: context,
              icon: Icons.smartphone,
              title: l10n.orderOnline,
              subtitle: l10n.orderOnlineDescription,
              onTap: () => _showComingSoonDialog(context, l10n),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 100,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade800,
          elevation: 4,
          shadowColor: Colors.blue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Colors.blue.shade200,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.blue,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.blue.shade300,
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageChangeLabel(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    
    // Zeige die gegensätzliche Sprache an
    if (currentLocale.languageCode == 'de') {
      return 'Change Language';  // Deutsch → Englisch anzeigen
    } else {
      return 'Sprache Ändern';   // Englisch → Deutsch anzeigen
    }
  }

  void _showLanguageSelectionDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Image.asset(
                'assets/images/flags/de.png',
                width: 32,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.flag, size: 24);
                },
              ),
              title: Text(l10n.german),
              onTap: () {
                Navigator.pop(context);
                onLanguageChange(const Locale('de', ''));
              },
            ),
            ListTile(
              leading: Image.asset(
                'assets/images/flags/en.png',
                width: 32,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.flag, size: 24);
                },
              ),
              title: Text(l10n.english),
              onTap: () {
                Navigator.pop(context);
                onLanguageChange(const Locale('en', ''));
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  void _handleOnSiteOrder(BuildContext context, AppLocalizations l10n) async {
    try {
      // Geräte-ID abrufen und prüfen (im Hintergrund)
      final String deviceId = await DeviceService.getDeviceId();
      final Location? currentLocation = await LocationService.getCurrentLocation();
      
      if (currentLocation != null) {
        // Gerät ist registriert - Direkt zum Menü
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnSiteOrderTypeScreen(location: currentLocation),
          ),
        );
      } else {
        // Gerät nicht registriert - Alternativen anbieten
        _showDeviceNotRegisteredDialog(context, l10n, deviceId);
      }
      
    } catch (e) {
      // Fehler beim Laden
      _showErrorDialog(context, l10n, e.toString());
    }
  }

  void _openQrScanner(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const QrScannerScreen(),
      ),
    );
  }

  void _showDeviceNotRegisteredDialog(BuildContext context, AppLocalizations l10n, String deviceId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Text(l10n.deviceNotRegistered),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deviceNotRegisteredMessage),
            const SizedBox(height: 16),
            Text(l10n.alternativeOptions, style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _openQrScanner(context);
            },
            child: Text(l10n.scanQrCode),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showComingSoonDialog(context, l10n);
            },
            child: Text(l10n.orderOnline),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(BuildContext context, AppLocalizations l10n, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Text(l10n.error),
          ],
        ),
        content: Text('${l10n.errorMessage}: $error'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  void _showReservationDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.reserveTable),
        content: Text(l10n.reserveTableMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Tischreservierung implementieren
            },
            child: Text(l10n.proceed),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.comingSoon),
        content: Text(l10n.comingSoonMessage),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}