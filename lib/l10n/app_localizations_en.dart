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
  String get alternativeOptions => 'Alternative options:';

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
  String get webQrScannerInfo => 'QR-Code scanning is not available in web browsers. Please use the mobile app or scan QR codes with your device\'s camera app.';

  @override
  String get backToMenu => 'Back to Menu';

  @override
  String get qrCodeScanHint => 'Hold steady and wait for auto-detection';

  @override
  String get cameraPermissionDenied => 'Camera permission is required for QR-Code scanning';

  @override
  String get ok => 'OK';

  @override
  String get scanNow => 'Scan Now';

  @override
  String get tapScanButton => 'Tap the scan button to detect QR codes';

  @override
  String get cameraActiveInBackground => 'Camera is active in background';

  @override
  String get initializingCamera => 'Initializing camera...';

  @override
  String get startCamera => 'Start Camera';

  @override
  String get useWebVersion => 'Use Web Version for Camera';

  @override
  String get webVersionRecommended => 'For QR-Code scanning, please use the web version at mrribsorderapp.netlify.app';

  @override
  String get scanResult => 'Scan Result';

  @override
  String get email => 'Email';

  @override
  String get emailRequired => 'Email *';

  @override
  String get emailHint => 'your.email@example.com';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneNumberRequired => 'Phone Number *';

  @override
  String get phoneHint => '1234567890';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get street => 'Street';

  @override
  String get streetRequired => 'Street *';

  @override
  String get streetHint => 'Example Street';

  @override
  String get houseNumber => 'No.';

  @override
  String get houseNumberRequired => 'No. *';

  @override
  String get houseNumberHint => '123';

  @override
  String get postalCode => 'Postal Code';

  @override
  String get postalCodeRequired => 'Postal Code *';

  @override
  String get postalCodeHint => '12345';

  @override
  String get city => 'City';

  @override
  String get cityRequired => 'City *';

  @override
  String get cityHint => 'Berlin';

  @override
  String get deliveryNotes => 'Delivery Notes (optional)';

  @override
  String get additionalNotes => 'Additional Notes (optional)';

  @override
  String get notesHint => 'e.g. allergies, special requests...';

  @override
  String get marketingConsent => 'I would like to receive offers and news';

  @override
  String get privacyNote => 'By entering your data, you agree to our privacy policy.';

  @override
  String get reservationDetails => 'Reservation Details';

  @override
  String get date => 'Date';

  @override
  String get dateRequired => 'Date *';

  @override
  String get selectDate => 'Select Date';

  @override
  String get time => 'Time';

  @override
  String get timeRequired => 'Time *';

  @override
  String get selectTime => 'Select Time';

  @override
  String get numberOfGuests => 'Guests';

  @override
  String get numberOfGuestsRequired => 'Guests *';

  @override
  String get guest => 'Guest';

  @override
  String get guests => 'Guests';

  @override
  String get specialRequests => 'Special Requests (optional)';

  @override
  String get confirmationByEmail => 'Confirmation by email';

  @override
  String get pickupConfirmationByEmail => 'Pickup confirmation by email';

  @override
  String get deliveryConfirmationByEmail => 'Delivery confirmation by email';

  @override
  String get reservationConfirmationByEmail => 'Reservation confirmation by email';

  @override
  String get delivery => 'Delivery';

  @override
  String get deliveryDescription => 'Home delivery';

  @override
  String get yourContactData => 'Your contact information for the order';

  @override
  String get yourContactAndDeliveryData => 'Your contact and delivery information';

  @override
  String get yourReservationData => 'Your contact information for the reservation';

  @override
  String get continueToOrder => 'Continue to order';

  @override
  String get checkAddressAndContinue => 'Check address & continue';

  @override
  String get makeReservation => 'Make reservation';

  @override
  String get dataSaved => 'Data saved - continue to menu';

  @override
  String get addressConfirmed => 'Delivery address confirmed - continue to menu';

  @override
  String get reservationSuccessful => 'Reservation successful! Confirmation sent by email.';

  @override
  String get pleaseEnterEmail => 'Please enter email address';

  @override
  String get pleaseEnterValidEmail => 'Please enter valid email address';

  @override
  String get pleaseEnterPhone => 'Please enter phone number';

  @override
  String get phoneTooShort => 'Phone number too short';

  @override
  String get pleaseEnterStreet => 'Please enter street';

  @override
  String get number => 'Number';

  @override
  String get invalid => 'Invalid';

  @override
  String get pleaseEnterCity => 'Please enter city';

  @override
  String get pleaseSelectDateTime => 'Please select date and time';

  @override
  String get deliveryAddressCheck => 'Check delivery address';

  @override
  String get enterDeliveryAddress => 'Enter delivery address';

  @override
  String get checkDeliveryAvailability => 'We\'ll check if we can deliver to your address';

  @override
  String get checkAvailability => 'Check availability';

  @override
  String get deliveryAvailable => 'Delivery available!';

  @override
  String weDeliverFrom(String restaurant) {
    return 'We deliver from $restaurant';
  }

  @override
  String distance(String distance) {
    return 'Distance: $distance km';
  }

  @override
  String get noDeliveryPossible => 'Sorry, no delivery possible';

  @override
  String nearestRestaurantDistance(String distance) {
    return 'The nearest restaurant is $distance km away';
  }

  @override
  String get addressOutsideDeliveryArea => 'Your address is outside our delivery area';

  @override
  String get addressNotFound => 'Address not found. Please check your input.';

  @override
  String get errorOccurred => 'An error occurred. Please try again later.';

  @override
  String get searchRestaurant => 'Search restaurant...';

  @override
  String get noRestaurantsAvailable => 'No restaurants available';

  @override
  String get noRestaurantsFound => 'No restaurants found';

  @override
  String get currentlyNoLocations => 'Currently no locations available.';

  @override
  String get tryDifferentSearch => 'Try a different search.';

  @override
  String get restaurantForReservation => 'Select restaurant for reservation';

  @override
  String get restaurantForDelivery => 'Select restaurant for delivery';

  @override
  String get restaurantForPickup => 'Select restaurant for pickup';

  @override
  String get restaurantForDineIn => 'Select restaurant for dine-in';

  @override
  String get selectRestaurant => 'Select restaurant';

  @override
  String get reservationPossible => 'Table reservation possible';

  @override
  String get deliveryAvailableShort => 'Delivery available';

  @override
  String get pickupPossible => 'Pickup possible';

  @override
  String get dineInPossible => 'Dine in';

  @override
  String get available => 'Available';

  @override
  String get closed => 'Closed';

  @override
  String get tables => 'tables';

  @override
  String serviceNotAvailable(String restaurant) {
    return 'This service is not available at $restaurant';
  }

  @override
  String get onlineOrderInfo => 'Online order: Select your desired service.';

  @override
  String get deliveryInfo => 'Delivery Information';

  @override
  String get deliveryFee => 'Delivery Fee';

  @override
  String get minimumOrderValue => 'Minimum Order Value';

  @override
  String get estimatedDeliveryTime => 'Estimated Delivery Time';

  @override
  String get deliveryFeeInfo => 'The delivery fee will be automatically added to your order.';

  @override
  String get accept => 'Accept & Continue';

  @override
  String get freeDelivery => 'Free Delivery';

  @override
  String get deliveryTime45to60 => '45-60 min.';

  @override
  String get paymentOnDelivery => 'Payment on delivery';

  @override
  String get paymentMethods => 'Payment Methods';

  @override
  String get cashOrCard => 'Cash or Card';

  @override
  String get changeAddress => 'Change address';

  @override
  String get continueToMenu => 'Continue to menu';

  @override
  String get selectArrivalTime => 'Select arrival time';

  @override
  String get availableTimeSlots => 'Available times';

  @override
  String get noTimeSlotsAvailable => 'No times available';

  @override
  String get timeSlotUnavailable => 'This time is no longer available';

  @override
  String get arrivalTime => 'Arrival time';

  @override
  String timeSlotLabel(Object time) {
    return '$time';
  }
}
