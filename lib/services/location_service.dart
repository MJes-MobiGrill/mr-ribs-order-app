import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/location.dart';
import 'device_service.dart';

class LocationService {
  static List<Location>? _cachedLocations;
  
  /// Lädt alle Standorte aus der JSON-Datei
  static Future<List<Location>> getAllLocations() async {
    if (_cachedLocations != null) {
      return _cachedLocations!;
    }
    
    try {
      final String response = await rootBundle.loadString('assets/data/locations.json');
      final List<dynamic> data = json.decode(response);
      
      _cachedLocations = data.map((json) => Location.fromJson(json)).toList();
      return _cachedLocations!;
      
    } catch (e) {
      print('Error loading locations: $e');
      return [];
    }
  }
  
  /// Sucht den Standort für die aktuelle Geräte-ID
  static Future<Location?> getCurrentLocation() async {
    final String deviceId = await DeviceService.getDeviceId();
    final List<Location> locations = await getAllLocations();
    
    for (Location location in locations) {
      if (location.registeredDeviceIds.contains(deviceId) && location.isActive) {
        return location;
      }
    }
    
    return null;
  }
  
  /// Prüft ob das aktuelle Gerät in einem Restaurant registriert ist
  static Future<bool> isDeviceRegistered() async {
    final Location? location = await getCurrentLocation();
    return location != null;
  }
  
  /// Registriert das aktuelle Gerät für einen Standort (für Testing)
  static Future<bool> registerDeviceForLocation(String locationId) async {
    try {
      final String deviceId = await DeviceService.getDeviceId();
      final List<Location> locations = await getAllLocations();
      
      Location? targetLocation;
      for (Location location in locations) {
        if (location.id == locationId) {
          targetLocation = location;
          break;
        }
      }
      
      if (targetLocation == null) {
        print('Location not found: $locationId');
        return false;
      }
      
      if (!targetLocation.registeredDeviceIds.contains(deviceId)) {
        targetLocation.registeredDeviceIds.add(deviceId);
        // In einer echten App würde hier ein API-Call gemacht
        print('Device $deviceId registered for location ${targetLocation.name}');
        return true;
      }
      
      return false;
    } catch (e) {
      print('Error registering device: $e');
      return false;
    }
  }
  
  /// Entfernt die Geräteregistrierung (für Testing)
  static Future<bool> unregisterDevice() async {
    try {
      final String deviceId = await DeviceService.getDeviceId();
      final List<Location> locations = await getAllLocations();
      
      for (Location location in locations) {
        location.registeredDeviceIds.remove(deviceId);
      }
      
      print('Device $deviceId unregistered from all locations');
      return true;
    } catch (e) {
      print('Error unregistering device: $e');
      return false;
    }
  }
  
  /// Lädt Cache neu
  static void clearCache() {
    _cachedLocations = null;
  }
  
  /// Sucht Standorte nach Name oder Adresse
  static Future<List<Location>> searchLocations(String query) async {
    final List<Location> locations = await getAllLocations();
    
    if (query.isEmpty) return locations;
    
    return locations.where((location) =>
      location.name.toLowerCase().contains(query.toLowerCase()) ||
      location.address.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
  
  /// Gibt aktive Standorte zurück
  static Future<List<Location>> getActiveLocations() async {
    final List<Location> locations = await getAllLocations();
    return locations.where((location) => location.isActive).toList();
  }
}