import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../l10n/app_localizations.dart';
import '../services/qr_code_service.dart';
import '../models/location.dart';
import 'on_site_order_type_screen.dart';

// Bedingte Imports - nur QR Scanner für Mobile
import 'package:qr_code_scanner/qr_code_scanner.dart' if (dart.library.html) 'dart:html' as qr;

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  // Mobile QR Scanner Controller
  dynamic _qrController;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  bool _isProcessing = false;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _checkWebUrl();
    }
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
        actions: _buildAppBarActions(l10n),
      ),
      body: kIsWeb ? _buildWebInterface(context, l10n) : _buildMobileScanner(context, l10n),
    );
  }

  List<Widget> _buildAppBarActions(AppLocalizations l10n) {
    if (kIsWeb) return [];
    
    return [
      // Flash-Toggle (nur Mobile)
      IconButton(
        icon: Icon(
          _flashOn ? Icons.flash_on : Icons.flash_off,
          color: _flashOn ? Colors.yellow : Colors.white,
        ),
        onPressed: () async {
          try {
            if (_qrController != null) {
              await _qrController.toggleFlash();
              setState(() {
                _flashOn = !_flashOn;
              });
            }
          } catch (e) {
            print('Flash toggle error: $e');
          }
        },
      ),
      // Kamera umschalten (nur Mobile)
      IconButton(
        icon: const Icon(Icons.flip_camera_ios),
        onPressed: () async {
          try {
            if (_qrController != null) {
              await _qrController.flipCamera();
            }
          } catch (e) {
            print('Camera flip error: $e');
          }
        },
      ),
    ];
  }

  Widget _buildWebInterface(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // QR-Code Icon
            Icon(
              Icons.qr_code_scanner,
              size: 120,
              color: Colors.blue.shade300,
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
            if (kDebugMode) ...[
              _buildTestLocationButton('Berlin Mitte', 'berlin-mitte'),
              const SizedBox(height: 12),
              _buildTestLocationButton('Hamburg City', 'hamburg-city'),
              const SizedBox(height: 12),
              _buildTestLocationButton('München Center', 'muenchen-center'),
              const SizedBox(height: 24),
            ],
            
            // Info-Box
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade600,
                    size: 28,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'QR-Code-Scanning ist auf Mobile-Geräten verfügbar',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Öffne diese App auf deinem Smartphone für das beste Erlebnis',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Zurück Button
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
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

  Widget _buildTestLocationButton(String name, String locationParam) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _processLocationParam(locationParam),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade100,
          foregroundColor: Colors.orange.shade800,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text('Test: $name'),
      ),
    );
  }

  Widget _buildMobileScanner(BuildContext context, AppLocalizations l10n) {
    // Dynamischer Import - funktioniert nur auf Mobile
    try {
      return Column(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                // QR Scanner View - nur für Mobile verfügbar
                _buildQRView(),
                
                // Processing Overlay
                if (_isProcessing) _buildProcessingOverlay(l10n),
                
                // Scan-Hinweise
                _buildScanInstructions(l10n),
              ],
            ),
          ),
          
          // Info-Bereich unten
          Expanded(
            flex: 1,
            child: _buildInfoSection(l10n),
          ),
        ],
      );
    } catch (e) {
      // Fallback wenn QR-Scanner nicht verfügbar
      return _buildMobileFallback(context, l10n);
    }
  }

  Widget _buildQRView() {
    try {
      // Nur erstellen wenn nicht auf Web
      if (kIsWeb) throw Exception('Web not supported');
      
      // Dynamische QR-View Erstellung
      return qr.QRView(
        key: _qrKey,
        onQRViewCreated: _onQRViewCreated,
        overlay: qr.QrScannerOverlayShape(
          borderColor: _isProcessing ? Colors.green : Colors.blue,
          borderRadius: 12,
          borderLength: 30,
          borderWidth: 5,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
        onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
      );
    } catch (e) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }
  }

  Widget _buildMobileFallback(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            Text(
              'Kamera nicht verfügbar',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'QR-Code-Scanner benötigt Kamera-Zugriff',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: Text(l10n.backToMenu),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingOverlay(AppLocalizations l10n) {
    return Container(
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
    );
  }

  Widget _buildScanInstructions(AppLocalizations l10n) {
    return Positioned(
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
    );
  }

  Widget _buildInfoSection(AppLocalizations l10n) {
    return Container(
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
    );
  }

  void _onQRViewCreated(dynamic controller) {
    setState(() {
      _qrController = controller;
    });
    
    try {
      controller.scannedDataStream.listen((scanData) {
        if (!_isProcessing && scanData.code != null) {
          _processQrCode(scanData.code!);
        }
      });
    } catch (e) {
      print('QR Controller setup error: $e');
    }
  }

  void _onPermissionSet(BuildContext context, dynamic ctrl, bool permission) {
    if (!permission) {
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
        // Kamera pausieren
        try {
          await _qrController?.pauseCamera();
        } catch (e) {
          print('Pause camera error: $e');
        }
        
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
        
        // Kurz warten vor nächstem Scan
        await Future.delayed(const Duration(seconds: 2));
        try {
          await _qrController?.resumeCamera();
        } catch (e) {
          print('Resume camera error: $e');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
        
        final l10n = AppLocalizations.of(context)!;
        _showErrorDialog(l10n, 'Fehler: $e');
        
        await Future.delayed(const Duration(seconds: 2));
        try {
          await _qrController?.resumeCamera();
        } catch (e) {
          print('Resume camera error: $e');
        }
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
    try {
      _qrController?.dispose();
    } catch (e) {
      print('Dispose error: $e');
    }
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (!kIsWeb) {
      try {
        _qrController?.pauseCamera();
        _qrController?.resumeCamera();
      } catch (e) {
        print('Reassemble error: $e');
      }
    }
  }
}