import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/location.dart';

class OnSiteOrderTypeScreen extends StatelessWidget {
  final Location location;

  const OnSiteOrderTypeScreen({
    super.key,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appName),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            
            // Restaurant Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      location.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      location.address,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
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
                color: Colors.blue.shade800,
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
              color: Colors.green,
              onTap: () => _selectConsumptionType(context, 'dine_in'),
            ),
            
            const SizedBox(height: 20),
            
            // Mitnehmen Button
            _buildConsumptionTypeButton(
              context: context,
              icon: Icons.takeout_dining,
              title: l10n.takeaway,
              subtitle: l10n.takeawayDescription,
              color: Colors.orange,
              onTap: () => _selectConsumptionType(context, 'takeaway'),
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
                      l10n.consumptionTypeInfo,
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 13,
                      ),
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

  Widget _buildConsumptionTypeButton({
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
          foregroundColor: color == Colors.green ? Colors.green.shade800 : Colors.orange.shade800,
          elevation: 4,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: color == Colors.green ? Colors.green.shade200 : Colors.orange.shade200,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color == Colors.green ? Colors.green.shade100 : Colors.orange.shade100,
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
              color: color == Colors.green ? Colors.green.shade300 : Colors.orange.shade300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _selectConsumptionType(BuildContext context, String consumptionType) {
    // TODO: Navigation zum Menü-Screen mit gewähltem Typ
    final l10n = AppLocalizations.of(context)!;
    
    String message = consumptionType == 'dine_in' 
        ? '${l10n.dineIn} at ${location.name}'
        : '${l10n.takeaway} from ${location.name}';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message - ${l10n.proceedingToMenu}'),
        backgroundColor: consumptionType == 'dine_in' ? Colors.green : Colors.orange,
        duration: Duration(seconds: 2),
      ),
    );
    
    // Hier würde später die Navigation zum Menü-Screen erfolgen
    // Navigator.push(context, MaterialPageRoute(
    //   builder: (context) => MenuScreen(
    //     location: location,
    //     orderType: consumptionType,
    //   ),
    // ));
  }
}