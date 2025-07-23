import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/location.dart';

class MenuScreen extends StatelessWidget {
  final Location location;
  final String orderType;
  final Map<String, dynamic>? customerData;

  const MenuScreen({
    super.key,
    required this.location,
    required this.orderType,
    this.customerData,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${location.name} - Menü'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu,
                size: 100,
                color: Colors.blue.shade300,
              ),
              const SizedBox(height: 24),
              Text(
                'Menü-Ansicht',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Hier würde das Menü angezeigt werden',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Debug-Info für Entwicklung
              if (customerData != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kundendaten erhalten:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('Bestelltyp: $orderType'),
                      Text('E-Mail: ${customerData!['email'] ?? 'N/A'}'),
                      Text('Telefon: ${customerData!['phone'] ?? 'N/A'}'),
                      if (customerData!['street'] != null) ...[
                        Text('Adresse: ${customerData!['street']} ${customerData!['houseNumber']}'),
                        Text('${customerData!['postalCode']} ${customerData!['city']}'),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}