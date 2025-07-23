import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';

class DeliveryAddressWidget extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController houseNumberController;
  final TextEditingController postalCodeController;
  final TextEditingController cityController;

  const DeliveryAddressWidget({
    super.key,
    required this.streetController,
    required this.houseNumberController,
    required this.postalCodeController,
    required this.cityController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.deliveryAddress,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Straße und Hausnummer
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Straße
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: streetController,
                decoration: InputDecoration(
                  labelText: l10n.streetRequired,
                  hintText: l10n.streetHint,
                  prefixIcon: const Icon(Icons.home),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterStreet;
                  }
                  return null;
                },
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Hausnummer
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: houseNumberController,
                decoration: InputDecoration(
                  labelText: l10n.houseNumberRequired,
                  hintText: l10n.houseNumberHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.number;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // PLZ und Stadt
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PLZ
            SizedBox(
              width: 120,
              child: TextFormField(
                controller: postalCodeController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
                decoration: InputDecoration(
                  labelText: l10n.postalCodeRequired,
                  hintText: l10n.postalCodeHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.postalCode;
                  }
                  if (value.length != 5) {
                    return l10n.invalid;
                  }
                  return null;
                },
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Stadt
            Expanded(
              child: TextFormField(
                controller: cityController,
                decoration: InputDecoration(
                  labelText: l10n.cityRequired,
                  hintText: l10n.cityHint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterCity;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}