import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/location.dart';

class GeocodingService {
  static const String _nominatimBaseUrl = 'https://nominatim.openstreetmap.org';
  static const double _defaultDeliveryRadiusKm = 5.0; // 5km Standard-Lieferradius
  
  /// Geocodiert eine Adresse zu Koordinaten
  static Future<GeocodingResult?> geocodeAddress({
    required String street,
    required String houseNumber,
    required String postalCode,
    required String city,
    String country = 'Germany',
  }) async {
    try {
      // Erstelle Adress-String
      final address = '$street $houseNumber, $postalCode $city, $country';
      
      // Nominatim API-Call
      final uri = Uri.parse('$_nominatimBaseUrl/search').replace(
        queryParameters: {
          'q': address,
          'format': 'json',
          'limit': '1',
          'countrycodes': 'de', // Beschränke auf Deutschland
          'addressdetails': '1',
        },
      );
      
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MrRibsOrderApp/1.0', // Nominatim erfordert User-Agent
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        
        if (results.isNotEmpty) {
          final result = results.first;
          
          return GeocodingResult(
            latitude: double.parse(result['lat']),
            longitude: double.parse(result['lon']),
            displayName: result['display_name'],
            address: AddressDetails.fromJson(result['address'] ?? {}),
          );
        }
      }
      
      return null;
    } catch (e) {
      print('Geocoding error: $e');
      return null;
    }
  }
  
  /// Prüft ob eine Adresse im Lieferradius eines Restaurants liegt
  static Future<DeliveryValidationResult> validateDeliveryAddress({
    required String street,
    required String houseNumber,
    required String postalCode,
    required String city,
    required Location restaurant,
    double? customRadiusKm,
  }) async {
    try {
      // Geocodiere die Adresse
      final geocodingResult = await geocodeAddress(
        street: street,
        houseNumber: houseNumber,
        postalCode: postalCode,
        city: city,
      );
      
      if (geocodingResult == null) {
        return DeliveryValidationResult(
          isValid: false,
          isInDeliveryRadius: false,
          errorMessage: 'Adresse konnte nicht gefunden werden. Bitte überprüfen Sie Ihre Eingabe.',
        );
      }
      
      // Berechne Distanz zum Restaurant
      final distance = calculateDistance(
        lat1: restaurant.coordinates.latitude,
        lon1: restaurant.coordinates.longitude,
        lat2: geocodingResult.latitude,
        lon2: geocodingResult.longitude,
      );
      
      final deliveryRadius = customRadiusKm ?? _defaultDeliveryRadiusKm;
      final isInRadius = distance <= deliveryRadius;
      
      return DeliveryValidationResult(
        isValid: true,
        isInDeliveryRadius: isInRadius,
        distance: distance,
        geocodingResult: geocodingResult,
        errorMessage: isInRadius 
            ? null 
            : 'Die Adresse liegt außerhalb unseres Liefergebiets (${deliveryRadius.toStringAsFixed(1)} km). Ihre Entfernung: ${distance.toStringAsFixed(1)} km.',
      );
      
    } catch (e) {
      print('Delivery validation error: $e');
      return DeliveryValidationResult(
        isValid: false,
        isInDeliveryRadius: false,
        errorMessage: 'Fehler bei der Adressvalidierung. Bitte versuchen Sie es später erneut.',
      );
    }
  }
  
  /// Berechnet die Distanz zwischen zwei Koordinaten in Kilometern (Haversine-Formel)
  static double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadiusKm = 6371.0;
    
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);
    
    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
        sin(dLon / 2) * sin(dLon / 2);
    
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadiusKm * c;
  }
  
  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
  
  /// Gibt eine Liste von Vorschlägen für eine Teiladresse zurück
  static Future<List<AddressSuggestion>> getSuggestions({
    required String query,
    String? postalCode,
  }) async {
    try {
      if (query.length < 3) return [];
      
      final uri = Uri.parse('$_nominatimBaseUrl/search').replace(
        queryParameters: {
          'q': postalCode != null ? '$query, $postalCode' : query,
          'format': 'json',
          'limit': '5',
          'countrycodes': 'de',
          'addressdetails': '1',
        },
      );
      
      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'MrRibsOrderApp/1.0',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> results = json.decode(response.body);
        
        return results.map((result) => AddressSuggestion(
          displayName: result['display_name'],
          street: result['address']?['road'] ?? '',
          houseNumber: result['address']?['house_number'] ?? '',
          postalCode: result['address']?['postcode'] ?? '',
          city: result['address']?['city'] ?? 
                result['address']?['town'] ?? 
                result['address']?['village'] ?? '',
        )).toList();
      }
      
      return [];
    } catch (e) {
      print('Address suggestion error: $e');
      return [];
    }
  }
}

/// Ergebnis der Geocodierung
class GeocodingResult {
  final double latitude;
  final double longitude;
  final String displayName;
  final AddressDetails address;

  GeocodingResult({
    required this.latitude,
    required this.longitude,
    required this.displayName,
    required this.address,
  });
}

/// Adress-Details von Nominatim
class AddressDetails {
  final String? houseNumber;
  final String? road;
  final String? postcode;
  final String? city;
  final String? state;
  final String? country;

  AddressDetails({
    this.houseNumber,
    this.road,
    this.postcode,
    this.city,
    this.state,
    this.country,
  });

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
      houseNumber: json['house_number'],
      road: json['road'],
      postcode: json['postcode'],
      city: json['city'] ?? json['town'] ?? json['village'],
      state: json['state'],
      country: json['country'],
    );
  }
}

/// Ergebnis der Liefervalidierung
class DeliveryValidationResult {
  final bool isValid;
  final bool isInDeliveryRadius;
  final double? distance;
  final GeocodingResult? geocodingResult;
  final String? errorMessage;

  DeliveryValidationResult({
    required this.isValid,
    required this.isInDeliveryRadius,
    this.distance,
    this.geocodingResult,
    this.errorMessage,
  });
}

/// Adress-Vorschlag für Autovervollständigung
class AddressSuggestion {
  final String displayName;
  final String street;
  final String houseNumber;
  final String postalCode;
  final String city;

  AddressSuggestion({
    required this.displayName,
    required this.street,
    required this.houseNumber,
    required this.postalCode,
    required this.city,
  });
}