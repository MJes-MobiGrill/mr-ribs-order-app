import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';

class ContactFormWidget extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final String selectedCountryCode;
  final Function(String) onCountryCodeChanged;

  const ContactFormWidget({
    super.key,
    required this.emailController,
    required this.phoneController,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        // E-Mail Feld
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: l10n.emailRequired,
            hintText: l10n.emailHint,
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return l10n.pleaseEnterEmail;
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(value)) {
              return l10n.pleaseEnterValidEmail;
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // Telefonnummer mit Ländervorwahl
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ländervorwahl Dropdown
            SizedBox(
              width: 100,
              child: DropdownButtonFormField<String>(
                value: selectedCountryCode,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
                items: const [
                  DropdownMenuItem(value: '+49', child: Text('🇩🇪 +49')),
                  DropdownMenuItem(value: '+43', child: Text('🇦🇹 +43')),
                  DropdownMenuItem(value: '+41', child: Text('🇨🇭 +41')),
                  DropdownMenuItem(value: '+31', child: Text('🇳🇱 +31')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    onCountryCodeChanged(value);
                  }
                },
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Telefonnummer Eingabe
            Expanded(
              child: TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                decoration: InputDecoration(
                  labelText: l10n.phoneNumberRequired,
                  hintText: l10n.phoneHint,
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterPhone;
                  }
                  if (value.length < 6) {
                    return l10n.phoneTooShort;
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