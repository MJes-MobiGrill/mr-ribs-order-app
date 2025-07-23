import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/location.dart';
import '../widgets/simple_language_button.dart';
import 'data_input_screen.dart';

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
      backgroundColor: const Color(0xFFF8F8F8), // Sehr helles Grau
      appBar: AppBar(
        title: Text(l10n.appName),
        backgroundColor: const Color(0xFF2C2C2C), // Fast Schwarz
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (onLanguageChange != null)
            SimpleAppBarLanguageButton(
              onLanguageChanged: onLanguageChange!,
            ),
        ],
      ),
      floatingActionButton: onLanguageChange != null 
          ? FloatingActionButton.extended(
              onPressed: () => _toggleLanguage(context),
              backgroundColor: const Color(0xFF424242), // Dunkelgrau
              foregroundColor: Colors.white,
              elevation: 2,
              icon: const Icon(Icons.language, size: 20),
              label: Text(_getLanguageButtonText(context)),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // Restaurant Info Card
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: const Color(0xFF8B0000), // Dunkles Rot nur für Akzent
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      location.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF212121), // Fast Schwarz
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.address,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF616161), // Mittelgrau
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Titel
            Text(
              l10n.selectConsumptionType,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF212121),
                fontWeight: FontWeight.bold,
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
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: const Color(0xFF757575),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.consumptionTypeInfo,
                      style: TextStyle(
                        color: const Color(0xFF616161),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 80), // Platz für FloatingActionButton
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
          foregroundColor: const Color(0xFF212121),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 28,
                color: const Color(0xFF424242), // Dunkelgrau
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
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF616161),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _selectConsumptionType(BuildContext context, String consumptionType) {
    // Navigation zum DataInputScreen
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
  
  String _getLanguageButtonText(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    return currentLocale.languageCode == 'de' 
        ? '🇬🇧 English'
        : '🇩🇪 Deutsch';
  }
  
  void _toggleLanguage(BuildContext context) {
    final currentLocale = Localizations.localeOf(context);
    final newLanguage = currentLocale.languageCode == 'de' ? 'en' : 'de';
    onLanguageChange?.call(Locale(newLanguage));
  }
}