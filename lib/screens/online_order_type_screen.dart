import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../widgets/simple_language_button.dart';

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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          // Sprach-Icon in der AppBar (zeigt aktuelle Sprache)
          if (onLanguageChange != null)
            SimpleAppBarLanguageButton(
              onLanguageChanged: onLanguageChange!,
            ),
        ],
      ),
      // Einfacher schwimmender Button mit Text
      floatingActionButton: onLanguageChange != null 
          ? SimpleFloatingLanguageButton(
              onLanguageChanged: onLanguageChange!,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            
            // Online Order Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Icon(
                Icons.smartphone,
                size: 64,
                color: Colors.blue.shade600,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Titel
            Text(
              l10n.orderOnline,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              l10n.selectConsumptionType,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Vor Ort essen Button
            _buildOrderTypeButton(
              context: context,
              icon: Icons.restaurant,
              title: l10n.dineIn,
              subtitle: l10n.dineInDescription,
              color: Colors.green,
              onTap: () => _selectOrderType(context, 'dine_in'),
            ),
            
            const SizedBox(height: 20),
            
            // Zum Mitnehmen Button
            _buildOrderTypeButton(
              context: context,
              icon: Icons.takeout_dining,
              title: l10n.takeaway,
              subtitle: l10n.takeawayDescription,
              color: Colors.orange,
              onTap: () => _selectOrderType(context, 'takeaway'),
            ),
            
            const SizedBox(height: 20),
            
            // Lieferung Button (zusätzlich für Online)
            _buildOrderTypeButton(
              context: context,
              icon: Icons.delivery_dining,
              title: 'Lieferung', // TODO: Add to localization
              subtitle: 'Lieferung nach Hause', // TODO: Add to localization
              color: Colors.purple,
              onTap: () => _selectOrderType(context, 'delivery'),
            ),
            
            const Spacer(),
            
            // Info Text
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Online-Bestellung: Wählen Sie Ihren gewünschten Service.',
                      style: TextStyle(
                        color: Colors.blue.shade800,
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

  Widget _buildOrderTypeButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 100,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: color == Colors.green 
              ? Colors.green.shade800 
              : color == Colors.orange 
                  ? Colors.orange.shade800 
                  : Colors.purple.shade800,
          elevation: 4,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: color == Colors.green 
                  ? Colors.green.shade200 
                  : color == Colors.orange 
                      ? Colors.orange.shade200 
                      : Colors.purple.shade200,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color == Colors.green 
                    ? Colors.green.shade100 
                    : color == Colors.orange 
                        ? Colors.orange.shade100 
                        : Colors.purple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
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
              color: color == Colors.green 
                  ? Colors.green.shade300 
                  : color == Colors.orange 
                      ? Colors.orange.shade300 
                      : Colors.purple.shade300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _selectOrderType(BuildContext context, String orderType) {
    final l10n = AppLocalizations.of(context)!;
    
    String message;
    Color snackBarColor;
    
    switch (orderType) {
      case 'dine_in':
        message = '${l10n.dineIn} - ${l10n.proceedingToMenu}';
        snackBarColor = Colors.green;
        break;
      case 'takeaway':
        message = '${l10n.takeaway} - ${l10n.proceedingToMenu}';
        snackBarColor = Colors.orange;
        break;
      case 'delivery':
        message = 'Lieferung - ${l10n.proceedingToMenu}';
        snackBarColor = Colors.purple;
        break;
      default:
        message = l10n.proceedingToMenu;
        snackBarColor = Colors.blue;
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: snackBarColor,
        duration: const Duration(seconds: 2),
      ),
    );
    
    // TODO: Navigation zum entsprechenden Screen
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) => MenuScreen(
    //     orderType: orderType,
    //   ),
    // ));
  }
}