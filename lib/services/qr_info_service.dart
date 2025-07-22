import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/location.dart';
import 'location_service.dart';

class QrInfoService {
  static Map<String, dynamic>? _cachedQrInfo;
  
  /// Lädt QR-Code-Informationen aus der JSON-Datei
  static Future<Map<String, dynamic>> getQrInfo() async {
    if (_cachedQrInfo != null) {
      return _cachedQrInfo!;
    }
    
    try {
      final String response = await rootBundle.loadString('assets/data/qr_info_config.json');
      _cachedQrInfo = json.decode(response);
      return _cachedQrInfo!;
    } catch (e) {
      print('Error loading QR info config: $e');
      return _getDefaultQrInfo();
    }
  }
  
  /// Gibt QR-Code-Texte für die aktuelle Sprache zurück
  static Future<Map<String, String>> getQrInfoTexts(String languageCode) async {
    final qrInfo = await getQrInfo();
    final qrCodeInfo = qrInfo['qrCodeInfo'] ?? {};
    
    return {
      'title': qrCodeInfo['title']?[languageCode] ?? qrCodeInfo['title']?['de'] ?? 'QR-Code am Tisch?',
      'description': qrCodeInfo['description']?[languageCode] ?? qrCodeInfo['description']?['de'] ?? 'Scanne den QR-Code am Tisch.',
      'deviceNotRegisteredHint': qrCodeInfo['deviceNotRegisteredHint']?[languageCode] ?? qrCodeInfo['deviceNotRegisteredHint']?['de'] ?? 'Tipp: Scanne den QR-Code am Tisch.',
    };
  }
  
  /// Gibt QR-Code-Schritte für die aktuelle Sprache zurück
  static Future<List<Map<String, String>>> getQrInfoSteps(String languageCode) async {
    final qrInfo = await getQrInfo();
    final steps = qrInfo['qrCodeInfo']?['steps'] as List<dynamic>? ?? [];
    
    return steps.map((step) => {
      'icon': step['icon']?.toString() ?? 'help',
      'text': step['text']?[languageCode]?.toString() ?? step['text']?['de']?.toString() ?? 'Schritt',
    }).toList();
  }
  
  /// Generiert QR-Code-URL für eine Location basierend auf JSON-Konfiguration
  static Future<String> generateQrCodeUrl(String locationParameter) async {
    final qrInfo = await getQrInfo();
    final baseUrl = qrInfo['baseUrl']?.toString() ?? 'https://mrribsorderapp.netlify.app';
    final urlParam = qrInfo['urlParameter']?.toString() ?? 'location';
    
    return '$baseUrl?$urlParam=$locationParameter';
  }
  
  /// Gibt alle QR-Code-URLs für alle Locations zurück
  static Future<Map<String, String>> getAllQrCodeUrls() async {
    final locations = await LocationService.getAllLocations();
    final qrUrls = <String, String>{};
    
    for (final location in locations) {
      if (location.isActive) {
        // Prüfe ob Location bereits qrCodeDirectUrl hat
        if (location.toJson().containsKey('qrCodeDirectUrl')) {
          final locationJson = location.toJson();
          qrUrls[location.name] = locationJson['qrCodeDirectUrl'] ?? await generateQrCodeUrl(locationJson['urlParameter'] ?? location.id);
        } else {
          // Fallback: Generiere URL basierend auf ID
          final urlParam = _extractUrlParameter(location.id);
          qrUrls[location.name] = await generateQrCodeUrl(urlParam);
        }
      }
    }
    
    return qrUrls;
  }
  
  /// Extrahiert URL-Parameter aus Location-ID
  static String _extractUrlParameter(String locationId) {
    // Wandelt "mr_ribs_berlin_mitte" in "berlin-mitte" um
    if (locationId.startsWith('mr_ribs_')) {
      return locationId.substring(8).replaceAll('_', '-');
    }
    return locationId.replaceAll('_', '-');
  }
  
  /// Findet Location anhand URL-Parameter
  static Future<Location?> findLocationByUrlParameter(String urlParameter) async {
    final locations = await LocationService.getAllLocations();
    
    for (final location in locations) {
      if (!location.isActive) continue;
      
      // Prüfe verschiedene Matching-Strategien
      final locationJson = location.toJson();
      
      // 1. Direkter urlParameter Match
      if (locationJson['urlParameter'] == urlParameter) {
        return location;
      }
      
      // 2. Extrahierter Parameter aus ID
      final extractedParam = _extractUrlParameter(location.id);
      if (extractedParam == urlParameter) {
        return location;
      }
      
      // 3. ID-basierter Match
      if (location.id.contains(urlParameter.replaceAll('-', '_'))) {
        return location;
      }
    }
    
    return null;
  }
  
  /// Standard-Fallback-Konfiguration
  static Map<String, dynamic> _getDefaultQrInfo() {
    return {
      'qrCodeInfo': {
        'title': {
          'de': 'QR-Code am Tisch?',
          'en': 'QR-Code at the table?'
        },
        'description': {
          'de': 'Scanne den QR-Code am Tisch mit deiner normalen Kamera-App.',
          'en': 'Scan the QR-Code at the table with your normal camera app.'
        },
        'steps': [
          {
            'icon': 'camera_alt',
            'text': {
              'de': 'Kamera-App öffnen',
              'en': 'Open camera app'
            }
          },
          {
            'icon': 'qr_code_scanner',
            'text': {
              'de': 'QR-Code scannen',
              'en': 'Scan QR-Code'
            }
          },
          {
            'icon': 'launch',
            'text': {
              'de': 'Link antippen',
              'en': 'Tap the link'
            }
          }
        ],
        'deviceNotRegisteredHint': {
          'de': 'Tipp: Scanne den QR-Code am Tisch mit deiner Kamera-App',
          'en': 'Tip: Scan the QR-Code at the table with your camera app'
        }
      },
      'baseUrl': 'https://mrribsorderapp.netlify.app',
      'urlParameter': 'location'
    };
  }
  
  /// Cache leeren
  static void clearCache() {
    _cachedQrInfo = null;
  }
}
