// lib/screens/qr_scanner_mobile.dart
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:async';
import '../l10n/app_localizations.dart';
import '../services/qr_code_service.dart';
import '../models/location.dart';
import 'on_site_order_type_screen.dart';

class QrScannerMobile extends StatefulWidget {
  const QrScannerMobile({super.key});

  @override
  State<QrScannerMobile> createState() => _QrScannerMobileState();
}

class _QrScannerMobileState extends State<QrScannerMobile> {
  QRViewController? _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isProcessing = false;
  bool _flashOn = false;

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
          IconButton(
            icon: Icon(
              _flashOn ? Icons.flash_on : Icons.flash_off,
              color: _flashOn ? Colors.yellow : Colors.white,
            ),
            onPressed: () async {
              if (_qrController != null) {
                await _qrController!.toggleFlash();
                setState(() {
                  _flashOn = !_flashOn;
                });
              }
            },
          ),
          // Kamera umschalten
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () async {
              if (_qrController != null) {
                await _qrController!.flipCamera();
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                // QR Scanner View
                QRView(
                  key: _qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: QrScannerOverlayShape(
                    borderColor: _isProcessing ? Colors.green : Colors.blue,
                    borderRadius: 12,
                    borderLength: 30,
                    borderWidth: 5,
                    cutOutSize: MediaQuery.of(context).size.width * 0.8,
                  ),
                  onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
                ),
                
                // Processing Overlay
                if (_isProcessing)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const CircularProgressIndicator(color: Colors.blue),
                            const SizedBox(height: 16),
                            Text(
                              l10n.processingQrCode,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                
                // Scan-Hinweise oben
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      l10n.pointCameraAtQrCode,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Info-Bereich unten
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue.shade50,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isProcessing) ...[
                    Text(
                      l10n.qrCodeValid,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ] else ...[
                    Icon(Icons.qr_code_scanner, size: 32, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      l10n.qrCodeScanHint,
                      style: TextStyle(fontSize: 14, color: Colors.blue.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      _qrController = controller;
    });
    
    controller.scannedDataStream.listen((scanData) {
      if (!_isProcessing && scanData.code != null) {
        _processQrCode(scanData.code!);
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      final l10n = AppLocalizations.of(context)!;
      _showErrorDialog(l10n, l10n.cameraPermissionDenied);
    }
  }

  Future<void> _processQrCode(String qrCode) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final Location? location = await QrCodeService.processQrCode(qrCode);

      if (location != null && mounted) {
        await _qrController?.pauseCamera();
        
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
        
        final l10n = AppLocalizations.of(context)!;
        _showErrorDialog(l10n, l10n.qrCodeErrorMessage);
        
        await Future.delayed(const Duration(seconds: 2));
        await _qrController?.resumeCamera();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        final l10n = AppLocalizations.of(context)!;
        _showErrorDialog(l10n, 'Fehler: $e');
        
        await Future.delayed(const Duration(seconds: 2));
        await _qrController?.resumeCamera();
      }
    }
  }

  void _showErrorDialog(AppLocalizations l10n, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red, size: 28),
            const SizedBox(width: 12),
            Text(l10n.qrCodeInvalid),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(error),
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
    _qrController?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    _qrController?.pauseCamera();
    _qrController?.resumeCamera();
  }
}