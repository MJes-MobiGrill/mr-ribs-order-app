import 'package:flutter/foundation.dart';

class UrlHelper {
  static String? getLocationParameter() {
    if (kIsWeb) {
      // Web: Verwende window.location
      return _getWebLocationParameter();
    }
    return null;
  }

  static String? _getWebLocationParameter() {
    try {
      if (kIsWeb) {
        // Verwende aktuelle URL
        final currentUrl = Uri.base;
        return currentUrl.queryParameters['location'];
      }
      return null;
    } catch (e) {
      print('Error getting URL parameter: $e');
      return null;
    }
  }

  static String generateQrCodeUrl(String baseUrl, String locationKey) {
    return '$baseUrl?location=$locationKey';
  }

  static List<String> getTestUrls(String baseUrl) {
    return [
      generateQrCodeUrl(baseUrl, 'berlin-mitte'),
      generateQrCodeUrl(baseUrl, 'hamburg-city'),
      generateQrCodeUrl(baseUrl, 'muenchen-center'),
    ];
  }
}