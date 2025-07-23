import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/dual_language_button.dart';
import '../theme/app_theme.dart';
import 'location_selection_screen.dart';
import 'delivery_address_check_screen.dart';

class OnlineOrderTypeScreen extends StatelessWidget {
  final Function(Locale)? onLanguageChange;

  const OnlineOrderTypeScreen({
    super.key,
    this.onLanguageChange,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
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
            const SizedBox(height: 40),
            
            // Logo und Titel nebeneinander
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/Logo_inapp.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        size: 40,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
                
                const SizedBox(width: 24),
                
                // Titel
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.orderOnline,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppTheme.grey900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.selectConsumptionType,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Buttons
            _buildOrderTypeButton(
              context: context,
              icon: Icons.restaurant,
              title: l10n.dineIn,
              subtitle: l10n.dineInDescription,
              onTap: () => _selectOrderType(context, 'dine_in'),
            ),
            
            const SizedBox(height: 12),
            
            _buildOrderTypeButton(
              context: context,
              icon: Icons.takeout_dining,
              title: l10n.takeaway,
              subtitle: l10n.takeawayDescription,
              onTap: () => _selectOrderType(context, 'takeaway'),
            ),
            
            const SizedBox(height: 12),
            
            _buildOrderTypeButton(
              context: context,
              icon: Icons.delivery_dining,
              title: l10n.delivery ?? 'Lieferung',
              subtitle: l10n.deliveryDescription ?? 'Lieferung nach Hause',
              onTap: () => _selectOrderType(context, 'delivery'),
            ),
            
            const SizedBox(height: 12),
            
            _buildOrderTypeButton(
              context: context,
              icon: Icons.event_seat,
              title: l10n.reserveTable,
              subtitle: l10n.reserveTableDescription,
              onTap: () => _selectOrderType(context, 'reservation'),
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
                      'Online-Bestellung: Wählen Sie Ihren gewünschten Service.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 80),
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
    return Container(
      height: 80,
      child: ElevatedButton(
        onPressed: onTap,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppTheme.grey100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 26,
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
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.grey400,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _selectOrderType(BuildContext context, String orderType) {
    if (orderType == 'delivery') {
      // Bei Lieferung erst Adresse prüfen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DeliveryAddressCheckScreen(),
        ),
      );
    } else {
      // Alle anderen direkt zur Restaurant-Auswahl
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LocationSelectionScreen(
            orderType: orderType,
          ),
        ),
      );
    }
  }
}