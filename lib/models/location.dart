class Location {
  final String id;
  final String name;
  final String address;
  final List<String> registeredDeviceIds;
  final bool isActive;
  final LocationCoordinates coordinates;
  final RestaurantInfo restaurantInfo;
  final String qrCode;
  final String qrCodeUrl;

  Location({
    required this.id,
    required this.name,
    required this.address,
    required this.registeredDeviceIds,
    required this.isActive,
    required this.coordinates,
    required this.restaurantInfo,
    required this.qrCode,
    required this.qrCodeUrl,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      registeredDeviceIds: List<String>.from(json['registeredDeviceIds'] ?? []),
      isActive: json['isActive'] ?? true,
      coordinates: LocationCoordinates.fromJson(json['coordinates'] ?? {}),
      restaurantInfo: RestaurantInfo.fromJson(json['restaurantInfo'] ?? {}),
      qrCode: json['qrCode'] ?? '',
      qrCodeUrl: json['qrCodeUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'registeredDeviceIds': registeredDeviceIds,
      'isActive': isActive,
      'coordinates': coordinates.toJson(),
      'restaurantInfo': restaurantInfo.toJson(),
      'qrCode': qrCode,
      'qrCodeUrl': qrCodeUrl,
    };
  }
}

class LocationCoordinates {
  final double latitude;
  final double longitude;

  LocationCoordinates({
    required this.latitude,
    required this.longitude,
  });

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) {
    return LocationCoordinates(
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class RestaurantInfo {
  final String phone;
  final String email;
  final OpeningHours openingHours;
  final int maxTables;
  final List<String> supportedOrderTypes;

  RestaurantInfo({
    required this.phone,
    required this.email,
    required this.openingHours,
    required this.maxTables,
    required this.supportedOrderTypes,
  });

  factory RestaurantInfo.fromJson(Map<String, dynamic> json) {
    return RestaurantInfo(
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      openingHours: OpeningHours.fromJson(json['openingHours'] ?? {}),
      maxTables: json['maxTables'] ?? 0,
      supportedOrderTypes: List<String>.from(json['supportedOrderTypes'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
      'openingHours': openingHours.toJson(),
      'maxTables': maxTables,
      'supportedOrderTypes': supportedOrderTypes,
    };
  }
}

class OpeningHours {
  final String monday;
  final String tuesday;
  final String wednesday;
  final String thursday;
  final String friday;
  final String saturday;
  final String sunday;

  OpeningHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) {
    return OpeningHours(
      monday: json['monday'] ?? 'Closed',
      tuesday: json['tuesday'] ?? 'Closed',
      wednesday: json['wednesday'] ?? 'Closed',
      thursday: json['thursday'] ?? 'Closed',
      friday: json['friday'] ?? 'Closed',
      saturday: json['saturday'] ?? 'Closed',
      sunday: json['sunday'] ?? 'Closed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': saturday,
      'sunday': sunday,
    };
  }
}