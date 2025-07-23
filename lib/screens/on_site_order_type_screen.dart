import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';
import 'data_input_screen.dart';

// Sprachwahl-Widget
class CompactLanguageToggle extends StatelessWidget {
  final Function(Locale) onLanguageChanged;

  const CompactLanguageToggle({
    super.key,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final isGerman = currentLocale.languageCode == 'de';
    
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Deutsche Flagge
          InkWell(
            onTap: isGerman ? null : () => onLanguageChanged(const Locale('de')),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: isGerman ? Colors.white.withOpacity(0.3) : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              child: Opacity(
                opacity: isGerman ? 1.0 : 0.6,
                child: const Text(
                  '🇩🇪',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          
          // Englische Flagge
          InkWell(
            onTap: !isGerman ? null : () => onLanguageChanged(const Locale('en')),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: !isGerman ? Colors.white.withOpacity(0.3) : Colors.transparent,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Opacity(
                opacity: !isGerman ? 1.0 : 0.6,
                child: const Text(
                  '🇬🇧',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnSiteOrderTypeScreen extends StatelessWidget {
  final Location location;
  final Function(Locale)? onLanguageChange;

  const OnSiteOrderTypeScreen({
    super.key,
    required this.location,
    this.onLanguageChange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundGrey,
      appBar: AppBar(
        title: Text(l10n.appName),
        backgroundColor: AppTheme.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          if (onLanguageChange != null)
            CompactLanguageToggle(
              onLanguageChanged: onLanguageChange!,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // QR-Code Scan Bestätigung
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code_scanner,
                    color: Colors.green.shade700,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'QR-Code erkannt!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        Text(
                          'Sie befinden sich bei ${location.name}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Restaurant Info Card
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppTheme.grey300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: AppTheme.primaryRed,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      location.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.grey900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      location.address,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.grey600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Titel
            Text(
              l10n.selectConsumptionType,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppTheme.grey900,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Mit Kontaktdaten bestellen',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // Hier essen Button
            _buildConsumptionTypeButton(
              context: context,
              icon: Icons.restaurant,
              title: l10n.dineIn,
              subtitle: l10n.dineInDescription,
              onTap: () => _selectConsumptionType(context, 'dine_in'),
            ),
            
            const SizedBox(height: 16),
            
            // Mitnehmen Button
            _buildConsumptionTypeButton(
              context: context,
              icon: Icons.takeout_dining,
              title: l10n.takeaway,
              subtitle: l10n.takeawayDescription,
              onTap: () => _selectConsumptionType(context, 'takeaway'),
            ),
            
            const Spacer(),
            
            // Info Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.grey300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.grey600,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'QR-Code-Bestellung: Mit Ihren Kontaktdaten für E-Mail-Bestätigung',
                      style: TextStyle(
                        color: AppTheme.grey600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildConsumptionTypeButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 90,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppTheme.grey900,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppTheme.grey300, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.grey100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 28,
                color: AppTheme.grey700,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.grey900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$subtitle + E-Mail-Bestätigung',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.grey600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.grey400,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _selectConsumptionType(BuildContext context, String consumptionType) {
    // Navigation zum DataInputScreen (MIT Kontaktdaten)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataInputScreen(
          location: location,
          orderType: consumptionType == 'dine_in' ? OrderType.dineIn : OrderType.takeaway,
        ),
      ),
    );
  }
}