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
      if (url.contains('mrribsorderapp.netlify.app') && url.contains('location=')) {
        final uri = Uri.parse(url);
        final locationParam = uri.queryParameters['location'];
        if (locationParam != null) {
          return 'mr_ribs_${locationParam.replaceAll('-', '_')}';
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Validiert QR-Code Format (Code oder URL)
  static bool isValidQrCodeFormat(String qrCodeText) {
    // Mr. Ribs QR-Codes oder URLs
    return qrCodeText.startsWith('MRRIBS_') || 
           qrCodeText.contains('mrribsorderapp.netlify.app') ||
           qrCodeText.startsWith('https://');
  }
}