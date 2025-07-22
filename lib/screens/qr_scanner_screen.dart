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
        actions: [
          // Flash-Toggle
          if (!kIsWeb)
            IconButton(
              icon: Icon(Icons.flash_on),
              onPressed: () async {
                await controller?.toggleFlash();
              },
            ),
          // Camera-Switch
          if (!kIsWeb)
            IconButton(
              icon: Icon(Icons.flip_camera_ios),
              onPressed: () async {
                await controller?.flipCamera();
              },
            ),
        ],
      ),
      body: kIsWeb ? _buildWebFallback(context, l10n) : _buildMobileScanner(context, l10n),
    );
  }

  // Web-Fallback - nur Info, keine Test-Buttons
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
              l10n.webQrScannerInfo,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
              label: Text(l10n.backToMenu),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Echter Mobile Scanner
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
              cutOutSize: MediaQuery.of(context).size.width * 0.8,
            ),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
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
                  Text(
                    l10n.processingQrCode,
                    style: TextStyle(fontSize: 16, color: Colors.blue.shade800),
                  ),
                ] else ...[
                  Icon(Icons.qr_code_scanner, size: 32, color: Colors.blue),
                  const SizedBox(height: 8),
                  Text(
                    l10n.pointCameraAtQrCode,
                    style: TextStyle(fontSize: 16, color: Colors.blue.shade800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.qrCodeScanHint,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
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
    setState(() {
      this.controller = controller;
    });
    
    controller.scannedDataStream.listen((scanData) {
      if (!_isProcessing && scanData.code != null) {
        _processQrCode(scanData.code!);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.cameraPermissionDenied),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _processQrCode(String qrCodeData) async {
    if (_isProcessing) return;
    
    setState(() {
      _isProcessing = true;
    });

    // Vibrieren/Feedback
    controller?.pauseCamera();

    try {
      final Location? location = await QrCodeService.processQrCode(qrCodeData);

      if (location != null && mounted) {
        // Erfolg - Restaurant gefunden
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnSiteOrderTypeScreen(location: location),
          ),
        );
      } else if (mounted) {
        // Fehler - QR-Code nicht gefunden
        controller?.resumeCamera();
        _showErrorDialog(AppLocalizations.of(context)!, 'Restaurant not found for this QR-Code');
      }
    } catch (e) {
      if (mounted) {
        controller?.resumeCamera();
        _showErrorDialog(AppLocalizations.of(context)!, e.toString());
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showErrorDialog(AppLocalizations l10n, String error) {
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$error'),
            const SizedBox(height: 16),
            Text(
              l10n.tryAnotherQrCode,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
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