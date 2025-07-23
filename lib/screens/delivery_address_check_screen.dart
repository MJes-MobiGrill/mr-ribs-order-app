import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../models/location.dart';
import '../services/location_service.dart';
import '../services/geocoding_service.dart';
import '../theme/app_theme.dart';
import 'data_input_screen.dart';
import 'location_selection_screen.dart';

class DeliveryAddressCheckScreen extends StatefulWidget {
  const DeliveryAddressCheckScreen({super.key});

  @override
  State<DeliveryAddressCheckScreen> createState() => _DeliveryAddressCheckScreenState();
}

class _DeliveryAddressCheckScreenState extends State<DeliveryAddressCheckScreen> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _houseNumberController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _cityController = TextEditingController();
  
  bool _isChecking = false;
  bool _hasChecked = false;
  Location? _nearestLocation;
  double? _distance;
  List<Location> _availableLocations = [];

  @override
  void dispose() {
    _streetController.dispose();
    _houseNumberController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.delivery ?? 'Lieferung'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon und Titel
              Icon(
                Icons.delivery_dining,
                size: 64,
                color: AppTheme.grey700,
              ),
              const SizedBox(height: 24),
              
              Text(
                l10n.enterDeliveryAddress ?? 'Lieferadresse eingeben',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                l10n.checkDeliveryAvailability ?? 'Wir prüfen, ob wir an Ihre Adresse liefern können',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Adressfelder
              _buildAddressFields(l10n),
              
              const SizedBox(height: 32),
              
              // Prüfen Button
              ElevatedButton(
                onPressed: _isChecking ? null : _checkDeliveryAvailability,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isChecking
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        l10n.checkAvailability ?? 'Verfügbarkeit prüfen',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              
              // Ergebnis anzeigen
              if (_hasChecked) ...[
                const SizedBox(height: 32),
                _buildResult(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressFields(AppLocalizations l10n) {
    return Column(
      children: [
        // Straße und Hausnummer
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: _streetController,
                decoration: InputDecoration(
                  labelText: l10n.streetRequired,
                  hintText: l10n.streetHint,
                  prefixIcon: const Icon(Icons.home),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterStreet;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _houseNumberController,
                decoration: InputDecoration(
                  labelText: l10n.houseNumberRequired,
                  hintText: l10n.houseNumberHint,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.number;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // PLZ und Stadt
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: TextFormField(
                controller: _postalCodeController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(5),
                ],
                decoration: InputDecoration(
                  labelText: l10n.postalCodeRequired,
                  hintText: l10n.postalCodeHint,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.postalCode;
                  }
                  if (value.length != 5) {
                    return l10n.invalid;
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _cityController,
                decoration: InputDecoration(
                  labelText: l10n.cityRequired,
                  hintText: l10n.cityHint,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.pleaseEnterCity;
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResult(BuildContext context) {
    if (_nearestLocation != null && _distance != null && _distance! <= 5.0) {
      // Lieferung möglich
      return _buildSuccessResult(context);
    } else {
      // Lieferung nicht möglich
      return _buildFailureResult(context);
    }
  }

  Widget _buildSuccessResult(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green.shade700,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.deliveryAvailable ?? 'Lieferung verfügbar!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Wir liefern von ${_nearestLocation!.name}',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          Text(
            'Entfernung: ${_distance!.toStringAsFixed(1)} km',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showDeliveryFeeDialog(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
            ),
            child: Text(l10n.continueToOrder ?? 'Weiter zur Bestellung'),
          ),
        ],
      ),
    );
  }

  void _showDeliveryFeeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final deliveryFee = _nearestLocation!.restaurantInfo.deliveryFee ?? 0.0;
    final minimumOrder = _nearestLocation!.restaurantInfo.minimumOrderValue ?? 0.0;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.delivery_dining,
                color: AppTheme.primaryRed,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.deliveryInfo ?? 'Lieferinformationen',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Liefergebühr
              _buildInfoRow(
                icon: Icons.euro,
                label: l10n.deliveryFee ?? 'Liefergebühr',
                value: '${deliveryFee.toStringAsFixed(2)} €',
                valueColor: deliveryFee == 0 ? Colors.green : null,
              ),
              const SizedBox(height: 12),
              
              // Mindestbestellwert
              _buildInfoRow(
                icon: Icons.shopping_cart,
                label: l10n.minimumOrderValue ?? 'Mindestbestellwert',
                value: '${minimumOrder.toStringAsFixed(2)} €',
              ),
              const SizedBox(height: 12),
              
              // Geschätzte Lieferzeit
              _buildInfoRow(
                icon: Icons.access_time,
                label: l10n.estimatedDeliveryTime ?? 'Geschätzte Lieferzeit',
                value: '45-60 Min.',
              ),
              
              const SizedBox(height: 16),
              
              // Info-Text
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.grey100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.grey300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppTheme.grey600,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.deliveryFeeInfo ?? 
                        'Die Liefergebühr wird automatisch zu Ihrer Bestellung hinzugefügt.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.grey700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                l10n.cancel ?? 'Abbrechen',
                style: TextStyle(color: AppTheme.grey600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _proceedWithDelivery(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryDark,
                foregroundColor: Colors.white,
              ),
              child: Text(l10n.accept ?? 'Akzeptieren & Weiter'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.grey600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: AppTheme.grey700,
              fontSize: 14,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: valueColor ?? AppTheme.grey900,
          ),
        ),
      ],
    );
  }

  Widget _buildFailureResult(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off,
            color: Colors.orange.shade700,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noDeliveryPossible ?? 'Leider keine Lieferung möglich',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _distance != null 
                ? 'Das nächste Restaurant ist ${_distance!.toStringAsFixed(1)} km entfernt'
                : l10n.addressOutsideDeliveryArea ?? 'Ihre Adresse liegt außerhalb unseres Liefergebiets',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Adresse ändern Button
          OutlinedButton.icon(
            onPressed: _resetAddressForm,
            icon: const Icon(Icons.edit_location),
            label: Text(l10n.changeAddress ?? 'Adresse ändern'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.orange.shade700,
              side: BorderSide(color: Colors.orange.shade400),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          
          Text(
            l10n.alternativeOptions ?? 'Alternative Optionen:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          // Abholung Button
          OutlinedButton.icon(
            onPressed: () => _switchToPickup(context),
            icon: const Icon(Icons.takeout_dining),
            label: Text(l10n.takeaway),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.grey800,
              side: BorderSide(color: AppTheme.grey400),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
          const SizedBox(height: 12),
          // Vor Ort essen Button
          OutlinedButton.icon(
            onPressed: () => _switchToDineIn(context),
            icon: const Icon(Icons.restaurant),
            label: Text(l10n.dineIn),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.grey800,
              side: BorderSide(color: AppTheme.grey400),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            ),
          ),
        ],
      ),
    );
  }
  
  void _resetAddressForm() {
    setState(() {
      _hasChecked = false;
      _nearestLocation = null;
      _distance = null;
      _availableLocations.clear();
      // Optional: Felder leeren
      // _streetController.clear();
      // _houseNumberController.clear();
      // _postalCodeController.clear();
      // _cityController.clear();
    });
  }

  Future<void> _checkDeliveryAvailability() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isChecking = true;
      _hasChecked = false;
    });

    try {
      // Geocodiere die Adresse
      final geocodingResult = await GeocodingService.geocodeAddress(
        street: _streetController.text,
        houseNumber: _houseNumberController.text,
        postalCode: _postalCodeController.text,
        city: _cityController.text,
      );

      if (geocodingResult == null) {
        _showErrorDialog('Adresse konnte nicht gefunden werden. Bitte überprüfen Sie Ihre Eingabe.');
        return;
      }

      // Lade alle Restaurants
      final locations = await LocationService.getActiveLocations();
      
      // Finde Restaurants die liefern und berechne Distanzen
      Location? nearest;
      double? nearestDistance;
      final availableLocations = <Location>[];

      for (final location in locations) {
        if (location.restaurantInfo.supportedOrderTypes.contains('delivery')) {
          final distance = GeocodingService.calculateDistance(
            lat1: geocodingResult.latitude,
            lon1: geocodingResult.longitude,
            lat2: location.coordinates.latitude,
            lon2: location.coordinates.longitude,
          );

          if (distance <= 5.0) { // 5km Lieferradius
            availableLocations.add(location);
            if (nearest == null || distance < nearestDistance!) {
              nearest = location;
              nearestDistance = distance;
            }
          }
        }
      }

      setState(() {
        _nearestLocation = nearest;
        _distance = nearestDistance;
        _availableLocations = availableLocations;
        _hasChecked = true;
      });
    } catch (e) {
      print('Error checking delivery: $e');
      _showErrorDialog('Ein Fehler ist aufgetreten. Bitte versuchen Sie es später erneut.');
    } finally {
      setState(() {
        _isChecking = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fehler'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _proceedWithDelivery(BuildContext context) {
    // Speichere die Adressdaten und Liefergebühr-Info
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => DataInputScreen(
          location: _nearestLocation!,
          orderType: OrderType.delivery,
          // Übergebe die bereits eingegebene Adresse und Lieferinfos
          prefilledData: {
            'street': _streetController.text,
            'houseNumber': _houseNumberController.text,
            'postalCode': _postalCodeController.text,
            'city': _cityController.text,
            'deliveryFee': _nearestLocation!.restaurantInfo.deliveryFee.toString(),
            'minimumOrderValue': _nearestLocation!.restaurantInfo.minimumOrderValue.toString(),
          },
        ),
      ),
    );
  }

  void _switchToPickup(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionScreen(
          orderType: 'takeaway',
        ),
      ),
    );
  }

  void _switchToDineIn(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LocationSelectionScreen(
          orderType: 'dine_in',
        ),
      ),
    );
  }
}