import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/location.dart';
import '../theme/app_theme.dart';
import 'menu_screen.dart';

enum TerminalOrderType {
  dineIn,      // Hier essen
  takeaway,    // Mitnehmen
}

class TerminalOrderScreen extends StatelessWidget {
  final Location location;
  final Function(Locale)? onLanguageChange;

  const TerminalOrderScreen({
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
            _buildLanguageToggle(context),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // Restaurant Info Card
            _buildRestaurantInfoCard(context),
            
            const SizedBox(height: 40),
            
            // Willkommens-Text
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
              'Wählen Sie Ihre Bestellart:',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppTheme.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Hier essen Button
            _buildOrderTypeButton(
              context: context,
              icon: Icons.restaurant,
              title: l10n.dineIn,
              subtitle: l10n.dineInDescription,
              orderType: TerminalOrderType.dineIn,
            ),
            
            const SizedBox(height: 16),
            
            // Mitnehmen Button
            _buildOrderTypeButton(
              context: context,
              icon: Icons.takeout_dining,
              title: l10n.takeaway,
              subtitle: l10n.takeawayDescription,
              orderType: TerminalOrderType.takeaway,
            ),
            
            const Spacer(),
            
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageToggle(BuildContext context) {
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
            onTap: isGerman ? null : () => onLanguageChange!(const Locale('de')),
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
                child: const Text('🇩🇪', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
          
          // Englische Flagge
          InkWell(
            onTap: !isGerman ? null : () => onLanguageChange!(const Locale('en')),
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
                child: const Text('🇬🇧', style: TextStyle(fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantInfoCard(BuildContext context) {
    return Card(
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
            // Restaurant Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.restaurant,
                color: AppTheme.primaryRed,
                size: 32,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Restaurant Name
            Text(
              location.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.grey900,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Address
            Text(
              location.address,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Status Badge - Terminal Ready
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.computer,
                    size: 18,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Terminal bereit',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
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
    required TerminalOrderType orderType,
  }) {
    return Container(
      height: 90,
      child: ElevatedButton(
        onPressed: () => _proceedToMenu(context, orderType),
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
            // Icon Container
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
            
            // Text Content
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.grey900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.grey600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Arrow Icon
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

  void _proceedToMenu(BuildContext context, TerminalOrderType orderType) {
    // Erfolgs-Animation
    _showSuccessAnimation(context, orderType);
  }

  void _showSuccessAnimation(BuildContext context, TerminalOrderType orderType) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Auto-close nach 1.5 Sekunden
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
            _navigateToMenu(context, orderType);
          }
        });

        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success Icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.green.shade700,
                    size: 48,
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Weiter zum Menü...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToMenu(BuildContext context, TerminalOrderType orderType) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(
          location: location,
          orderType: _getOrderTypeString(orderType),
          customerData: _getTerminalCustomerData(orderType),
        ),
      ),
    );
  }

  String _getOrderTypeString(TerminalOrderType orderType) {
    switch (orderType) {
      case TerminalOrderType.dineIn:
        return 'terminal_dine_in';
      case TerminalOrderType.takeaway:
        return 'terminal_takeaway';
    }
  }

  Map<String, dynamic> _getTerminalCustomerData(TerminalOrderType orderType) {
    return {
      'isTerminalOrder': true,
      'restaurantId': location.id,
      'restaurantName': location.name,
      'orderType': _getOrderTypeString(orderType),
      'timestamp': DateTime.now().toIso8601String(),
      'deviceType': 'terminal',
      'requiresContactData': false,
    };
  }
}