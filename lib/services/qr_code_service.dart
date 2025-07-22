import '../models/location.dart';
import 'location_service.dart';

class QrCodeService {
  /// Sucht Location anhand des QR-Code Texts oder URL
  static Future<Location?> processQrCode(String qrCodeText) async {
    try {
      final List<Location> locations = await LocationService.getAllLocations();
      
      for (Location location in locations) {
        if (!location.isActive) continue;
        
        // Prüfe sowohl QR-Code als auch URL
        if (location.qrCode == qrCodeText || location.qrCodeUrl == qrCodeText) {
          return location;
        }
        
        // Prüfe auch ob die URL-Parameter übereinstimmen
        if (_extractLocationFromUrl(qrCodeText) == location.id) {
          return location;
        }
      }
      
      return null;
      
    } catch (e) {
      print('Error processing QR-Code: $e');
      return null;
    }
  }
  
  /// Extrahiert Location-ID aus einer URL
  static String? _extractLocationFromUrl(String url) {
    try {
      if (url.contains('mrribs.app/qr/')) {
        final parts = url.split('/qr/');
        if (parts.length == 2) {
          final locationPart = parts[1].split('?')[0]; // Entferne Query-Parameter
          return 'mr_ribs_${locationPart.replaceAll('-', '_')}';
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Simuliert QR-Code Scan für Testing (ohne echten Scanner)
  static Future<String> simulateQrCodeScan(String testCode) async {
    // Simuliert Scan-Verzögerung
    await Future.delayed(Duration(milliseconds: 1500));
    return testCode;
  }
  
  /// Validiert QR-Code Format (Code oder URL)
  static bool isValidQrCodeFormat(String qrCodeText) {
    // Mr. Ribs QR-Codes oder URLs
    return qrCodeText.startsWith('MRRIBS_') || 
           qrCodeText.contains('mrribs.app/qr/') ||
           qrCodeText.startsWith('https://');
  }
  
  /// Generiert Test-URL
  static String generateTestUrl(String locationKey) {
    return 'https://mrribs.app/qr/$locationKey';
  }
}