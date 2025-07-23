import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../screens/data_input_screen.dart';

class OrderTypeInfoWidget extends StatelessWidget {
  final OrderType orderType;

  const OrderTypeInfoWidget({
    super.key,
    required this.orderType,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    final config = _getOrderTypeConfig(l10n);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(config.icon, color: config.color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.title,
                  style: TextStyle(
                    color: config.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  config.subtitle,
                  style: TextStyle(
                    color: config.color.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _OrderTypeConfig _getOrderTypeConfig(AppLocalizations l10n) {
    switch (orderType) {
      case OrderType.dineIn:
        return _OrderTypeConfig(
          icon: Icons.restaurant,
          color: Colors.green,
          title: l10n.dineIn,
          subtitle: l10n.confirmationByEmail,
        );
      case OrderType.takeaway:
        return _OrderTypeConfig(
          icon: Icons.takeout_dining,
          color: Colors.orange,
          title: l10n.takeaway,
          subtitle: l10n.pickupConfirmationByEmail,
        );
      case OrderType.delivery:
        return _OrderTypeConfig(
          icon: Icons.delivery_dining,
          color: Colors.purple,
          title: l10n.delivery,
          subtitle: l10n.deliveryConfirmationByEmail,
        );
      case OrderType.reservation:
        return _OrderTypeConfig(
          icon: Icons.event_seat,
          color: Colors.indigo,
          title: l10n.reserveTable,
          subtitle: l10n.reservationConfirmationByEmail,
        );
    }
  }
}

class _OrderTypeConfig {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  _OrderTypeConfig({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });
}