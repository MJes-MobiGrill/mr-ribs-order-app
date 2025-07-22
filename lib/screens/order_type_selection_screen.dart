import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/device_service.dart';
import '../services/location_service.dart';
import '../services/qr_info_service.dart';
import '../models/location.dart';
import 'on_site_order_type_screen.dart';

class OrderTypeSelectionScreen extends StatefulWidget {
  final Function(Locale) onLanguageChange;

  const OrderTypeSelectionScreen({
    super.key,
    required this.onLanguageChange,
  });

  @override
  State<OrderTypeSelectionScreen> createState() => _OrderTypeSelectionScreenState();
}

class _OrderTypeSelectionScreenState extends State<OrderTypeSelectionScreen> {
  Map<String, String> _qrInfoTexts = {};
  List<Map<String, String>> _qrInfoSteps = [];
  bool _isLoadingQrInfo = true;

  @override
  void initState() {
    super.initState();
    _loadQrInfo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadQrInfo();
  }

  Future<void> _loadQrInfo() async {
    final locale = Localizations.localeOf(context);
    final languageCode = locale.languageCode;
    
    try {
      final texts = await QrInfoService.getQrInfoTexts(languageCode);
      final steps = await QrInfoService.getQrInfoSteps(languageCode);
      
      if (mounted) {
        setState(() {
          _qrInfoTexts = texts;
          _qrInfoSteps = steps;
          _isLoadingQrInfo = false;
        });
      }
    } catch (e) {
      print('Error loading QR info: $e');
      if (mounted) {
        setState(() {
          _isLoadingQrInfo = false;
        });
      }
    }
  }

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
            
            const SizedBox(height: 40),
            
            // QR-Code Info Box (JSON-basiert)
            if (!_isLoadingQrInfo) _buildQrCodeInfoBox(context),
          ],
        ),
      ),
    );
  }

  Widget _buildQrCodeInfoBox(BuildContext context) {
    final title = _qrInfoTexts['title'] ?? 'QR-Code am Tisch?';
    final description = _qrInfoTexts['description'] ?? 'Scanne den QR-Code am Tisch.';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.qr_code_2, color: Colors.green.shade600, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: Colors.green.shade700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildQrInfoSteps(),
        ],
      ),
    );
  }

  List<Widget> _buildQrInfoSteps() {
    return _qrInfoSteps.map((step) {
      final iconName = step['icon'] ?? 'help';
      final text = step['text'] ?? 'Schritt';
      
      IconData icon;
      switch (iconName) {
        case 'camera_alt':
          icon = Icons.camera_alt;
          break;
        case 'qr_code_scanner':
          icon = Icons.qr_code_scanner;
          break;
        case 'launch':
          icon = Icons.launch;
          break;
        default:
          icon = Icons.help;
      }
      
      return Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(
          children: [
            Icon(icon, color: Colors.green.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }).toList();
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
    
    if (currentLocale.languageCode == 'de') {
      return 'Change Language';
    } else {
      return 'Sprache Ändern';
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
              leading: const Text('🇩🇪', style: TextStyle(fontSize: 24)),
              title: Text(l10n.german),
              onTap: () {
                Navigator.pop(context);
                widget.onLanguageChange(const Locale('de', ''));
              },
            ),
            ListTile(
              leading: const Text('🇬🇧', style: TextStyle(fontSize: 24)),
              title: Text(l10n.english),
              onTap: () {
                Navigator.pop(context);
                widget.onLanguageChange(const Locale('en', ''));
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
      final String deviceId = await DeviceService.getDeviceId();
      final Location? currentLocation = await LocationService.getCurrentLocation();
      
      if (currentLocation != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OnSiteOrderTypeScreen(location: currentLocation),
          ),
        );
      } else {
        _showDeviceNotRegisteredDialog(context, l10n, deviceId);
      }
      
    } catch (e) {
      _showErrorDialog(context, l10n, e.toString());
    }
  }

  void _showDeviceNotRegisteredDialog(BuildContext context, AppLocalizations l10n, String deviceId) {
    final hintText = _qrInfoTexts['deviceNotRegisteredHint'] ?? 'Tipp: Scanne den QR-Code am Tisch.';
    
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.qr_code_2, color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hintText,
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
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