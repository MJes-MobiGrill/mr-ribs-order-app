// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mr. Ribs Order App';

  @override
  String get appTitle => 'Mr. Ribs';

  @override
  String get appSubtitle => 'Order App';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get selectLanguageHint => 'Select Language / Sprache auswählen';

  @override
  String get german => 'Deutsch';

  @override
  String get english => 'English';

  @override
  String get selectOrderType => 'Select Order Type';

  @override
  String get selectConsumptionType => 'How would you like to enjoy your meal?';

  @override
  String get orderOnSite => 'Order On-Site';

  @override
  String get orderOnSiteDescription => 'Order with restaurant device';

  @override
  String get dineIn => 'Dine In';

  @override
  String get dineInDescription => 'Eat here at the restaurant';

  @override
  String get takeaway => 'Takeaway';

  @override
  String get takeawayDescription => 'Take your order to go';

  @override
  String get consumptionTypeInfo => 'You can change this option later if needed.';

  @override
  String get proceedingToMenu => 'Proceeding to menu...';

  @override
  String get scanQrCode => 'Scan QR Code';

  @override
  String get scanQrCodeDescription => 'Scan QR code to identify restaurant';

  @override
  String get processingQrCode => 'Processing QR-Code...';

  @override
  String get qrCodeValid => 'QR-Code Valid';

  @override
  String get qrCodeInvalid => 'QR-Code Invalid';

  @override
  String get qrCodeErrorMessage => 'This QR-Code is not valid or the restaurant is not active.';

  @override
  String get reserveTable => 'Reserve Table';

  @override
  String get reserveTableDescription => 'Book a table in advance';

  @override
  String get orderOnline => 'Order Online';

  @override
  String get orderOnlineDescription => 'Order with your own device';

  @override
  String get deviceCheck => 'Device Check';

  @override
  String get deviceCheckMessage => 'Checking device registration...';

  @override
  String get deviceRegistered => 'Device Registered';

  @override
  String get deviceNotRegistered => 'Device Not Registered';

  @override
  String get deviceNotRegisteredMessage => 'This device is not registered with any Mr. Ribs restaurant.';

  @override
  String get restaurantName => 'Restaurant';

  @override
  String get address => 'Address';

  @override
  String get deviceId => 'Device ID';

  @override
  String get proceedToMenu => 'Proceed to Menu';

  @override
  String get alternativeOptions => 'Alternative Options:';

  @override
  String get error => 'Error';

  @override
  String get errorMessage => 'An error occurred';

  @override
  String get scanQrCodeMessage => 'Point your camera at the QR code or test with the buttons below:';

  @override
  String get reserveTableMessage => 'Select date, time and number of guests for your reservation.';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get comingSoonMessage => 'This feature will be implemented soon.';

  @override
  String get cancel => 'Cancel';

  @override
  String get proceed => 'Proceed';

  @override
  String get startScan => 'Start Scan';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get webCameraNotSupported => 'Camera not supported in web browser';

  @override
  String get useTestButtonsBelow => 'Use the test buttons below to simulate QR code scanning:';

  @override
  String get pointCameraAtQrCode => 'Point your camera at a QR code';

  @override
  String get tryAnotherQrCode => 'Please try scanning another QR code.';

  @override
  String get ok => 'OK';
}
