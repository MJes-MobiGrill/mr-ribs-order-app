import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Mr. Ribs Order App'**
  String get appName;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mr. Ribs'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Order App'**
  String get appSubtitle;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectLanguageHint.
  ///
  /// In en, this message translates to:
  /// **'Select Language / Sprache auswählen'**
  String get selectLanguageHint;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get german;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @selectOrderType.
  ///
  /// In en, this message translates to:
  /// **'Select Order Type'**
  String get selectOrderType;

  /// No description provided for @selectConsumptionType.
  ///
  /// In en, this message translates to:
  /// **'How would you like to enjoy your meal?'**
  String get selectConsumptionType;

  /// No description provided for @orderOnSite.
  ///
  /// In en, this message translates to:
  /// **'Order On-Site'**
  String get orderOnSite;

  /// No description provided for @orderOnSiteDescription.
  ///
  /// In en, this message translates to:
  /// **'Order with restaurant device'**
  String get orderOnSiteDescription;

  /// No description provided for @dineIn.
  ///
  /// In en, this message translates to:
  /// **'Dine In'**
  String get dineIn;

  /// No description provided for @dineInDescription.
  ///
  /// In en, this message translates to:
  /// **'Eat here at the restaurant'**
  String get dineInDescription;

  /// No description provided for @takeaway.
  ///
  /// In en, this message translates to:
  /// **'Takeaway'**
  String get takeaway;

  /// No description provided for @takeawayDescription.
  ///
  /// In en, this message translates to:
  /// **'Take your order to go'**
  String get takeawayDescription;

  /// No description provided for @consumptionTypeInfo.
  ///
  /// In en, this message translates to:
  /// **'You can change this option later if needed.'**
  String get consumptionTypeInfo;

  /// No description provided for @proceedingToMenu.
  ///
  /// In en, this message translates to:
  /// **'Proceeding to menu...'**
  String get proceedingToMenu;

  /// No description provided for @scanQrCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQrCode;

  /// No description provided for @scanQrCodeDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code to identify restaurant'**
  String get scanQrCodeDescription;

  /// No description provided for @processingQrCode.
  ///
  /// In en, this message translates to:
  /// **'Processing QR-Code...'**
  String get processingQrCode;

  /// No description provided for @qrCodeValid.
  ///
  /// In en, this message translates to:
  /// **'QR-Code Valid'**
  String get qrCodeValid;

  /// No description provided for @qrCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'QR-Code Invalid'**
  String get qrCodeInvalid;

  /// No description provided for @qrCodeErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'This QR-Code is not valid or the restaurant is not active.'**
  String get qrCodeErrorMessage;

  /// No description provided for @reserveTable.
  ///
  /// In en, this message translates to:
  /// **'Reserve Table'**
  String get reserveTable;

  /// No description provided for @reserveTableDescription.
  ///
  /// In en, this message translates to:
  /// **'Book a table in advance'**
  String get reserveTableDescription;

  /// No description provided for @orderOnline.
  ///
  /// In en, this message translates to:
  /// **'Order Online'**
  String get orderOnline;

  /// No description provided for @orderOnlineDescription.
  ///
  /// In en, this message translates to:
  /// **'Order with your own device'**
  String get orderOnlineDescription;

  /// No description provided for @deviceCheck.
  ///
  /// In en, this message translates to:
  /// **'Device Check'**
  String get deviceCheck;

  /// No description provided for @deviceCheckMessage.
  ///
  /// In en, this message translates to:
  /// **'Checking device registration...'**
  String get deviceCheckMessage;

  /// No description provided for @deviceRegistered.
  ///
  /// In en, this message translates to:
  /// **'Device Registered'**
  String get deviceRegistered;

  /// No description provided for @deviceNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Device Not Registered'**
  String get deviceNotRegistered;

  /// No description provided for @deviceNotRegisteredMessage.
  ///
  /// In en, this message translates to:
  /// **'This device is not registered with any Mr. Ribs restaurant.'**
  String get deviceNotRegisteredMessage;

  /// No description provided for @restaurantName.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurantName;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @deviceId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get deviceId;

  /// No description provided for @proceedToMenu.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Menu'**
  String get proceedToMenu;

  /// No description provided for @alternativeOptions.
  ///
  /// In en, this message translates to:
  /// **'Alternative Options:'**
  String get alternativeOptions;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorMessage;

  /// No description provided for @scanQrCodeMessage.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the QR code or test with the buttons below:'**
  String get scanQrCodeMessage;

  /// No description provided for @reserveTableMessage.
  ///
  /// In en, this message translates to:
  /// **'Select date, time and number of guests for your reservation.'**
  String get reserveTableMessage;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'This feature will be implemented soon.'**
  String get comingSoonMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Proceed'**
  String get proceed;

  /// No description provided for @startScan.
  ///
  /// In en, this message translates to:
  /// **'Start Scan'**
  String get startScan;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @webCameraNotSupported.
  ///
  /// In en, this message translates to:
  /// **'Camera not supported in web browser'**
  String get webCameraNotSupported;

  /// No description provided for @useTestButtonsBelow.
  ///
  /// In en, this message translates to:
  /// **'Use the test buttons below to simulate QR code scanning:'**
  String get useTestButtonsBelow;

  /// No description provided for @pointCameraAtQrCode.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at a QR code'**
  String get pointCameraAtQrCode;

  /// No description provided for @tryAnotherQrCode.
  ///
  /// In en, this message translates to:
  /// **'Please try scanning another QR code.'**
  String get tryAnotherQrCode;

  /// No description provided for @webQrScannerInfo.
  ///
  /// In en, this message translates to:
  /// **'QR-Code scanning is not available in web browsers. Please use the mobile app or scan QR codes with your device\'s camera app.'**
  String get webQrScannerInfo;

  /// No description provided for @backToMenu.
  ///
  /// In en, this message translates to:
  /// **'Back to Menu'**
  String get backToMenu;

  /// No description provided for @qrCodeScanHint.
  ///
  /// In en, this message translates to:
  /// **'Hold steady and wait for auto-detection'**
  String get qrCodeScanHint;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required for QR-Code scanning'**
  String get cameraPermissionDenied;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @scanNow.
  ///
  /// In en, this message translates to:
  /// **'Scan Now'**
  String get scanNow;

  /// No description provided for @tapScanButton.
  ///
  /// In en, this message translates to:
  /// **'Tap the scan button to detect QR codes'**
  String get tapScanButton;

  /// No description provided for @cameraActiveInBackground.
  ///
  /// In en, this message translates to:
  /// **'Camera is active in background'**
  String get cameraActiveInBackground;

  /// No description provided for @initializingCamera.
  ///
  /// In en, this message translates to:
  /// **'Initializing camera...'**
  String get initializingCamera;

  /// No description provided for @startCamera.
  ///
  /// In en, this message translates to:
  /// **'Start Camera'**
  String get startCamera;

  /// No description provided for @useWebVersion.
  ///
  /// In en, this message translates to:
  /// **'Use Web Version for Camera'**
  String get useWebVersion;

  /// No description provided for @webVersionRecommended.
  ///
  /// In en, this message translates to:
  /// **'For QR-Code scanning, please use the web version at mrribsorderapp.netlify.app'**
  String get webVersionRecommended;

  /// No description provided for @scanResult.
  ///
  /// In en, this message translates to:
  /// **'Scan Result'**
  String get scanResult;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailRequired;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'your.email@example.com'**
  String get emailHint;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone Number *'**
  String get phoneNumberRequired;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'1234567890'**
  String get phoneHint;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @streetRequired.
  ///
  /// In en, this message translates to:
  /// **'Street *'**
  String get streetRequired;

  /// No description provided for @streetHint.
  ///
  /// In en, this message translates to:
  /// **'Example Street'**
  String get streetHint;

  /// No description provided for @houseNumber.
  ///
  /// In en, this message translates to:
  /// **'No.'**
  String get houseNumber;

  /// No description provided for @houseNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'No. *'**
  String get houseNumberRequired;

  /// No description provided for @houseNumberHint.
  ///
  /// In en, this message translates to:
  /// **'123'**
  String get houseNumberHint;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// No description provided for @postalCodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Postal Code *'**
  String get postalCodeRequired;

  /// No description provided for @postalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'12345'**
  String get postalCodeHint;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cityRequired.
  ///
  /// In en, this message translates to:
  /// **'City *'**
  String get cityRequired;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'Berlin'**
  String get cityHint;

  /// No description provided for @deliveryNotes.
  ///
  /// In en, this message translates to:
  /// **'Delivery Notes (optional)'**
  String get deliveryNotes;

  /// No description provided for @additionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional Notes (optional)'**
  String get additionalNotes;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. allergies, special requests...'**
  String get notesHint;

  /// No description provided for @marketingConsent.
  ///
  /// In en, this message translates to:
  /// **'I would like to receive offers and news'**
  String get marketingConsent;

  /// No description provided for @privacyNote.
  ///
  /// In en, this message translates to:
  /// **'By entering your data, you agree to our privacy policy.'**
  String get privacyNote;

  /// No description provided for @reservationDetails.
  ///
  /// In en, this message translates to:
  /// **'Reservation Details'**
  String get reservationDetails;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @dateRequired.
  ///
  /// In en, this message translates to:
  /// **'Date *'**
  String get dateRequired;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @timeRequired.
  ///
  /// In en, this message translates to:
  /// **'Time *'**
  String get timeRequired;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @numberOfGuests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get numberOfGuests;

  /// No description provided for @numberOfGuestsRequired.
  ///
  /// In en, this message translates to:
  /// **'Guests *'**
  String get numberOfGuestsRequired;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @specialRequests.
  ///
  /// In en, this message translates to:
  /// **'Special Requests (optional)'**
  String get specialRequests;

  /// No description provided for @confirmationByEmail.
  ///
  /// In en, this message translates to:
  /// **'Confirmation by email'**
  String get confirmationByEmail;

  /// No description provided for @pickupConfirmationByEmail.
  ///
  /// In en, this message translates to:
  /// **'Pickup confirmation by email'**
  String get pickupConfirmationByEmail;

  /// No description provided for @deliveryConfirmationByEmail.
  ///
  /// In en, this message translates to:
  /// **'Delivery confirmation by email'**
  String get deliveryConfirmationByEmail;

  /// No description provided for @reservationConfirmationByEmail.
  ///
  /// In en, this message translates to:
  /// **'Reservation confirmation by email'**
  String get reservationConfirmationByEmail;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @deliveryDescription.
  ///
  /// In en, this message translates to:
  /// **'Home delivery'**
  String get deliveryDescription;

  /// No description provided for @yourContactData.
  ///
  /// In en, this message translates to:
  /// **'Your contact information for the order'**
  String get yourContactData;

  /// No description provided for @yourContactAndDeliveryData.
  ///
  /// In en, this message translates to:
  /// **'Your contact and delivery information'**
  String get yourContactAndDeliveryData;

  /// No description provided for @yourReservationData.
  ///
  /// In en, this message translates to:
  /// **'Your contact information for the reservation'**
  String get yourReservationData;

  /// No description provided for @continueToOrder.
  ///
  /// In en, this message translates to:
  /// **'Continue to order'**
  String get continueToOrder;

  /// No description provided for @checkAddressAndContinue.
  ///
  /// In en, this message translates to:
  /// **'Check address & continue'**
  String get checkAddressAndContinue;

  /// No description provided for @makeReservation.
  ///
  /// In en, this message translates to:
  /// **'Make reservation'**
  String get makeReservation;

  /// No description provided for @dataSaved.
  ///
  /// In en, this message translates to:
  /// **'Data saved - continue to menu'**
  String get dataSaved;

  /// No description provided for @addressConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Delivery address confirmed - continue to menu'**
  String get addressConfirmed;

  /// No description provided for @reservationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Reservation successful! Confirmation sent by email.'**
  String get reservationSuccessful;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter email address'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get pleaseEnterValidEmail;

  /// No description provided for @pleaseEnterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get pleaseEnterPhone;

  /// No description provided for @phoneTooShort.
  ///
  /// In en, this message translates to:
  /// **'Phone number too short'**
  String get phoneTooShort;

  /// No description provided for @pleaseEnterStreet.
  ///
  /// In en, this message translates to:
  /// **'Please enter street'**
  String get pleaseEnterStreet;

  /// No description provided for @number.
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get number;

  /// No description provided for @invalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get invalid;

  /// No description provided for @pleaseEnterCity.
  ///
  /// In en, this message translates to:
  /// **'Please enter city'**
  String get pleaseEnterCity;

  /// No description provided for @pleaseSelectDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select date and time'**
  String get pleaseSelectDateTime;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
