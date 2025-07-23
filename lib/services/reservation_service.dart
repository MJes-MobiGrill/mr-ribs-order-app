import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reservation.dart';
import '../models/location.dart';
import '../models/time_slot.dart';

class ReservationService {
  static const String _reservationsKey = 'reservations';
  static const String _utilizationKey = 'utilization';
  
  /// Generiert verfügbare Zeitslots basierend auf Öffnungszeiten
  static Future<List<TimeSlot>> generateTimeSlots(
    Location restaurant,
    DateTime date,
  ) async {
    try {
      // Lade Zeitslot-Konfiguration
      final String response = await rootBundle.loadString('assets/data/reservation_time_slots.json');
      final Map<String, dynamic> config = json.decode(response);
      final slotConfig = config['reservationTimeSlots'];
      
      // Bestimme Wochentag
      final weekday = _getWeekdayName(date.weekday);
      final openingHours = _getOpeningHoursForDay(restaurant.restaurantInfo.openingHours, weekday);
      
      if (openingHours == 'Closed' || openingHours == 'Geschlossen') {
        return [];
      }
      
      // Parse Öffnungszeiten
      final parts = openingHours.split('-');
      if (parts.length != 2) return [];
      
      final openTime = _parseTime(parts[0].trim());
      final closeTime = _parseTime(parts[1].trim());
      
      if (openTime == null || closeTime == null) return [];
      
      // Generiere Slots
      final slots = <TimeSlot>[];
      final slotDuration = slotConfig['slotDuration'] as int;
      final toleranceMinutes = slotConfig['toleranceMinutes'] as int;
      final lastReservationMinutes = slotConfig['lastReservationBeforeClosing'] as int;
      
      var currentTime = openTime;
      final lastPossibleTime = closeTime.subtract(Duration(minutes: lastReservationMinutes));
      
      while (currentTime.isBefore(lastPossibleTime) || currentTime.isAtSameMomentAs(lastPossibleTime)) {
        final endTime = currentTime.add(Duration(minutes: toleranceMinutes));
        
        slots.add(TimeSlot(
          startTime: _formatTime(currentTime),
          endTime: _formatTime(endTime),
          isAvailable: true,
        ));
        
        currentTime = currentTime.add(Duration(minutes: slotDuration));
      }
      
      // Filter vergangene Zeiten für heutiges Datum
      if (_isToday(date)) {
        final now = DateTime.now();
        slots.removeWhere((slot) {
          final slotTime = _parseTime(slot.startTime);
          if (slotTime == null) return true;
          
          final slotDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            slotTime.hour,
            slotTime.minute,
          );
          
          // Mindestens 2 Stunden Vorlaufzeit
          return slotDateTime.isBefore(now.add(const Duration(hours: 2)));
        });
      }
      
      return slots;
    } catch (e) {
      print('Error generating time slots: $e');
      return [];
    }
  }
  
  static String _getWeekdayName(int weekday) {
    const days = [
      'monday', 'tuesday', 'wednesday', 'thursday', 
      'friday', 'saturday', 'sunday'
    ];
    return days[weekday - 1];
  }
  
  static String _getOpeningHoursForDay(OpeningHours hours, String day) {
    switch (day) {
      case 'monday': return hours.monday;
      case 'tuesday': return hours.tuesday;
      case 'wednesday': return hours.wednesday;
      case 'thursday': return hours.thursday;
      case 'friday': return hours.friday;
      case 'saturday': return hours.saturday;
      case 'sunday': return hours.sunday;
      default: return 'Closed';
    }
  }
  
  static DateTime? _parseTime(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length != 2) return null;
      
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }
  
  static String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  static bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }
  
  /// Erstellt eine neue Reservierung
  static Future<Reservation> createReservation({
    required Location restaurant,
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required DateTime reservationDate,
    required String timeSlot,
    required int numberOfGuests,
    String? specialRequests,
  }) async {
    // Generiere eindeutige ID
    final reservationId = _generateReservationId();
    
    final reservation = Reservation(
      id: reservationId,
      restaurantId: restaurant.id,
      restaurantName: restaurant.name,
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      reservationDate: reservationDate,
      timeSlot: timeSlot,
      numberOfGuests: numberOfGuests,
      createdAt: DateTime.now(),
      specialRequests: specialRequests,
    );
    
    // Speichere Reservierung
    await _saveReservation(reservation);
    
    // Update Restaurant-Auslastung
    await _updateUtilization(restaurant, reservationDate, timeSlot);
    
    print('✅ Reservation created: ${reservation.id} for ${restaurant.name}');
    return reservation;
  }
  
  /// Lädt alle Reservierungen
  static Future<List<Reservation>> getAllReservations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reservationsJson = prefs.getStringList(_reservationsKey) ?? [];
      
      return reservationsJson
          .map((json) => Reservation.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error loading reservations: $e');
      return [];
    }
  }
  
  /// Lädt Reservierungen für ein Restaurant
  static Future<List<Reservation>> getReservationsByRestaurant(String restaurantId) async {
    final allReservations = await getAllReservations();
    return allReservations
        .where((reservation) => reservation.restaurantId == restaurantId)
        .toList();
  }
  
  /// Prüft Verfügbarkeit für Restaurant an einem Datum
  static Future<Map<String, int>> getAvailableTimeSlots(
    Location restaurant, 
    DateTime date
  ) async {
    try {
      // Lade verfügbare Zeitslots aus JSON
      final timeSlots = await _loadDefaultTimeSlots();
      
      // Lade aktuelle Auslastung
      final utilization = await _getUtilization(restaurant.id, date);
      
      // Berechne verfügbare Tische pro Zeitslot
      final availableSlots = <String, int>{};
      
      for (final slot in timeSlots) {
        final maxTables = restaurant.restaurantInfo.maxTables;
        final reservedTables = utilization?.getAvailableTables(slot) ?? 0;
        final availableTables = maxTables - reservedTables;
        
        availableSlots[slot] = availableTables > 0 ? availableTables : 0;
      }
      
      return availableSlots;
    } catch (e) {
      print('Error getting available time slots: $e');
      return {};
    }
  }
  
  /// Speichert eine Reservierung
  static Future<void> _saveReservation(Reservation reservation) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final reservationsJson = prefs.getStringList(_reservationsKey) ?? [];
      
      reservationsJson.add(jsonEncode(reservation.toJson()));
      await prefs.setStringList(_reservationsKey, reservationsJson);
    } catch (e) {
      print('Error saving reservation: $e');
      throw Exception('Fehler beim Speichern der Reservierung');
    }
  }
  
  /// Lädt Standard-Zeitslots aus JSON
  static Future<List<String>> _loadDefaultTimeSlots() async {
    try {
      final String response = await rootBundle.loadString('assets/data/time_slots.json');
      final Map<String, dynamic> data = json.decode(response);
      final List<dynamic> pickupSlots = data['pickup']?['slots'] ?? [];
      
      return pickupSlots
          .map((slot) => slot['value']?.toString() ?? '')
          .where((value) => value.isNotEmpty && value != 'asap')
          .toList();
    } catch (e) {
      print('Error loading time slots: $e');
      // Fallback-Zeitslots
      return ['18:00', '18:30', '19:00', '19:30', '20:00', '20:30'];
    }
  }
  
  /// Lädt Auslastungsdaten für Restaurant und Datum
  static Future<RestaurantUtilization?> _getUtilization(String restaurantId, DateTime date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final utilizationJson = prefs.getStringList(_utilizationKey) ?? [];
      
      final dateString = date.toIso8601String().split('T')[0];
      
      for (final json in utilizationJson) {
        final utilization = RestaurantUtilization.fromJson(jsonDecode(json));
        if (utilization.restaurantId == restaurantId && 
            utilization.date.toIso8601String().split('T')[0] == dateString) {
          return utilization;
        }
      }
      
      return null;
    } catch (e) {
      print('Error getting utilization: $e');
      return null;
    }
  }
  
  /// Aktualisiert Auslastungsdaten nach einer Reservierung
  static Future<void> _updateUtilization(Location restaurant, DateTime date, String timeSlot) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final utilizationJson = prefs.getStringList(_utilizationKey) ?? [];
      
      final dateString = date.toIso8601String().split('T')[0];
      RestaurantUtilization? existingUtilization;
      int existingIndex = -1;
      
      // Suche existierende Auslastung
      for (int i = 0; i < utilizationJson.length; i++) {
        final utilization = RestaurantUtilization.fromJson(jsonDecode(utilizationJson[i]));
        if (utilization.restaurantId == restaurant.id && 
            utilization.date.toIso8601String().split('T')[0] == dateString) {
          existingUtilization = utilization;
          existingIndex = i;
          break;
        }
      }
      
      // Erstelle oder aktualisiere Auslastung
      if (existingUtilization != null) {
        // Erhöhe reservierte Tische für den Zeitslot
        final currentReserved = existingUtilization.timeSlots[timeSlot] ?? 0;
        existingUtilization.timeSlots[timeSlot] = currentReserved + 1;
        
        utilizationJson[existingIndex] = jsonEncode(existingUtilization.toJson());
      } else {
        // Erstelle neue Auslastung
        final newUtilization = RestaurantUtilization(
          restaurantId: restaurant.id,
          date: date,
          timeSlots: {timeSlot: 1},
          maxTables: restaurant.restaurantInfo.maxTables,
        );
        
        utilizationJson.add(jsonEncode(newUtilization.toJson()));
      }
      
      await prefs.setStringList(_utilizationKey, utilizationJson);
    } catch (e) {
      print('Error updating utilization: $e');
    }
  }
  
  /// Generiert eine eindeutige Reservierungs-ID
  static String _generateReservationId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 10000).toString().padLeft(4, '0');
    return 'RSV$timestamp$random';
  }
  
  /// Debug: Zeigt alle gespeicherten Daten
  static Future<Map<String, dynamic>> getDebugInfo() async {
    final reservations = await getAllReservations();
    final prefs = await SharedPreferences.getInstance();
    final utilizationJson = prefs.getStringList(_utilizationKey) ?? [];
    
    return {
      'reservations_count': reservations.length,
      'reservations': reservations.map((r) => r.toJson()).toList(),
      'utilization_entries': utilizationJson.length,
      'utilization': utilizationJson.map((json) => jsonDecode(json)).toList(),
    };
  }
  
  /// Löscht alle Reservierungsdaten (für Testing)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_reservationsKey);
    await prefs.remove(_utilizationKey);
    print('🧹 All reservation data cleared');
  }
}