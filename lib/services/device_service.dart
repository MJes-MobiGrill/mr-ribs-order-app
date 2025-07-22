import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DeviceService {
  static const String _deviceIdKey = 'device_id';
  
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
}