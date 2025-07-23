import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class ReservationDetailsWidget extends StatelessWidget {
  final DateTime? selectedDate;
  final TimeOfDay? selectedTime;
  final int guestCount;
  final VoidCallback onDateTap;
  final VoidCallback onTimeTap;
  final Function(int?) onGuestCountChanged;

  const ReservationDetailsWidget({
    super.key,
    required this.selectedDate,
    required this.selectedTime,
    required this.guestCount,
    required this.onDateTap,
    required this.onTimeTap,
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
        
        // Datum Auswahl
        InkWell(
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
        
        const SizedBox(height: 16),
        
        // Zeit und Personenanzahl
        Row(
          children: [
            // Zeit Auswahl
            Expanded(
              child: InkWell(
                onTap: onTimeTap,
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.timeRequired,
                    prefixIcon: const Icon(Icons.access_time),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    selectedTime != null
                        ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                        : l10n.selectTime,
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedTime != null ? null : Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // Personenanzahl
            Expanded(
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
      ],
    );
  }
}