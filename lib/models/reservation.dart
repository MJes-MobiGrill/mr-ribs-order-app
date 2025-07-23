class Reservation {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final DateTime reservationDate;
  final String timeSlot;
  final int numberOfGuests;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final DateTime createdAt;
  final String? specialRequests;

  Reservation({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.reservationDate,
    required this.timeSlot,
    required this.numberOfGuests,
    this.status = 'pending',
    required this.createdAt,
    this.specialRequests,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      customerName: json['customerName'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      reservationDate: DateTime.parse(json['reservationDate']),
      timeSlot: json['timeSlot'] ?? '',
      numberOfGuests: json['numberOfGuests'] ?? 1,
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['createdAt']),
      specialRequests: json['specialRequests'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'reservationDate': reservationDate.toIso8601String(),
      'timeSlot': timeSlot,
      'numberOfGuests': numberOfGuests,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'specialRequests': specialRequests,
    };
  }

  String get formattedDate {
    final months = [
      '', 'Jan', 'Feb', 'Mär', 'Apr', 'Mai', 'Jun',
      'Jul', 'Aug', 'Sep', 'Okt', 'Nov', 'Dez'
    ];
    
    return '${reservationDate.day}. ${months[reservationDate.month]} ${reservationDate.year}';
  }

  String get formattedDateTime {
    return '$formattedDate um $timeSlot';
  }
}

// Model für Restaurant-Auslastung
class RestaurantUtilization {
  final String restaurantId;
  final DateTime date;
  final Map<String, int> timeSlots; // timeSlot -> verfügbare Tische
  final int maxTables;

  RestaurantUtilization({
    required this.restaurantId,
    required this.date,
    required this.timeSlots,
    required this.maxTables,
  });

  factory RestaurantUtilization.fromJson(Map<String, dynamic> json) {
    return RestaurantUtilization(
      restaurantId: json['restaurantId'] ?? '',
      date: DateTime.parse(json['date']),
      timeSlots: Map<String, int>.from(json['timeSlots'] ?? {}),
      maxTables: json['maxTables'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'restaurantId': restaurantId,
      'date': date.toIso8601String().split('T')[0], // Nur Datum
      'timeSlots': timeSlots,
      'maxTables': maxTables,
    };
  }

  bool isTimeSlotAvailable(String timeSlot) {
    return (timeSlots[timeSlot] ?? 0) > 0;
  }

  int getAvailableTables(String timeSlot) {
    return timeSlots[timeSlot] ?? 0;
  }
}