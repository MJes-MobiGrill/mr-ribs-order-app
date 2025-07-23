// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'Mr. Ribs Bestell-App';

  @override
  String get appTitle => 'Mr. Ribs';

  @override
  String get appSubtitle => 'Bestell-App';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get selectLanguageHint => 'Select Language / Sprache auswählen';

  @override
  String get german => 'Deutsch';

  @override
  String get english => 'English';

  @override
  String get selectOrderType => 'Bestellart auswählen';

  @override
  String get selectConsumptionType => 'Wie möchten Sie Ihr Essen genießen?';

  @override
  String get orderOnSite => 'Vor Ort bestellen';

  @override
  String get orderOnSiteDescription => 'Mit dem Restaurant-Gerät bestellen';

  @override
  String get dineIn => 'Vor Ort essen';

  @override
  String get dineInDescription => 'Hier im Restaurant essen';

  @override
  String get takeaway => 'Zum Mitnehmen';

  @override
  String get takeawayDescription => 'Bestellung zum Mitnehmen';

  @override
  String get consumptionTypeInfo => 'Sie können diese Option später bei Bedarf ändern.';

  @override
  String get proceedingToMenu => 'Weiter zum Menü...';

  @override
  String get scanQrCode => 'QR-Code scannen';

  @override
  String get scanQrCodeDescription => 'QR-Code scannen um Restaurant zu identifizieren';

  @override
  String get processingQrCode => 'Verarbeite QR-Code...';

  @override
  String get qrCodeValid => 'QR-Code Gültig';

  @override
  String get qrCodeInvalid => 'QR-Code Ungültig';

  @override
  String get qrCodeErrorMessage => 'Dieser QR-Code ist nicht gültig oder das Restaurant ist nicht aktiv.';

  @override
  String get reserveTable => 'Tisch reservieren';

  @override
  String get reserveTableDescription => 'Tisch im Voraus buchen';

  @override
  String get orderOnline => 'Online bestellen';

  @override
  String get orderOnlineDescription => 'Mit deinem eigenen Gerät bestellen';

  @override
  String get deviceCheck => 'Geräte-Prüfung';

  @override
  String get deviceCheckMessage => 'Prüfe Geräte-Registrierung...';

  @override
  String get deviceRegistered => 'Gerät Registriert';

  @override
  String get deviceNotRegistered => 'Gerät Nicht Registriert';

  @override
  String get deviceNotRegisteredMessage => 'Dieses Gerät ist in keinem Mr. Ribs Restaurant registriert.';

  @override
  String get restaurantName => 'Restaurant';

  @override
  String get address => 'Adresse';

  @override
  String get deviceId => 'Geräte-ID';

  @override
  String get proceedToMenu => 'Zum Menü';

  @override
  String get alternativeOptions => 'Alternative Optionen:';

  @override
  String get error => 'Fehler';

  @override
  String get errorMessage => 'Ein Fehler ist aufgetreten';

  @override
  String get scanQrCodeMessage => 'Richte deine Kamera auf den QR-Code oder teste mit den Buttons unten:';

  @override
  String get reserveTableMessage => 'Wähle Datum, Uhrzeit und Anzahl der Gäste für deine Reservierung.';

  @override
  String get comingSoon => 'Bald verfügbar';

  @override
  String get comingSoonMessage => 'Diese Funktion wird bald implementiert.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get proceed => 'Fortfahren';

  @override
  String get startScan => 'Scan starten';

  @override
  String get tryAgain => 'Erneut versuchen';

  @override
  String get webCameraNotSupported => 'Kamera wird im Webbrowser nicht unterstützt';

  @override
  String get useTestButtonsBelow => 'Verwende die Test-Buttons unten um QR-Code-Scanning zu simulieren:';

  @override
  String get pointCameraAtQrCode => 'Richte deine Kamera auf einen QR-Code';

  @override
  String get tryAnotherQrCode => 'Bitte versuche einen anderen QR-Code zu scannen.';

  @override
  String get webQrScannerInfo => 'QR-Code-Scanning ist in Webbrowsern nicht verfügbar. Bitte nutze die Mobile-App oder scanne QR-Codes mit der Kamera-App deines Geräts.';

  @override
  String get backToMenu => 'Zurück zum Menü';

  @override
  String get qrCodeScanHint => 'Ruhig halten und auf automatische Erkennung warten';

  @override
  String get cameraPermissionDenied => 'Kamera-Berechtigung ist für QR-Code-Scanning erforderlich';

  @override
  String get ok => 'OK';

  @override
  String get scanNow => 'Jetzt scannen';

  @override
  String get tapScanButton => 'Tippe den Scan-Button um QR-Codes zu erkennen';

  @override
  String get cameraActiveInBackground => 'Kamera ist im Hintergrund aktiv';

  @override
  String get initializingCamera => 'Kamera wird initialisiert...';

  @override
  String get startCamera => 'Kamera starten';

  @override
  String get useWebVersion => 'Web-Version für Kamera verwenden';

  @override
  String get webVersionRecommended => 'Für QR-Code-Scanning nutze bitte die Web-Version unter mrribsorderapp.netlify.app';

  @override
  String get scanResult => 'Scan-Ergebnis';

  @override
  String get email => 'E-Mail';

  @override
  String get emailRequired => 'E-Mail *';

  @override
  String get emailHint => 'ihre.email@beispiel.de';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get phoneNumberRequired => 'Telefonnummer *';

  @override
  String get phoneHint => '1234567890';

  @override
  String get deliveryAddress => 'Lieferadresse';

  @override
  String get street => 'Straße';

  @override
  String get streetRequired => 'Straße *';

  @override
  String get streetHint => 'Musterstraße';

  @override
  String get houseNumber => 'Nr.';

  @override
  String get houseNumberRequired => 'Nr. *';

  @override
  String get houseNumberHint => '123';

  @override
  String get postalCode => 'PLZ';

  @override
  String get postalCodeRequired => 'PLZ *';

  @override
  String get postalCodeHint => '12345';

  @override
  String get city => 'Stadt';

  @override
  String get cityRequired => 'Stadt *';

  @override
  String get cityHint => 'Berlin';

  @override
  String get deliveryNotes => 'Lieferhinweise (optional)';

  @override
  String get additionalNotes => 'Anmerkungen (optional)';

  @override
  String get notesHint => 'z.B. Allergien, besondere Wünsche...';

  @override
  String get marketingConsent => 'Ich möchte über Angebote und Neuigkeiten informiert werden';

  @override
  String get privacyNote => 'Mit der Eingabe Ihrer Daten stimmen Sie unseren Datenschutzbestimmungen zu.';

  @override
  String get reservationDetails => 'Reservierungsdetails';

  @override
  String get date => 'Datum';

  @override
  String get dateRequired => 'Datum *';

  @override
  String get selectDate => 'Datum wählen';

  @override
  String get time => 'Uhrzeit';

  @override
  String get timeRequired => 'Uhrzeit *';

  @override
  String get selectTime => 'Zeit wählen';

  @override
  String get numberOfGuests => 'Personen';

  @override
  String get numberOfGuestsRequired => 'Personen *';

  @override
  String get guest => 'Person';

  @override
  String get guests => 'Personen';

  @override
  String get specialRequests => 'Besondere Wünsche (optional)';

  @override
  String get confirmationByEmail => 'Bestätigung per E-Mail';

  @override
  String get pickupConfirmationByEmail => 'Abholbestätigung per E-Mail';

  @override
  String get deliveryConfirmationByEmail => 'Lieferbestätigung per E-Mail';

  @override
  String get reservationConfirmationByEmail => 'Reservierungsbestätigung per E-Mail';

  @override
  String get delivery => 'Lieferung';

  @override
  String get deliveryDescription => 'Lieferung nach Hause';

  @override
  String get yourContactData => 'Ihre Kontaktdaten für die Bestellung';

  @override
  String get yourContactAndDeliveryData => 'Ihre Kontakt- und Lieferdaten';

  @override
  String get yourReservationData => 'Ihre Kontaktdaten für die Reservierung';

  @override
  String get continueToOrder => 'Weiter zur Bestellung';

  @override
  String get checkAddressAndContinue => 'Lieferadresse prüfen & weiter';

  @override
  String get makeReservation => 'Tisch reservieren';

  @override
  String get dataSaved => 'Daten gespeichert - weiter zum Menü';

  @override
  String get addressConfirmed => 'Lieferadresse bestätigt - weiter zum Menü';

  @override
  String get reservationSuccessful => 'Reservierung erfolgreich! Bestätigung wurde per E-Mail versendet.';

  @override
  String get pleaseEnterEmail => 'Bitte E-Mail-Adresse eingeben';

  @override
  String get pleaseEnterValidEmail => 'Bitte gültige E-Mail-Adresse eingeben';

  @override
  String get pleaseEnterPhone => 'Bitte Telefonnummer eingeben';

  @override
  String get phoneTooShort => 'Telefonnummer zu kurz';

  @override
  String get pleaseEnterStreet => 'Bitte Straße eingeben';

  @override
  String get number => 'Nummer';

  @override
  String get invalid => 'Ungültig';

  @override
  String get pleaseEnterCity => 'Bitte Stadt eingeben';

  @override
  String get pleaseSelectDateTime => 'Bitte Datum und Uhrzeit wählen';

  @override
  String get deliveryAddressCheck => 'Lieferadresse prüfen';

  @override
  String get enterDeliveryAddress => 'Lieferadresse eingeben';

  @override
  String get checkDeliveryAvailability => 'Wir prüfen, ob wir an Ihre Adresse liefern können';

  @override
  String get checkAvailability => 'Verfügbarkeit prüfen';

  @override
  String get deliveryAvailable => 'Lieferung verfügbar!';

  @override
  String weDeliverFrom(String restaurant) {
    return 'Wir liefern von $restaurant';
  }

  @override
  String distance(String distance) {
    return 'Entfernung: $distance km';
  }

  @override
  String get noDeliveryPossible => 'Leider keine Lieferung möglich';

  @override
  String nearestRestaurantDistance(String distance) {
    return 'Das nächste Restaurant ist $distance km entfernt';
  }

  @override
  String get addressOutsideDeliveryArea => 'Ihre Adresse liegt außerhalb unseres Liefergebiets';

  @override
  String get addressNotFound => 'Adresse konnte nicht gefunden werden. Bitte überprüfen Sie Ihre Eingabe.';

  @override
  String get errorOccurred => 'Ein Fehler ist aufgetreten. Bitte versuchen Sie es später erneut.';

  @override
  String get searchRestaurant => 'Restaurant suchen...';

  @override
  String get noRestaurantsAvailable => 'Keine Restaurants verfügbar';

  @override
  String get noRestaurantsFound => 'Keine Restaurants gefunden';

  @override
  String get currentlyNoLocations => 'Aktuell sind keine Standorte verfügbar.';

  @override
  String get tryDifferentSearch => 'Versuchen Sie eine andere Suche.';

  @override
  String get restaurantForReservation => 'Restaurant für Reservierung wählen';

  @override
  String get restaurantForDelivery => 'Restaurant für Lieferung wählen';

  @override
  String get restaurantForPickup => 'Restaurant für Abholung wählen';

  @override
  String get restaurantForDineIn => 'Restaurant zum Essen wählen';

  @override
  String get selectRestaurant => 'Restaurant wählen';

  @override
  String get reservationPossible => 'Tischreservierung möglich';

  @override
  String get deliveryAvailableShort => 'Lieferung verfügbar';

  @override
  String get pickupPossible => 'Abholung möglich';

  @override
  String get dineInPossible => 'Vor Ort essen';

  @override
  String get available => 'Verfügbar';

  @override
  String get closed => 'Geschlossen';

  @override
  String get tables => 'Tische';

  @override
  String serviceNotAvailable(String restaurant) {
    return 'Dieser Service ist in $restaurant nicht verfügbar';
  }

  @override
  String get onlineOrderInfo => 'Online-Bestellung: Wählen Sie Ihren gewünschten Service.';

  @override
  String get deliveryInfo => 'Lieferinformationen';

  @override
  String get deliveryFee => 'Liefergebühr';

  @override
  String get minimumOrderValue => 'Mindestbestellwert';

  @override
  String get estimatedDeliveryTime => 'Geschätzte Lieferzeit';

  @override
  String get deliveryFeeInfo => 'Die Liefergebühr wird automatisch zu Ihrer Bestellung hinzugefügt.';

  @override
  String get accept => 'Akzeptieren & Weiter';

  @override
  String get freeDelivery => 'Kostenlose Lieferung';

  @override
  String get deliveryTime45to60 => '45-60 Min.';

  @override
  String get paymentOnDelivery => 'Zahlung bei Lieferung';

  @override
  String get paymentMethods => 'Zahlungsmethoden';

  @override
  String get cashOrCard => 'Bar oder Karte';

  @override
  String get changeAddress => 'Adresse ändern';

  @override
  String get continueToMenu => 'Weiter zum Menü';

  @override
  String get selectArrivalTime => 'Ankunftszeit wählen';

  @override
  String get availableTimeSlots => 'Verfügbare Zeiten';

  @override
  String get noTimeSlotsAvailable => 'Keine Zeiten verfügbar';

  @override
  String get timeSlotUnavailable => 'Diese Zeit ist nicht mehr verfügbar';

  @override
  String get arrivalTime => 'Ankunftszeit';

  @override
  String timeSlotLabel(Object time) {
    return '$time Uhr';
  }
}
