import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../l10n/app_localizations.dart';
import '../services/qr_code_service.dart';
import '../models/location.dart';
import 'on_site_order_type_screen.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool _isProcessing = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
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
      body: kIsWeb ? _buildWebFallback(context, l10n) : _buildMobileScanner(context, l10n),
    );
  }

  // Web-Fallback mit Test-Buttons
  Widget _buildWebFallback(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 100,
              color: Colors.blue.shade300,
            ),
            const SizedBox(height: 32),
            Text(
              l10n.webCameraNotSupported,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.useTestButtonsBelow,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            // Test-Buttons für Web (simuliere echte Netlify-URLs)
            Text(
              'Test URLs (replace with your Netlify domain):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            _buildWebTestButton(context, l10n, 'https://your-app.netlify.app?location=berlin-mitte', '🏢 Berlin Mitte'),
            const SizedBox(height: 12),
            _buildWebTestButton(context, l10n, 'https://your-app.netlify.app?location=hamburg-city', '🌊 Hamburg City'),
            const SizedBox(height: 12),
            _buildWebTestButton(context, l10n, 'https://your-app.netlify.app?location=muenchen-center', '🏔️ München Center'),
          ],
        ),
      ),
    );
  }

  Widget _buildWebTestButton(BuildContext context, AppLocalizations l10n, String url, String label) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isProcessing ? null : () => _processQrCode(context, l10n, url),
        icon: Icon(Icons.qr_code_2),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green.shade100,
          foregroundColor: Colors.green.shade800,
          padding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  // Mobile Scanner
  Widget _buildMobileScanner(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: Colors.blue.shade50,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isProcessing) ...[
                  CircularProgressIndicator(color: Colors.blue),
                  const SizedBox(height: 12),
                  Text(l10n.processingQrCode),
                ] else ...[
                  Icon(Icons.qr_code_scanner, size: 32, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    l10n.pointCameraAtQrCode,
                    style: TextStyle(fontSize: 16, color: Colors.blue.shade800),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!_isProcessing && scanData.code != null) {
        _processQrCode(context, AppLocalizations.of(context)!, scanData.code!);
      }
    });
  }

  void _processQrCode(BuildContext context, AppLocalizations l10n, String qrCodeData) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    try {
      // QR-Code verarbeiten
      final Location? location = await QrCodeService.processQrCode(qrCodeData);

      if (location != null && mounted) {
        // Erfolg - Restaurant gefunden
        controller?.pauseCamera();
        
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnSiteOrderTypeScreen(location: location),
          ),
        );
      } else if (mounted) {
        // Fehler - QR-Code nicht gefunden
        _showErrorDialog(context, l10n, 'Restaurant not found for this QR-Code');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog(context, l10n, e.toString());
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showErrorDialog(BuildContext context, AppLocalizations l10n, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Text(l10n.qrCodeInvalid),
          ],
        ),
        content: Text('$error\n\n${l10n.tryAnotherQrCode}'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}