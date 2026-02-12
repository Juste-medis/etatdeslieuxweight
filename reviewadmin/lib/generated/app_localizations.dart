import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_sw.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_th.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('ko'),
    Locale('pt'),
    Locale('sw'),
    Locale('ta'),
    Locale('th'),
    Locale('ur')
  ];

  /// No description provided for @equipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get equipment;

  /// No description provided for @confirmationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to'**
  String get confirmationPrompt;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhoto;

  /// No description provided for @photoDescription.
  ///
  /// In en, this message translates to:
  /// **'Adding photos provides objective evidence for the property condition.'**
  String get photoDescription;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add comments'**
  String get addComment;

  /// No description provided for @deleteRoom.
  ///
  /// In en, this message translates to:
  /// **'Delete room'**
  String get deleteRoom;

  /// No description provided for @listOfEquipements.
  ///
  /// In en, this message translates to:
  /// **'List of equipments'**
  String get listOfEquipements;

  /// No description provided for @compteurs.
  ///
  /// In en, this message translates to:
  /// **'Meters'**
  String get compteurs;

  /// No description provided for @cles.
  ///
  /// In en, this message translates to:
  /// **'Keys'**
  String get cles;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @baseelements.
  ///
  /// In en, this message translates to:
  /// **'default'**
  String get baseelements;

  /// No description provided for @roomInventoriesDescription.
  ///
  /// In en, this message translates to:
  /// **'If there is no item, leave the value as 0'**
  String get roomInventoriesDescription;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @itemInventories.
  ///
  /// In en, this message translates to:
  /// **'Item Inventories'**
  String get itemInventories;

  /// No description provided for @roomInventories.
  ///
  /// In en, this message translates to:
  /// **'Room Inventories'**
  String get roomInventories;

  /// No description provided for @livingRoom.
  ///
  /// In en, this message translates to:
  /// **'Living Room'**
  String get livingRoom;

  /// No description provided for @bedroom.
  ///
  /// In en, this message translates to:
  /// **'Bedroom'**
  String get bedroom;

  /// No description provided for @kitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get kitchen;

  /// No description provided for @bathroom.
  ///
  /// In en, this message translates to:
  /// **'Bathroom'**
  String get bathroom;

  /// No description provided for @toilets.
  ///
  /// In en, this message translates to:
  /// **'Toilets'**
  String get toilets;

  /// No description provided for @laundry.
  ///
  /// In en, this message translates to:
  /// **'Laundry Room'**
  String get laundry;

  /// No description provided for @entrance.
  ///
  /// In en, this message translates to:
  /// **'Entrance'**
  String get entrance;

  /// No description provided for @balcony.
  ///
  /// In en, this message translates to:
  /// **'Balcony'**
  String get balcony;

  /// No description provided for @terrace.
  ///
  /// In en, this message translates to:
  /// **'Terrace'**
  String get terrace;

  /// No description provided for @parkingGarage.
  ///
  /// In en, this message translates to:
  /// **'Parking-Garage'**
  String get parkingGarage;

  /// No description provided for @cellar.
  ///
  /// In en, this message translates to:
  /// **'Cellar'**
  String get cellar;

  /// No description provided for @garden.
  ///
  /// In en, this message translates to:
  /// **'Garden'**
  String get garden;

  /// No description provided for @otherRoom.
  ///
  /// In en, this message translates to:
  /// **'Other Room'**
  String get otherRoom;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @wantToDoInventory.
  ///
  /// In en, this message translates to:
  /// **'Do you want to perform the inventory?'**
  String get wantToDoInventory;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// No description provided for @collective.
  ///
  /// In en, this message translates to:
  /// **'Collective'**
  String get collective;

  /// No description provided for @district.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get district;

  /// No description provided for @central.
  ///
  /// In en, this message translates to:
  /// **'Central'**
  String get central;

  /// No description provided for @not_applicable.
  ///
  /// In en, this message translates to:
  /// **'Not Applicable'**
  String get not_applicable;

  /// No description provided for @electric.
  ///
  /// In en, this message translates to:
  /// **'Electric'**
  String get electric;

  /// No description provided for @gas.
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get gas;

  /// No description provided for @wood.
  ///
  /// In en, this message translates to:
  /// **'Wood'**
  String get wood;

  /// No description provided for @pellet.
  ///
  /// In en, this message translates to:
  /// **'Pellet'**
  String get pellet;

  /// No description provided for @oil.
  ///
  /// In en, this message translates to:
  /// **'Oil'**
  String get oil;

  /// No description provided for @solar.
  ///
  /// In en, this message translates to:
  /// **'Solar'**
  String get solar;

  /// No description provided for @coal.
  ///
  /// In en, this message translates to:
  /// **'Coal'**
  String get coal;

  /// No description provided for @natural_gas.
  ///
  /// In en, this message translates to:
  /// **'Natural Gas'**
  String get natural_gas;

  /// No description provided for @additionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional information'**
  String get additionalInfo;

  /// No description provided for @heatingType.
  ///
  /// In en, this message translates to:
  /// **'Heating type'**
  String get heatingType;

  /// No description provided for @heatingMode.
  ///
  /// In en, this message translates to:
  /// **'Heating mode'**
  String get heatingMode;

  /// No description provided for @hotWaterType.
  ///
  /// In en, this message translates to:
  /// **'Hot water type'**
  String get hotWaterType;

  /// No description provided for @hotWaterMode.
  ///
  /// In en, this message translates to:
  /// **'Hot water mode'**
  String get hotWaterMode;

  /// No description provided for @mailbox.
  ///
  /// In en, this message translates to:
  /// **'Mailbox'**
  String get mailbox;

  /// No description provided for @typeOfGood.
  ///
  /// In en, this message translates to:
  /// **'Type of property'**
  String get typeOfGood;

  /// No description provided for @supply.
  ///
  /// In en, this message translates to:
  /// **'supply'**
  String get supply;

  /// No description provided for @propertyLabel.
  ///
  /// In en, this message translates to:
  /// **'The property'**
  String get propertyLabel;

  /// No description provided for @propertyAddress.
  ///
  /// In en, this message translates to:
  /// **'Full address of the property'**
  String get propertyAddress;

  /// No description provided for @addressComplement.
  ///
  /// In en, this message translates to:
  /// **'Additional address info'**
  String get addressComplement;

  /// No description provided for @floor.
  ///
  /// In en, this message translates to:
  /// **'Floor'**
  String get floor;

  /// No description provided for @surface.
  ///
  /// In en, this message translates to:
  /// **'Surface area'**
  String get surface;

  /// No description provided for @roomCount.
  ///
  /// In en, this message translates to:
  /// **'Number of rooms'**
  String get roomCount;

  /// No description provided for @furnished.
  ///
  /// In en, this message translates to:
  /// **'Furnished'**
  String get furnished;

  /// No description provided for @unfurnished.
  ///
  /// In en, this message translates to:
  /// **'Unfurnished'**
  String get unfurnished;

  /// No description provided for @box.
  ///
  /// In en, this message translates to:
  /// **'Box'**
  String get box;

  /// No description provided for @garage.
  ///
  /// In en, this message translates to:
  /// **'Garage'**
  String get garage;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @reviewDate.
  ///
  /// In en, this message translates to:
  /// **'Date of the review'**
  String get reviewDate;

  /// No description provided for @documentMadeAt.
  ///
  /// In en, this message translates to:
  /// **'Document made in'**
  String get documentMadeAt;

  /// No description provided for @tenantExitDate.
  ///
  /// In en, this message translates to:
  /// **'Tenant\'s move-out date'**
  String get tenantExitDate;

  /// No description provided for @pleaseentervalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseentervalidEmail;

  /// No description provided for @whereSearching.
  ///
  /// In en, this message translates to:
  /// **'Where are you searching?'**
  String get whereSearching;

  /// No description provided for @requiredInfo.
  ///
  /// In en, this message translates to:
  /// **'Required information'**
  String get requiredInfo;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validEmail;

  /// No description provided for @enterThe.
  ///
  /// In en, this message translates to:
  /// **'Enter the'**
  String get enterThe;

  /// No description provided for @tenantInfo.
  ///
  /// In en, this message translates to:
  /// **'Information about the tenant(s)'**
  String get tenantInfo;

  /// No description provided for @whoDoesReview.
  ///
  /// In en, this message translates to:
  /// **'Who performs the inspection?'**
  String get whoDoesReview;

  /// No description provided for @mandated.
  ///
  /// In en, this message translates to:
  /// **'I have been mandated'**
  String get mandated;

  /// No description provided for @fullNameMandataire.
  ///
  /// In en, this message translates to:
  /// **'Full name of the representative'**
  String get fullNameMandataire;

  /// No description provided for @addressMandataire.
  ///
  /// In en, this message translates to:
  /// **'Full address of the representative'**
  String get addressMandataire;

  /// No description provided for @emailMandataire.
  ///
  /// In en, this message translates to:
  /// **'Representative\'s owner\'s email'**
  String get emailMandataire;

  /// No description provided for @fullNameTenant.
  ///
  /// In en, this message translates to:
  /// **'Full name of the tenant'**
  String get fullNameTenant;

  /// No description provided for @addressTenant.
  ///
  /// In en, this message translates to:
  /// **'Full address of the tenant'**
  String get addressTenant;

  /// No description provided for @emailTenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant\'s email'**
  String get emailTenant;

  /// No description provided for @entryDateIfExit.
  ///
  /// In en, this message translates to:
  /// **'Tenant\'s move-in date'**
  String get entryDateIfExit;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @procurations.
  ///
  /// In en, this message translates to:
  /// **'Proxies'**
  String get procurations;

  /// No description provided for @inventories.
  ///
  /// In en, this message translates to:
  /// **'Inventories'**
  String get inventories;

  /// No description provided for @selfreview.
  ///
  /// In en, this message translates to:
  /// **'I want to perform the inspection myself or I have been mandated to do so'**
  String get selfreview;

  /// No description provided for @delegateedl.
  ///
  /// In en, this message translates to:
  /// **'I want to delegate my inventory reports to my tenants so they can simultaneously carry out an entrance and an exit inspection'**
  String get delegateedl;

  /// No description provided for @ownerinfo.
  ///
  /// In en, this message translates to:
  /// **'Owner(s) information'**
  String get ownerinfo;

  /// No description provided for @ownerfullname.
  ///
  /// In en, this message translates to:
  /// **'Full name of the owner or company'**
  String get ownerfullname;

  /// No description provided for @owneraddress.
  ///
  /// In en, this message translates to:
  /// **'Full address of the owner or company'**
  String get owneraddress;

  /// No description provided for @owneremail.
  ///
  /// In en, this message translates to:
  /// **'Email of the owner or company'**
  String get owneremail;

  /// No description provided for @selectreviewtype.
  ///
  /// In en, this message translates to:
  /// **'Select Review Type'**
  String get selectreviewtype;

  /// No description provided for @pleaseselecttype.
  ///
  /// In en, this message translates to:
  /// **'Please select the type of review you want to perform'**
  String get pleaseselecttype;

  /// No description provided for @exitreview.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitreview;

  /// No description provided for @createinventoryreport.
  ///
  /// In en, this message translates to:
  /// **'Create an inventory report'**
  String get createinventoryreport;

  /// No description provided for @bestlandlords.
  ///
  /// In en, this message translates to:
  /// **'Best Landlords'**
  String get bestlandlords;

  /// No description provided for @finalization.
  ///
  /// In en, this message translates to:
  /// **'Finalization'**
  String get finalization;

  /// No description provided for @inventoryreport.
  ///
  /// In en, this message translates to:
  /// **'Inventory Report'**
  String get inventoryreport;

  /// No description provided for @finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get finished;

  /// No description provided for @landlordprincipal.
  ///
  /// In en, this message translates to:
  /// **'Landlord Principal'**
  String get landlordprincipal;

  /// No description provided for @outgoingtenant.
  ///
  /// In en, this message translates to:
  /// **'Outgoing Tenant'**
  String get outgoingtenant;

  /// No description provided for @incomingtenant.
  ///
  /// In en, this message translates to:
  /// **'Incoming Tenant'**
  String get incomingtenant;

  /// No description provided for @findproxies.
  ///
  /// In en, this message translates to:
  /// **'Find your proxies here'**
  String get findproxies;

  /// No description provided for @findreportshere.
  ///
  /// In en, this message translates to:
  /// **'Find your property reports here'**
  String get findreportshere;

  /// No description provided for @termsandconditions.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsandconditions;

  /// No description provided for @contactus.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactus;

  /// No description provided for @deleteaccount.
  ///
  /// In en, this message translates to:
  /// **'Delete my account'**
  String get deleteaccount;

  /// No description provided for @buycredits.
  ///
  /// In en, this message translates to:
  /// **'Buy credits'**
  String get buycredits;

  /// No description provided for @myprocurations.
  ///
  /// In en, this message translates to:
  /// **'My proxies'**
  String get myprocurations;

  /// No description provided for @myreviews.
  ///
  /// In en, this message translates to:
  /// **'My property reports'**
  String get myreviews;

  /// No description provided for @signmeout.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out of your account'**
  String get signmeout;

  /// No description provided for @youwillbeloggedout.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out of your account'**
  String get youwillbeloggedout;

  /// No description provided for @doyouwantToproceed.
  ///
  /// In en, this message translates to:
  /// **'Do you want to proceed?'**
  String get doyouwantToproceed;

  /// No description provided for @signout.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signout;

  /// No description provided for @verificationInprogress.
  ///
  /// In en, this message translates to:
  /// **'Verification in progress...'**
  String get verificationInprogress;

  /// No description provided for @vevrify.
  ///
  /// In en, this message translates to:
  /// **'verify'**
  String get vevrify;

  /// No description provided for @resendotp.
  ///
  /// In en, this message translates to:
  /// **'Resend the code'**
  String get resendotp;

  /// No description provided for @pleaseEnterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// No description provided for @tenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenant;

  /// No description provided for @otpverification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpverification;

  /// No description provided for @wesendandotpto.
  ///
  /// In en, this message translates to:
  /// **'We sent an OTP to '**
  String get wesendandotpto;

  /// No description provided for @entertoconfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter it to confirm your address before continuing'**
  String get entertoconfirm;

  /// No description provided for @passmustbeatleastsixcharaters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least six characters'**
  String get passmustbeatleastsixcharaters;

  /// No description provided for @iam.
  ///
  /// In en, this message translates to:
  /// **'I am'**
  String get iam;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @hello_world.
  ///
  /// In en, this message translates to:
  /// **'Hello World'**
  String get hello_world;

  /// No description provided for @solidAlerts.
  ///
  /// In en, this message translates to:
  /// **'Solid Alerts'**
  String get solidAlerts;

  /// No description provided for @thisIsAPrimaryAlert.
  ///
  /// In en, this message translates to:
  /// **'This is a Primary alert'**
  String get thisIsAPrimaryAlert;

  /// No description provided for @thisIsASecondaryAlert.
  ///
  /// In en, this message translates to:
  /// **'This is a Secondary alert'**
  String get thisIsASecondaryAlert;

  /// No description provided for @thisIsASuccessAlert.
  ///
  /// In en, this message translates to:
  /// **'This is a Success alert'**
  String get thisIsASuccessAlert;

  /// No description provided for @thisIsAWarningAlert.
  ///
  /// In en, this message translates to:
  /// **'This is a Warning alert'**
  String get thisIsAWarningAlert;

  /// No description provided for @thisIsAInfoAlert.
  ///
  /// In en, this message translates to:
  /// **'This is a Info alert'**
  String get thisIsAInfoAlert;

  /// No description provided for @thisIsADangerAlert.
  ///
  /// In en, this message translates to:
  /// **'This is a Danger alert'**
  String get thisIsADangerAlert;

  /// No description provided for @leftBorderAlerts.
  ///
  /// In en, this message translates to:
  /// **'Left Border Alerts'**
  String get leftBorderAlerts;

  /// No description provided for @outlineAlerts.
  ///
  /// In en, this message translates to:
  /// **'Outline Alerts'**
  String get outlineAlerts;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @needAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Need an account?'**
  String get needAnAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUp;

  /// No description provided for @useGoogle.
  ///
  /// In en, this message translates to:
  /// **'Use Google'**
  String get useGoogle;

  /// No description provided for @useApple.
  ///
  /// In en, this message translates to:
  /// **'Use Apple'**
  String get useApple;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get enterYourEmailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @enterYourEmailWeWillSendYouALinkToResetYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your email, we will send you a link to Reset your password'**
  String get enterYourEmailWeWillSendYouALinkToResetYourPassword;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @shapesStyles.
  ///
  /// In en, this message translates to:
  /// **'Shapes Styles'**
  String get shapesStyles;

  /// No description provided for @indicators.
  ///
  /// In en, this message translates to:
  /// **'Indicators'**
  String get indicators;

  /// No description provided for @avatarWithContent.
  ///
  /// In en, this message translates to:
  /// **'Avatar With Content'**
  String get avatarWithContent;

  /// No description provided for @avatarGroup.
  ///
  /// In en, this message translates to:
  /// **'Avatar Group'**
  String get avatarGroup;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @sM.
  ///
  /// In en, this message translates to:
  /// **'S M'**
  String get sM;

  /// No description provided for @basic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get basic;

  /// No description provided for @defaultButtons.
  ///
  /// In en, this message translates to:
  /// **'Default Buttons'**
  String get defaultButtons;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// No description provided for @background.
  ///
  /// In en, this message translates to:
  /// **'background'**
  String get background;

  /// No description provided for @foreground.
  ///
  /// In en, this message translates to:
  /// **'foreground'**
  String get foreground;

  /// No description provided for @secondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondary;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @danger.
  ///
  /// In en, this message translates to:
  /// **'Danger'**
  String get danger;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @link.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get link;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @outlineButtons.
  ///
  /// In en, this message translates to:
  /// **'Outline Buttons'**
  String get outlineButtons;

  /// No description provided for @softButtons.
  ///
  /// In en, this message translates to:
  /// **'Soft Buttons'**
  String get softButtons;

  /// No description provided for @ghostButtons.
  ///
  /// In en, this message translates to:
  /// **'Ghost Buttons'**
  String get ghostButtons;

  /// No description provided for @buttonsWithLabel.
  ///
  /// In en, this message translates to:
  /// **'Buttons with Label'**
  String get buttonsWithLabel;

  /// No description provided for @loadMoreButtons.
  ///
  /// In en, this message translates to:
  /// **'Load More Buttons'**
  String get loadMoreButtons;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @buttonsSizes.
  ///
  /// In en, this message translates to:
  /// **'Buttons Sizes'**
  String get buttonsSizes;

  /// No description provided for @button2Xl.
  ///
  /// In en, this message translates to:
  /// **'Button 2Xl'**
  String get button2Xl;

  /// No description provided for @padding.
  ///
  /// In en, this message translates to:
  /// **'padding'**
  String get padding;

  /// No description provided for @buttonXl.
  ///
  /// In en, this message translates to:
  /// **'Button Xl'**
  String get buttonXl;

  /// No description provided for @buttonLg.
  ///
  /// In en, this message translates to:
  /// **'Button Lg'**
  String get buttonLg;

  /// No description provided for @buttonMd.
  ///
  /// In en, this message translates to:
  /// **'Button Md'**
  String get buttonMd;

  /// No description provided for @buttonSm.
  ///
  /// In en, this message translates to:
  /// **'Button Sm'**
  String get buttonSm;

  /// No description provided for @groupButtons.
  ///
  /// In en, this message translates to:
  /// **'Group Buttons'**
  String get groupButtons;

  /// No description provided for @buttonsToolbar.
  ///
  /// In en, this message translates to:
  /// **'Buttons Toolbar'**
  String get buttonsToolbar;

  /// No description provided for @verticalVariation.
  ///
  /// In en, this message translates to:
  /// **'Vertical Variation'**
  String get verticalVariation;

  /// No description provided for @button.
  ///
  /// In en, this message translates to:
  /// **'Button'**
  String get button;

  /// No description provided for @dropdown.
  ///
  /// In en, this message translates to:
  /// **'Dropdown'**
  String get dropdown;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @addNewTask.
  ///
  /// In en, this message translates to:
  /// **'Add New Task'**
  String get addNewTask;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @enterTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter title'**
  String get enterTitle;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start Date'**
  String get selectStartDate;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @selectStartTime.
  ///
  /// In en, this message translates to:
  /// **'Select start Time'**
  String get selectStartTime;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get selectEndDate;

  /// No description provided for @selectEndTime.
  ///
  /// In en, this message translates to:
  /// **'Select end time'**
  String get selectEndTime;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @enterHere.
  ///
  /// In en, this message translates to:
  /// **'Enter here'**
  String get enterHere;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @endTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get endTime;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @newTask.
  ///
  /// In en, this message translates to:
  /// **'New Task'**
  String get newTask;

  /// No description provided for @uIUXDesignReview.
  ///
  /// In en, this message translates to:
  /// **'UI UX Design Review'**
  String get uIUXDesignReview;

  /// No description provided for @writeEngagingIntroductionSectionParagraphsForYourBlog.
  ///
  /// In en, this message translates to:
  /// **'Write engaging introduction & section paragraphs for your blog.'**
  String get writeEngagingIntroductionSectionParagraphsForYourBlog;

  /// No description provided for @businessIdeas.
  ///
  /// In en, this message translates to:
  /// **'Business Ideas'**
  String get businessIdeas;

  /// No description provided for @blogPostWriting.
  ///
  /// In en, this message translates to:
  /// **'Blog Post Writing'**
  String get blogPostWriting;

  /// No description provided for @technology.
  ///
  /// In en, this message translates to:
  /// **'Technology'**
  String get technology;

  /// No description provided for @paragraphGenerator.
  ///
  /// In en, this message translates to:
  /// **'Paragraph Generator'**
  String get paragraphGenerator;

  /// No description provided for @horizontalCards.
  ///
  /// In en, this message translates to:
  /// **'Horizontal Cards'**
  String get horizontalCards;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get completed;

  /// No description provided for @cardImage.
  ///
  /// In en, this message translates to:
  /// **'Card Image'**
  String get cardImage;

  /// No description provided for @cardBorderColor.
  ///
  /// In en, this message translates to:
  /// **'Card Border Color'**
  String get cardBorderColor;

  /// No description provided for @selectAUserToStartChatting.
  ///
  /// In en, this message translates to:
  /// **'Select a user to start chatting'**
  String get selectAUserToStartChatting;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @createNewGroup.
  ///
  /// In en, this message translates to:
  /// **'Create New Group'**
  String get createNewGroup;

  /// No description provided for @deleteConversation.
  ///
  /// In en, this message translates to:
  /// **'Delete Conversation'**
  String get deleteConversation;

  /// No description provided for @blockReport.
  ///
  /// In en, this message translates to:
  /// **'Block & Report'**
  String get blockReport;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @typeHere.
  ///
  /// In en, this message translates to:
  /// **'Type here'**
  String get typeHere;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @heyThereIm.
  ///
  /// In en, this message translates to:
  /// **'Hey there I’m'**
  String get heyThereIm;

  /// No description provided for @colorsOptions.
  ///
  /// In en, this message translates to:
  /// **'Colors Options'**
  String get colorsOptions;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @incomeVSExpense.
  ///
  /// In en, this message translates to:
  /// **'Income VS Expense'**
  String get incomeVSExpense;

  /// No description provided for @newOrders.
  ///
  /// In en, this message translates to:
  /// **'New Orders'**
  String get newOrders;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @eCommerceAdminDashboardViewIsWorking.
  ///
  /// In en, this message translates to:
  /// **'ECommerceAdminDashboardView is working!'**
  String get eCommerceAdminDashboardViewIsWorking;

  /// No description provided for @hrmAdminDashboardIsWorking.
  ///
  /// In en, this message translates to:
  /// **'HRMAdminDashboard is working!'**
  String get hrmAdminDashboardIsWorking;

  /// No description provided for @influencerAdminDashboardIsWorking.
  ///
  /// In en, this message translates to:
  /// **'InfluencerAdminDashboard is working!'**
  String get influencerAdminDashboardIsWorking;

  /// No description provided for @newsAdminDashboardIsWorking.
  ///
  /// In en, this message translates to:
  /// **'NewsAdminDashboard is working!'**
  String get newsAdminDashboardIsWorking;

  /// No description provided for @wordGeneration.
  ///
  /// In en, this message translates to:
  /// **'Word Generation'**
  String get wordGeneration;

  /// No description provided for @contentsOverviews.
  ///
  /// In en, this message translates to:
  /// **'Contents Overviews'**
  String get contentsOverviews;

  /// No description provided for @subscribeStatistic.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Statistic'**
  String get subscribeStatistic;

  /// No description provided for @rewardEarningAdminDashboardIsWorking.
  ///
  /// In en, this message translates to:
  /// **'RewardEarningAdminDashboard is working!'**
  String get rewardEarningAdminDashboardIsWorking;

  /// No description provided for @sMSAdminDashboardIsWorking.
  ///
  /// In en, this message translates to:
  /// **'SMSAdminDashboard is working!'**
  String get sMSAdminDashboardIsWorking;

  /// No description provided for @tableDragDrop.
  ///
  /// In en, this message translates to:
  /// **'Table Drag & Drop'**
  String get tableDragDrop;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @starred.
  ///
  /// In en, this message translates to:
  /// **'Starred'**
  String get starred;

  /// No description provided for @sent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get sent;

  /// No description provided for @drafts.
  ///
  /// In en, this message translates to:
  /// **'Drafts'**
  String get drafts;

  /// No description provided for @spam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get spam;

  /// No description provided for @trash.
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get trash;

  /// No description provided for @compose.
  ///
  /// In en, this message translates to:
  /// **'Compose'**
  String get compose;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @newtext.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newtext;

  /// No description provided for @openNavigationMenu.
  ///
  /// In en, this message translates to:
  /// **'Open Navigation menu'**
  String get openNavigationMenu;

  /// No description provided for @whimsicalWeddingGraphicsToDesignYour.
  ///
  /// In en, this message translates to:
  /// **'Whimsical Wedding Graphics to Design Your'**
  String get whimsicalWeddingGraphicsToDesignYour;

  /// No description provided for @devonLane.
  ///
  /// In en, this message translates to:
  /// **'Devon Lane'**
  String get devonLane;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// No description provided for @generalQuestions.
  ///
  /// In en, this message translates to:
  /// **'General Questions'**
  String get generalQuestions;

  /// No description provided for @howCanYouBeSureTheNumbersAreReallyRandom.
  ///
  /// In en, this message translates to:
  /// **'How can you be sure the numbers are really random?'**
  String get howCanYouBeSureTheNumbersAreReallyRandom;

  /// No description provided for @isTheSourceCodeForTheGeneratorAvailable.
  ///
  /// In en, this message translates to:
  /// **'Is the source code for the generator available?'**
  String get isTheSourceCodeForTheGeneratorAvailable;

  /// No description provided for @canIDownloadTheGeneratorSoftwareAndRunItOnMyOwnComputer.
  ///
  /// In en, this message translates to:
  /// **'Can I download the generator software and run it on my own computer?'**
  String get canIDownloadTheGeneratorSoftwareAndRunItOnMyOwnComputer;

  /// No description provided for @canOtherInfoBeAddedToAnInvoice.
  ///
  /// In en, this message translates to:
  /// **'Can other info be added to an invoice?'**
  String get canOtherInfoBeAddedToAnInvoice;

  /// No description provided for @howDoIPickWinnersForALotteryOrDrawing.
  ///
  /// In en, this message translates to:
  /// **'How do I pick winners for a lottery or drawing?'**
  String get howDoIPickWinnersForALotteryOrDrawing;

  /// No description provided for @whatSecurityMeasuresAreInPlaceForMyData.
  ///
  /// In en, this message translates to:
  /// **'What security measures are in place for my data?'**
  String get whatSecurityMeasuresAreInPlaceForMyData;

  /// No description provided for @whatShouldIDoIfIEncounterTechnicalIssues.
  ///
  /// In en, this message translates to:
  /// **'What should I do if I encounter technical issues?'**
  String get whatShouldIDoIfIEncounterTechnicalIssues;

  /// No description provided for @ourGeneratorSourceCodeIsProprietaryAndNotPubliclyAvailable.
  ///
  /// In en, this message translates to:
  /// **'Our generator’s source code is proprietary and not publicly available, but we provide detailed documentation and support for understanding our algorithms.'**
  String get ourGeneratorSourceCodeIsProprietaryAndNotPubliclyAvailable;

  /// No description provided for @weCombineHardwareAndSoftwareMethods.
  ///
  /// In en, this message translates to:
  /// **'We combine hardware and software methods, including cryptographic algorithms, to ensure randomness. Regular statistical testing verifies the integrity and unpredictability of our numbers.'**
  String get weCombineHardwareAndSoftwareMethods;

  /// No description provided for @theGeneratorOperatesOnlyOnOurSecureOnlinePlatform.
  ///
  /// In en, this message translates to:
  /// **'The generator operates only on our secure online platform to ensure consistent performance and security. Use our platform for your needs.'**
  String get theGeneratorOperatesOnlyOnOurSecureOnlinePlatform;

  /// No description provided for @ourInvoicingSystemAllowsForCustomization.
  ///
  /// In en, this message translates to:
  /// **'Our invoicing system allows for customization like logos and messages. Refer to the user guide or contact support for assistance.'**
  String get ourInvoicingSystemAllowsForCustomization;

  /// No description provided for @weUseCryptographicAlgorithmsAndRigorousTesting.
  ///
  /// In en, this message translates to:
  /// **'We use cryptographic algorithms and rigorous testing to ensure the numbers are unpredictable and unbiased, with transparency and independent verification available.'**
  String get weUseCryptographicAlgorithmsAndRigorousTesting;

  /// No description provided for @useACertifiedRandomNumberGeneratorForAFair.
  ///
  /// In en, this message translates to:
  /// **'Use a certified random number generator for a fair and transparent drawing. Document rules and criteria clearly. Contact us for best practices.'**
  String get useACertifiedRandomNumberGeneratorForAFair;

  /// No description provided for @weImplementRobustSecurityMeasuresIncludingEncryption.
  ///
  /// In en, this message translates to:
  /// **'We implement robust security measures including encryption, secure servers, and regular audits to protect your data. Our platform adheres to industry standards for data protection and privacy. We also provide transparency about our security practices and are open to addressing any concerns.'**
  String get weImplementRobustSecurityMeasuresIncludingEncryption;

  /// No description provided for @ifYouExperienceTechnicalIssues.
  ///
  /// In en, this message translates to:
  /// **'If you experience technical issues, please contact our support team for assistance. We offer various support channels including email and phone to resolve problems promptly. Our team is dedicated to providing timely solutions and ensuring a smooth user experience.'**
  String get ifYouExperienceTechnicalIssues;

  /// No description provided for @alreadyHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get enterFullName;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter email address'**
  String get enterEmailAddress;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// No description provided for @blackTShirtForMan.
  ///
  /// In en, this message translates to:
  /// **'Black T-Shirt For Man'**
  String get blackTShirtForMan;

  /// No description provided for @salesRatio.
  ///
  /// In en, this message translates to:
  /// **'Sales Ratio'**
  String get salesRatio;

  /// No description provided for @salesByCountry.
  ///
  /// In en, this message translates to:
  /// **'Sales By Country'**
  String get salesByCountry;

  /// No description provided for @registeredOn.
  ///
  /// In en, this message translates to:
  /// **'Registered On'**
  String get registeredOn;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @position.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get position;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @inputExample.
  ///
  /// In en, this message translates to:
  /// **'Input Example'**
  String get inputExample;

  /// No description provided for @inputWithSelect.
  ///
  /// In en, this message translates to:
  /// **'Input With Select'**
  String get inputWithSelect;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @disabledInput.
  ///
  /// In en, this message translates to:
  /// **'Disabled Input'**
  String get disabledInput;

  /// No description provided for @inputWithIcon.
  ///
  /// In en, this message translates to:
  /// **'Input with Icon'**
  String get inputWithIcon;

  /// No description provided for @inputWithIconRight.
  ///
  /// In en, this message translates to:
  /// **'Input with Icon Right'**
  String get inputWithIconRight;

  /// No description provided for @inputPassword.
  ///
  /// In en, this message translates to:
  /// **'Input Password'**
  String get inputPassword;

  /// No description provided for @inputDate.
  ///
  /// In en, this message translates to:
  /// **'Input Date'**
  String get inputDate;

  /// No description provided for @roundedInput.
  ///
  /// In en, this message translates to:
  /// **'Rounded Input'**
  String get roundedInput;

  /// No description provided for @inputBorderStyle.
  ///
  /// In en, this message translates to:
  /// **'Input Border Style'**
  String get inputBorderStyle;

  /// No description provided for @exampleTextarea.
  ///
  /// In en, this message translates to:
  /// **'Example Textarea'**
  String get exampleTextarea;

  /// No description provided for @inputSizing.
  ///
  /// In en, this message translates to:
  /// **'Input Sizing'**
  String get inputSizing;

  /// No description provided for @fileInput.
  ///
  /// In en, this message translates to:
  /// **'File Input'**
  String get fileInput;

  /// No description provided for @defaultSelect.
  ///
  /// In en, this message translates to:
  /// **'Default Select'**
  String get defaultSelect;

  /// No description provided for @inputWithPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Input with Placeholder'**
  String get inputWithPlaceholder;

  /// No description provided for @selectYouStatus.
  ///
  /// In en, this message translates to:
  /// **'Select you status'**
  String get selectYouStatus;

  /// No description provided for @menuSize.
  ///
  /// In en, this message translates to:
  /// **'Menu Size'**
  String get menuSize;

  /// No description provided for @selectSize.
  ///
  /// In en, this message translates to:
  /// **'Select Size'**
  String get selectSize;

  /// No description provided for @multipleSelectInput.
  ///
  /// In en, this message translates to:
  /// **'Multiple select input'**
  String get multipleSelectInput;

  /// No description provided for @defaulttext.
  ///
  /// In en, this message translates to:
  /// **'default'**
  String get defaulttext;

  /// No description provided for @selectItems.
  ///
  /// In en, this message translates to:
  /// **'Select Items'**
  String get selectItems;

  /// No description provided for @choseACity.
  ///
  /// In en, this message translates to:
  /// **'Chose a city'**
  String get choseACity;

  /// No description provided for @textInputs.
  ///
  /// In en, this message translates to:
  /// **'Text inputs'**
  String get textInputs;

  /// No description provided for @browserDefaults.
  ///
  /// In en, this message translates to:
  /// **'Browser Defaults'**
  String get browserDefaults;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterYourFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterYourFirstName;

  /// No description provided for @pleaseEnterYourFirstName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your first name'**
  String get pleaseEnterYourFirstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterYourLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterYourLastName;

  /// No description provided for @pleaseEnterYourLastName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your last name'**
  String get pleaseEnterYourLastName;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select Country'**
  String get selectCountry;

  /// No description provided for @pleaseSelectYourCountry.
  ///
  /// In en, this message translates to:
  /// **'Please select your country'**
  String get pleaseSelectYourCountry;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @selectCity.
  ///
  /// In en, this message translates to:
  /// **'Select City'**
  String get selectCity;

  /// No description provided for @pleaseSelectYourCity.
  ///
  /// In en, this message translates to:
  /// **'Please select your city'**
  String get pleaseSelectYourCity;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No description provided for @pleaseSelectYourState.
  ///
  /// In en, this message translates to:
  /// **'Please select your state'**
  String get pleaseSelectYourState;

  /// No description provided for @agreeToTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Agree to terms and conditions'**
  String get agreeToTermsAndConditions;

  /// No description provided for @pleaseCheckThisBoxToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please check this box to continue'**
  String get pleaseCheckThisBoxToContinue;

  /// No description provided for @saveFrom.
  ///
  /// In en, this message translates to:
  /// **'Save From'**
  String get saveFrom;

  /// No description provided for @customStyles.
  ///
  /// In en, this message translates to:
  /// **'Custom Styles'**
  String get customStyles;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @uIUXDesign.
  ///
  /// In en, this message translates to:
  /// **'UI/UX Design'**
  String get uIUXDesign;

  /// No description provided for @development.
  ///
  /// In en, this message translates to:
  /// **'development'**
  String get development;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found!'**
  String get noDataFound;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get assignedTo;

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'left'**
  String get left;

  /// No description provided for @createProject.
  ///
  /// In en, this message translates to:
  /// **'Create Project'**
  String get createProject;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// No description provided for @enterProjectName.
  ///
  /// In en, this message translates to:
  /// **'Enter project name'**
  String get enterProjectName;

  /// No description provided for @pleaseEnterProjectName.
  ///
  /// In en, this message translates to:
  /// **'Please enter project name'**
  String get pleaseEnterProjectName;

  /// No description provided for @pleaseSelectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Please select start date'**
  String get pleaseSelectStartDate;

  /// No description provided for @pleaseSelectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Please select end date'**
  String get pleaseSelectEndDate;

  /// No description provided for @createNewBoard.
  ///
  /// In en, this message translates to:
  /// **'Create New Board'**
  String get createNewBoard;

  /// No description provided for @boardName.
  ///
  /// In en, this message translates to:
  /// **'Board Name'**
  String get boardName;

  /// No description provided for @enterBoardName.
  ///
  /// In en, this message translates to:
  /// **'Enter board name'**
  String get enterBoardName;

  /// No description provided for @pleaseEnterBoardName.
  ///
  /// In en, this message translates to:
  /// **'Please enter board name'**
  String get pleaseEnterBoardName;

  /// No description provided for @selectColor.
  ///
  /// In en, this message translates to:
  /// **'Select Color'**
  String get selectColor;

  /// No description provided for @addNewBoard.
  ///
  /// In en, this message translates to:
  /// **'Add New Board'**
  String get addNewBoard;

  /// No description provided for @googleMap.
  ///
  /// In en, this message translates to:
  /// **'Google Map'**
  String get googleMap;

  /// No description provided for @defaultMap.
  ///
  /// In en, this message translates to:
  /// **'Default Map'**
  String get defaultMap;

  /// No description provided for @leafletMultipleLocation.
  ///
  /// In en, this message translates to:
  /// **'Leaflet Multiple location'**
  String get leafletMultipleLocation;

  /// No description provided for @ooopsPageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Ooops! Page Not Found'**
  String get ooopsPageNotFound;

  /// No description provided for @thisPageDoesNotExist.
  ///
  /// In en, this message translates to:
  /// **'This page doesn\'t exist or was removed! We suggest you back to home'**
  String get thisPageDoesNotExist;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @newConversation.
  ///
  /// In en, this message translates to:
  /// **'New Conversation'**
  String get newConversation;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'30 Message'**
  String get message;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'15 hours ago'**
  String get hoursAgo;

  /// No description provided for @typeAMessageOrUploadAnImage.
  ///
  /// In en, this message translates to:
  /// **'Type a message or upload an image'**
  String get typeAMessageOrUploadAnImage;

  /// No description provided for @aiChatbot.
  ///
  /// In en, this message translates to:
  /// **'Ai Chatbot'**
  String get aiChatbot;

  /// No description provided for @defaultBot.
  ///
  /// In en, this message translates to:
  /// **'Default Bot'**
  String get defaultBot;

  /// No description provided for @basicPricingPlan.
  ///
  /// In en, this message translates to:
  /// **'Basic Pricing Plan'**
  String get basicPricingPlan;

  /// No description provided for @chooseYourBestPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Best Plan'**
  String get chooseYourBestPlan;

  /// No description provided for @defaultPricingPlan.
  ///
  /// In en, this message translates to:
  /// **'Default Pricing Plan'**
  String get defaultPricingPlan;

  /// No description provided for @powerfulFeaturesFor.
  ///
  /// In en, this message translates to:
  /// **'Powerful features for'**
  String get powerfulFeaturesFor;

  /// No description provided for @powerfulCreators.
  ///
  /// In en, this message translates to:
  /// **'powerful creators'**
  String get powerfulCreators;

  /// No description provided for @payMonthly.
  ///
  /// In en, this message translates to:
  /// **'Pay Monthly'**
  String get payMonthly;

  /// No description provided for @payYearly.
  ///
  /// In en, this message translates to:
  /// **'Pay Yearly'**
  String get payYearly;

  /// No description provided for @alice.
  ///
  /// In en, this message translates to:
  /// **'Alice'**
  String get alice;

  /// No description provided for @bob.
  ///
  /// In en, this message translates to:
  /// **'Bob'**
  String get bob;

  /// No description provided for @addNewProject.
  ///
  /// In en, this message translates to:
  /// **'Add New Project'**
  String get addNewProject;

  /// No description provided for @enterProjectTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Project Title'**
  String get enterProjectTitle;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter title'**
  String get pleaseEnterTitle;

  /// No description provided for @assignerTo.
  ///
  /// In en, this message translates to:
  /// **'Assigner To'**
  String get assignerTo;

  /// No description provided for @selectEmployee.
  ///
  /// In en, this message translates to:
  /// **'Select Employee'**
  String get selectEmployee;

  /// No description provided for @writeSomething.
  ///
  /// In en, this message translates to:
  /// **'Write Something'**
  String get writeSomething;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @allPriority.
  ///
  /// In en, this message translates to:
  /// **'All Priority'**
  String get allPriority;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get high;

  /// No description provided for @showing.
  ///
  /// In en, this message translates to:
  /// **'Showing'**
  String get showing;

  /// No description provided for @entries.
  ///
  /// In en, this message translates to:
  /// **'entries'**
  String get entries;

  /// No description provided for @addNewUser.
  ///
  /// In en, this message translates to:
  /// **'Add New User'**
  String get addNewUser;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get show;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @cOPYRIGHT.
  ///
  /// In en, this message translates to:
  /// **'cOPYRIGHT'**
  String get cOPYRIGHT;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All rights Reserved'**
  String get allRightsReserved;

  /// No description provided for @unknownRoute.
  ///
  /// In en, this message translates to:
  /// **'Unknown Route'**
  String get unknownRoute;

  /// No description provided for @borderedTable.
  ///
  /// In en, this message translates to:
  /// **'Bordered Table'**
  String get borderedTable;

  /// No description provided for @stripedRows.
  ///
  /// In en, this message translates to:
  /// **'Striped Rows'**
  String get stripedRows;

  /// No description provided for @hoverTable.
  ///
  /// In en, this message translates to:
  /// **'Hover Table'**
  String get hoverTable;

  /// No description provided for @tablesBorderColors.
  ///
  /// In en, this message translates to:
  /// **'Tables Border Colors'**
  String get tablesBorderColors;

  /// No description provided for @tableHead.
  ///
  /// In en, this message translates to:
  /// **'Table Head'**
  String get tableHead;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @sl.
  ///
  /// In en, this message translates to:
  /// **'sl'**
  String get sl;

  /// No description provided for @defaultTable.
  ///
  /// In en, this message translates to:
  /// **'Default Table'**
  String get defaultTable;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @whatIsLoremIpsum.
  ///
  /// In en, this message translates to:
  /// **'What is Lorem Ipsum'**
  String get whatIsLoremIpsum;

  /// No description provided for @heading.
  ///
  /// In en, this message translates to:
  /// **'Heading'**
  String get heading;

  /// No description provided for @headingColors.
  ///
  /// In en, this message translates to:
  /// **'Heading Colors'**
  String get headingColors;

  /// No description provided for @texts.
  ///
  /// In en, this message translates to:
  /// **'Texts'**
  String get texts;

  /// No description provided for @inineTextElements.
  ///
  /// In en, this message translates to:
  /// **'Inine Text Elements'**
  String get inineTextElements;

  /// No description provided for @youCanUseTheMarkTagTo.
  ///
  /// In en, this message translates to:
  /// **'You can use the mark tag to'**
  String get youCanUseTheMarkTagTo;

  /// No description provided for @highlight.
  ///
  /// In en, this message translates to:
  /// **' highlight '**
  String get highlight;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'text'**
  String get text;

  /// No description provided for @thisIsAParagraphItStandsOutFromRegularDeleteText.
  ///
  /// In en, this message translates to:
  /// **'This is a paragraph. it stands out from regular Delete text'**
  String get thisIsAParagraphItStandsOutFromRegularDeleteText;

  /// No description provided for @thisLineOfTextIsMeantToBeTreatedAsNoLongerAccurate.
  ///
  /// In en, this message translates to:
  /// **'This line of text is meant to be treated as no longer accurate.'**
  String get thisLineOfTextIsMeantToBeTreatedAsNoLongerAccurate;

  /// No description provided for @thisLineOfTextWillRenderAsUnderlined.
  ///
  /// In en, this message translates to:
  /// **'This line of text will render as underlined'**
  String get thisLineOfTextWillRenderAsUnderlined;

  /// No description provided for @thisLineOfTextIsMeantToBeTreatedAsAnAdditionToTheDocument.
  ///
  /// In en, this message translates to:
  /// **'This line of text is meant to be treated as an addition to the document.'**
  String get thisLineOfTextIsMeantToBeTreatedAsAnAdditionToTheDocument;

  /// No description provided for @thisIsAParagraphItStandsOutFromRegularText.
  ///
  /// In en, this message translates to:
  /// **'This is a paragraph. it stands out from regular text.'**
  String get thisIsAParagraphItStandsOutFromRegularText;

  /// No description provided for @thisLineRenderedAsBoldText.
  ///
  /// In en, this message translates to:
  /// **'This line rendered as bold text.'**
  String get thisLineRenderedAsBoldText;

  /// No description provided for @thisLineRenderedAsItalicizedText.
  ///
  /// In en, this message translates to:
  /// **'This line rendered as italicized text.'**
  String get thisLineRenderedAsItalicizedText;

  /// No description provided for @serial.
  ///
  /// In en, this message translates to:
  /// **'Serial'**
  String get serial;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @developer.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get developer;

  /// No description provided for @designer.
  ///
  /// In en, this message translates to:
  /// **'Designer'**
  String get designer;

  /// No description provided for @tester.
  ///
  /// In en, this message translates to:
  /// **'Tester'**
  String get tester;

  /// No description provided for @formDialog.
  ///
  /// In en, this message translates to:
  /// **'Form Dialog'**
  String get formDialog;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @selectPosition.
  ///
  /// In en, this message translates to:
  /// **'Select Position'**
  String get selectPosition;

  /// No description provided for @pleaseSelectAPosition.
  ///
  /// In en, this message translates to:
  /// **'Please select a position'**
  String get pleaseSelectAPosition;

  /// No description provided for @enterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Full Name'**
  String get enterYourFullName;

  /// No description provided for @pleaseEnterYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your full name'**
  String get pleaseEnterYourFullName;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Email'**
  String get enterYourEmail;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @enterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterYourPhoneNumber;

  /// No description provided for @pleaseEnterYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get pleaseEnterYourPhoneNumber;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @registrationDate.
  ///
  /// In en, this message translates to:
  /// **'Registration Date'**
  String get registrationDate;

  /// No description provided for @profilePicture.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePicture;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @socialMediaOverview.
  ///
  /// In en, this message translates to:
  /// **'Social Media Overview'**
  String get socialMediaOverview;

  /// No description provided for @by.
  ///
  /// In en, this message translates to:
  /// **'by'**
  String get by;

  /// No description provided for @statistic.
  ///
  /// In en, this message translates to:
  /// **'Statistic'**
  String get statistic;

  /// No description provided for @stockValue.
  ///
  /// In en, this message translates to:
  /// **'Stock Value'**
  String get stockValue;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// No description provided for @topSellingProduct.
  ///
  /// In en, this message translates to:
  /// **'Top Selling Product'**
  String get topSellingProduct;

  /// No description provided for @customerOfTheMonth.
  ///
  /// In en, this message translates to:
  /// **'Customer of the month'**
  String get customerOfTheMonth;

  /// No description provided for @top5PurchasingProduct.
  ///
  /// In en, this message translates to:
  /// **'Top 5 Purchasing Product'**
  String get top5PurchasingProduct;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @runningOrder.
  ///
  /// In en, this message translates to:
  /// **'Running Order'**
  String get runningOrder;

  /// No description provided for @pendingOrder.
  ///
  /// In en, this message translates to:
  /// **'Pending Order'**
  String get pendingOrder;

  /// No description provided for @weeklyValue.
  ///
  /// In en, this message translates to:
  /// **'Weekly Value'**
  String get weeklyValue;

  /// No description provided for @monthlyValue.
  ///
  /// In en, this message translates to:
  /// **'Monthly Value'**
  String get monthlyValue;

  /// No description provided for @yearlyValue.
  ///
  /// In en, this message translates to:
  /// **'Yearly Value'**
  String get yearlyValue;

  /// No description provided for @cashBalance.
  ///
  /// In en, this message translates to:
  /// **'Cash Balance'**
  String get cashBalance;

  /// No description provided for @bankBalance.
  ///
  /// In en, this message translates to:
  /// **'Bank Balance'**
  String get bankBalance;

  /// No description provided for @supplierDue.
  ///
  /// In en, this message translates to:
  /// **'Supplier Due'**
  String get supplierDue;

  /// No description provided for @monthlyExpense.
  ///
  /// In en, this message translates to:
  /// **'Monthly Expense'**
  String get monthlyExpense;

  /// No description provided for @debitTransaction.
  ///
  /// In en, this message translates to:
  /// **'Debit Transaction'**
  String get debitTransaction;

  /// No description provided for @creditTransaction.
  ///
  /// In en, this message translates to:
  /// **'Credit Transaction'**
  String get creditTransaction;

  /// No description provided for @generatedArticle.
  ///
  /// In en, this message translates to:
  /// **'Generated Article'**
  String get generatedArticle;

  /// No description provided for @speechToText.
  ///
  /// In en, this message translates to:
  /// **'Speech To Text'**
  String get speechToText;

  /// No description provided for @imagesGenerated.
  ///
  /// In en, this message translates to:
  /// **'Images Generated'**
  String get imagesGenerated;

  /// No description provided for @pDFGenerate.
  ///
  /// In en, this message translates to:
  /// **'PDF Generate'**
  String get pDFGenerate;

  /// No description provided for @codeGenerated.
  ///
  /// In en, this message translates to:
  /// **'Code Generated'**
  String get codeGenerated;

  /// No description provided for @voiceoverGenerated.
  ///
  /// In en, this message translates to:
  /// **'Voiceover Generated'**
  String get voiceoverGenerated;

  /// No description provided for @documentGenerated.
  ///
  /// In en, this message translates to:
  /// **'Document Generated'**
  String get documentGenerated;

  /// No description provided for @totalCreditBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Credit Balance'**
  String get totalCreditBalance;

  /// No description provided for @apple.
  ///
  /// In en, this message translates to:
  /// **'Apple'**
  String get apple;

  /// No description provided for @bananas.
  ///
  /// In en, this message translates to:
  /// **'Bananas'**
  String get bananas;

  /// No description provided for @freshSoyabeanOil.
  ///
  /// In en, this message translates to:
  /// **'Fresh Soyabean Oil'**
  String get freshSoyabeanOil;

  /// No description provided for @cabbage.
  ///
  /// In en, this message translates to:
  /// **'Cabbage'**
  String get cabbage;

  /// No description provided for @rice.
  ///
  /// In en, this message translates to:
  /// **'Rice'**
  String get rice;

  /// No description provided for @freshFruits.
  ///
  /// In en, this message translates to:
  /// **'Fresh Fruits'**
  String get freshFruits;

  /// No description provided for @beefMeat.
  ///
  /// In en, this message translates to:
  /// **'Beef Meat'**
  String get beefMeat;

  /// No description provided for @beetroot.
  ///
  /// In en, this message translates to:
  /// **'Beetroot'**
  String get beetroot;

  /// No description provided for @potato.
  ///
  /// In en, this message translates to:
  /// **'Potato'**
  String get potato;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @partyName.
  ///
  /// In en, this message translates to:
  /// **'Party Name'**
  String get partyName;

  /// No description provided for @paymentType.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get paymentType;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @estherHoward.
  ///
  /// In en, this message translates to:
  /// **'Esther Howard'**
  String get estherHoward;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @jeromeBell.
  ///
  /// In en, this message translates to:
  /// **'Jerome Bell'**
  String get jeromeBell;

  /// No description provided for @marvinMcKinney.
  ///
  /// In en, this message translates to:
  /// **'Marvin McKinney'**
  String get marvinMcKinney;

  /// No description provided for @kathrynMurphy.
  ///
  /// In en, this message translates to:
  /// **'Kathryn Murphy'**
  String get kathrynMurphy;

  /// No description provided for @floydMiles.
  ///
  /// In en, this message translates to:
  /// **'Floyd Miles'**
  String get floydMiles;

  /// No description provided for @recentSales.
  ///
  /// In en, this message translates to:
  /// **'Recent Sales'**
  String get recentSales;

  /// No description provided for @show5Results.
  ///
  /// In en, this message translates to:
  /// **'Show 5 Results'**
  String get show5Results;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @totalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSales;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @totalProfit.
  ///
  /// In en, this message translates to:
  /// **'Total Profit'**
  String get totalProfit;

  /// No description provided for @cocaCola.
  ///
  /// In en, this message translates to:
  /// **'Coca cola'**
  String get cocaCola;

  /// No description provided for @drinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get drinks;

  /// No description provided for @fanta.
  ///
  /// In en, this message translates to:
  /// **'Fanta'**
  String get fanta;

  /// No description provided for @fruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get fruits;

  /// No description provided for @bread.
  ///
  /// In en, this message translates to:
  /// **'Bread'**
  String get bread;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @jennyWilson.
  ///
  /// In en, this message translates to:
  /// **'Jenny Wilson'**
  String get jennyWilson;

  /// No description provided for @dianneRussell.
  ///
  /// In en, this message translates to:
  /// **'Dianne Russell'**
  String get dianneRussell;

  /// No description provided for @wadeWarren.
  ///
  /// In en, this message translates to:
  /// **'Wade Warren'**
  String get wadeWarren;

  /// No description provided for @darrellSteward.
  ///
  /// In en, this message translates to:
  /// **'Darrell Steward'**
  String get darrellSteward;

  /// No description provided for @dessieCooper.
  ///
  /// In en, this message translates to:
  /// **'Bessie Cooper'**
  String get dessieCooper;

  /// No description provided for @mango.
  ///
  /// In en, this message translates to:
  /// **'Mango'**
  String get mango;

  /// No description provided for @bessieCooper.
  ///
  /// In en, this message translates to:
  /// **'Bessie Cooper'**
  String get bessieCooper;

  /// No description provided for @banana.
  ///
  /// In en, this message translates to:
  /// **'Banana'**
  String get banana;

  /// No description provided for @helloAcnoo.
  ///
  /// In en, this message translates to:
  /// **'Hello Acnoo'**
  String get helloAcnoo;

  /// No description provided for @bestRegards.
  ///
  /// In en, this message translates to:
  /// **'Best Regards'**
  String get bestRegards;

  /// No description provided for @acnoo.
  ///
  /// In en, this message translates to:
  /// **'Acnoo'**
  String get acnoo;

  /// No description provided for @basicInput.
  ///
  /// In en, this message translates to:
  /// **'Basic Input'**
  String get basicInput;

  /// No description provided for @inputWithValue.
  ///
  /// In en, this message translates to:
  /// **'Input with Value'**
  String get inputWithValue;

  /// No description provided for @rounded.
  ///
  /// In en, this message translates to:
  /// **'Rounded'**
  String get rounded;

  /// No description provided for @placeholder.
  ///
  /// In en, this message translates to:
  /// **'Placeholder'**
  String get placeholder;

  /// No description provided for @inputValue.
  ///
  /// In en, this message translates to:
  /// **'Input Value'**
  String get inputValue;

  /// No description provided for @input.
  ///
  /// In en, this message translates to:
  /// **'Input'**
  String get input;

  /// No description provided for @openThisSelectMenu.
  ///
  /// In en, this message translates to:
  /// **'Open this select menu'**
  String get openThisSelectMenu;

  /// No description provided for @loremIpsumIsSimplyDummyTextOfThePrintingAndTypesettingIndustry.
  ///
  /// In en, this message translates to:
  /// **'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'**
  String get loremIpsumIsSimplyDummyTextOfThePrintingAndTypesettingIndustry;

  /// No description provided for @one.
  ///
  /// In en, this message translates to:
  /// **'One'**
  String get one;

  /// No description provided for @two.
  ///
  /// In en, this message translates to:
  /// **'two'**
  String get two;

  /// No description provided for @three.
  ///
  /// In en, this message translates to:
  /// **'three'**
  String get three;

  /// No description provided for @eligendiDoloreVoluptate.
  ///
  /// In en, this message translates to:
  /// **'eligendi dolore voluptate'**
  String get eligendiDoloreVoluptate;

  /// No description provided for @natusQuiaAut.
  ///
  /// In en, this message translates to:
  /// **'natus quia aut'**
  String get natusQuiaAut;

  /// No description provided for @aliquamSintLibero.
  ///
  /// In en, this message translates to:
  /// **'aliquam sint libero'**
  String get aliquamSintLibero;

  /// No description provided for @reiciendisRemVoluptas.
  ///
  /// In en, this message translates to:
  /// **'reiciendis rem voluptas'**
  String get reiciendisRemVoluptas;

  /// No description provided for @repellendusEumEveniet.
  ///
  /// In en, this message translates to:
  /// **'repellendus eum eveniet'**
  String get repellendusEumEveniet;

  /// No description provided for @doloribuseEtEos.
  ///
  /// In en, this message translates to:
  /// **'doloribus et eos'**
  String get doloribuseEtEos;

  /// No description provided for @illoExcepturiCupiditate.
  ///
  /// In en, this message translates to:
  /// **'illo excepturi cupiditate'**
  String get illoExcepturiCupiditate;

  /// No description provided for @sitSitAut.
  ///
  /// In en, this message translates to:
  /// **'sit sit aut'**
  String get sitSitAut;

  /// No description provided for @autemOptioVelit.
  ///
  /// In en, this message translates to:
  /// **'autem optio velit'**
  String get autemOptioVelit;

  /// No description provided for @quiaExplicaboPossimus.
  ///
  /// In en, this message translates to:
  /// **'quia explicabo possimus'**
  String get quiaExplicaboPossimus;

  /// No description provided for @ipsumAspernaturId.
  ///
  /// In en, this message translates to:
  /// **'ipsum aspernatur id'**
  String get ipsumAspernaturId;

  /// No description provided for @etEaQuis.
  ///
  /// In en, this message translates to:
  /// **'et ea quis'**
  String get etEaQuis;

  /// No description provided for @rerumSintAliquid.
  ///
  /// In en, this message translates to:
  /// **'rerum sint aliquid'**
  String get rerumSintAliquid;

  /// No description provided for @quiIsteRatione.
  ///
  /// In en, this message translates to:
  /// **'qui iste ratione'**
  String get quiIsteRatione;

  /// No description provided for @debitisUndeCorrupti.
  ///
  /// In en, this message translates to:
  /// **'debitis unde corrupti'**
  String get debitisUndeCorrupti;

  /// No description provided for @quiaEosEum.
  ///
  /// In en, this message translates to:
  /// **'quia eos eum'**
  String get quiaEosEum;

  /// No description provided for @nihilPorroEst.
  ///
  /// In en, this message translates to:
  /// **'nihil porro est'**
  String get nihilPorroEst;

  /// No description provided for @doloremSuntCorrupti.
  ///
  /// In en, this message translates to:
  /// **'dolorem sunt corrupti'**
  String get doloremSuntCorrupti;

  /// No description provided for @quiaNecessitatibusMolestiae.
  ///
  /// In en, this message translates to:
  /// **'quia necessitatibus molestiae'**
  String get quiaNecessitatibusMolestiae;

  /// No description provided for @quiMolestiaeQuis.
  ///
  /// In en, this message translates to:
  /// **'qui molestiae quis'**
  String get quiMolestiaeQuis;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'progress'**
  String get progress;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration '**
  String get duration;

  /// No description provided for @moveItemFrom.
  ///
  /// In en, this message translates to:
  /// **'Move item from'**
  String get moveItemFrom;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get move;

  /// No description provided for @exportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel'**
  String get exportExcel;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get exportCSV;

  /// No description provided for @exportPDF.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPDF;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @describeWhatKindOfCodeYouNeed.
  ///
  /// In en, this message translates to:
  /// **'Describe what kind of code you need'**
  String get describeWhatKindOfCodeYouNeed;

  /// No description provided for @codingLevel.
  ///
  /// In en, this message translates to:
  /// **'Coding Level'**
  String get codingLevel;

  /// No description provided for @programingLanguage.
  ///
  /// In en, this message translates to:
  /// **'Programing Language'**
  String get programingLanguage;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get expert;

  /// No description provided for @novice.
  ///
  /// In en, this message translates to:
  /// **'Novice'**
  String get novice;

  /// No description provided for @junior.
  ///
  /// In en, this message translates to:
  /// **'Junior'**
  String get junior;

  /// No description provided for @midLevel.
  ///
  /// In en, this message translates to:
  /// **'Mid-Level'**
  String get midLevel;

  /// No description provided for @senior.
  ///
  /// In en, this message translates to:
  /// **'Senior'**
  String get senior;

  /// No description provided for @proficient.
  ///
  /// In en, this message translates to:
  /// **'Proficient'**
  String get proficient;

  /// No description provided for @master.
  ///
  /// In en, this message translates to:
  /// **'Master'**
  String get master;

  /// No description provided for @lead.
  ///
  /// In en, this message translates to:
  /// **'Lead'**
  String get lead;

  /// No description provided for @sureHereABasicCodeForAnCounterAppUsingDartFlutterFramework.
  ///
  /// In en, this message translates to:
  /// **'Sure! Here’s a basic code for an counter app using Dart\'s Flutter framework'**
  String get sureHereABasicCodeForAnCounterAppUsingDartFlutterFramework;

  /// No description provided for @thisCodeUsesTheSetStateMethodToUpdateCountVariableStateAndUpdateTheUI.
  ///
  /// In en, this message translates to:
  /// **'This code uses the setState method to update `count` variable\'s state and update the UI'**
  String
      get thisCodeUsesTheSetStateMethodToUpdateCountVariableStateAndUpdateTheUI;

  /// No description provided for @documentName.
  ///
  /// In en, this message translates to:
  /// **'Document Name'**
  String get documentName;

  /// No description provided for @textToImage.
  ///
  /// In en, this message translates to:
  /// **'Text to Image'**
  String get textToImage;

  /// No description provided for @imageToImage.
  ///
  /// In en, this message translates to:
  /// **'Image to Image'**
  String get imageToImage;

  /// No description provided for @describeAnImageYouWantToGenerate.
  ///
  /// In en, this message translates to:
  /// **'Describe an image you want to Generate'**
  String get describeAnImageYouWantToGenerate;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @clickOrDropAnImageHere.
  ///
  /// In en, this message translates to:
  /// **'Click or drop an image here'**
  String get clickOrDropAnImageHere;

  /// No description provided for @upTo10MB.
  ///
  /// In en, this message translates to:
  /// **'Up to 10MB'**
  String get upTo10MB;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @oF.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get oF;

  /// No description provided for @narration.
  ///
  /// In en, this message translates to:
  /// **'Narration'**
  String get narration;

  /// No description provided for @conversational.
  ///
  /// In en, this message translates to:
  /// **'Conversational'**
  String get conversational;

  /// No description provided for @formal.
  ///
  /// In en, this message translates to:
  /// **'Formal'**
  String get formal;

  /// No description provided for @casual.
  ///
  /// In en, this message translates to:
  /// **'Casual'**
  String get casual;

  /// No description provided for @excited.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get excited;

  /// No description provided for @calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calm;

  /// No description provided for @serious.
  ///
  /// In en, this message translates to:
  /// **'Serious'**
  String get serious;

  /// No description provided for @friendly.
  ///
  /// In en, this message translates to:
  /// **'Friendly'**
  String get friendly;

  /// No description provided for @inspirational.
  ///
  /// In en, this message translates to:
  /// **'Inspirational'**
  String get inspirational;

  /// No description provided for @persuasive.
  ///
  /// In en, this message translates to:
  /// **'Persuasive'**
  String get persuasive;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @joyful.
  ///
  /// In en, this message translates to:
  /// **'Joyful'**
  String get joyful;

  /// No description provided for @neutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get neutral;

  /// No description provided for @authoritative.
  ///
  /// In en, this message translates to:
  /// **'Authoritative'**
  String get authoritative;

  /// No description provided for @warm.
  ///
  /// In en, this message translates to:
  /// **'Warm'**
  String get warm;

  /// No description provided for @playful.
  ///
  /// In en, this message translates to:
  /// **'Playful'**
  String get playful;

  /// No description provided for @dramatic.
  ///
  /// In en, this message translates to:
  /// **'Dramatic'**
  String get dramatic;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @empathetic.
  ///
  /// In en, this message translates to:
  /// **'Empathetic'**
  String get empathetic;

  /// No description provided for @instructional.
  ///
  /// In en, this message translates to:
  /// **'Instructional'**
  String get instructional;

  /// No description provided for @fileName.
  ///
  /// In en, this message translates to:
  /// **'File Name'**
  String get fileName;

  /// No description provided for @enterFileName.
  ///
  /// In en, this message translates to:
  /// **'Enter File Name'**
  String get enterFileName;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @voices.
  ///
  /// In en, this message translates to:
  /// **'Voices'**
  String get voices;

  /// No description provided for @speakingStyle.
  ///
  /// In en, this message translates to:
  /// **'Speaking Style'**
  String get speakingStyle;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @selectOne.
  ///
  /// In en, this message translates to:
  /// **'Select One'**
  String get selectOne;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get second;

  /// No description provided for @downloadFiels.
  ///
  /// In en, this message translates to:
  /// **'Download Fiels'**
  String get downloadFiels;

  /// No description provided for @speed.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speed;

  /// No description provided for @makeUpA5SentenceStoryAboutSharkyAToothBrushingSharkSuperhero.
  ///
  /// In en, this message translates to:
  /// **'Make up a 5-sentence story about \"Sharky\", a tooth-brushing shark superhero'**
  String get makeUpA5SentenceStoryAboutSharkyAToothBrushingSharkSuperhero;

  /// No description provided for @certainlyToProvideYouWithMoreRelevant.
  ///
  /// In en, this message translates to:
  /// **'Certainly! To provide you with more relevant and effective UX copy for a subscription plan, I\'d need some specific details. However, I can offer you a generic example. Please adapt the following based on your product or service specifics'**
  String get certainlyToProvideYouWithMoreRelevant;

  /// No description provided for @subscriptionPlanTitlePremiumMembership.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plan Title: Premium Membership'**
  String get subscriptionPlanTitlePremiumMembership;

  /// No description provided for @unlockAWorldOfExclusiveBenefitsWithOurPremiumMembership.
  ///
  /// In en, this message translates to:
  /// **'Unlock a world of exclusive benefits with our Premium Membership. Enjoy limitless access, early bird privileges, and personalized insights tailored just for you'**
  String get unlockAWorldOfExclusiveBenefitsWithOurPremiumMembership;

  /// No description provided for @introductionSection.
  ///
  /// In en, this message translates to:
  /// **'1. Introduction Section'**
  String get introductionSection;

  /// No description provided for @unlockAWorldOfExclusiveBenefits.
  ///
  /// In en, this message translates to:
  /// **'Unlock a World of Exclusive Benefits'**
  String get unlockAWorldOfExclusiveBenefits;

  /// No description provided for @upgradeToOurPremiumMembershipForAnnparalleledExperience.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to our Premium Membership for an unparalleled experience. Enjoy a host of premium features designed to elevate your [Product/Service] journey'**
  String get upgradeToOurPremiumMembershipForAnnparalleledExperience;

  /// No description provided for @featuresHighlights.
  ///
  /// In en, this message translates to:
  /// **'2. Features Highlights'**
  String get featuresHighlights;

  /// No description provided for @pricingInformation.
  ///
  /// In en, this message translates to:
  /// **'3. Pricing Information'**
  String get pricingInformation;

  /// No description provided for @limitlessAccess.
  ///
  /// In en, this message translates to:
  /// **'Limitless Access: Dive into unrestricted access to our full range of [Product/Service]. Early Bird Access: Be the first to experience new features, products, and updates before anyone else. Personalized Insights: Tailored recommendations and insights to enhance your [Product/Service] experience based on your preferences'**
  String get limitlessAccess;

  /// No description provided for @chooseThePlanThatSuitsYourNeedsNest.
  ///
  /// In en, this message translates to:
  /// **'Choose the plan that suits your needs best:'**
  String get chooseThePlanThatSuitsYourNeedsNest;

  /// No description provided for @monthlyPlan999Month.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan: \\\$9.99/month'**
  String get monthlyPlan999Month;

  /// No description provided for @annualPlanSave209588year.
  ///
  /// In en, this message translates to:
  /// **'Annual Plan: Save 20% - \\\$95.88/year'**
  String get annualPlanSave209588year;

  /// No description provided for @callToActionSection.
  ///
  /// In en, this message translates to:
  /// **'4. Call-to-Action Section'**
  String get callToActionSection;

  /// No description provided for @readyToElevateYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Ready to elevate your experience?'**
  String get readyToElevateYourExperience;

  /// No description provided for @subscribeNowButton.
  ///
  /// In en, this message translates to:
  /// **'[Subscribe Now] Button'**
  String get subscribeNowButton;

  /// No description provided for @guaranteeSection.
  ///
  /// In en, this message translates to:
  /// **'5. Guarantee Section'**
  String get guaranteeSection;

  /// No description provided for @riskFreeSatisfactionGuaranteed.
  ///
  /// In en, this message translates to:
  /// **'Risk-Free Satisfaction Guaranteed'**
  String get riskFreeSatisfactionGuaranteed;

  /// No description provided for @fAQSection.
  ///
  /// In en, this message translates to:
  /// **'6. FAQ Section'**
  String get fAQSection;

  /// No description provided for @haveQuestionsWeGotAnswers.
  ///
  /// In en, this message translates to:
  /// **'Have Questions? We\'ve Got Answers'**
  String get haveQuestionsWeGotAnswers;

  /// No description provided for @howDoICancelMySubscription.
  ///
  /// In en, this message translates to:
  /// **'How do I cancel my subscription'**
  String get howDoICancelMySubscription;

  /// No description provided for @canISwitchPlansAtAnyTime.
  ///
  /// In en, this message translates to:
  /// **'Can I switch plans at any time'**
  String get canISwitchPlansAtAnyTime;

  /// No description provided for @isMyPaymentInformationSecure.
  ///
  /// In en, this message translates to:
  /// **'Is my payment information secure'**
  String get isMyPaymentInformationSecure;

  /// No description provided for @footerSection.
  ///
  /// In en, this message translates to:
  /// **'7. Footer Section'**
  String get footerSection;

  /// No description provided for @joinYourCompanyPremiumAndExperience.
  ///
  /// In en, this message translates to:
  /// **'Join [Your Company] Premium and experience [Product/Service] like never before. Subscribe now to unlock a new level of excellence'**
  String get joinYourCompanyPremiumAndExperience;

  /// No description provided for @notSatisfiedWeOfferA30DayMoneyBackGuaranteeNoQuestionsAsked.
  ///
  /// In en, this message translates to:
  /// **'Not satisfied? We offer a 30-day money-back guarantee. No questions asked'**
  String get notSatisfiedWeOfferA30DayMoneyBackGuaranteeNoQuestionsAsked;

  /// No description provided for @feelFreeToCustomizeThisCopyAccordingToYourBrandVoice.
  ///
  /// In en, this message translates to:
  /// **'Feel free to customize this copy according to your brand voice, specific features, and pricing details'**
  String get feelFreeToCustomizeThisCopyAccordingToYourBrandVoice;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @maximumLength.
  ///
  /// In en, this message translates to:
  /// **'Maximum Length'**
  String get maximumLength;

  /// No description provided for @numberOfResults.
  ///
  /// In en, this message translates to:
  /// **'Number of Results'**
  String get numberOfResults;

  /// No description provided for @creativity.
  ///
  /// In en, this message translates to:
  /// **'Creativity'**
  String get creativity;

  /// No description provided for @toneOfVoice.
  ///
  /// In en, this message translates to:
  /// **'Tone of Voice'**
  String get toneOfVoice;

  /// No description provided for @blogWritingSuggestion.
  ///
  /// In en, this message translates to:
  /// **'Blog Writing  Suggestion'**
  String get blogWritingSuggestion;

  /// No description provided for @writeAText.
  ///
  /// In en, this message translates to:
  /// **'Write a Text'**
  String get writeAText;

  /// No description provided for @compareBusinessStrategies.
  ///
  /// In en, this message translates to:
  /// **'Compare business strategies'**
  String get compareBusinessStrategies;

  /// No description provided for @createAPersonalContentForMe.
  ///
  /// In en, this message translates to:
  /// **'Create a personal content for me'**
  String get createAPersonalContentForMe;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @productDescriptions.
  ///
  /// In en, this message translates to:
  /// **'Product Descriptions'**
  String get productDescriptions;

  /// No description provided for @socialMediaCaptions.
  ///
  /// In en, this message translates to:
  /// **'Social Media Captions'**
  String get socialMediaCaptions;

  /// No description provided for @emailNewsletters.
  ///
  /// In en, this message translates to:
  /// **'Email Newsletters'**
  String get emailNewsletters;

  /// No description provided for @sEOMetaDescriptions.
  ///
  /// In en, this message translates to:
  /// **'SEO Meta Descriptions'**
  String get sEOMetaDescriptions;

  /// No description provided for @adCopy.
  ///
  /// In en, this message translates to:
  /// **'Ad Copy'**
  String get adCopy;

  /// No description provided for @landingPageCopy.
  ///
  /// In en, this message translates to:
  /// **'Landing Page Copy'**
  String get landingPageCopy;

  /// No description provided for @pressReleases.
  ///
  /// In en, this message translates to:
  /// **'Press Releases'**
  String get pressReleases;

  /// No description provided for @whitepapers.
  ///
  /// In en, this message translates to:
  /// **'Whitepapers'**
  String get whitepapers;

  /// No description provided for @caseStudies.
  ///
  /// In en, this message translates to:
  /// **'Case Studies'**
  String get caseStudies;

  /// No description provided for @videoScripts.
  ///
  /// In en, this message translates to:
  /// **'Video Scripts'**
  String get videoScripts;

  /// No description provided for @ecommerceProductListings.
  ///
  /// In en, this message translates to:
  /// **'E-commerce Product Listings'**
  String get ecommerceProductListings;

  /// No description provided for @websiteContent.
  ///
  /// In en, this message translates to:
  /// **'Website Content'**
  String get websiteContent;

  /// No description provided for @technicalDocumentation.
  ///
  /// In en, this message translates to:
  /// **'Technical Documentation'**
  String get technicalDocumentation;

  /// No description provided for @creativeWritingShortStories.
  ///
  /// In en, this message translates to:
  /// **'Creative Writing (e.g., Short Stories)'**
  String get creativeWritingShortStories;

  /// No description provided for @brandStorytelling.
  ///
  /// In en, this message translates to:
  /// **'Brand Storytelling'**
  String get brandStorytelling;

  /// No description provided for @resumeandCoverLetters.
  ///
  /// In en, this message translates to:
  /// **'Resume and Cover Letters'**
  String get resumeandCoverLetters;

  /// No description provided for @appStoreDescriptions.
  ///
  /// In en, this message translates to:
  /// **'App Store Descriptions'**
  String get appStoreDescriptions;

  /// No description provided for @ebookWriting.
  ///
  /// In en, this message translates to:
  /// **'E-book Writing'**
  String get ebookWriting;

  /// No description provided for @customerTestimonials.
  ///
  /// In en, this message translates to:
  /// **'Customer Testimonials'**
  String get customerTestimonials;

  /// No description provided for @salesCopy.
  ///
  /// In en, this message translates to:
  /// **'Sales Copy'**
  String get salesCopy;

  /// No description provided for @howtoGuides.
  ///
  /// In en, this message translates to:
  /// **'How-to Guides'**
  String get howtoGuides;

  /// No description provided for @fAQsWriting.
  ///
  /// In en, this message translates to:
  /// **'FAQs Writing'**
  String get fAQsWriting;

  /// No description provided for @jobDescriptions.
  ///
  /// In en, this message translates to:
  /// **'Job Descriptions'**
  String get jobDescriptions;

  /// No description provided for @businessProposals.
  ///
  /// In en, this message translates to:
  /// **'Business Proposals'**
  String get businessProposals;

  /// No description provided for @coldEmailOutreach.
  ///
  /// In en, this message translates to:
  /// **'Cold Email Outreach'**
  String get coldEmailOutreach;

  /// No description provided for @speechWriting.
  ///
  /// In en, this message translates to:
  /// **'Speech Writing'**
  String get speechWriting;

  /// No description provided for @interviewQuestionWriting.
  ///
  /// In en, this message translates to:
  /// **'Interview Question Writing'**
  String get interviewQuestionWriting;

  /// No description provided for @reviewResponses.
  ///
  /// In en, this message translates to:
  /// **'Review Responses'**
  String get reviewResponses;

  /// No description provided for @eventInvitations.
  ///
  /// In en, this message translates to:
  /// **'Event Invitations'**
  String get eventInvitations;

  /// No description provided for @witty.
  ///
  /// In en, this message translates to:
  /// **'Witty'**
  String get witty;

  /// No description provided for @imaginative.
  ///
  /// In en, this message translates to:
  /// **'Imaginative'**
  String get imaginative;

  /// No description provided for @direct.
  ///
  /// In en, this message translates to:
  /// **'Direct'**
  String get direct;

  /// No description provided for @energetic.
  ///
  /// In en, this message translates to:
  /// **'Energetic'**
  String get energetic;

  /// No description provided for @reflective.
  ///
  /// In en, this message translates to:
  /// **'Reflective'**
  String get reflective;

  /// No description provided for @adventurous.
  ///
  /// In en, this message translates to:
  /// **'Adventurous'**
  String get adventurous;

  /// No description provided for @quirky.
  ///
  /// In en, this message translates to:
  /// **'Quirky'**
  String get quirky;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professional;

  /// No description provided for @confident.
  ///
  /// In en, this message translates to:
  /// **'Confident'**
  String get confident;

  /// No description provided for @respectful.
  ///
  /// In en, this message translates to:
  /// **'Respectful'**
  String get respectful;

  /// No description provided for @bold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// No description provided for @caring.
  ///
  /// In en, this message translates to:
  /// **'Caring'**
  String get caring;

  /// No description provided for @optimistic.
  ///
  /// In en, this message translates to:
  /// **'Optimistic'**
  String get optimistic;

  /// No description provided for @sophisticated.
  ///
  /// In en, this message translates to:
  /// **'Sophisticated'**
  String get sophisticated;

  /// No description provided for @humorous.
  ///
  /// In en, this message translates to:
  /// **'Humorous'**
  String get humorous;

  /// No description provided for @thoughtful.
  ///
  /// In en, this message translates to:
  /// **'Thoughtful'**
  String get thoughtful;

  /// No description provided for @keywordsSeparateWithComma.
  ///
  /// In en, this message translates to:
  /// **'Keywords (Separate with comma)'**
  String get keywordsSeparateWithComma;

  /// No description provided for @egMaanthemeAcnoo.
  ///
  /// In en, this message translates to:
  /// **'e.g. maantheme, acnoo'**
  String get egMaanthemeAcnoo;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @openAIAdmin.
  ///
  /// In en, this message translates to:
  /// **'Open AI Admin'**
  String get openAIAdmin;

  /// No description provided for @eRPAdmin.
  ///
  /// In en, this message translates to:
  /// **'ERP Admin'**
  String get eRPAdmin;

  /// No description provided for @pOSAdmin.
  ///
  /// In en, this message translates to:
  /// **'POS Admin'**
  String get pOSAdmin;

  /// No description provided for @earningAdmin.
  ///
  /// In en, this message translates to:
  /// **'Earning Admin'**
  String get earningAdmin;

  /// No description provided for @sMSAdmin.
  ///
  /// In en, this message translates to:
  /// **'SMS Admin'**
  String get sMSAdmin;

  /// No description provided for @influencerAdmin.
  ///
  /// In en, this message translates to:
  /// **'Influencer Admin'**
  String get influencerAdmin;

  /// No description provided for @hRMAdmin.
  ///
  /// In en, this message translates to:
  /// **'HRM Admin'**
  String get hRMAdmin;

  /// No description provided for @newsAdmin.
  ///
  /// In en, this message translates to:
  /// **'News Admin'**
  String get newsAdmin;

  /// No description provided for @eCommerceAdmin.
  ///
  /// In en, this message translates to:
  /// **'eCommerce Admin'**
  String get eCommerceAdmin;

  /// No description provided for @widgets.
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get widgets;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @chart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get chart;

  /// No description provided for @application.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get application;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @kanban.
  ///
  /// In en, this message translates to:
  /// **'Kanban'**
  String get kanban;

  /// No description provided for @openAI.
  ///
  /// In en, this message translates to:
  /// **'Open AI'**
  String get openAI;

  /// No description provided for @aIWriter.
  ///
  /// In en, this message translates to:
  /// **'AI Writer'**
  String get aIWriter;

  /// No description provided for @aIImage.
  ///
  /// In en, this message translates to:
  /// **'AI Image'**
  String get aIImage;

  /// No description provided for @aIChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aIChat;

  /// No description provided for @aICode.
  ///
  /// In en, this message translates to:
  /// **'AI Code'**
  String get aICode;

  /// No description provided for @aIVoiceover.
  ///
  /// In en, this message translates to:
  /// **'AI Voiceover'**
  String get aIVoiceover;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @usersList.
  ///
  /// In en, this message translates to:
  /// **'Users List'**
  String get usersList;

  /// No description provided for @usersGrid.
  ///
  /// In en, this message translates to:
  /// **'Users Grid'**
  String get usersGrid;

  /// No description provided for @tablesForms.
  ///
  /// In en, this message translates to:
  /// **'Tables & Forms'**
  String get tablesForms;

  /// No description provided for @tables.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get tables;

  /// No description provided for @basicTable.
  ///
  /// In en, this message translates to:
  /// **'Basic Table'**
  String get basicTable;

  /// No description provided for @dataTable.
  ///
  /// In en, this message translates to:
  /// **'Data Table'**
  String get dataTable;

  /// No description provided for @forms.
  ///
  /// In en, this message translates to:
  /// **'Forms'**
  String get forms;

  /// No description provided for @basicForms.
  ///
  /// In en, this message translates to:
  /// **'Basic Forms'**
  String get basicForms;

  /// No description provided for @formSelect.
  ///
  /// In en, this message translates to:
  /// **'Form Select'**
  String get formSelect;

  /// No description provided for @validation.
  ///
  /// In en, this message translates to:
  /// **'Validation'**
  String get validation;

  /// No description provided for @components.
  ///
  /// In en, this message translates to:
  /// **'Components'**
  String get components;

  /// No description provided for @buttons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get buttons;

  /// No description provided for @colors.
  ///
  /// In en, this message translates to:
  /// **'Colors'**
  String get colors;

  /// No description provided for @alert.
  ///
  /// In en, this message translates to:
  /// **'Alert'**
  String get alert;

  /// No description provided for @typography.
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get typography;

  /// No description provided for @cards.
  ///
  /// In en, this message translates to:
  /// **'Cards'**
  String get cards;

  /// No description provided for @avatars.
  ///
  /// In en, this message translates to:
  /// **'Avatars'**
  String get avatars;

  /// No description provided for @dragDrop.
  ///
  /// In en, this message translates to:
  /// **'Drag & Drop'**
  String get dragDrop;

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @authentication.
  ///
  /// In en, this message translates to:
  /// **'Authentication'**
  String get authentication;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @maps.
  ///
  /// In en, this message translates to:
  /// **'Maps'**
  String get maps;

  /// No description provided for @pricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get pricing;

  /// No description provided for @fAQs.
  ///
  /// In en, this message translates to:
  /// **'FAQs'**
  String get fAQs;

  /// No description provided for @tabsPills.
  ///
  /// In en, this message translates to:
  /// **'Tabs & Pills'**
  String get tabsPills;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error '**
  String get error;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsConditions;

  /// No description provided for @introduction.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get introduction;

  /// No description provided for @informationCollection.
  ///
  /// In en, this message translates to:
  /// **'Information Collection'**
  String get informationCollection;

  /// No description provided for @useofInformation.
  ///
  /// In en, this message translates to:
  /// **'Use of Information'**
  String get useofInformation;

  /// No description provided for @dataSharing.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get dataSharing;

  /// No description provided for @dataSecurity.
  ///
  /// In en, this message translates to:
  /// **'Data Security'**
  String get dataSecurity;

  /// No description provided for @yourRights.
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get yourRights;

  /// No description provided for @changestoThisPolicy.
  ///
  /// In en, this message translates to:
  /// **'Changes to This Policy'**
  String get changestoThisPolicy;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @ourPrivacyPolicyProvidesAComprehensive.
  ///
  /// In en, this message translates to:
  /// **'Our Privacy Policy provides a comprehensive overview of how we manage your information when you visit our website or use our services. It explains the types of data we collect, including personal details and usage information, and how we use this data to improve our offerings. The policy also covers the circumstances under which we may disclose your information to third parties and the measures we take to protect your privacy. We are deeply committed to ensuring that your personal data is handled with the highest level of care and security, safeguarding it against unauthorized access or misuse.'**
  String get ourPrivacyPolicyProvidesAComprehensive;

  /// No description provided for @weGatherARangeOfInformationToEnhanceYourExperience.
  ///
  /// In en, this message translates to:
  /// **'We gather a range of information to enhance your experience on our website and services. This includes personal details that you voluntarily provide, such as your name, email address, and other contact information. Additionally, we collect usage data like your IP address, browser type, and operating system through cookies, log files, and other tracking technologies. These technologies help us understand how you interact with our site, allowing us to improve our services and deliver a more personalized experience. We ensure that all collected data is handled with strict confidentiality and security measures.'**
  String get weGatherARangeOfInformationToEnhanceYourExperience;

  /// No description provided for @theInformationWeCollectHelpsUsEnhanceOurServices.
  ///
  /// In en, this message translates to:
  /// **'The information we collect helps us enhance our services and tailor your experience to your preferences. We use your data to communicate with you effectively and to personalize your interactions with our platform. Additionally, your data may be utilized for research and analytics purposes, allowing us to better understand user behavior and improve our offerings.'**
  String get theInformationWeCollectHelpsUsEnhanceOurServices;

  /// No description provided for @weDoNotSellOrRentYourPersonalInformationToThirdParties.
  ///
  /// In en, this message translates to:
  /// **'We do not sell or rent your personal information to third parties. However, we may share your data with trusted partners who help us operate and improve our services. These partners are carefully selected and are required to adhere to our strict privacy standards, ensuring your information remains secure and confidential.'**
  String get weDoNotSellOrRentYourPersonalInformationToThirdParties;

  /// No description provided for @weImplementAppropriateSecurityMeasures.
  ///
  /// In en, this message translates to:
  /// **'We implement appropriate security measures to protect your personal information from unauthorized access, alteration, or disclosure. Despite our efforts, no data transmission over the internet can be guaranteed to be completely secure.'**
  String get weImplementAppropriateSecurityMeasures;

  /// No description provided for @youHaveTheRightToAccessCorrect.
  ///
  /// In en, this message translates to:
  /// **'You have the right to access, correct, or delete your personal information. You can also opt out of certain data collection practices. For more details on how to exercise these rights, please contact us.'**
  String get youHaveTheRightToAccessCorrect;

  /// No description provided for @weMayUpdateThisPrivacyPolicyFromTimeToTime.
  ///
  /// In en, this message translates to:
  /// **'We may update this Privacy Policy from time to time. Any changes will be posted on this page, and we encourage you to review it periodically.'**
  String get weMayUpdateThisPrivacyPolicyFromTimeToTime;

  /// No description provided for @ifYouHaveAnyQuestionsOrConcernsAboutOurPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or concerns about our Privacy Policy, please contact us at [contact information].'**
  String get ifYouHaveAnyQuestionsOrConcernsAboutOurPrivacyPolicy;

  /// No description provided for @subMenusCannotBeNullOrEmptyIfTheItemTypeIsSubmenu.
  ///
  /// In en, this message translates to:
  /// **'Sub menus cannot be null or empty if the item type is submenu'**
  String get subMenusCannotBeNullOrEmptyIfTheItemTypeIsSubmenu;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @agreementToTerms.
  ///
  /// In en, this message translates to:
  /// **'Agreement to Terms'**
  String get agreementToTerms;

  /// No description provided for @userResponsibilities.
  ///
  /// In en, this message translates to:
  /// **'User Responsibilities'**
  String get userResponsibilities;

  /// No description provided for @prohibitedActivities.
  ///
  /// In en, this message translates to:
  /// **'Prohibited Activities'**
  String get prohibitedActivities;

  /// No description provided for @serviceModifications.
  ///
  /// In en, this message translates to:
  /// **'Service Modifications'**
  String get serviceModifications;

  /// No description provided for @limitationOfLiability.
  ///
  /// In en, this message translates to:
  /// **'Limitation of Liability'**
  String get limitationOfLiability;

  /// No description provided for @governingLaw.
  ///
  /// In en, this message translates to:
  /// **'Governing Law'**
  String get governingLaw;

  /// No description provided for @changesToTheseTerms.
  ///
  /// In en, this message translates to:
  /// **'Changes to These Terms'**
  String get changesToTheseTerms;

  /// No description provided for @contactInformation.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get contactInformation;

  /// No description provided for @byAccessingOrUsingOurWebsiteAndServices.
  ///
  /// In en, this message translates to:
  /// **'By accessing or using our website and services, you agree to be bound by these Terms and Conditions. This agreement outlines the rules and regulations governing your use of our platform, including any content, features, and services we offer. It is important that you read these terms carefully before using our services. If you do not agree with any part of these terms, you must not use our website or services. Your continued use of the platform signifies your acceptance of these terms and any future changes to them. We may update these terms from time to time, and it is your responsibility to review them periodically.'**
  String get byAccessingOrUsingOurWebsiteAndServices;

  /// No description provided for @asAUserOfOurPlatform.
  ///
  /// In en, this message translates to:
  /// **'As a user of our platform, you agree to use our services responsibly and in accordance with all applicable laws and regulations. You are responsible for ensuring that any information you provide is accurate and up-to-date. Additionally, you must maintain the confidentiality of your account credentials and are solely responsible for any activities that occur under your account. You agree not to engage in any activity that could harm others or interfere with the normal operation of our services. This includes, but is not limited to, distributing harmful content or attempting to gain unauthorized access to our systems.'**
  String get asAUserOfOurPlatform;

  /// No description provided for @youAreProhibitedFromEngagingInActivities.
  ///
  /// In en, this message translates to:
  /// **'You are prohibited from engaging in activities that violate the rights of others or the integrity of our platform. This includes, but is not limited to, any form of harassment, intellectual property infringement, or dissemination of malicious software. Using our services for illegal activities, such as fraud or theft, is strictly forbidden. We reserve the right to take appropriate action, including suspending or terminating your access, if you are found to be engaging in any prohibited activities. We also retain the right to report any illegal activities to the appropriate authorities.'**
  String get youAreProhibitedFromEngagingInActivities;

  /// No description provided for @weReserveTheRightToModify.
  ///
  /// In en, this message translates to:
  /// **'We reserve the right to modify, suspend, or discontinue any part of our services at any time without prior notice. This includes making changes to the functionality, features, or availability of our platform. While we strive to keep you informed about significant changes, we cannot guarantee that all updates will be communicated in advance. It is your responsibility to regularly review our terms and service descriptions for any updates. We are not liable for any loss or damage that may result from such modifications or disruptions. Your continued use of our services following any changes signifies your acceptance of those modifications.'**
  String get weReserveTheRightToModify;

  /// No description provided for @ourPlatformAndServicesAreProvided.
  ///
  /// In en, this message translates to:
  /// **'Our platform and services are provided on an \"as is\" and \"as available\" basis. We make no warranties, either express or implied, regarding the accuracy, completeness, or reliability of the content or services provided. We do not guarantee that our services will be uninterrupted or error-free. To the fullest extent permitted by law, we are not liable for any direct, indirect, incidental, or consequential damages arising from your use or inability to use our services. This includes, but is not limited to, damages for loss of data, profits, or other intangible losses. You agree that your sole remedy for dissatisfaction with our services is to stop using them.'**
  String get ourPlatformAndServicesAreProvided;

  /// No description provided for @theseTermsAndConditionsAreGoverned.
  ///
  /// In en, this message translates to:
  /// **'These Terms and Conditions are governed by and construed in accordance with the laws of the jurisdiction in which our company is incorporated. Any disputes arising from these terms or your use of our services will be subject to the exclusive jurisdiction of the courts located in that jurisdiction. By agreeing to these terms, you consent to the personal jurisdiction and venue of these courts. This provision does not affect your statutory rights as a consumer. If any part of these terms is found to be invalid or unenforceable, the remaining provisions will continue to apply.'**
  String get theseTermsAndConditionsAreGoverned;

  /// No description provided for @weMayUpdateTheseTermsAndConditionsPeriodically.
  ///
  /// In en, this message translates to:
  /// **'We may update these Terms and Conditions periodically to reflect changes in our services or legal requirements. When updates are made, we will post the revised terms on this page with a new effective date. It is your responsibility to review these terms regularly to stay informed about any changes. Continued use of our services after the posting of any changes constitutes acceptance of those changes. If you do not agree with the revised terms, you should discontinue use of our services. We encourage you to check this page frequently to ensure you are aware of the latest terms.'**
  String get weMayUpdateTheseTermsAndConditionsPeriodically;

  /// No description provided for @ifYouHaveAnyQuestionsOrConcernsRegardingTheseTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or concerns regarding these Terms and Conditions, please do not hesitate to contact us. You can reach us through the contact information provided on our website, which includes email addresses, phone numbers, and physical addresses. We are committed to addressing your inquiries and resolving any issues you may have in a timely manner. Your feedback is important to us, and we strive to provide prompt and effective support. Please ensure that you provide accurate contact details so that we can respond to your queries appropriately.'**
  String get ifYouHaveAnyQuestionsOrConcernsRegardingTheseTermsAndConditions;

  /// No description provided for @viewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get viewed;

  /// No description provided for @defaultLineChart.
  ///
  /// In en, this message translates to:
  /// **'Default Line Chart'**
  String get defaultLineChart;

  /// No description provided for @multipleLineChart.
  ///
  /// In en, this message translates to:
  /// **'Multiple Line Chart'**
  String get multipleLineChart;

  /// No description provided for @areaChart.
  ///
  /// In en, this message translates to:
  /// **'Area Chart'**
  String get areaChart;

  /// No description provided for @transparentChart.
  ///
  /// In en, this message translates to:
  /// **'Transparent Chart'**
  String get transparentChart;

  /// No description provided for @mingguanChart.
  ///
  /// In en, this message translates to:
  /// **'Mingguan Chart'**
  String get mingguanChart;

  /// No description provided for @pieChart.
  ///
  /// In en, this message translates to:
  /// **'Pie Chart'**
  String get pieChart;

  /// No description provided for @bitcoin.
  ///
  /// In en, this message translates to:
  /// **'Bitcoin'**
  String get bitcoin;

  /// No description provided for @solana.
  ///
  /// In en, this message translates to:
  /// **'Solana'**
  String get solana;

  /// No description provided for @ethereum.
  ///
  /// In en, this message translates to:
  /// **'Ethereum'**
  String get ethereum;

  /// No description provided for @bTC.
  ///
  /// In en, this message translates to:
  /// **'BTC'**
  String get bTC;

  /// No description provided for @sOL.
  ///
  /// In en, this message translates to:
  /// **'SOL'**
  String get sOL;

  /// No description provided for @eTH.
  ///
  /// In en, this message translates to:
  /// **'ETH'**
  String get eTH;

  /// No description provided for @visitsByDay.
  ///
  /// In en, this message translates to:
  /// **'Visits By Day'**
  String get visitsByDay;

  /// No description provided for @thisMonthLeaveRequest.
  ///
  /// In en, this message translates to:
  /// **'This Month Leave Request'**
  String get thisMonthLeaveRequest;

  /// No description provided for @sinceLastMonthLeaveRequest.
  ///
  /// In en, this message translates to:
  /// **'Since Last Month Leave Request'**
  String get sinceLastMonthLeaveRequest;

  /// No description provided for @thisMonthSalary.
  ///
  /// In en, this message translates to:
  /// **'This Month Salary'**
  String get thisMonthSalary;

  /// No description provided for @sinceLastMonthSalary.
  ///
  /// In en, this message translates to:
  /// **'Since Last Month Salary'**
  String get sinceLastMonthSalary;

  /// No description provided for @totalEmployees.
  ///
  /// In en, this message translates to:
  /// **'Total Employees'**
  String get totalEmployees;

  /// No description provided for @todayPresent.
  ///
  /// In en, this message translates to:
  /// **'Today Present'**
  String get todayPresent;

  /// No description provided for @thisMonthExpenses.
  ///
  /// In en, this message translates to:
  /// **'This Month Expenses'**
  String get thisMonthExpenses;

  /// No description provided for @sinceLastMonthExpenses.
  ///
  /// In en, this message translates to:
  /// **'Since Last Month Expenses'**
  String get sinceLastMonthExpenses;

  /// No description provided for @arleneMcCoy.
  ///
  /// In en, this message translates to:
  /// **'Arlene McCoy'**
  String get arleneMcCoy;

  /// No description provided for @eventPlanner.
  ///
  /// In en, this message translates to:
  /// **'Event planner'**
  String get eventPlanner;

  /// No description provided for @ralphEdwards.
  ///
  /// In en, this message translates to:
  /// **'Ralph Edwards'**
  String get ralphEdwards;

  /// No description provided for @languageTutor.
  ///
  /// In en, this message translates to:
  /// **'Language Tutor'**
  String get languageTutor;

  /// No description provided for @fitnessTrainer.
  ///
  /// In en, this message translates to:
  /// **'Fitness Trainer'**
  String get fitnessTrainer;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @twitter.
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get twitter;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @youtube.
  ///
  /// In en, this message translates to:
  /// **'Youtube'**
  String get youtube;

  /// No description provided for @linkedin.
  ///
  /// In en, this message translates to:
  /// **'Linkedin'**
  String get linkedin;

  /// No description provided for @pinterest.
  ///
  /// In en, this message translates to:
  /// **'Pinterest'**
  String get pinterest;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Order Status'**
  String get orderStatus;

  /// No description provided for @salesOverview.
  ///
  /// In en, this message translates to:
  /// **'Sales Overview'**
  String get salesOverview;

  /// No description provided for @totalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get totalProducts;

  /// No description provided for @totalStores.
  ///
  /// In en, this message translates to:
  /// **'Total Stores'**
  String get totalStores;

  /// No description provided for @totalDeliveryBoy.
  ///
  /// In en, this message translates to:
  /// **'Total Delivery Boy'**
  String get totalDeliveryBoy;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalSubscription.
  ///
  /// In en, this message translates to:
  /// **'Total Subscription'**
  String get totalSubscription;

  /// No description provided for @totalExpense.
  ///
  /// In en, this message translates to:
  /// **'Total Expense'**
  String get totalExpense;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @uPIPay.
  ///
  /// In en, this message translates to:
  /// **'UPI Pay'**
  String get uPIPay;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @science.
  ///
  /// In en, this message translates to:
  /// **'Science'**
  String get science;

  /// No description provided for @quizName.
  ///
  /// In en, this message translates to:
  /// **'Quiz Name'**
  String get quizName;

  /// No description provided for @rewardPoint.
  ///
  /// In en, this message translates to:
  /// **'Reward Point'**
  String get rewardPoint;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get createdAt;

  /// No description provided for @withdraw.
  ///
  /// In en, this message translates to:
  /// **'Withdraw'**
  String get withdraw;

  /// No description provided for @sMSDeliveried.
  ///
  /// In en, this message translates to:
  /// **'SMS Deliveried'**
  String get sMSDeliveried;

  /// No description provided for @sMSFailed.
  ///
  /// In en, this message translates to:
  /// **'SMS Failed'**
  String get sMSFailed;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @sMSHistoryStatistics.
  ///
  /// In en, this message translates to:
  /// **'SMS History Statistics'**
  String get sMSHistoryStatistics;

  /// No description provided for @sMSReport.
  ///
  /// In en, this message translates to:
  /// **'SMS Report'**
  String get sMSReport;

  /// No description provided for @topUsers.
  ///
  /// In en, this message translates to:
  /// **'Top Users'**
  String get topUsers;

  /// No description provided for @latestQuiz.
  ///
  /// In en, this message translates to:
  /// **'Latest Quiz'**
  String get latestQuiz;

  /// No description provided for @totalQuizCategory.
  ///
  /// In en, this message translates to:
  /// **'Total quiz category'**
  String get totalQuizCategory;

  /// No description provided for @totalQuizzes.
  ///
  /// In en, this message translates to:
  /// **'Total Quizzes'**
  String get totalQuizzes;

  /// No description provided for @totalQuestions.
  ///
  /// In en, this message translates to:
  /// **'Total Questions'**
  String get totalQuestions;

  /// No description provided for @totalWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Total Withdraw'**
  String get totalWithdraw;

  /// No description provided for @pendingWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Pending Withdraw'**
  String get pendingWithdraw;

  /// No description provided for @approvedWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Approved Withdraw'**
  String get approvedWithdraw;

  /// No description provided for @rejectedWithdraw.
  ///
  /// In en, this message translates to:
  /// **'Rejected Withdraw'**
  String get rejectedWithdraw;

  /// No description provided for @totalUser.
  ///
  /// In en, this message translates to:
  /// **'Total User'**
  String get totalUser;

  /// No description provided for @totalCurrency.
  ///
  /// In en, this message translates to:
  /// **'Total Currency'**
  String get totalCurrency;

  /// No description provided for @totalRewards.
  ///
  /// In en, this message translates to:
  /// **'Total Rewards'**
  String get totalRewards;

  /// No description provided for @formValidation.
  ///
  /// In en, this message translates to:
  /// **'Form Validation'**
  String get formValidation;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @loremIpsumIsSimplyDummyTextOfThePrinting.
  ///
  /// In en, this message translates to:
  /// **'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the '**
  String get loremIpsumIsSimplyDummyTextOfThePrinting;

  /// No description provided for @black.
  ///
  /// In en, this message translates to:
  /// **'black '**
  String get black;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'White '**
  String get white;

  /// No description provided for @bases.
  ///
  /// In en, this message translates to:
  /// **'Bases '**
  String get bases;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @promotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get promotions;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// No description provided for @thisIsImageTitle.
  ///
  /// In en, this message translates to:
  /// **'This is Image title'**
  String get thisIsImageTitle;

  /// No description provided for @uIDesign.
  ///
  /// In en, this message translates to:
  /// **'UI Design'**
  String get uIDesign;

  /// No description provided for @inReview.
  ///
  /// In en, this message translates to:
  /// **'In Review'**
  String get inReview;

  /// No description provided for @businessDashboard.
  ///
  /// In en, this message translates to:
  /// **'Business Dashboard'**
  String get businessDashboard;

  /// No description provided for @loremIpsumDolorSitAmet.
  ///
  /// In en, this message translates to:
  /// **'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore'**
  String get loremIpsumDolorSitAmet;

  /// No description provided for @molestiaeQuiaUtCumqueSitNihilIpsamRepellendus.
  ///
  /// In en, this message translates to:
  /// **'Molestiae quia ut cumque sit nihil ipsam repellendus.'**
  String get molestiaeQuiaUtCumqueSitNihilIpsamRepellendus;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @proBusiness.
  ///
  /// In en, this message translates to:
  /// **'Pro Business'**
  String get proBusiness;

  /// No description provided for @enterprise.
  ///
  /// In en, this message translates to:
  /// **'Enterprise'**
  String get enterprise;

  /// No description provided for @forTheProfessionals.
  ///
  /// In en, this message translates to:
  /// **'For the professionals'**
  String get forTheProfessionals;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'user'**
  String get user;

  /// No description provided for @assetDelivery.
  ///
  /// In en, this message translates to:
  /// **'20 Asset Delivery'**
  String get assetDelivery;

  /// No description provided for @unlimitedBandwidth.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Bandwidth'**
  String get unlimitedBandwidth;

  /// No description provided for @supportSystem.
  ///
  /// In en, this message translates to:
  /// **'Support System'**
  String get supportSystem;

  /// No description provided for @messageAllOperator.
  ///
  /// In en, this message translates to:
  /// **'120+ Message all Operator'**
  String get messageAllOperator;

  /// No description provided for @freebie.
  ///
  /// In en, this message translates to:
  /// **'Freebie'**
  String get freebie;

  /// No description provided for @idealForIndividualsWhoNeedQuickAccessToBasicFeatures.
  ///
  /// In en, this message translates to:
  /// **'Ideal for individuals who need quick access to basic features'**
  String get idealForIndividualsWhoNeedQuickAccessToBasicFeatures;

  /// No description provided for @pNGSVGGraphics.
  ///
  /// In en, this message translates to:
  /// **'20,000+ of PNG & SVG graphics'**
  String get pNGSVGGraphics;

  /// No description provided for @accessTo100MillionStockImages.
  ///
  /// In en, this message translates to:
  /// **'Access to 100 million stock images'**
  String get accessTo100MillionStockImages;

  /// No description provided for @uploadCustomIconsAndFonts.
  ///
  /// In en, this message translates to:
  /// **'Upload custom icons and fonts'**
  String get uploadCustomIconsAndFonts;

  /// No description provided for @unlimitedSharing.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Sharing'**
  String get unlimitedSharing;

  /// No description provided for @uploadGraphicsVideoInUpTo4k.
  ///
  /// In en, this message translates to:
  /// **'Upload graphics & video in up to 4k'**
  String get uploadGraphicsVideoInUpTo4k;

  /// No description provided for @unlimitedProjects.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Projects'**
  String get unlimitedProjects;

  /// No description provided for @instantAccessToOurDesignSystem.
  ///
  /// In en, this message translates to:
  /// **'Instant Access to our design system'**
  String get instantAccessToOurDesignSystem;

  /// No description provided for @createTeamsToCollaborateOnDesigns.
  ///
  /// In en, this message translates to:
  /// **'Create teams to collaborate on designs'**
  String get createTeamsToCollaborateOnDesigns;

  /// No description provided for @idealForIndividualsWhoWhoNeedAdvancedFeaturesAndToolsForClientWork.
  ///
  /// In en, this message translates to:
  /// **'Ideal for individuals who who need advanced features and tools for client work.'**
  String get idealForIndividualsWhoWhoNeedAdvancedFeaturesAndToolsForClientWork;

  /// No description provided for @idealForBusinessesWhoNeedPersonalizedServicesAndSecurityForLargeTeams.
  ///
  /// In en, this message translates to:
  /// **'Ideal for businesses who need personalized services and security for large teams.'**
  String
      get idealForBusinessesWhoNeedPersonalizedServicesAndSecurityForLargeTeams;

  /// No description provided for @totalEarning.
  ///
  /// In en, this message translates to:
  /// **'Total Earning'**
  String get totalEarning;

  /// No description provided for @wordGenerated.
  ///
  /// In en, this message translates to:
  /// **'Word Generated'**
  String get wordGenerated;

  /// No description provided for @first.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get first;

  /// No description provided for @third.
  ///
  /// In en, this message translates to:
  /// **'Third'**
  String get third;

  /// No description provided for @fourth.
  ///
  /// In en, this message translates to:
  /// **'Fourth'**
  String get fourth;

  /// No description provided for @startChat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChat;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'following'**
  String get following;

  /// No description provided for @choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Plan'**
  String get choosePlan;

  /// No description provided for @getStartedNow.
  ///
  /// In en, this message translates to:
  /// **'Get Started Now'**
  String get getStartedNow;

  /// No description provided for @dailyUses.
  ///
  /// In en, this message translates to:
  /// **'Daily Uses'**
  String get dailyUses;

  /// No description provided for @todayIncome.
  ///
  /// In en, this message translates to:
  /// **'Today Income'**
  String get todayIncome;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @codes.
  ///
  /// In en, this message translates to:
  /// **'Codes'**
  String get codes;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @voiceover.
  ///
  /// In en, this message translates to:
  /// **'Voiceover'**
  String get voiceover;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get readMore;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @helloShaidulIslam.
  ///
  /// In en, this message translates to:
  /// **'Hello, Shaidul Islam'**
  String get helloShaidulIslam;

  /// No description provided for @yourAccountIsCurrently.
  ///
  /// In en, this message translates to:
  /// **'Your Account is currently '**
  String get yourAccountIsCurrently;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freePlan;

  /// No description provided for @upgradePlan.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get upgradePlan;

  /// No description provided for @buyCredits.
  ///
  /// In en, this message translates to:
  /// **'Buy Credits'**
  String get buyCredits;

  /// No description provided for @topCustomers.
  ///
  /// In en, this message translates to:
  /// **'Top Customers'**
  String get topCustomers;

  /// No description provided for @topSellingItems.
  ///
  /// In en, this message translates to:
  /// **'Top Selling Items'**
  String get topSellingItems;

  /// No description provided for @earningReports.
  ///
  /// In en, this message translates to:
  /// **'Earning Reports'**
  String get earningReports;

  /// No description provided for @topBrands.
  ///
  /// In en, this message translates to:
  /// **'Top Brands'**
  String get topBrands;

  /// No description provided for @userStatistics.
  ///
  /// In en, this message translates to:
  /// **'User Statistics'**
  String get userStatistics;

  /// No description provided for @topVendors.
  ///
  /// In en, this message translates to:
  /// **'Top Vendors'**
  String get topVendors;

  /// No description provided for @topDeliveryMan.
  ///
  /// In en, this message translates to:
  /// **'Top Delivery Man'**
  String get topDeliveryMan;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// No description provided for @outOfDelivery.
  ///
  /// In en, this message translates to:
  /// **'Out of Delivery'**
  String get outOfDelivery;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @samsung.
  ///
  /// In en, this message translates to:
  /// **'Samsung'**
  String get samsung;

  /// No description provided for @fashion.
  ///
  /// In en, this message translates to:
  /// **'Fashion'**
  String get fashion;

  /// No description provided for @generalMotors.
  ///
  /// In en, this message translates to:
  /// **'General Motors'**
  String get generalMotors;

  /// No description provided for @foods.
  ///
  /// In en, this message translates to:
  /// **'Foods'**
  String get foods;

  /// No description provided for @revenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get revenue;

  /// No description provided for @subTitle.
  ///
  /// In en, this message translates to:
  /// **'Sub Title'**
  String get subTitle;

  /// No description provided for @bodyText.
  ///
  /// In en, this message translates to:
  /// **'Body Text'**
  String get bodyText;

  /// No description provided for @smallText.
  ///
  /// In en, this message translates to:
  /// **'Small Text'**
  String get smallText;

  /// No description provided for @thisIsTitleLoremIpsumIsSimplyDummy.
  ///
  /// In en, this message translates to:
  /// **'This is title Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry'**
  String get thisIsTitleLoremIpsumIsSimplyDummy;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @deliveryMan.
  ///
  /// In en, this message translates to:
  /// **'Delivery Man'**
  String get deliveryMan;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @orderCompleted.
  ///
  /// In en, this message translates to:
  /// **'Order Completed'**
  String get orderCompleted;

  /// No description provided for @latestRegistered.
  ///
  /// In en, this message translates to:
  /// **'Latest Registered'**
  String get latestRegistered;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'2024'**
  String get year;

  /// No description provided for @loremIpsumIsSimplyDummyTextOfThePrintingAndTypesettingIndustry2.
  ///
  /// In en, this message translates to:
  /// **'Lorem Ipsumis simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktoppublishing software like Aldus PageMaker including versions of Lorem Ipsum.\\nContrary to popular belief, Lorem Ipsum is not simply randomtext. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor atHampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites.\\nThestandard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Ciceroare also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.'**
  String get loremIpsumIsSimplyDummyTextOfThePrintingAndTypesettingIndustry2;

  /// No description provided for @powerful.
  ///
  /// In en, this message translates to:
  /// **'Powerful'**
  String get powerful;

  /// No description provided for @features.
  ///
  /// In en, this message translates to:
  /// **' Features '**
  String get features;

  /// No description provided for @pricingPlan.
  ///
  /// In en, this message translates to:
  /// **'\n& Pricing plan'**
  String get pricingPlan;

  /// No description provided for @customersGrowth.
  ///
  /// In en, this message translates to:
  /// **'Customers Growth'**
  String get customersGrowth;

  /// No description provided for @totalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total Customers'**
  String get totalCustomers;

  /// No description provided for @thisMonthCustomers.
  ///
  /// In en, this message translates to:
  /// **'18 This Month Customers'**
  String get thisMonthCustomers;

  /// No description provided for @thisMonthSMS.
  ///
  /// In en, this message translates to:
  /// **'This Month SMS'**
  String get thisMonthSMS;

  /// No description provided for @todaySendSMS.
  ///
  /// In en, this message translates to:
  /// **'12 Today Send SMS'**
  String get todaySendSMS;

  /// No description provided for @totalPlan.
  ///
  /// In en, this message translates to:
  /// **'Total Plan'**
  String get totalPlan;

  /// No description provided for @basicStandardEnterprise.
  ///
  /// In en, this message translates to:
  /// **'Basic, Standard, Enterprise'**
  String get basicStandardEnterprise;

  /// No description provided for @thisMonthIncome.
  ///
  /// In en, this message translates to:
  /// **'10,000 This Month Income'**
  String get thisMonthIncome;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sept.
  ///
  /// In en, this message translates to:
  /// **'Sept'**
  String get sept;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @outgoing.
  ///
  /// In en, this message translates to:
  /// **'Outgoing'**
  String get outgoing;

  /// No description provided for @incoming.
  ///
  /// In en, this message translates to:
  /// **'Incoming'**
  String get incoming;

  /// No description provided for @joinDate.
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// No description provided for @orderDone.
  ///
  /// In en, this message translates to:
  /// **'Order Done'**
  String get orderDone;

  /// No description provided for @recentRegisteredClient.
  ///
  /// In en, this message translates to:
  /// **'Recent Registered Client'**
  String get recentRegisteredClient;

  /// No description provided for @incomeReport.
  ///
  /// In en, this message translates to:
  /// **'Income Report'**
  String get incomeReport;

  /// No description provided for @recentRegisteredInfluencer.
  ///
  /// In en, this message translates to:
  /// **'Recent Registered Influencer'**
  String get recentRegisteredInfluencer;

  /// No description provided for @withdrawReport.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Report'**
  String get withdrawReport;

  /// No description provided for @totalClients.
  ///
  /// In en, this message translates to:
  /// **'Total Clients'**
  String get totalClients;

  /// No description provided for @activeClients.
  ///
  /// In en, this message translates to:
  /// **'Active Clients'**
  String get activeClients;

  /// No description provided for @totalInfluencer.
  ///
  /// In en, this message translates to:
  /// **'Total Influencer'**
  String get totalInfluencer;

  /// No description provided for @activeInfluencer.
  ///
  /// In en, this message translates to:
  /// **'Active Influencer'**
  String get activeInfluencer;

  /// No description provided for @totalServices.
  ///
  /// In en, this message translates to:
  /// **'Total Services'**
  String get totalServices;

  /// No description provided for @totalStaff.
  ///
  /// In en, this message translates to:
  /// **'Total Staff'**
  String get totalStaff;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @lateUser.
  ///
  /// In en, this message translates to:
  /// **'Late User'**
  String get lateUser;

  /// No description provided for @employeeId.
  ///
  /// In en, this message translates to:
  /// **'Employee Id'**
  String get employeeId;

  /// No description provided for @employeeName.
  ///
  /// In en, this message translates to:
  /// **'Employee Name'**
  String get employeeName;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @leaveDuration.
  ///
  /// In en, this message translates to:
  /// **'Leave Duration'**
  String get leaveDuration;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @leslieAlexander.
  ///
  /// In en, this message translates to:
  /// **'Leslie Alexander'**
  String get leslieAlexander;

  /// No description provided for @courtneyHenry.
  ///
  /// In en, this message translates to:
  /// **'Courtney Henry'**
  String get courtneyHenry;

  /// No description provided for @kristinWatson.
  ///
  /// In en, this message translates to:
  /// **'Kristin Watson'**
  String get kristinWatson;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @salaryReport.
  ///
  /// In en, this message translates to:
  /// **'Salary Report'**
  String get salaryReport;

  /// No description provided for @leaveRequest.
  ///
  /// In en, this message translates to:
  /// **'Leave Request'**
  String get leaveRequest;

  /// No description provided for @upcomingBirthday.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Birthday'**
  String get upcomingBirthday;

  /// No description provided for @birthdayDate.
  ///
  /// In en, this message translates to:
  /// **'Birthday Date'**
  String get birthdayDate;

  /// No description provided for @exitEmployee.
  ///
  /// In en, this message translates to:
  /// **'Exit Employee'**
  String get exitEmployee;

  /// No description provided for @employeeAttendance.
  ///
  /// In en, this message translates to:
  /// **'Employee Attendance'**
  String get employeeAttendance;

  /// No description provided for @freeUsers.
  ///
  /// In en, this message translates to:
  /// **'Free Users'**
  String get freeUsers;

  /// No description provided for @subscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed'**
  String get subscribed;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscribe;

  /// No description provided for @userStatistic.
  ///
  /// In en, this message translates to:
  /// **'User Statistic'**
  String get userStatistic;

  /// No description provided for @categoryWiseNews.
  ///
  /// In en, this message translates to:
  /// **'Category Wise News'**
  String get categoryWiseNews;

  /// No description provided for @mostViewedNews.
  ///
  /// In en, this message translates to:
  /// **'Most Viewed News'**
  String get mostViewedNews;

  /// No description provided for @latestComments.
  ///
  /// In en, this message translates to:
  /// **'Latest Comments'**
  String get latestComments;

  /// No description provided for @newsReaders.
  ///
  /// In en, this message translates to:
  /// **'News Readers'**
  String get newsReaders;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @featuredSection.
  ///
  /// In en, this message translates to:
  /// **'Featured Sectioion'**
  String get featuredSection;

  /// No description provided for @adSpaces.
  ///
  /// In en, this message translates to:
  /// **'Ad Spaces'**
  String get adSpaces;

  /// No description provided for @breakingNews.
  ///
  /// In en, this message translates to:
  /// **'Breaking News'**
  String get breakingNews;

  /// No description provided for @publishedNews.
  ///
  /// In en, this message translates to:
  /// **'Published News'**
  String get publishedNews;

  /// No description provided for @draftNews.
  ///
  /// In en, this message translates to:
  /// **'Draft News'**
  String get draftNews;

  /// No description provided for @totalBlogs.
  ///
  /// In en, this message translates to:
  /// **'Total Blogs'**
  String get totalBlogs;

  /// No description provided for @uSInflationDeceleratingInBoostToEconomy.
  ///
  /// In en, this message translates to:
  /// **'US inflation decelerating in boost to economy'**
  String get uSInflationDeceleratingInBoostToEconomy;

  /// No description provided for @politics.
  ///
  /// In en, this message translates to:
  /// **'Politics'**
  String get politics;

  /// No description provided for @familyS.
  ///
  /// In en, this message translates to:
  /// **'Family\'s'**
  String get familyS;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @travels.
  ///
  /// In en, this message translates to:
  /// **'Travels'**
  String get travels;

  /// No description provided for @religion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get religion;

  /// No description provided for @minsAgo.
  ///
  /// In en, this message translates to:
  /// **'Mins ago'**
  String get minsAgo;

  /// No description provided for @greatNews.
  ///
  /// In en, this message translates to:
  /// **'Great News'**
  String get greatNews;

  /// No description provided for @eCommerce.
  ///
  /// In en, this message translates to:
  /// **'eCommerce'**
  String get eCommerce;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCode;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enterCouponCode;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @shippingCharge.
  ///
  /// In en, this message translates to:
  /// **'Shipping Charge'**
  String get shippingCharge;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter first name'**
  String get enterFirstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter last name'**
  String get enterLastName;

  /// No description provided for @companyName.
  ///
  /// In en, this message translates to:
  /// **'Company name (optional)'**
  String get companyName;

  /// No description provided for @enterCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Enter Company name'**
  String get enterCompanyName;

  /// No description provided for @countryRegion.
  ///
  /// In en, this message translates to:
  /// **'Country / Region'**
  String get countryRegion;

  /// No description provided for @streetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street Address'**
  String get streetAddress;

  /// No description provided for @enterStreetAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter street address'**
  String get enterStreetAddress;

  /// No description provided for @townCity.
  ///
  /// In en, this message translates to:
  /// **'Town / City'**
  String get townCity;

  /// No description provided for @enterTownCity.
  ///
  /// In en, this message translates to:
  /// **'Enter Town / City'**
  String get enterTownCity;

  /// No description provided for @enterState.
  ///
  /// In en, this message translates to:
  /// **'Enter State'**
  String get enterState;

  /// No description provided for @zIPCode.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zIPCode;

  /// No description provided for @enterZIPCode.
  ///
  /// In en, this message translates to:
  /// **'Enter ZIP Code'**
  String get enterZIPCode;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Phone'**
  String get enterPhone;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @additionalInformation.
  ///
  /// In en, this message translates to:
  /// **'Additional information'**
  String get additionalInformation;

  /// No description provided for @orderNotes.
  ///
  /// In en, this message translates to:
  /// **'Order notes (optional)'**
  String get orderNotes;

  /// No description provided for @notesAboutYourOrder.
  ///
  /// In en, this message translates to:
  /// **'notes about your order'**
  String get notesAboutYourOrder;

  /// No description provided for @yourOrders.
  ///
  /// In en, this message translates to:
  /// **'Your Orders'**
  String get yourOrders;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @clickHereToEnterYourCode.
  ///
  /// In en, this message translates to:
  /// **'Click here to enter your code'**
  String get clickHereToEnterYourCode;

  /// No description provided for @haveACoupon.
  ///
  /// In en, this message translates to:
  /// **'Have a coupon'**
  String get haveACoupon;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @relatedProducts.
  ///
  /// In en, this message translates to:
  /// **'Related products'**
  String get relatedProducts;

  /// No description provided for @savannahNguyen.
  ///
  /// In en, this message translates to:
  /// **'Savannah Nguyen'**
  String get savannahNguyen;

  /// No description provided for @inStock.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get inStock;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @priceRange.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get priceRange;

  /// No description provided for @productStatus.
  ///
  /// In en, this message translates to:
  /// **'Product Status'**
  String get productStatus;

  /// No description provided for @onSale.
  ///
  /// In en, this message translates to:
  /// **'On Sale'**
  String get onSale;

  /// No description provided for @starRating.
  ///
  /// In en, this message translates to:
  /// **'Star Rating'**
  String get starRating;

  /// No description provided for @allCategory.
  ///
  /// In en, this message translates to:
  /// **'All Category'**
  String get allCategory;

  /// No description provided for @womanDress.
  ///
  /// In en, this message translates to:
  /// **'Woman Dress'**
  String get womanDress;

  /// No description provided for @tShirts.
  ///
  /// In en, this message translates to:
  /// **'T-Shirts'**
  String get tShirts;

  /// No description provided for @shoes.
  ///
  /// In en, this message translates to:
  /// **'Shoes'**
  String get shoes;

  /// No description provided for @sunGlass.
  ///
  /// In en, this message translates to:
  /// **'Sun glass'**
  String get sunGlass;

  /// No description provided for @womanBag.
  ///
  /// In en, this message translates to:
  /// **'Woman Bag'**
  String get womanBag;

  /// No description provided for @freshFood.
  ///
  /// In en, this message translates to:
  /// **'Fresh Food'**
  String get freshFood;

  /// No description provided for @smartPhone.
  ///
  /// In en, this message translates to:
  /// **'Smart Phone'**
  String get smartPhone;

  /// No description provided for @computer.
  ///
  /// In en, this message translates to:
  /// **'Computer'**
  String get computer;

  /// No description provided for @sortByPopularity.
  ///
  /// In en, this message translates to:
  /// **'Sort by Popularity'**
  String get sortByPopularity;

  /// No description provided for @sortByNewestFirst.
  ///
  /// In en, this message translates to:
  /// **'Sort by Newest First'**
  String get sortByNewestFirst;

  /// No description provided for @sortByOldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Sort by Oldest First'**
  String get sortByOldestFirst;

  /// No description provided for @sortByPriceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Sort by Price: Low to High'**
  String get sortByPriceLowToHigh;

  /// No description provided for @sortByPriceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Sort by Price: High to Low'**
  String get sortByPriceHighToLow;

  /// No description provided for @sortByBestRating.
  ///
  /// In en, this message translates to:
  /// **'Sort by Best Rating'**
  String get sortByBestRating;

  /// No description provided for @sortByMostReviewed.
  ///
  /// In en, this message translates to:
  /// **'Sort by Most Reviewed'**
  String get sortByMostReviewed;

  /// No description provided for @sortByFeatured.
  ///
  /// In en, this message translates to:
  /// **'Sort by Featured'**
  String get sortByFeatured;

  /// No description provided for @sortByRelevance.
  ///
  /// In en, this message translates to:
  /// **'Sort by Relevance'**
  String get sortByRelevance;

  /// No description provided for @sortByDiscount.
  ///
  /// In en, this message translates to:
  /// **'Sort by Discount'**
  String get sortByDiscount;

  /// No description provided for @sortByAlphabeticalAZ.
  ///
  /// In en, this message translates to:
  /// **'Sort by Alphabetical: A-Z'**
  String get sortByAlphabeticalAZ;

  /// No description provided for @sortByAlphabeticalZA.
  ///
  /// In en, this message translates to:
  /// **'Sort by Alphabetical: Z-A'**
  String get sortByAlphabeticalZA;

  /// No description provided for @sortByClosestLocation.
  ///
  /// In en, this message translates to:
  /// **'Sort by Closest Location'**
  String get sortByClosestLocation;

  /// No description provided for @sortByTrending.
  ///
  /// In en, this message translates to:
  /// **'Sort by Trending'**
  String get sortByTrending;

  /// No description provided for @sortByMostLiked.
  ///
  /// In en, this message translates to:
  /// **'Sort by Most Liked'**
  String get sortByMostLiked;

  /// No description provided for @productList.
  ///
  /// In en, this message translates to:
  /// **'Product List'**
  String get productList;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @pOSInventory.
  ///
  /// In en, this message translates to:
  /// **'POS & Inventory'**
  String get pOSInventory;

  /// No description provided for @pOSSale.
  ///
  /// In en, this message translates to:
  /// **'POS Sale'**
  String get pOSSale;

  /// No description provided for @saleList.
  ///
  /// In en, this message translates to:
  /// **'Sale List'**
  String get saleList;

  /// No description provided for @purchaseList.
  ///
  /// In en, this message translates to:
  /// **'Purchase List'**
  String get purchaseList;

  /// No description provided for @addPurchase.
  ///
  /// In en, this message translates to:
  /// **'Add Purchase'**
  String get addPurchase;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @qty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qty;

  /// No description provided for @purchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get purchasePrice;

  /// No description provided for @salesPrice.
  ///
  /// In en, this message translates to:
  /// **'Sales Price'**
  String get salesPrice;

  /// No description provided for @subTotal.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get subTotal;

  /// No description provided for @shipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @receiveAmount.
  ///
  /// In en, this message translates to:
  /// **'Receive Amount'**
  String get receiveAmount;

  /// No description provided for @ex25.
  ///
  /// In en, this message translates to:
  /// **'Ex:25'**
  String get ex25;

  /// No description provided for @changeAmount.
  ///
  /// In en, this message translates to:
  /// **'Change Amount'**
  String get changeAmount;

  /// No description provided for @dueAmount.
  ///
  /// In en, this message translates to:
  /// **'Due Amount'**
  String get dueAmount;

  /// No description provided for @exOutOfLimit.
  ///
  /// In en, this message translates to:
  /// **'Ex: out of limit'**
  String get exOutOfLimit;

  /// No description provided for @transactionID.
  ///
  /// In en, this message translates to:
  /// **'Transaction ID'**
  String get transactionID;

  /// No description provided for @exHF5gJ7.
  ///
  /// In en, this message translates to:
  /// **'Ex: HF5gJ7'**
  String get exHF5gJ7;

  /// No description provided for @searchProductByName.
  ///
  /// In en, this message translates to:
  /// **'Search product by name'**
  String get searchProductByName;

  /// No description provided for @selectASupplier.
  ///
  /// In en, this message translates to:
  /// **'Select a supplier'**
  String get selectASupplier;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @watch.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get watch;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @bag.
  ///
  /// In en, this message translates to:
  /// **'Bag'**
  String get bag;

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;

  /// No description provided for @addNewPurchase.
  ///
  /// In en, this message translates to:
  /// **'Add New Purchase'**
  String get addNewPurchase;

  /// No description provided for @invoiceNo.
  ///
  /// In en, this message translates to:
  /// **'Invoice No'**
  String get invoiceNo;

  /// No description provided for @selectAWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Select a warehouse'**
  String get selectAWarehouse;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @salePrice.
  ///
  /// In en, this message translates to:
  /// **'Sale Price'**
  String get salePrice;

  /// No description provided for @ex25411.
  ///
  /// In en, this message translates to:
  /// **'Ex:25411'**
  String get ex25411;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier Name'**
  String get supplierName;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @paymentStatus.
  ///
  /// In en, this message translates to:
  /// **'Payment Status'**
  String get paymentStatus;

  /// No description provided for @salesBy.
  ///
  /// In en, this message translates to:
  /// **'Sales By'**
  String get salesBy;

  /// No description provided for @addSales.
  ///
  /// In en, this message translates to:
  /// **'Add Sales'**
  String get addSales;

  /// No description provided for @scanSearchProductByCodeOrName.
  ///
  /// In en, this message translates to:
  /// **'Scan / search product by code or name'**
  String get scanSearchProductByCodeOrName;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get selectCustomer;

  /// No description provided for @selectWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Select Warehouse'**
  String get selectWarehouse;

  /// No description provided for @totalItem.
  ///
  /// In en, this message translates to:
  /// **'Total Item'**
  String get totalItem;

  /// No description provided for @quotation.
  ///
  /// In en, this message translates to:
  /// **'Quotation'**
  String get quotation;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'welcome'**
  String get welcome;

  /// No description provided for @wall.
  ///
  /// In en, this message translates to:
  /// **'Wall'**
  String get wall;

  /// No description provided for @ceiling.
  ///
  /// In en, this message translates to:
  /// **'Ceiling'**
  String get ceiling;

  /// No description provided for @door.
  ///
  /// In en, this message translates to:
  /// **'Door'**
  String get door;

  /// No description provided for @window.
  ///
  /// In en, this message translates to:
  /// **'Window'**
  String get window;

  /// No description provided for @sofa.
  ///
  /// In en, this message translates to:
  /// **'Sofa'**
  String get sofa;

  /// No description provided for @lamp.
  ///
  /// In en, this message translates to:
  /// **'Lamp'**
  String get lamp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'bn',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'ko',
        'pt',
        'sw',
        'ta',
        'th',
        'ur'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'sw':
      return AppLocalizationsSw();
    case 'ta':
      return AppLocalizationsTa();
    case 'th':
      return AppLocalizationsTh();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
