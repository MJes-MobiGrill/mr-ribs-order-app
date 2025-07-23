import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/location.dart';
import '../services/location_service.dart';
import '../theme/app_theme.dart';
import 'data_input_screen.dart';

class LocationSelectionScreen extends StatefulWidget {
  final String orderType;

  const LocationSelectionScreen({
    super.key,
    required this.orderType,
  });

  @override
  State<LocationSelectionScreen> createState() => _LocationSelectionScreenState();
}

class _LocationSelectionScreenState extends State<LocationSelectionScreen> {
  List<Location> _locations = [];
  List<Location> _filteredLocations = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadLocations() async {
    try {
      final locations = await LocationService.getActiveLocations();
      if (mounted) {
        setState(() {
          _locations = locations;
          _filteredLocations = locations;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading locations: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _filterLocations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredLocations = _locations;
      } else {
        _filteredLocations = _locations.where((location) {
          final nameLower = location.name.toLowerCase();
          final addressLower = location.address.toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower) || addressLower.contains(queryLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        elevation: 0,
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Such-Header
                Container(
                  color: AppTheme.primaryDark,
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterLocations,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Restaurant suchen...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
                
                // Restaurant-Liste
                Expanded(
                  child: _filteredLocations.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.all(24),
                          itemCount: _filteredLocations.length,
                          itemBuilder: (context, index) {
                            final location = _filteredLocations[index];
                            return _buildLocationCard(context, location);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppTheme.grey400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchController.text.isEmpty 
                ? 'Keine Restaurants verfügbar'
                : 'Keine Restaurants gefunden',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppTheme.grey600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchController.text.isEmpty
                ? 'Aktuell sind keine Standorte verfügbar.'
                : 'Versuchen Sie eine andere Suche.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.grey500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(BuildContext context, Location location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        child: InkWell(
          onTap: () => _selectLocation(context, location),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Restaurant Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.grey100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.restaurant,
                        size: 24,
                        color: AppTheme.primaryRed,
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Restaurant Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            location.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            location.address,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          // Zusatz-Infos
                          Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: AppTheme.grey600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _getTodaysHours(location),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              if (widget.orderType == 'reservation') ...[
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.table_restaurant,
                                  size: 14,
                                  color: AppTheme.grey600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${location.restaurantInfo.maxTables} Tische',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Pfeil
                    Icon(
                      Icons.arrow_forward_ios,
                      color: AppTheme.grey400,
                      size: 20,
                    ),
                  ],
                ),
                
                // Verfügbarkeits-Badge
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.grey100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _getOrderTypeText(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.grey700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getTitle() {
    switch (widget.orderType) {
      case 'reservation':
        return 'Restaurant für Reservierung wählen';
      case 'delivery':
        return 'Restaurant für Lieferung wählen';
      case 'takeaway':
        return 'Restaurant für Abholung wählen';
      case 'dine_in':
        return 'Restaurant zum Essen wählen';
      default:
        return 'Restaurant wählen';
    }
  }

  String _getOrderTypeText() {
    switch (widget.orderType) {
      case 'reservation':
        return 'Tischreservierung möglich';
      case 'delivery':
        return 'Lieferung verfügbar';
      case 'takeaway':
        return 'Abholung möglich';
      case 'dine_in':
        return 'Vor Ort essen';
      default:
        return 'Verfügbar';
    }
  }

  String _getTodaysHours(Location location) {
    final today = DateTime.now().weekday;
    final hours = location.restaurantInfo.openingHours;
    
    String todaysHours;
    switch (today) {
      case 1: todaysHours = hours.monday; break;
      case 2: todaysHours = hours.tuesday; break;
      case 3: todaysHours = hours.wednesday; break;
      case 4: todaysHours = hours.thursday; break;
      case 5: todaysHours = hours.friday; break;
      case 6: todaysHours = hours.saturday; break;
      case 7: todaysHours = hours.sunday; break;
      default: todaysHours = 'Geschlossen';
    }
    
    return todaysHours == 'Closed' ? 'Geschlossen' : todaysHours;
  }

  void _selectLocation(BuildContext context, Location location) {
    // Prüfe ob der gewählte Service unterstützt wird
    final supportedTypes = location.restaurantInfo.supportedOrderTypes;
    final mappedType = _mapOrderTypeToSupported(widget.orderType);
    
    if (!supportedTypes.contains(mappedType) && widget.orderType != 'reservation') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Dieser Service ist in ${location.name} nicht verfügbar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    // Navigation zum DataInputScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataInputScreen(
          location: location,
          orderType: _mapOrderType(),
        ),
      ),
    );
  }

  String _mapOrderTypeToSupported(String orderType) {
    switch (orderType) {
      case 'dine_in':
        return 'dine_in';
      case 'takeaway':
        return 'takeaway';
      case 'delivery':
        return 'delivery';
      default:
        return orderType;
    }
  }

  OrderType _mapOrderType() {
    switch (widget.orderType) {
      case 'reservation':
        return OrderType.reservation;
      case 'delivery':
        return OrderType.delivery;
      case 'takeaway':
        return OrderType.takeaway;
      case 'dine_in':
        return OrderType.dineIn;
      default:
        return OrderType.dineIn;
    }
  }
}