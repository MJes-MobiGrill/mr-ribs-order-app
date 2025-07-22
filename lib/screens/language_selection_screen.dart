import 'package:flutter/material.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final Function(Locale) onLanguageSelected;

  const LanguageSelectionScreen({
    super.key,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // App Titel
                Text(
                  'Mr. Ribs',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'Order App',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.blue.shade600,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                // Sprachauswahl Titel
                Text(
                  'Select Language / Sprache auswählen',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 32),
                
                // Sprachbuttons
                Column(
                  children: [
                    _buildLanguageButton(
                      context: context,
                      flagAsset: 'assets/images/flags/de.png',
                      languageName: 'Deutsch',
                      locale: const Locale('de', ''),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    _buildLanguageButton(
                      context: context,
                      flagAsset: 'assets/images/flags/en.png',
                      languageName: 'English',
                      locale: const Locale('en', ''),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton({
    required BuildContext context,
    required String flagAsset,
    required String languageName,
    required Locale locale,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => onLanguageSelected(locale),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.blue.shade800,
          elevation: 4,
          shadowColor: Colors.blue.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(
              color: Colors.blue.shade200,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              flagAsset,
              width: 32,
              height: 24,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 32,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.flag,
                    size: 16,
                    color: Colors.grey,
                  ),
                );
              },
            ),
            const SizedBox(width: 12),
            Text(
              languageName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}