import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../models/location.dart';
import 'location_service.dart';

// Device Types für bessere Typisierung
enum DeviceType {
  terminal,    // Restaurant Terminal (in locations.json registriert)
  external,    // Externes Gerät (nicht registriert)
  qrCode,      // QR-Code gescannt (URL Parameter vorhanden)
}

class DeviceDetectionResult {
  final DeviceType deviceType;
  final Location? location;
  final String deviceId;
  final String? qrParameter;

  DeviceDetectionResult({
    required this.deviceType,
    this.location,
    required this.deviceId,
    this.qrParameter,
  });

  bool get isTerminal => deviceType == DeviceType.terminal;
  bool get isExternal => deviceType == DeviceType.external;
  bool get isQrCode => deviceType == DeviceType.qrCode;
}

class DeviceService {
  static const String _deviceIdKey = 'device_id';
  
  /// Intelligente Geräte-Erkennung - Hauptmethode
  static Future<DeviceDetectionResult> detectDeviceType({String? qrParameter}) async {
    final deviceId = await getDeviceId();
    
    // 1. QR-Code Scan hat höchste Priorität
    if (qrParameter != null) {
      final location = await _findLocationByQrParameter(qrParameter);
      return DeviceDetectionResult(
        deviceType: DeviceType.qrCode,
        location: location,
        deviceId: deviceId,
        qrParameter: qrParameter,
      );
    }
    
    // 2. Prüfe ob Gerät als Terminal registriert ist
    final location = await _findLocationByDeviceId(deviceId);
    if (location != null) {
      return DeviceDetectionResult(
        deviceType: DeviceType.terminal,
        location: location,
        deviceId: deviceId,
      );
    }
    
    // 3. Externes Gerät (nicht registriert)
    return DeviceDetectionResult(
      deviceType: DeviceType.external,
      deviceId: deviceId,
    );
  }
  
  /// Findet Location anhand Device-ID
  static Future<Location?> _findLocationByDeviceId(String deviceId) async {
    try {
      final locations = await LocationService.getAllLocations();
      
      for (final location in locations) {
        if (location.isActive && location.registeredDeviceIds.contains(deviceId)) {
          return location;
        }
      }
      return null;
    } catch (e) {
      print('Error finding location by device ID: $e');
      return null;
    }
  }
  
  /// Findet Location anhand QR-Parameter
  static Future<Location?> _findLocationByQrParameter(String qrParameter) async {
    try {
      final locations = await LocationService.getAllLocations();
      
      for (final location in locations) {
        if (!location.isActive) continue;
        
        // Verschiedene Matching-Strategien
        final locationJson = location.toJson();
        
        // 1. Direkter urlParameter Match
        if (locationJson['urlParameter'] == qrParameter) {
          return location;
        }
        
        // 2. ID-basierter Match
        if (location.id.contains(qrParameter.replaceAll('-', '_'))) {
          return location;
        }
        
        // 3. QR-Code Match
        if (location.qrCode.toLowerCase().contains(qrParameter.toLowerCase())) {
          return location;
        }
      }
      return null;
    } catch (e) {
      print('Error finding location by QR parameter: $e');
      return null;
    }
  }
  
  /// Generiert oder lädt eine eindeutige Geräte-ID
  static Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString(_deviceIdKey);
    
    if (deviceId == null) {
      deviceId = await _generateDeviceId();
      await prefs.setString(_deviceIdKey, deviceId);
    }
    
    return deviceId;
  }
  
  /// Generiert eine neue Geräte-ID basierend auf Device-Eigenschaften
  static Future<String> _generateDeviceId() async {
    String deviceInfo = '';
    
    try {
      if (kIsWeb) {
        // Web: Verwende Browser-Eigenschaften
        deviceInfo = '${DateTime.now().millisecondsSinceEpoch}_web';
      } else if (Platform.isAndroid || Platform.isIOS) {
        // Mobile: Verwende Platform-Info + Timestamp
        deviceInfo = '${Platform.operatingSystem}_${DateTime.now().millisecondsSinceEpoch}';
      } else {
        // Desktop: Verwende OS + Timestamp
        deviceInfo = '${Platform.operatingSystem}_${DateTime.now().millisecondsSinceEpoch}';
      }
      
      // Hash erstellen für eindeutige aber anonyme ID
      var bytes = utf8.encode(deviceInfo);
      var digest = sha256.convert(bytes);
      
      return digest.toString().substring(0, 16); // Kurze ID
      
    } catch (e) {
      // Fallback: Zufällige ID
      return DateTime.now().millisecondsSinceEpoch.toString();
    }
  }
  
  /// Setzt eine neue Geräte-ID (für Testing/Reset)
  static Future<void> setDeviceId(String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceIdKey, deviceId);
  }
  
  /// Löscht die gespeicherte Geräte-ID
  static Future<void> clearDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_deviceIdKey);
  }
  
  /// Prüft ob die aktuelle Geräte-ID in der Whitelist steht
  static Future<bool> isRegisteredDevice(List<String> registeredDeviceIds) async {
    final currentDeviceId = await getDeviceId();
    return registeredDeviceIds.contains(currentDeviceId);
  }
  
  /// Legacy-Methode für Rückwärtskompatibilität
  @Deprecated('Use detectDeviceType() instead')
  static Future<Location?> getCurrentLocation() async {
    final deviceId = await getDeviceId();
    return await _findLocationByDeviceId(deviceId);
  }
  
  /// Debug-Informationen für Development
  static Future<Map<String, dynamic>> getDebugInfo() async {
    final deviceId = await getDeviceId();
    final location = await _findLocationByDeviceId(deviceId);
    
    return {
      'deviceId': deviceId,
      'isRegistered': location != null,
      'location': location?.toJson(),
      'platform': kIsWeb ? 'web' : Platform.operatingSystem,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  /// Registriert ein Gerät für Testing (simuliert Terminal)
  static Future<bool> registerDeviceForTesting(String locationId) async {
    try {
      final deviceId = await getDeviceId();
      final locations = await LocationService.getAllLocations();
      
      for (final location in locations) {
        if (location.id == locationId && location.isActive) {
          // In echten Apps: API-Call zur Registrierung
          location.registeredDeviceIds.add(deviceId);
          print('✅ Device $deviceId registered as terminal for ${location.name}');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Error registering device: $e');
      return false;
    }
  }
  
  /// Entfernt Geräteregistrierung für Testing
  static Future<void> unregisterDeviceForTesting() async {
    try {
      final deviceId = await getDeviceId();
      final locations = await LocationService.getAllLocations();
      
      for (final location in locations) {
        location.registeredDeviceIds.remove(deviceId);
      }
      print('✅ Device $deviceId unregistered from all locations');
    } catch (e) {
      print('❌ Error unregistering device: $e');
    }
  }
}