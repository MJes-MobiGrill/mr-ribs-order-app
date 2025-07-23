import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/location.dart';
import '../widgets/forms/contact_form_widget.dart';
import '../widgets/forms/delivery_address_widget.dart';
import '../widgets/forms/reservation_details_widget.dart';
import '../widgets/forms/order_type_info_widget.dart';
import 'menu_screen.dart';

enum OrderType {
  dineIn,      // Vor Ort essen
  takeaway,    // Abholen
  delivery,    // Lieferung
  reservation  // Tischreservierung
}

class DataInputScreen extends StatefulWidget {
  final Location location;
  final OrderType orderType;
  final Map<String, String>? prefilledData;

  const DataInputScreen({
    super.key,
    required this.location,
    required this.orderType,
    this.prefilledData,
  });

  @override
  State<DataInputScreen> createState() => _DataInputScreenState();
}

class _DataInputScreenState extends State<DataInputScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller für Kontaktdaten
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  // Controller für Lieferadresse
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  
  // Zusätzliche Felder
  final _additionalInfoController = TextEditingController();
  
  // Status-Variablen
  bool _isLoading = false;
  String _selectedCountryCode = '+49';
  bool _acceptsMarketing = false;
  
  // Reservierungs-Variablen
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _guestCount = 2;

  @override
  void initState() {
    super.initState();
    // Fülle die Adressfelder vor, falls Daten übergeben wurden
    if (widget.prefilledData != null) {
      _streetController.text = widget.prefilledData!['street'] ?? '';
      _houseNumberController.text = widget.prefilledData!['houseNumber'] ?? '';
      _postalCodeController.text = widget.prefilledData!['postalCode'] ?? '';
      _cityController.text = widget.prefilledData!['city'] ?? '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _houseNumberController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getScreenTitle(l10n)),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Restaurant Info
              _buildRestaurantInfoCard(context),
              
              const SizedBox(height: 24),
              
              // Order Type Info
              OrderTypeInfoWidget(orderType: widget.orderType),
              
              const SizedBox(height: 32),
              
              // Formular-Titel
              Text(
                _getFormTitle(l10n),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.blue.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Kontaktdaten (immer erforderlich)
              ContactFormWidget(
                emailController: _emailController,
                phoneController: _phoneController,
                selectedCountryCode: _selectedCountryCode,
                onCountryCodeChanged: (code) {
                  setState(() {
                    _selectedCountryCode = code;
                  });
                },
              ),
              
              // Zusätzliche Felder basierend auf OrderType
              ..._buildAdditionalFields(l10n),
              
              const SizedBox(height: 24),
              
              // Marketing Checkbox
              _buildMarketingCheckbox(l10n),
              
              const SizedBox(height: 32),
              
              // Submit Button
              _buildSubmitButton(context, l10n),
              
              const SizedBox(height: 16),
              
              // Datenschutz-Hinweis
              _buildPrivacyNote(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantInfoCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.blue,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.location.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    widget.location.address,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildAdditionalFields(AppLocalizations l10n) {
    switch (widget.orderType) {
      case OrderType.delivery:
        return [
          const SizedBox(height: 24),
          DeliveryAddressWidget(
            streetController: _streetController,
            houseNumberController: _houseNumberController,
            postalCodeController: _postalCodeController,
            cityController: _cityController,
          ),
          const SizedBox(height: 16),
          _buildAdditionalInfoField(l10n, label: l10n.deliveryNotes),
        ];
        
      case OrderType.reservation:
        return [
          const SizedBox(height: 24),
          ReservationDetailsWidget(
            selectedDate: _selectedDate,
            selectedTime: _selectedTime,
            guestCount: _guestCount,
            onDateTap: () => _selectDate(context),
            onTimeTap: () => _selectTime(context),
            onGuestCountChanged: (value) {
              if (value != null) {
                setState(() {
                  _guestCount = value;
                });
              }
            },
          ),
          const SizedBox(height: 16),
          _buildAdditionalInfoField(l10n, label: l10n.specialRequests),
        ];
        
      default:
        return [
          const SizedBox(height: 16),
          _buildAdditionalInfoField(l10n),
        ];
    }
  }

  Widget _buildAdditionalInfoField(AppLocalizations l10n, {String? label}) {
    return TextFormField(
      controller: _additionalInfoController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: label ?? l10n.additionalNotes,
        hintText: l10n.notesHint,
        prefixIcon: const Icon(Icons.note),
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildMarketingCheckbox(AppLocalizations l10n) {
    return CheckboxListTile(
      value: _acceptsMarketing,
      onChanged: (value) {
        setState(() {
          _acceptsMarketing = value!;
        });
      },
      title: Text(
        l10n.marketingConsent,
        style: const TextStyle(fontSize: 14),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildSubmitButton(BuildContext context, AppLocalizations l10n) {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _handleSubmit(context, l10n),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              _getSubmitButtonText(l10n),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }

  Widget _buildPrivacyNote(AppLocalizations l10n) {
    return Text(
      l10n.privacyNote,
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade600,
      ),
      textAlign: TextAlign.center,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 19, minute: 0),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleSubmit(BuildContext context, AppLocalizations l10n) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Zusätzliche Validierung für Reservierung
    if (widget.orderType == OrderType.reservation) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.pleaseSelectDateTime),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    setState(() {
      _isLoading = true;
    });

    // Simuliere API-Call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Erfolgs-Feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_getSuccessMessage(l10n)),
          backgroundColor: Colors.green,
        ),
      );

      // Navigation je nach OrderType
      if (widget.orderType == OrderType.reservation) {
        // Bei Reservierung zurück zum Hauptmenü
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        // Bei Bestellung weiter zum Menü
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MenuScreen(
              location: widget.location,
              orderType: _getOrderTypeString(),
              customerData: _collectCustomerData(),
            ),
          ),
        );
      }
    }
  }

  Map<String, dynamic> _collectCustomerData() {
    final data = <String, dynamic>{
      'email': _emailController.text,
      'phone': '$_selectedCountryCode${_phoneController.text}',
      'acceptsMarketing': _acceptsMarketing,
    };

    if (widget.orderType == OrderType.delivery) {
      data.addAll({
        'street': _streetController.text,
        'houseNumber': _houseNumberController.text,
        'postalCode': _postalCodeController.text,
        'city': _cityController.text,
      });
    }

    if (_additionalInfoController.text.isNotEmpty) {
      data['notes'] = _additionalInfoController.text;
    }

    if (widget.orderType == OrderType.reservation) {
      if (_selectedDate != null) {
        data['date'] = _selectedDate!.toIso8601String();
      }
      if (_selectedTime != null) {
        data['time'] = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
      }
      data['guestCount'] = _guestCount;
    }

    return data;
  }

  String _getOrderTypeString() {
    switch (widget.orderType) {
      case OrderType.dineIn:
        return 'dine_in';
      case OrderType.takeaway:
        return 'takeaway';
      case OrderType.delivery:
        return 'delivery';
      case OrderType.reservation:
        return 'reservation';
    }
  }

  String _getScreenTitle(AppLocalizations l10n) {
    switch (widget.orderType) {
      case OrderType.dineIn:
        return l10n.dineIn;
      case OrderType.takeaway:
        return l10n.takeaway;
      case OrderType.delivery:
        return l10n.delivery;
      case OrderType.reservation:
        return l10n.reserveTable;
    }
  }

  String _getFormTitle(AppLocalizations l10n) {
    switch (widget.orderType) {
      case OrderType.delivery:
        return l10n.yourContactAndDeliveryData;
      case OrderType.reservation:
        return l10n.yourReservationData;
      default:
        return l10n.yourContactData;
    }
  }

  String _getSubmitButtonText(AppLocalizations l10n) {
    switch (widget.orderType) {
      case OrderType.dineIn:
      case OrderType.takeaway:
        return l10n.continueToMenu ?? 'Weiter zum Menü';
      case OrderType.delivery:
        return l10n.continueToMenu ?? 'Weiter zum Menü';
      case OrderType.reservation:
        return l10n.makeReservation;
    }
  }

  String _getSuccessMessage(AppLocalizations l10n) {
    switch (widget.orderType) {
      case OrderType.dineIn:
      case OrderType.takeaway:
        return l10n.dataSaved;
      case OrderType.delivery:
        return l10n.addressConfirmed;
      case OrderType.reservation:
        return l10n.reservationSuccessful;
    }
  }
}