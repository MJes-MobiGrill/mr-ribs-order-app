class TimeSlot {
  final String startTime;
  final String endTime;
  final bool isAvailable;
  final int availableTables;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    this.availableTables = 0,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      availableTables: json['availableTables'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startTime': startTime,
      'endTime': endTime,
      'isAvailable': isAvailable,
      'availableTables': availableTables,
    };
  }

  String get displayText => '$startTime - $endTime';
  
  String get displayTimeOnly => startTime;
}