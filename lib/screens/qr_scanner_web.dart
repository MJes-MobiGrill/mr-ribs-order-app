// lib/screens/qr_scanner_web.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../l10n/app_localizations.dart';
import '../services/qr_code_service.dart';
import '../models/location.dart';
import 'on_site_order_type_screen.dart';

class QrScannerWeb extends StatefulWidget {
  const QrScannerWeb({super.key});

  @override
  State<QrScannerWeb> createState() => _QrScannerWebState();
}

class _QrScannerWebState extends State<QrScannerWeb> {
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _checkWebUrl();
  }

  // Prüfe Web-URL für direkte QR-Code Navigation
  void _checkWebUrl() {
    try {
      final currentUrl = Uri.base;
      final locationParam = currentUrl.queryParameters['location'];
      
      if (locationParam != null) {
        _processLocationParam(locationParam);
      }
    } catch (e) {
      print('Error checking web URL: $e');
    }
  }

  Future<void> _processLocationParam(String locationParam) async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Simuliere QR-Code URL für Location Parameter
      final qrUrl = 'https://mrribsorderapp.netlify.app?location=$locationParam';
      final Location? location = await QrCodeService.processQrCode(qrUrl);

      if (location != null && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnSiteOrderTypeScreen(location: location),
          ),
        );
      } else if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanQrCode),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isProcessing ? _buildProcessingView(l10n) : _buildWebInterface(context, l10n),
    );
  }

  Widget _buildProcessingView(AppLocalizations l10n) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Colors.blue),
            const SizedBox(height: 24),
            Text(
              l10n.processingQrCode,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebInterface(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // QR-Code Icon mit Animation
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.8, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Icon(
                    Icons.qr_code_scanner,
                    size: 120,
                    color: Colors.blue.shade300,
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Hauptnachricht
            Text(
              'QR-Code Scanner',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Verwende dein Smartphone um QR-Codes zu scannen',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 40),
            
            // Test-Links für Entwicklung
            if (Uri.base.host.contains('localhost') || Uri.base.host.contains('127.0.0.1')) ...[
              _buildTestSection(),
              const SizedBox(height: 32),
            ],
            
            // Info-Box
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade600,
                    size: 32,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'QR-Code-Scanning ist auf Mobile-Geräten verfügbar',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Öffne diese App auf deinem Smartphone für das beste Erlebnis',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade300),
                    ),
                    child: Text(
                      'https://mrribsorderapp.netlify.app',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Zurück Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: Text(l10n.backToMenu),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bug_report, color: Colors.orange.shade600, size: 20),
              const SizedBox(width: 8),
              Text(
                'Development Test Links',
                style: TextStyle(
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTestLocationButton('Berlin Mitte', 'berlin-mitte'),
          const SizedBox(height: 8),
          _buildTestLocationButton('Hamburg City', 'hamburg-city'),
          const SizedBox(height: 8),
          _buildTestLocationButton('München Center', 'muenchen-center'),
        ],
      ),
    );
  }

  Widget _buildTestLocationButton(String name, String locationParam) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _processLocationParam(locationParam),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade100,
          foregroundColor: Colors.orange.shade800,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text('Test: $name'),
      ),
    );
  }
}