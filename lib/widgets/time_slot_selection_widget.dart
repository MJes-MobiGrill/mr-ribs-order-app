import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/location.dart';

class ReservationDetailsWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final int guestCount;
  final VoidCallback onDateTap;
  final Location location;
  final Function(String) onTimeSlotSelected;
  final Function(int?) onGuestCountChanged;

  const ReservationDetailsWidget({
    super.key,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.guestCount,
    required this.onDateTap,
    required this.location,
    required this.onTimeSlotSelected,
    required this.onGuestCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.reservationDetails,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Datum und Personenanzahl nebeneinander
        Row(
          children: [
            // Datum Auswahl
            Expanded(
              child: InkWell(
                onTap: onDateTap,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.dateRequired,
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.day}.${selectedDate!.month}.${selectedDate!.year}'
                        : l10n.selectDate,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate != null ? null : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Personenanzahl
            SizedBox(
              width: 140,
              child: DropdownButtonFormField<int>(
                value: guestCount,
                decoration: InputDecoration(
                  labelText: l10n.numberOfGuestsRequired,
                  prefixIcon: const Icon(Icons.group),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: List.generate(20, (i) => i + 1)
                    .map((count) => DropdownMenuItem(
                          value: count,
                          child: Text('$count ${count == 1 ? l10n.guest : l10n.guests}'),
                        ))
                    .toList(),
                onChanged: onGuestCountChanged,
              ),
            ),
          ],
        ),
        
        // Zeit-Auswahl (nur wenn Datum gewählt wurde)
        if (selectedDate != null) ...[
          const SizedBox(height: 24),
          TimeSlotSelector(
            selectedDate: selectedDate!,
            location: location,
            selectedTimeSlot: selectedTimeSlot,
            onTimeSelected: onTimeSlotSelected,
          ),
        ],
      ],
    );
  }
}

// Korrigierte Zeitslot-Auswahl
class TimeSlotSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Location location;
  final Function(String) onTimeSelected;
  final String? selectedTimeSlot;

  const TimeSlotSelector({
    super.key,
    required this.selectedDate,
    required this.location,
    required this.onTimeSelected,
    this.selectedTimeSlot,
  });

  @override
  State<TimeSlotSelector> createState() => _TimeSlotSelectorState();
}

class _TimeSlotSelectorState extends State<TimeSlotSelector> {
  List<String> _availableSlots = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableTimeSlots();
  }

  @override
  void didUpdateWidget(TimeSlotSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      _loadAvailableTimeSlots();
    }
  }

  Future<void> _loadAvailableTimeSlots() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Generiere Standard-Zeitslots basierend auf Öffnungszeiten
      final slots = _generateTimeSlots();
      
      setState(() {
        _availableSlots = slots;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading time slots: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> _generateTimeSlots() {
    final weekday = widget.selectedDate.weekday;
    final openingHours = _getOpeningHoursForDay(weekday);
    
    if (openingHours == 'Closed' || openingHours == 'Geschlossen') {
      return [];
    }
    
    // Parse Öffnungszeiten (Format: "11:00-22:00")
    final parts = openingHours.split('-');
    if (parts.length != 2) return [];
    
    final openTime = _parseTime(parts[0].trim());
    final closeTime = _parseTime(parts[1].trim());
    
    if (openTime == null || closeTime == null) return [];
    
    // Generiere 30-Minuten-Slots
    final slots = <String>[];
    var currentTime = openTime;
    final lastSlotTime = closeTime.subtract(const Duration(hours: 1)); // 1h vor Schluss
    
    while (currentTime.isBefore(lastSlotTime) || currentTime.isAtSameMomentAs(lastSlotTime)) {
      slots.add(_formatTime(currentTime));
      currentTime = currentTime.add(const Duration(minutes: 30));
    }
    
    // Filter vergangene Zeiten für heutiges Datum
    if (_isToday(widget.selectedDate)) {
      final now = DateTime.now();
      slots.removeWhere((slot) {
        final slotTime = _parseTime(slot);
        if (slotTime == null) return true;
        
        final slotDateTime = DateTime(
          widget.selectedDate.year,
          widget.selectedDate.month,
          widget.selectedDate.day,
          slotTime.hour,
          slotTime.minute,
        );
        
        // Mindestens 2 Stunden Vorlaufzeit
        return slotDateTime.isBefore(now.add(const Duration(hours: 2)));
      });
    }
    
    return slots;
  }

  String _getOpeningHoursForDay(int weekday) {
    final hours = widget.location.restaurantInfo.openingHours;
    switch (weekday) {
      case 1: return hours.monday;
      case 2: return hours.tuesday;
      case 3: return hours.wednesday;
      case 4: return hours.thursday;
      case 5: return hours.friday;
      case 6: return hours.saturday;
      case 7: return hours.sunday;
      default: return 'Closed';
    }
  }

  DateTime? _parseTime(String timeStr) {
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

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_availableSlots.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.event_busy,
              size: 48,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noTimeSlotsAvailable ?? 'Keine Zeiten verfügbar',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.selectArrivalTime ?? 'Ankunftszeit wählen',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Zeit-Buttons im Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _availableSlots.length,
          itemBuilder: (context, index) {
            final slot = _availableSlots[index];
            final isSelected = widget.selectedTimeSlot == slot;
            
            return Material(
              color: isSelected ? Colors.blue.shade50 : Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              child: InkWell(
                onTap: () => widget.onTimeSelected(slot),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.blue : Colors.green,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      slot,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? Colors.blue.shade700 : Colors.green.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}