// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Equipment`
  String get equipment {
    return Intl.message(
      'Equipment',
      name: 'equipment',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure to`
  String get confirmationPrompt {
    return Intl.message(
      'Are you sure to',
      name: 'confirmationPrompt',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photos {
    return Intl.message(
      'Photos',
      name: 'photos',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo`
  String get addPhoto {
    return Intl.message(
      'Add a photo',
      name: 'addPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Adding photos provides objective evidence for the property condition.`
  String get photoDescription {
    return Intl.message(
      'Adding photos provides objective evidence for the property condition.',
      name: 'photoDescription',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message(
      'Comments',
      name: 'comments',
      desc: '',
      args: [],
    );
  }

  /// `Add comments`
  String get addComment {
    return Intl.message(
      'Add comments',
      name: 'addComment',
      desc: '',
      args: [],
    );
  }

  /// `Delete room`
  String get deleteRoom {
    return Intl.message(
      'Delete room',
      name: 'deleteRoom',
      desc: '',
      args: [],
    );
  }

  /// `List of equipments`
  String get listOfEquipements {
    return Intl.message(
      'List of equipments',
      name: 'listOfEquipements',
      desc: '',
      args: [],
    );
  }

  /// `Meters`
  String get compteurs {
    return Intl.message(
      'Meters',
      name: 'compteurs',
      desc: '',
      args: [],
    );
  }

  /// `Keys`
  String get cles {
    return Intl.message(
      'Keys',
      name: 'cles',
      desc: '',
      args: [],
    );
  }

  /// `No items found`
  String get noItemsFound {
    return Intl.message(
      'No items found',
      name: 'noItemsFound',
      desc: '',
      args: [],
    );
  }

  /// `default`
  String get baseelements {
    return Intl.message(
      'default',
      name: 'baseelements',
      desc: '',
      args: [],
    );
  }

  /// `If there is no item, leave the value as 0`
  String get roomInventoriesDescription {
    return Intl.message(
      'If there is no item, leave the value as 0',
      name: 'roomInventoriesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Room`
  String get room {
    return Intl.message(
      'Room',
      name: 'room',
      desc: '',
      args: [],
    );
  }

  /// `Item Inventories`
  String get itemInventories {
    return Intl.message(
      'Item Inventories',
      name: 'itemInventories',
      desc: '',
      args: [],
    );
  }

  /// `Room Inventories`
  String get roomInventories {
    return Intl.message(
      'Room Inventories',
      name: 'roomInventories',
      desc: '',
      args: [],
    );
  }

  /// `Living Room`
  String get livingRoom {
    return Intl.message(
      'Living Room',
      name: 'livingRoom',
      desc: '',
      args: [],
    );
  }

  /// `Bedroom`
  String get bedroom {
    return Intl.message(
      'Bedroom',
      name: 'bedroom',
      desc: '',
      args: [],
    );
  }

  /// `Kitchen`
  String get kitchen {
    return Intl.message(
      'Kitchen',
      name: 'kitchen',
      desc: '',
      args: [],
    );
  }

  /// `Bathroom`
  String get bathroom {
    return Intl.message(
      'Bathroom',
      name: 'bathroom',
      desc: '',
      args: [],
    );
  }

  /// `Toilets`
  String get toilets {
    return Intl.message(
      'Toilets',
      name: 'toilets',
      desc: '',
      args: [],
    );
  }

  /// `Laundry Room`
  String get laundry {
    return Intl.message(
      'Laundry Room',
      name: 'laundry',
      desc: '',
      args: [],
    );
  }

  /// `Entrance`
  String get entrance {
    return Intl.message(
      'Entrance',
      name: 'entrance',
      desc: '',
      args: [],
    );
  }

  /// `Balcony`
  String get balcony {
    return Intl.message(
      'Balcony',
      name: 'balcony',
      desc: '',
      args: [],
    );
  }

  /// `Terrace`
  String get terrace {
    return Intl.message(
      'Terrace',
      name: 'terrace',
      desc: '',
      args: [],
    );
  }

  /// `Parking-Garage`
  String get parkingGarage {
    return Intl.message(
      'Parking-Garage',
      name: 'parkingGarage',
      desc: '',
      args: [],
    );
  }

  /// `Cellar`
  String get cellar {
    return Intl.message(
      'Cellar',
      name: 'cellar',
      desc: '',
      args: [],
    );
  }

  /// `Garden`
  String get garden {
    return Intl.message(
      'Garden',
      name: 'garden',
      desc: '',
      args: [],
    );
  }

  /// `Other Room`
  String get otherRoom {
    return Intl.message(
      'Other Room',
      name: 'otherRoom',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to perform the inventory?`
  String get wantToDoInventory {
    return Intl.message(
      'Do you want to perform the inventory?',
      name: 'wantToDoInventory',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Individual`
  String get individual {
    return Intl.message(
      'Individual',
      name: 'individual',
      desc: '',
      args: [],
    );
  }

  /// `Collective`
  String get collective {
    return Intl.message(
      'Collective',
      name: 'collective',
      desc: '',
      args: [],
    );
  }

  /// `District`
  String get district {
    return Intl.message(
      'District',
      name: 'district',
      desc: '',
      args: [],
    );
  }

  /// `Central`
  String get central {
    return Intl.message(
      'Central',
      name: 'central',
      desc: '',
      args: [],
    );
  }

  /// `Not Applicable`
  String get not_applicable {
    return Intl.message(
      'Not Applicable',
      name: 'not_applicable',
      desc: '',
      args: [],
    );
  }

  /// `Electric`
  String get electric {
    return Intl.message(
      'Electric',
      name: 'electric',
      desc: '',
      args: [],
    );
  }

  /// `Gas`
  String get gas {
    return Intl.message(
      'Gas',
      name: 'gas',
      desc: '',
      args: [],
    );
  }

  /// `Wood`
  String get wood {
    return Intl.message(
      'Wood',
      name: 'wood',
      desc: '',
      args: [],
    );
  }

  /// `Pellet`
  String get pellet {
    return Intl.message(
      'Pellet',
      name: 'pellet',
      desc: '',
      args: [],
    );
  }

  /// `Oil`
  String get oil {
    return Intl.message(
      'Oil',
      name: 'oil',
      desc: '',
      args: [],
    );
  }

  /// `Solar`
  String get solar {
    return Intl.message(
      'Solar',
      name: 'solar',
      desc: '',
      args: [],
    );
  }

  /// `Coal`
  String get coal {
    return Intl.message(
      'Coal',
      name: 'coal',
      desc: '',
      args: [],
    );
  }

  /// `Natural Gas`
  String get natural_gas {
    return Intl.message(
      'Natural Gas',
      name: 'natural_gas',
      desc: '',
      args: [],
    );
  }

  /// `Additional information`
  String get additionalInfo {
    return Intl.message(
      'Additional information',
      name: 'additionalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Heating type`
  String get heatingType {
    return Intl.message(
      'Heating type',
      name: 'heatingType',
      desc: '',
      args: [],
    );
  }

  /// `Heating mode`
  String get heatingMode {
    return Intl.message(
      'Heating mode',
      name: 'heatingMode',
      desc: '',
      args: [],
    );
  }

  /// `Hot water type`
  String get hotWaterType {
    return Intl.message(
      'Hot water type',
      name: 'hotWaterType',
      desc: '',
      args: [],
    );
  }

  /// `Hot water mode`
  String get hotWaterMode {
    return Intl.message(
      'Hot water mode',
      name: 'hotWaterMode',
      desc: '',
      args: [],
    );
  }

  /// `Mailbox`
  String get mailbox {
    return Intl.message(
      'Mailbox',
      name: 'mailbox',
      desc: '',
      args: [],
    );
  }

  /// `Type of property`
  String get typeOfGood {
    return Intl.message(
      'Type of property',
      name: 'typeOfGood',
      desc: '',
      args: [],
    );
  }

  /// `supply`
  String get supply {
    return Intl.message(
      'supply',
      name: 'supply',
      desc: '',
      args: [],
    );
  }

  /// `The property`
  String get propertyLabel {
    return Intl.message(
      'The property',
      name: 'propertyLabel',
      desc: '',
      args: [],
    );
  }

  /// `Full address of the property`
  String get propertyAddress {
    return Intl.message(
      'Full address of the property',
      name: 'propertyAddress',
      desc: '',
      args: [],
    );
  }

  /// `Additional address info`
  String get addressComplement {
    return Intl.message(
      'Additional address info',
      name: 'addressComplement',
      desc: '',
      args: [],
    );
  }

  /// `Floor`
  String get floor {
    return Intl.message(
      'Floor',
      name: 'floor',
      desc: '',
      args: [],
    );
  }

  /// `Surface area`
  String get surface {
    return Intl.message(
      'Surface area',
      name: 'surface',
      desc: '',
      args: [],
    );
  }

  /// `Number of rooms`
  String get roomCount {
    return Intl.message(
      'Number of rooms',
      name: 'roomCount',
      desc: '',
      args: [],
    );
  }

  /// `Furnished`
  String get furnished {
    return Intl.message(
      'Furnished',
      name: 'furnished',
      desc: '',
      args: [],
    );
  }

  /// `Unfurnished`
  String get unfurnished {
    return Intl.message(
      'Unfurnished',
      name: 'unfurnished',
      desc: '',
      args: [],
    );
  }

  /// `Box`
  String get box {
    return Intl.message(
      'Box',
      name: 'box',
      desc: '',
      args: [],
    );
  }

  /// `Garage`
  String get garage {
    return Intl.message(
      'Garage',
      name: 'garage',
      desc: '',
      args: [],
    );
  }

  /// `Parking`
  String get parking {
    return Intl.message(
      'Parking',
      name: 'parking',
      desc: '',
      args: [],
    );
  }

  /// `Date of the review`
  String get reviewDate {
    return Intl.message(
      'Date of the review',
      name: 'reviewDate',
      desc: '',
      args: [],
    );
  }

  /// `Document made in`
  String get documentMadeAt {
    return Intl.message(
      'Document made in',
      name: 'documentMadeAt',
      desc: '',
      args: [],
    );
  }

  /// `Tenant's move-out date`
  String get tenantExitDate {
    return Intl.message(
      'Tenant\'s move-out date',
      name: 'tenantExitDate',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get pleaseentervalidEmail {
    return Intl.message(
      'Please enter a valid email address',
      name: 'pleaseentervalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Where are you searching?`
  String get whereSearching {
    return Intl.message(
      'Where are you searching?',
      name: 'whereSearching',
      desc: '',
      args: [],
    );
  }

  /// `Required information`
  String get requiredInfo {
    return Intl.message(
      'Required information',
      name: 'requiredInfo',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get validEmail {
    return Intl.message(
      'Please enter a valid email address',
      name: 'validEmail',
      desc: '',
      args: [],
    );
  }

  /// `Enter the`
  String get enterThe {
    return Intl.message(
      'Enter the',
      name: 'enterThe',
      desc: '',
      args: [],
    );
  }

  /// `Information about the tenant(s)`
  String get tenantInfo {
    return Intl.message(
      'Information about the tenant(s)',
      name: 'tenantInfo',
      desc: '',
      args: [],
    );
  }

  /// `Who performs the inspection?`
  String get whoDoesReview {
    return Intl.message(
      'Who performs the inspection?',
      name: 'whoDoesReview',
      desc: '',
      args: [],
    );
  }

  /// `I have been mandated`
  String get mandated {
    return Intl.message(
      'I have been mandated',
      name: 'mandated',
      desc: '',
      args: [],
    );
  }

  /// `Full name of the representative`
  String get fullNameMandataire {
    return Intl.message(
      'Full name of the representative',
      name: 'fullNameMandataire',
      desc: '',
      args: [],
    );
  }

  /// `Full address of the representative`
  String get addressMandataire {
    return Intl.message(
      'Full address of the representative',
      name: 'addressMandataire',
      desc: '',
      args: [],
    );
  }

  /// `Representative's owner's email`
  String get emailMandataire {
    return Intl.message(
      'Representative\'s owner\'s email',
      name: 'emailMandataire',
      desc: '',
      args: [],
    );
  }

  /// `Full name of the tenant`
  String get fullNameTenant {
    return Intl.message(
      'Full name of the tenant',
      name: 'fullNameTenant',
      desc: '',
      args: [],
    );
  }

  /// `Full address of the tenant`
  String get addressTenant {
    return Intl.message(
      'Full address of the tenant',
      name: 'addressTenant',
      desc: '',
      args: [],
    );
  }

  /// `Tenant's email`
  String get emailTenant {
    return Intl.message(
      'Tenant\'s email',
      name: 'emailTenant',
      desc: '',
      args: [],
    );
  }

  /// `Tenant's move-in date`
  String get entryDateIfExit {
    return Intl.message(
      'Tenant\'s move-in date',
      name: 'entryDateIfExit',
      desc: '',
      args: [],
    );
  }

  /// `and`
  String get and {
    return Intl.message(
      'and',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Proxies`
  String get procurations {
    return Intl.message(
      'Proxies',
      name: 'procurations',
      desc: '',
      args: [],
    );
  }

  /// `Inventories`
  String get inventories {
    return Intl.message(
      'Inventories',
      name: 'inventories',
      desc: '',
      args: [],
    );
  }

  /// `I want to perform the inspection myself or I have been mandated to do so`
  String get selfreview {
    return Intl.message(
      'I want to perform the inspection myself or I have been mandated to do so',
      name: 'selfreview',
      desc: '',
      args: [],
    );
  }

  /// `I want to delegate my inventory reports to my tenants so they can simultaneously carry out an entrance and an exit inspection`
  String get delegateedl {
    return Intl.message(
      'I want to delegate my inventory reports to my tenants so they can simultaneously carry out an entrance and an exit inspection',
      name: 'delegateedl',
      desc: '',
      args: [],
    );
  }

  /// `Owner(s) information`
  String get ownerinfo {
    return Intl.message(
      'Owner(s) information',
      name: 'ownerinfo',
      desc: '',
      args: [],
    );
  }

  /// `Full name of the owner or company`
  String get ownerfullname {
    return Intl.message(
      'Full name of the owner or company',
      name: 'ownerfullname',
      desc: '',
      args: [],
    );
  }

  /// `Full address of the owner or company`
  String get owneraddress {
    return Intl.message(
      'Full address of the owner or company',
      name: 'owneraddress',
      desc: '',
      args: [],
    );
  }

  /// `Email of the owner or company`
  String get owneremail {
    return Intl.message(
      'Email of the owner or company',
      name: 'owneremail',
      desc: '',
      args: [],
    );
  }

  /// `Select Review Type`
  String get selectreviewtype {
    return Intl.message(
      'Select Review Type',
      name: 'selectreviewtype',
      desc: '',
      args: [],
    );
  }

  /// `Please select the type of review you want to perform`
  String get pleaseselecttype {
    return Intl.message(
      'Please select the type of review you want to perform',
      name: 'pleaseselecttype',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exitreview {
    return Intl.message(
      'Exit',
      name: 'exitreview',
      desc: '',
      args: [],
    );
  }

  /// `Create an inventory report`
  String get createinventoryreport {
    return Intl.message(
      'Create an inventory report',
      name: 'createinventoryreport',
      desc: '',
      args: [],
    );
  }

  /// `Best Landlords`
  String get bestlandlords {
    return Intl.message(
      'Best Landlords',
      name: 'bestlandlords',
      desc: '',
      args: [],
    );
  }

  /// `Finalization`
  String get finalization {
    return Intl.message(
      'Finalization',
      name: 'finalization',
      desc: '',
      args: [],
    );
  }

  /// `Inventory Report`
  String get inventoryreport {
    return Intl.message(
      'Inventory Report',
      name: 'inventoryreport',
      desc: '',
      args: [],
    );
  }

  /// `Finished`
  String get finished {
    return Intl.message(
      'Finished',
      name: 'finished',
      desc: '',
      args: [],
    );
  }

  /// `Landlord Principal`
  String get landlordprincipal {
    return Intl.message(
      'Landlord Principal',
      name: 'landlordprincipal',
      desc: '',
      args: [],
    );
  }

  /// `Outgoing Tenant`
  String get outgoingtenant {
    return Intl.message(
      'Outgoing Tenant',
      name: 'outgoingtenant',
      desc: '',
      args: [],
    );
  }

  /// `Incoming Tenant`
  String get incomingtenant {
    return Intl.message(
      'Incoming Tenant',
      name: 'incomingtenant',
      desc: '',
      args: [],
    );
  }

  /// `Find your proxies here`
  String get findproxies {
    return Intl.message(
      'Find your proxies here',
      name: 'findproxies',
      desc: '',
      args: [],
    );
  }

  /// `Find your property reports here`
  String get findreportshere {
    return Intl.message(
      'Find your property reports here',
      name: 'findreportshere',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get termsandconditions {
    return Intl.message(
      'Terms of Use',
      name: 'termsandconditions',
      desc: '',
      args: [],
    );
  }

  /// `Contact us`
  String get contactus {
    return Intl.message(
      'Contact us',
      name: 'contactus',
      desc: '',
      args: [],
    );
  }

  /// `Delete my account`
  String get deleteaccount {
    return Intl.message(
      'Delete my account',
      name: 'deleteaccount',
      desc: '',
      args: [],
    );
  }

  /// `Buy credits`
  String get buycredits {
    return Intl.message(
      'Buy credits',
      name: 'buycredits',
      desc: '',
      args: [],
    );
  }

  /// `My proxies`
  String get myprocurations {
    return Intl.message(
      'My proxies',
      name: 'myprocurations',
      desc: '',
      args: [],
    );
  }

  /// `My property reports`
  String get myreviews {
    return Intl.message(
      'My property reports',
      name: 'myreviews',
      desc: '',
      args: [],
    );
  }

  /// `You will be logged out of your account`
  String get signmeout {
    return Intl.message(
      'You will be logged out of your account',
      name: 'signmeout',
      desc: '',
      args: [],
    );
  }

  /// `You will be logged out of your account`
  String get youwillbeloggedout {
    return Intl.message(
      'You will be logged out of your account',
      name: 'youwillbeloggedout',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to proceed?`
  String get doyouwantToproceed {
    return Intl.message(
      'Do you want to proceed?',
      name: 'doyouwantToproceed',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get signout {
    return Intl.message(
      'Sign out',
      name: 'signout',
      desc: '',
      args: [],
    );
  }

  /// `Verification in progress...`
  String get verificationInprogress {
    return Intl.message(
      'Verification in progress...',
      name: 'verificationInprogress',
      desc: '',
      args: [],
    );
  }

  /// `verify`
  String get vevrify {
    return Intl.message(
      'verify',
      name: 'vevrify',
      desc: '',
      args: [],
    );
  }

  /// `Resend the code`
  String get resendotp {
    return Intl.message(
      'Resend the code',
      name: 'resendotp',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get pleaseEnterYourPassword {
    return Intl.message(
      'Please enter your password',
      name: 'pleaseEnterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Tenant`
  String get tenant {
    return Intl.message(
      'Tenant',
      name: 'tenant',
      desc: '',
      args: [],
    );
  }

  /// `OTP Verification`
  String get otpverification {
    return Intl.message(
      'OTP Verification',
      name: 'otpverification',
      desc: '',
      args: [],
    );
  }

  /// `We sent an OTP to `
  String get wesendandotpto {
    return Intl.message(
      'We sent an OTP to ',
      name: 'wesendandotpto',
      desc: '',
      args: [],
    );
  }

  /// `Enter it to confirm your address before continuing`
  String get entertoconfirm {
    return Intl.message(
      'Enter it to confirm your address before continuing',
      name: 'entertoconfirm',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least six characters`
  String get passmustbeatleastsixcharaters {
    return Intl.message(
      'Password must be at least six characters',
      name: 'passmustbeatleastsixcharaters',
      desc: '',
      args: [],
    );
  }

  /// `I am`
  String get iam {
    return Intl.message(
      'I am',
      name: 'iam',
      desc: '',
      args: [],
    );
  }

  /// `Owner`
  String get owner {
    return Intl.message(
      'Owner',
      name: 'owner',
      desc: '',
      args: [],
    );
  }

  /// `Hello World`
  String get hello_world {
    return Intl.message(
      'Hello World',
      name: 'hello_world',
      desc: '',
      args: [],
    );
  }

  /// `Solid Alerts`
  String get solidAlerts {
    return Intl.message(
      'Solid Alerts',
      name: 'solidAlerts',
      desc: '',
      args: [],
    );
  }

  /// `This is a Primary alert`
  String get thisIsAPrimaryAlert {
    return Intl.message(
      'This is a Primary alert',
      name: 'thisIsAPrimaryAlert',
      desc: '',
      args: [],
    );
  }

  /// `This is a Secondary alert`
  String get thisIsASecondaryAlert {
    return Intl.message(
      'This is a Secondary alert',
      name: 'thisIsASecondaryAlert',
      desc: '',
      args: [],
    );
  }

  /// `This is a Success alert`
  String get thisIsASuccessAlert {
    return Intl.message(
      'This is a Success alert',
      name: 'thisIsASuccessAlert',
      desc: '',
      args: [],
    );
  }

  /// `This is a Warning alert`
  String get thisIsAWarningAlert {
    return Intl.message(
      'This is a Warning alert',
      name: 'thisIsAWarningAlert',
      desc: '',
      args: [],
    );
  }

  /// `This is a Info alert`
  String get thisIsAInfoAlert {
    return Intl.message(
      'This is a Info alert',
      name: 'thisIsAInfoAlert',
      desc: '',
      args: [],
    );
  }

  /// `This is a Danger alert`
  String get thisIsADangerAlert {
    return Intl.message(
      'This is a Danger alert',
      name: 'thisIsADangerAlert',
      desc: '',
      args: [],
    );
  }

  /// `Left Border Alerts`
  String get leftBorderAlerts {
    return Intl.message(
      'Left Border Alerts',
      name: 'leftBorderAlerts',
      desc: '',
      args: [],
    );
  }

  /// `Outline Alerts`
  String get outlineAlerts {
    return Intl.message(
      'Outline Alerts',
      name: 'outlineAlerts',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Need an account?`
  String get needAnAccount {
    return Intl.message(
      'Need an account?',
      name: 'needAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Use Google`
  String get useGoogle {
    return Intl.message(
      'Use Google',
      name: 'useGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Use Apple`
  String get useApple {
    return Intl.message(
      'Use Apple',
      name: 'useApple',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email address`
  String get enterYourEmailAddress {
    return Intl.message(
      'Enter your email address',
      name: 'enterYourEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Remember Me`
  String get rememberMe {
    return Intl.message(
      'Remember Me',
      name: 'rememberMe',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email, we will send you a link to Reset your password`
  String get enterYourEmailWeWillSendYouALinkToResetYourPassword {
    return Intl.message(
      'Enter your email, we will send you a link to Reset your password',
      name: 'enterYourEmailWeWillSendYouALinkToResetYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Shapes Styles`
  String get shapesStyles {
    return Intl.message(
      'Shapes Styles',
      name: 'shapesStyles',
      desc: '',
      args: [],
    );
  }

  /// `Indicators`
  String get indicators {
    return Intl.message(
      'Indicators',
      name: 'indicators',
      desc: '',
      args: [],
    );
  }

  /// `Avatar With Content`
  String get avatarWithContent {
    return Intl.message(
      'Avatar With Content',
      name: 'avatarWithContent',
      desc: '',
      args: [],
    );
  }

  /// `Avatar Group`
  String get avatarGroup {
    return Intl.message(
      'Avatar Group',
      name: 'avatarGroup',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `S M`
  String get sM {
    return Intl.message(
      'S M',
      name: 'sM',
      desc: '',
      args: [],
    );
  }

  /// `Basic`
  String get basic {
    return Intl.message(
      'Basic',
      name: 'basic',
      desc: '',
      args: [],
    );
  }

  /// `Default Buttons`
  String get defaultButtons {
    return Intl.message(
      'Default Buttons',
      name: 'defaultButtons',
      desc: '',
      args: [],
    );
  }

  /// `Primary`
  String get primary {
    return Intl.message(
      'Primary',
      name: 'primary',
      desc: '',
      args: [],
    );
  }

  /// `background`
  String get background {
    return Intl.message(
      'background',
      name: 'background',
      desc: '',
      args: [],
    );
  }

  /// `foreground`
  String get foreground {
    return Intl.message(
      'foreground',
      name: 'foreground',
      desc: '',
      args: [],
    );
  }

  /// `Secondary`
  String get secondary {
    return Intl.message(
      'Secondary',
      name: 'secondary',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `Danger`
  String get danger {
    return Intl.message(
      'Danger',
      name: 'danger',
      desc: '',
      args: [],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message(
      'Dark',
      name: 'dark',
      desc: '',
      args: [],
    );
  }

  /// `Link`
  String get link {
    return Intl.message(
      'Link',
      name: 'link',
      desc: '',
      args: [],
    );
  }

  /// `Light`
  String get light {
    return Intl.message(
      'Light',
      name: 'light',
      desc: '',
      args: [],
    );
  }

  /// `Outline Buttons`
  String get outlineButtons {
    return Intl.message(
      'Outline Buttons',
      name: 'outlineButtons',
      desc: '',
      args: [],
    );
  }

  /// `Soft Buttons`
  String get softButtons {
    return Intl.message(
      'Soft Buttons',
      name: 'softButtons',
      desc: '',
      args: [],
    );
  }

  /// `Ghost Buttons`
  String get ghostButtons {
    return Intl.message(
      'Ghost Buttons',
      name: 'ghostButtons',
      desc: '',
      args: [],
    );
  }

  /// `Buttons with Label`
  String get buttonsWithLabel {
    return Intl.message(
      'Buttons with Label',
      name: 'buttonsWithLabel',
      desc: '',
      args: [],
    );
  }

  /// `Load More Buttons`
  String get loadMoreButtons {
    return Intl.message(
      'Load More Buttons',
      name: 'loadMoreButtons',
      desc: '',
      args: [],
    );
  }

  /// `Loading`
  String get loading {
    return Intl.message(
      'Loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  /// `Buttons Sizes`
  String get buttonsSizes {
    return Intl.message(
      'Buttons Sizes',
      name: 'buttonsSizes',
      desc: '',
      args: [],
    );
  }

  /// `Button 2Xl`
  String get button2Xl {
    return Intl.message(
      'Button 2Xl',
      name: 'button2Xl',
      desc: '',
      args: [],
    );
  }

  /// `padding`
  String get padding {
    return Intl.message(
      'padding',
      name: 'padding',
      desc: '',
      args: [],
    );
  }

  /// `Button Xl`
  String get buttonXl {
    return Intl.message(
      'Button Xl',
      name: 'buttonXl',
      desc: '',
      args: [],
    );
  }

  /// `Button Lg`
  String get buttonLg {
    return Intl.message(
      'Button Lg',
      name: 'buttonLg',
      desc: '',
      args: [],
    );
  }

  /// `Button Md`
  String get buttonMd {
    return Intl.message(
      'Button Md',
      name: 'buttonMd',
      desc: '',
      args: [],
    );
  }

  /// `Button Sm`
  String get buttonSm {
    return Intl.message(
      'Button Sm',
      name: 'buttonSm',
      desc: '',
      args: [],
    );
  }

  /// `Group Buttons`
  String get groupButtons {
    return Intl.message(
      'Group Buttons',
      name: 'groupButtons',
      desc: '',
      args: [],
    );
  }

  /// `Buttons Toolbar`
  String get buttonsToolbar {
    return Intl.message(
      'Buttons Toolbar',
      name: 'buttonsToolbar',
      desc: '',
      args: [],
    );
  }

  /// `Vertical Variation`
  String get verticalVariation {
    return Intl.message(
      'Vertical Variation',
      name: 'verticalVariation',
      desc: '',
      args: [],
    );
  }

  /// `Button`
  String get button {
    return Intl.message(
      'Button',
      name: 'button',
      desc: '',
      args: [],
    );
  }

  /// `Dropdown`
  String get dropdown {
    return Intl.message(
      'Dropdown',
      name: 'dropdown',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get item {
    return Intl.message(
      'Item',
      name: 'item',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Add New Task`
  String get addNewTask {
    return Intl.message(
      'Add New Task',
      name: 'addNewTask',
      desc: '',
      args: [],
    );
  }

  /// `Title`
  String get title {
    return Intl.message(
      'Title',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Enter title`
  String get enterTitle {
    return Intl.message(
      'Enter title',
      name: 'enterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start Date`
  String get startDate {
    return Intl.message(
      'Start Date',
      name: 'startDate',
      desc: '',
      args: [],
    );
  }

  /// `Select start Date`
  String get selectStartDate {
    return Intl.message(
      'Select start Date',
      name: 'selectStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Select start Time`
  String get selectStartTime {
    return Intl.message(
      'Select start Time',
      name: 'selectStartTime',
      desc: '',
      args: [],
    );
  }

  /// `End Date`
  String get endDate {
    return Intl.message(
      'End Date',
      name: 'endDate',
      desc: '',
      args: [],
    );
  }

  /// `Select end date`
  String get selectEndDate {
    return Intl.message(
      'Select end date',
      name: 'selectEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Select end time`
  String get selectEndTime {
    return Intl.message(
      'Select end time',
      name: 'selectEndTime',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Enter here`
  String get enterHere {
    return Intl.message(
      'Enter here',
      name: 'enterHere',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `View Details`
  String get viewDetails {
    return Intl.message(
      'View Details',
      name: 'viewDetails',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get startTime {
    return Intl.message(
      'Start Time',
      name: 'startTime',
      desc: '',
      args: [],
    );
  }

  /// `End Time`
  String get endTime {
    return Intl.message(
      'End Time',
      name: 'endTime',
      desc: '',
      args: [],
    );
  }

  /// `Details`
  String get details {
    return Intl.message(
      'Details',
      name: 'details',
      desc: '',
      args: [],
    );
  }

  /// `Daily`
  String get daily {
    return Intl.message(
      'Daily',
      name: 'daily',
      desc: '',
      args: [],
    );
  }

  /// `Weekly`
  String get weekly {
    return Intl.message(
      'Weekly',
      name: 'weekly',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Add`
  String get add {
    return Intl.message(
      'Add',
      name: 'add',
      desc: '',
      args: [],
    );
  }

  /// `New Task`
  String get newTask {
    return Intl.message(
      'New Task',
      name: 'newTask',
      desc: '',
      args: [],
    );
  }

  /// `UI UX Design Review`
  String get uIUXDesignReview {
    return Intl.message(
      'UI UX Design Review',
      name: 'uIUXDesignReview',
      desc: '',
      args: [],
    );
  }

  /// `Write engaging introduction & section paragraphs for your blog.`
  String get writeEngagingIntroductionSectionParagraphsForYourBlog {
    return Intl.message(
      'Write engaging introduction & section paragraphs for your blog.',
      name: 'writeEngagingIntroductionSectionParagraphsForYourBlog',
      desc: '',
      args: [],
    );
  }

  /// `Business Ideas`
  String get businessIdeas {
    return Intl.message(
      'Business Ideas',
      name: 'businessIdeas',
      desc: '',
      args: [],
    );
  }

  /// `Blog Post Writing`
  String get blogPostWriting {
    return Intl.message(
      'Blog Post Writing',
      name: 'blogPostWriting',
      desc: '',
      args: [],
    );
  }

  /// `Technology`
  String get technology {
    return Intl.message(
      'Technology',
      name: 'technology',
      desc: '',
      args: [],
    );
  }

  /// `Paragraph Generator`
  String get paragraphGenerator {
    return Intl.message(
      'Paragraph Generator',
      name: 'paragraphGenerator',
      desc: '',
      args: [],
    );
  }

  /// `Horizontal Cards`
  String get horizontalCards {
    return Intl.message(
      'Horizontal Cards',
      name: 'horizontalCards',
      desc: '',
      args: [],
    );
  }

  /// `completed`
  String get completed {
    return Intl.message(
      'completed',
      name: 'completed',
      desc: '',
      args: [],
    );
  }

  /// `Card Image`
  String get cardImage {
    return Intl.message(
      'Card Image',
      name: 'cardImage',
      desc: '',
      args: [],
    );
  }

  /// `Card Border Color`
  String get cardBorderColor {
    return Intl.message(
      'Card Border Color',
      name: 'cardBorderColor',
      desc: '',
      args: [],
    );
  }

  /// `Select a user to start chatting`
  String get selectAUserToStartChatting {
    return Intl.message(
      'Select a user to start chatting',
      name: 'selectAUserToStartChatting',
      desc: '',
      args: [],
    );
  }

  /// `Active`
  String get active {
    return Intl.message(
      'Active',
      name: 'active',
      desc: '',
      args: [],
    );
  }

  /// `Create New Group`
  String get createNewGroup {
    return Intl.message(
      'Create New Group',
      name: 'createNewGroup',
      desc: '',
      args: [],
    );
  }

  /// `Delete Conversation`
  String get deleteConversation {
    return Intl.message(
      'Delete Conversation',
      name: 'deleteConversation',
      desc: '',
      args: [],
    );
  }

  /// `Block & Report`
  String get blockReport {
    return Intl.message(
      'Block & Report',
      name: 'blockReport',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Type here`
  String get typeHere {
    return Intl.message(
      'Type here',
      name: 'typeHere',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Private`
  String get private {
    return Intl.message(
      'Private',
      name: 'private',
      desc: '',
      args: [],
    );
  }

  /// `Group`
  String get group {
    return Intl.message(
      'Group',
      name: 'group',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message(
      'All',
      name: 'all',
      desc: '',
      args: [],
    );
  }

  /// `Hey there I’m`
  String get heyThereIm {
    return Intl.message(
      'Hey there I’m',
      name: 'heyThereIm',
      desc: '',
      args: [],
    );
  }

  /// `Colors Options`
  String get colorsOptions {
    return Intl.message(
      'Colors Options',
      name: 'colorsOptions',
      desc: '',
      args: [],
    );
  }

  /// `Income`
  String get income {
    return Intl.message(
      'Income',
      name: 'income',
      desc: '',
      args: [],
    );
  }

  /// `Expense`
  String get expense {
    return Intl.message(
      'Expense',
      name: 'expense',
      desc: '',
      args: [],
    );
  }

  /// `Income VS Expense`
  String get incomeVSExpense {
    return Intl.message(
      'Income VS Expense',
      name: 'incomeVSExpense',
      desc: '',
      args: [],
    );
  }

  /// `New Orders`
  String get newOrders {
    return Intl.message(
      'New Orders',
      name: 'newOrders',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message(
      'Status',
      name: 'status',
      desc: '',
      args: [],
    );
  }

  /// `Approved`
  String get approved {
    return Intl.message(
      'Approved',
      name: 'approved',
      desc: '',
      args: [],
    );
  }

  /// `Pending`
  String get pending {
    return Intl.message(
      'Pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  /// `ECommerceAdminDashboardView is working!`
  String get eCommerceAdminDashboardViewIsWorking {
    return Intl.message(
      'ECommerceAdminDashboardView is working!',
      name: 'eCommerceAdminDashboardViewIsWorking',
      desc: '',
      args: [],
    );
  }

  /// `HRMAdminDashboard is working!`
  String get hrmAdminDashboardIsWorking {
    return Intl.message(
      'HRMAdminDashboard is working!',
      name: 'hrmAdminDashboardIsWorking',
      desc: '',
      args: [],
    );
  }

  /// `InfluencerAdminDashboard is working!`
  String get influencerAdminDashboardIsWorking {
    return Intl.message(
      'InfluencerAdminDashboard is working!',
      name: 'influencerAdminDashboardIsWorking',
      desc: '',
      args: [],
    );
  }

  /// `NewsAdminDashboard is working!`
  String get newsAdminDashboardIsWorking {
    return Intl.message(
      'NewsAdminDashboard is working!',
      name: 'newsAdminDashboardIsWorking',
      desc: '',
      args: [],
    );
  }

  /// `Word Generation`
  String get wordGeneration {
    return Intl.message(
      'Word Generation',
      name: 'wordGeneration',
      desc: '',
      args: [],
    );
  }

  /// `Contents Overviews`
  String get contentsOverviews {
    return Intl.message(
      'Contents Overviews',
      name: 'contentsOverviews',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe Statistic`
  String get subscribeStatistic {
    return Intl.message(
      'Subscribe Statistic',
      name: 'subscribeStatistic',
      desc: '',
      args: [],
    );
  }

  /// `RewardEarningAdminDashboard is working!`
  String get rewardEarningAdminDashboardIsWorking {
    return Intl.message(
      'RewardEarningAdminDashboard is working!',
      name: 'rewardEarningAdminDashboardIsWorking',
      desc: '',
      args: [],
    );
  }

  /// `SMSAdminDashboard is working!`
  String get sMSAdminDashboardIsWorking {
    return Intl.message(
      'SMSAdminDashboard is working!',
      name: 'sMSAdminDashboardIsWorking',
      desc: '',
      args: [],
    );
  }

  /// `Table Drag & Drop`
  String get tableDragDrop {
    return Intl.message(
      'Table Drag & Drop',
      name: 'tableDragDrop',
      desc: '',
      args: [],
    );
  }

  /// `Inactive`
  String get inactive {
    return Intl.message(
      'Inactive',
      name: 'inactive',
      desc: '',
      args: [],
    );
  }

  /// `Inbox`
  String get inbox {
    return Intl.message(
      'Inbox',
      name: 'inbox',
      desc: '',
      args: [],
    );
  }

  /// `Starred`
  String get starred {
    return Intl.message(
      'Starred',
      name: 'starred',
      desc: '',
      args: [],
    );
  }

  /// `Sent`
  String get sent {
    return Intl.message(
      'Sent',
      name: 'sent',
      desc: '',
      args: [],
    );
  }

  /// `Drafts`
  String get drafts {
    return Intl.message(
      'Drafts',
      name: 'drafts',
      desc: '',
      args: [],
    );
  }

  /// `Spam`
  String get spam {
    return Intl.message(
      'Spam',
      name: 'spam',
      desc: '',
      args: [],
    );
  }

  /// `Trash`
  String get trash {
    return Intl.message(
      'Trash',
      name: 'trash',
      desc: '',
      args: [],
    );
  }

  /// `Compose`
  String get compose {
    return Intl.message(
      'Compose',
      name: 'compose',
      desc: '',
      args: [],
    );
  }

  /// `Tags`
  String get tags {
    return Intl.message(
      'Tags',
      name: 'tags',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newtext {
    return Intl.message(
      'New',
      name: 'newtext',
      desc: '',
      args: [],
    );
  }

  /// `Open Navigation menu`
  String get openNavigationMenu {
    return Intl.message(
      'Open Navigation menu',
      name: 'openNavigationMenu',
      desc: '',
      args: [],
    );
  }

  /// `Whimsical Wedding Graphics to Design Your`
  String get whimsicalWeddingGraphicsToDesignYour {
    return Intl.message(
      'Whimsical Wedding Graphics to Design Your',
      name: 'whimsicalWeddingGraphicsToDesignYour',
      desc: '',
      args: [],
    );
  }

  /// `Devon Lane`
  String get devonLane {
    return Intl.message(
      'Devon Lane',
      name: 'devonLane',
      desc: '',
      args: [],
    );
  }

  /// `Reply`
  String get reply {
    return Intl.message(
      'Reply',
      name: 'reply',
      desc: '',
      args: [],
    );
  }

  /// `Forward`
  String get forward {
    return Intl.message(
      'Forward',
      name: 'forward',
      desc: '',
      args: [],
    );
  }

  /// `General Questions`
  String get generalQuestions {
    return Intl.message(
      'General Questions',
      name: 'generalQuestions',
      desc: '',
      args: [],
    );
  }

  /// `How can you be sure the numbers are really random?`
  String get howCanYouBeSureTheNumbersAreReallyRandom {
    return Intl.message(
      'How can you be sure the numbers are really random?',
      name: 'howCanYouBeSureTheNumbersAreReallyRandom',
      desc: '',
      args: [],
    );
  }

  /// `Is the source code for the generator available?`
  String get isTheSourceCodeForTheGeneratorAvailable {
    return Intl.message(
      'Is the source code for the generator available?',
      name: 'isTheSourceCodeForTheGeneratorAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Can I download the generator software and run it on my own computer?`
  String get canIDownloadTheGeneratorSoftwareAndRunItOnMyOwnComputer {
    return Intl.message(
      'Can I download the generator software and run it on my own computer?',
      name: 'canIDownloadTheGeneratorSoftwareAndRunItOnMyOwnComputer',
      desc: '',
      args: [],
    );
  }

  /// `Can other info be added to an invoice?`
  String get canOtherInfoBeAddedToAnInvoice {
    return Intl.message(
      'Can other info be added to an invoice?',
      name: 'canOtherInfoBeAddedToAnInvoice',
      desc: '',
      args: [],
    );
  }

  /// `How do I pick winners for a lottery or drawing?`
  String get howDoIPickWinnersForALotteryOrDrawing {
    return Intl.message(
      'How do I pick winners for a lottery or drawing?',
      name: 'howDoIPickWinnersForALotteryOrDrawing',
      desc: '',
      args: [],
    );
  }

  /// `What security measures are in place for my data?`
  String get whatSecurityMeasuresAreInPlaceForMyData {
    return Intl.message(
      'What security measures are in place for my data?',
      name: 'whatSecurityMeasuresAreInPlaceForMyData',
      desc: '',
      args: [],
    );
  }

  /// `What should I do if I encounter technical issues?`
  String get whatShouldIDoIfIEncounterTechnicalIssues {
    return Intl.message(
      'What should I do if I encounter technical issues?',
      name: 'whatShouldIDoIfIEncounterTechnicalIssues',
      desc: '',
      args: [],
    );
  }

  /// `Our generator’s source code is proprietary and not publicly available, but we provide detailed documentation and support for understanding our algorithms.`
  String get ourGeneratorSourceCodeIsProprietaryAndNotPubliclyAvailable {
    return Intl.message(
      'Our generator’s source code is proprietary and not publicly available, but we provide detailed documentation and support for understanding our algorithms.',
      name: 'ourGeneratorSourceCodeIsProprietaryAndNotPubliclyAvailable',
      desc: '',
      args: [],
    );
  }

  /// `We combine hardware and software methods, including cryptographic algorithms, to ensure randomness. Regular statistical testing verifies the integrity and unpredictability of our numbers.`
  String get weCombineHardwareAndSoftwareMethods {
    return Intl.message(
      'We combine hardware and software methods, including cryptographic algorithms, to ensure randomness. Regular statistical testing verifies the integrity and unpredictability of our numbers.',
      name: 'weCombineHardwareAndSoftwareMethods',
      desc: '',
      args: [],
    );
  }

  /// `The generator operates only on our secure online platform to ensure consistent performance and security. Use our platform for your needs.`
  String get theGeneratorOperatesOnlyOnOurSecureOnlinePlatform {
    return Intl.message(
      'The generator operates only on our secure online platform to ensure consistent performance and security. Use our platform for your needs.',
      name: 'theGeneratorOperatesOnlyOnOurSecureOnlinePlatform',
      desc: '',
      args: [],
    );
  }

  /// `Our invoicing system allows for customization like logos and messages. Refer to the user guide or contact support for assistance.`
  String get ourInvoicingSystemAllowsForCustomization {
    return Intl.message(
      'Our invoicing system allows for customization like logos and messages. Refer to the user guide or contact support for assistance.',
      name: 'ourInvoicingSystemAllowsForCustomization',
      desc: '',
      args: [],
    );
  }

  /// `We use cryptographic algorithms and rigorous testing to ensure the numbers are unpredictable and unbiased, with transparency and independent verification available.`
  String get weUseCryptographicAlgorithmsAndRigorousTesting {
    return Intl.message(
      'We use cryptographic algorithms and rigorous testing to ensure the numbers are unpredictable and unbiased, with transparency and independent verification available.',
      name: 'weUseCryptographicAlgorithmsAndRigorousTesting',
      desc: '',
      args: [],
    );
  }

  /// `Use a certified random number generator for a fair and transparent drawing. Document rules and criteria clearly. Contact us for best practices.`
  String get useACertifiedRandomNumberGeneratorForAFair {
    return Intl.message(
      'Use a certified random number generator for a fair and transparent drawing. Document rules and criteria clearly. Contact us for best practices.',
      name: 'useACertifiedRandomNumberGeneratorForAFair',
      desc: '',
      args: [],
    );
  }

  /// `We implement robust security measures including encryption, secure servers, and regular audits to protect your data. Our platform adheres to industry standards for data protection and privacy. We also provide transparency about our security practices and are open to addressing any concerns.`
  String get weImplementRobustSecurityMeasuresIncludingEncryption {
    return Intl.message(
      'We implement robust security measures including encryption, secure servers, and regular audits to protect your data. Our platform adheres to industry standards for data protection and privacy. We also provide transparency about our security practices and are open to addressing any concerns.',
      name: 'weImplementRobustSecurityMeasuresIncludingEncryption',
      desc: '',
      args: [],
    );
  }

  /// `If you experience technical issues, please contact our support team for assistance. We offer various support channels including email and phone to resolve problems promptly. Our team is dedicated to providing timely solutions and ensuring a smooth user experience.`
  String get ifYouExperienceTechnicalIssues {
    return Intl.message(
      'If you experience technical issues, please contact our support team for assistance. We offer various support channels including email and phone to resolve problems promptly. Our team is dedicated to providing timely solutions and ensuring a smooth user experience.',
      name: 'ifYouExperienceTechnicalIssues',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Full Name`
  String get fullName {
    return Intl.message(
      'Full Name',
      name: 'fullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter full name`
  String get enterFullName {
    return Intl.message(
      'Enter full name',
      name: 'enterFullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter email address`
  String get enterEmailAddress {
    return Intl.message(
      'Enter email address',
      name: 'enterEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get sales {
    return Intl.message(
      'Sales',
      name: 'sales',
      desc: '',
      args: [],
    );
  }

  /// `Sale`
  String get sale {
    return Intl.message(
      'Sale',
      name: 'sale',
      desc: '',
      args: [],
    );
  }

  /// `Black T-Shirt For Man`
  String get blackTShirtForMan {
    return Intl.message(
      'Black T-Shirt For Man',
      name: 'blackTShirtForMan',
      desc: '',
      args: [],
    );
  }

  /// `Sales Ratio`
  String get salesRatio {
    return Intl.message(
      'Sales Ratio',
      name: 'salesRatio',
      desc: '',
      args: [],
    );
  }

  /// `Sales By Country`
  String get salesByCountry {
    return Intl.message(
      'Sales By Country',
      name: 'salesByCountry',
      desc: '',
      args: [],
    );
  }

  /// `Registered On`
  String get registeredOn {
    return Intl.message(
      'Registered On',
      name: 'registeredOn',
      desc: '',
      args: [],
    );
  }

  /// `User Name`
  String get userName {
    return Intl.message(
      'User Name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Position`
  String get position {
    return Intl.message(
      'Position',
      name: 'position',
      desc: '',
      args: [],
    );
  }

  /// `Action`
  String get action {
    return Intl.message(
      'Action',
      name: 'action',
      desc: '',
      args: [],
    );
  }

  /// `Input Example`
  String get inputExample {
    return Intl.message(
      'Input Example',
      name: 'inputExample',
      desc: '',
      args: [],
    );
  }

  /// `Input With Select`
  String get inputWithSelect {
    return Intl.message(
      'Input With Select',
      name: 'inputWithSelect',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Disabled Input`
  String get disabledInput {
    return Intl.message(
      'Disabled Input',
      name: 'disabledInput',
      desc: '',
      args: [],
    );
  }

  /// `Input with Icon`
  String get inputWithIcon {
    return Intl.message(
      'Input with Icon',
      name: 'inputWithIcon',
      desc: '',
      args: [],
    );
  }

  /// `Input with Icon Right`
  String get inputWithIconRight {
    return Intl.message(
      'Input with Icon Right',
      name: 'inputWithIconRight',
      desc: '',
      args: [],
    );
  }

  /// `Input Password`
  String get inputPassword {
    return Intl.message(
      'Input Password',
      name: 'inputPassword',
      desc: '',
      args: [],
    );
  }

  /// `Input Date`
  String get inputDate {
    return Intl.message(
      'Input Date',
      name: 'inputDate',
      desc: '',
      args: [],
    );
  }

  /// `Rounded Input`
  String get roundedInput {
    return Intl.message(
      'Rounded Input',
      name: 'roundedInput',
      desc: '',
      args: [],
    );
  }

  /// `Input Border Style`
  String get inputBorderStyle {
    return Intl.message(
      'Input Border Style',
      name: 'inputBorderStyle',
      desc: '',
      args: [],
    );
  }

  /// `Example Textarea`
  String get exampleTextarea {
    return Intl.message(
      'Example Textarea',
      name: 'exampleTextarea',
      desc: '',
      args: [],
    );
  }

  /// `Input Sizing`
  String get inputSizing {
    return Intl.message(
      'Input Sizing',
      name: 'inputSizing',
      desc: '',
      args: [],
    );
  }

  /// `File Input`
  String get fileInput {
    return Intl.message(
      'File Input',
      name: 'fileInput',
      desc: '',
      args: [],
    );
  }

  /// `Default Select`
  String get defaultSelect {
    return Intl.message(
      'Default Select',
      name: 'defaultSelect',
      desc: '',
      args: [],
    );
  }

  /// `Input with Placeholder`
  String get inputWithPlaceholder {
    return Intl.message(
      'Input with Placeholder',
      name: 'inputWithPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Select you status`
  String get selectYouStatus {
    return Intl.message(
      'Select you status',
      name: 'selectYouStatus',
      desc: '',
      args: [],
    );
  }

  /// `Menu Size`
  String get menuSize {
    return Intl.message(
      'Menu Size',
      name: 'menuSize',
      desc: '',
      args: [],
    );
  }

  /// `Select Size`
  String get selectSize {
    return Intl.message(
      'Select Size',
      name: 'selectSize',
      desc: '',
      args: [],
    );
  }

  /// `Multiple select input`
  String get multipleSelectInput {
    return Intl.message(
      'Multiple select input',
      name: 'multipleSelectInput',
      desc: '',
      args: [],
    );
  }

  /// `default`
  String get defaulttext {
    return Intl.message(
      'default',
      name: 'defaulttext',
      desc: '',
      args: [],
    );
  }

  /// `Select Items`
  String get selectItems {
    return Intl.message(
      'Select Items',
      name: 'selectItems',
      desc: '',
      args: [],
    );
  }

  /// `Chose a city`
  String get choseACity {
    return Intl.message(
      'Chose a city',
      name: 'choseACity',
      desc: '',
      args: [],
    );
  }

  /// `Text inputs`
  String get textInputs {
    return Intl.message(
      'Text inputs',
      name: 'textInputs',
      desc: '',
      args: [],
    );
  }

  /// `Browser Defaults`
  String get browserDefaults {
    return Intl.message(
      'Browser Defaults',
      name: 'browserDefaults',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get firstName {
    return Intl.message(
      'First Name',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your first name`
  String get enterYourFirstName {
    return Intl.message(
      'Enter your first name',
      name: 'enterYourFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your first name`
  String get pleaseEnterYourFirstName {
    return Intl.message(
      'Please enter your first name',
      name: 'pleaseEnterYourFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get lastName {
    return Intl.message(
      'Last Name',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Enter your last name`
  String get enterYourLastName {
    return Intl.message(
      'Enter your last name',
      name: 'enterYourLastName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your last name`
  String get pleaseEnterYourLastName {
    return Intl.message(
      'Please enter your last name',
      name: 'pleaseEnterYourLastName',
      desc: '',
      args: [],
    );
  }

  /// `Country`
  String get country {
    return Intl.message(
      'Country',
      name: 'country',
      desc: '',
      args: [],
    );
  }

  /// `Select Country`
  String get selectCountry {
    return Intl.message(
      'Select Country',
      name: 'selectCountry',
      desc: '',
      args: [],
    );
  }

  /// `Please select your country`
  String get pleaseSelectYourCountry {
    return Intl.message(
      'Please select your country',
      name: 'pleaseSelectYourCountry',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
  }

  /// `Select City`
  String get selectCity {
    return Intl.message(
      'Select City',
      name: 'selectCity',
      desc: '',
      args: [],
    );
  }

  /// `Please select your city`
  String get pleaseSelectYourCity {
    return Intl.message(
      'Please select your city',
      name: 'pleaseSelectYourCity',
      desc: '',
      args: [],
    );
  }

  /// `State`
  String get state {
    return Intl.message(
      'State',
      name: 'state',
      desc: '',
      args: [],
    );
  }

  /// `Select State`
  String get selectState {
    return Intl.message(
      'Select State',
      name: 'selectState',
      desc: '',
      args: [],
    );
  }

  /// `Please select your state`
  String get pleaseSelectYourState {
    return Intl.message(
      'Please select your state',
      name: 'pleaseSelectYourState',
      desc: '',
      args: [],
    );
  }

  /// `Agree to terms and conditions`
  String get agreeToTermsAndConditions {
    return Intl.message(
      'Agree to terms and conditions',
      name: 'agreeToTermsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Please check this box to continue`
  String get pleaseCheckThisBoxToContinue {
    return Intl.message(
      'Please check this box to continue',
      name: 'pleaseCheckThisBoxToContinue',
      desc: '',
      args: [],
    );
  }

  /// `Save From`
  String get saveFrom {
    return Intl.message(
      'Save From',
      name: 'saveFrom',
      desc: '',
      args: [],
    );
  }

  /// `Custom Styles`
  String get customStyles {
    return Intl.message(
      'Custom Styles',
      name: 'customStyles',
      desc: '',
      args: [],
    );
  }

  /// `Business`
  String get business {
    return Intl.message(
      'Business',
      name: 'business',
      desc: '',
      args: [],
    );
  }

  /// `Personal`
  String get personal {
    return Intl.message(
      'Personal',
      name: 'personal',
      desc: '',
      args: [],
    );
  }

  /// `UI/UX Design`
  String get uIUXDesign {
    return Intl.message(
      'UI/UX Design',
      name: 'uIUXDesign',
      desc: '',
      args: [],
    );
  }

  /// `development`
  String get development {
    return Intl.message(
      'development',
      name: 'development',
      desc: '',
      args: [],
    );
  }

  /// `No data found!`
  String get noDataFound {
    return Intl.message(
      'No data found!',
      name: 'noDataFound',
      desc: '',
      args: [],
    );
  }

  /// `Assigned to`
  String get assignedTo {
    return Intl.message(
      'Assigned to',
      name: 'assignedTo',
      desc: '',
      args: [],
    );
  }

  /// `day`
  String get day {
    return Intl.message(
      'day',
      name: 'day',
      desc: '',
      args: [],
    );
  }

  /// `days`
  String get days {
    return Intl.message(
      'days',
      name: 'days',
      desc: '',
      args: [],
    );
  }

  /// `left`
  String get left {
    return Intl.message(
      'left',
      name: 'left',
      desc: '',
      args: [],
    );
  }

  /// `Create Project`
  String get createProject {
    return Intl.message(
      'Create Project',
      name: 'createProject',
      desc: '',
      args: [],
    );
  }

  /// `Project Name`
  String get projectName {
    return Intl.message(
      'Project Name',
      name: 'projectName',
      desc: '',
      args: [],
    );
  }

  /// `Enter project name`
  String get enterProjectName {
    return Intl.message(
      'Enter project name',
      name: 'enterProjectName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter project name`
  String get pleaseEnterProjectName {
    return Intl.message(
      'Please enter project name',
      name: 'pleaseEnterProjectName',
      desc: '',
      args: [],
    );
  }

  /// `Please select start date`
  String get pleaseSelectStartDate {
    return Intl.message(
      'Please select start date',
      name: 'pleaseSelectStartDate',
      desc: '',
      args: [],
    );
  }

  /// `Please select end date`
  String get pleaseSelectEndDate {
    return Intl.message(
      'Please select end date',
      name: 'pleaseSelectEndDate',
      desc: '',
      args: [],
    );
  }

  /// `Create New Board`
  String get createNewBoard {
    return Intl.message(
      'Create New Board',
      name: 'createNewBoard',
      desc: '',
      args: [],
    );
  }

  /// `Board Name`
  String get boardName {
    return Intl.message(
      'Board Name',
      name: 'boardName',
      desc: '',
      args: [],
    );
  }

  /// `Enter board name`
  String get enterBoardName {
    return Intl.message(
      'Enter board name',
      name: 'enterBoardName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter board name`
  String get pleaseEnterBoardName {
    return Intl.message(
      'Please enter board name',
      name: 'pleaseEnterBoardName',
      desc: '',
      args: [],
    );
  }

  /// `Select Color`
  String get selectColor {
    return Intl.message(
      'Select Color',
      name: 'selectColor',
      desc: '',
      args: [],
    );
  }

  /// `Add New Board`
  String get addNewBoard {
    return Intl.message(
      'Add New Board',
      name: 'addNewBoard',
      desc: '',
      args: [],
    );
  }

  /// `Google Map`
  String get googleMap {
    return Intl.message(
      'Google Map',
      name: 'googleMap',
      desc: '',
      args: [],
    );
  }

  /// `Default Map`
  String get defaultMap {
    return Intl.message(
      'Default Map',
      name: 'defaultMap',
      desc: '',
      args: [],
    );
  }

  /// `Leaflet Multiple location`
  String get leafletMultipleLocation {
    return Intl.message(
      'Leaflet Multiple location',
      name: 'leafletMultipleLocation',
      desc: '',
      args: [],
    );
  }

  /// `Ooops! Page Not Found`
  String get ooopsPageNotFound {
    return Intl.message(
      'Ooops! Page Not Found',
      name: 'ooopsPageNotFound',
      desc: '',
      args: [],
    );
  }

  /// `This page doesn't exist or was removed! We suggest you back to home`
  String get thisPageDoesNotExist {
    return Intl.message(
      'This page doesn\'t exist or was removed! We suggest you back to home',
      name: 'thisPageDoesNotExist',
      desc: '',
      args: [],
    );
  }

  /// `Go Back`
  String get goBack {
    return Intl.message(
      'Go Back',
      name: 'goBack',
      desc: '',
      args: [],
    );
  }

  /// `New Conversation`
  String get newConversation {
    return Intl.message(
      'New Conversation',
      name: 'newConversation',
      desc: '',
      args: [],
    );
  }

  /// `30 Message`
  String get message {
    return Intl.message(
      '30 Message',
      name: 'message',
      desc: '',
      args: [],
    );
  }

  /// `15 hours ago`
  String get hoursAgo {
    return Intl.message(
      '15 hours ago',
      name: 'hoursAgo',
      desc: '',
      args: [],
    );
  }

  /// `Type a message or upload an image`
  String get typeAMessageOrUploadAnImage {
    return Intl.message(
      'Type a message or upload an image',
      name: 'typeAMessageOrUploadAnImage',
      desc: '',
      args: [],
    );
  }

  /// `Ai Chatbot`
  String get aiChatbot {
    return Intl.message(
      'Ai Chatbot',
      name: 'aiChatbot',
      desc: '',
      args: [],
    );
  }

  /// `Default Bot`
  String get defaultBot {
    return Intl.message(
      'Default Bot',
      name: 'defaultBot',
      desc: '',
      args: [],
    );
  }

  /// `Basic Pricing Plan`
  String get basicPricingPlan {
    return Intl.message(
      'Basic Pricing Plan',
      name: 'basicPricingPlan',
      desc: '',
      args: [],
    );
  }

  /// `Choose Your Best Plan`
  String get chooseYourBestPlan {
    return Intl.message(
      'Choose Your Best Plan',
      name: 'chooseYourBestPlan',
      desc: '',
      args: [],
    );
  }

  /// `Default Pricing Plan`
  String get defaultPricingPlan {
    return Intl.message(
      'Default Pricing Plan',
      name: 'defaultPricingPlan',
      desc: '',
      args: [],
    );
  }

  /// `Powerful features for`
  String get powerfulFeaturesFor {
    return Intl.message(
      'Powerful features for',
      name: 'powerfulFeaturesFor',
      desc: '',
      args: [],
    );
  }

  /// `powerful creators`
  String get powerfulCreators {
    return Intl.message(
      'powerful creators',
      name: 'powerfulCreators',
      desc: '',
      args: [],
    );
  }

  /// `Pay Monthly`
  String get payMonthly {
    return Intl.message(
      'Pay Monthly',
      name: 'payMonthly',
      desc: '',
      args: [],
    );
  }

  /// `Pay Yearly`
  String get payYearly {
    return Intl.message(
      'Pay Yearly',
      name: 'payYearly',
      desc: '',
      args: [],
    );
  }

  /// `Alice`
  String get alice {
    return Intl.message(
      'Alice',
      name: 'alice',
      desc: '',
      args: [],
    );
  }

  /// `Bob`
  String get bob {
    return Intl.message(
      'Bob',
      name: 'bob',
      desc: '',
      args: [],
    );
  }

  /// `Add New Project`
  String get addNewProject {
    return Intl.message(
      'Add New Project',
      name: 'addNewProject',
      desc: '',
      args: [],
    );
  }

  /// `Enter Project Title`
  String get enterProjectTitle {
    return Intl.message(
      'Enter Project Title',
      name: 'enterProjectTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please enter title`
  String get pleaseEnterTitle {
    return Intl.message(
      'Please enter title',
      name: 'pleaseEnterTitle',
      desc: '',
      args: [],
    );
  }

  /// `Assigner To`
  String get assignerTo {
    return Intl.message(
      'Assigner To',
      name: 'assignerTo',
      desc: '',
      args: [],
    );
  }

  /// `Select Employee`
  String get selectEmployee {
    return Intl.message(
      'Select Employee',
      name: 'selectEmployee',
      desc: '',
      args: [],
    );
  }

  /// `Write Something`
  String get writeSomething {
    return Intl.message(
      'Write Something',
      name: 'writeSomething',
      desc: '',
      args: [],
    );
  }

  /// `In Progress`
  String get inProgress {
    return Intl.message(
      'In Progress',
      name: 'inProgress',
      desc: '',
      args: [],
    );
  }

  /// `All Priority`
  String get allPriority {
    return Intl.message(
      'All Priority',
      name: 'allPriority',
      desc: '',
      args: [],
    );
  }

  /// `low`
  String get low {
    return Intl.message(
      'low',
      name: 'low',
      desc: '',
      args: [],
    );
  }

  /// `medium`
  String get medium {
    return Intl.message(
      'medium',
      name: 'medium',
      desc: '',
      args: [],
    );
  }

  /// `high`
  String get high {
    return Intl.message(
      'high',
      name: 'high',
      desc: '',
      args: [],
    );
  }

  /// `Showing`
  String get showing {
    return Intl.message(
      'Showing',
      name: 'showing',
      desc: '',
      args: [],
    );
  }

  /// `entries`
  String get entries {
    return Intl.message(
      'entries',
      name: 'entries',
      desc: '',
      args: [],
    );
  }

  /// `Add New User`
  String get addNewUser {
    return Intl.message(
      'Add New User',
      name: 'addNewUser',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get previous {
    return Intl.message(
      'Previous',
      name: 'previous',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Show`
  String get show {
    return Intl.message(
      'Show',
      name: 'show',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get project {
    return Intl.message(
      'Project',
      name: 'project',
      desc: '',
      args: [],
    );
  }

  /// `Priority`
  String get priority {
    return Intl.message(
      'Priority',
      name: 'priority',
      desc: '',
      args: [],
    );
  }

  /// `Actions`
  String get actions {
    return Intl.message(
      'Actions',
      name: 'actions',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `cOPYRIGHT`
  String get cOPYRIGHT {
    return Intl.message(
      'cOPYRIGHT',
      name: 'cOPYRIGHT',
      desc: '',
      args: [],
    );
  }

  /// `All rights Reserved`
  String get allRightsReserved {
    return Intl.message(
      'All rights Reserved',
      name: 'allRightsReserved',
      desc: '',
      args: [],
    );
  }

  /// `Unknown Route`
  String get unknownRoute {
    return Intl.message(
      'Unknown Route',
      name: 'unknownRoute',
      desc: '',
      args: [],
    );
  }

  /// `Bordered Table`
  String get borderedTable {
    return Intl.message(
      'Bordered Table',
      name: 'borderedTable',
      desc: '',
      args: [],
    );
  }

  /// `Striped Rows`
  String get stripedRows {
    return Intl.message(
      'Striped Rows',
      name: 'stripedRows',
      desc: '',
      args: [],
    );
  }

  /// `Hover Table`
  String get hoverTable {
    return Intl.message(
      'Hover Table',
      name: 'hoverTable',
      desc: '',
      args: [],
    );
  }

  /// `Tables Border Colors`
  String get tablesBorderColors {
    return Intl.message(
      'Tables Border Colors',
      name: 'tablesBorderColors',
      desc: '',
      args: [],
    );
  }

  /// `Table Head`
  String get tableHead {
    return Intl.message(
      'Table Head',
      name: 'tableHead',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `sl`
  String get sl {
    return Intl.message(
      'sl',
      name: 'sl',
      desc: '',
      args: [],
    );
  }

  /// `Default Table`
  String get defaultTable {
    return Intl.message(
      'Default Table',
      name: 'defaultTable',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `What is Lorem Ipsum`
  String get whatIsLoremIpsum {
    return Intl.message(
      'What is Lorem Ipsum',
      name: 'whatIsLoremIpsum',
      desc: '',
      args: [],
    );
  }

  /// `Heading`
  String get heading {
    return Intl.message(
      'Heading',
      name: 'heading',
      desc: '',
      args: [],
    );
  }

  /// `Heading Colors`
  String get headingColors {
    return Intl.message(
      'Heading Colors',
      name: 'headingColors',
      desc: '',
      args: [],
    );
  }

  /// `Texts`
  String get texts {
    return Intl.message(
      'Texts',
      name: 'texts',
      desc: '',
      args: [],
    );
  }

  /// `Inine Text Elements`
  String get inineTextElements {
    return Intl.message(
      'Inine Text Elements',
      name: 'inineTextElements',
      desc: '',
      args: [],
    );
  }

  /// `You can use the mark tag to`
  String get youCanUseTheMarkTagTo {
    return Intl.message(
      'You can use the mark tag to',
      name: 'youCanUseTheMarkTagTo',
      desc: '',
      args: [],
    );
  }

  /// ` highlight `
  String get highlight {
    return Intl.message(
      ' highlight ',
      name: 'highlight',
      desc: '',
      args: [],
    );
  }

  /// `text`
  String get text {
    return Intl.message(
      'text',
      name: 'text',
      desc: '',
      args: [],
    );
  }

  /// `This is a paragraph. it stands out from regular Delete text`
  String get thisIsAParagraphItStandsOutFromRegularDeleteText {
    return Intl.message(
      'This is a paragraph. it stands out from regular Delete text',
      name: 'thisIsAParagraphItStandsOutFromRegularDeleteText',
      desc: '',
      args: [],
    );
  }

  /// `This line of text is meant to be treated as no longer accurate.`
  String get thisLineOfTextIsMeantToBeTreatedAsNoLongerAccurate {
    return Intl.message(
      'This line of text is meant to be treated as no longer accurate.',
      name: 'thisLineOfTextIsMeantToBeTreatedAsNoLongerAccurate',
      desc: '',
      args: [],
    );
  }

  /// `This line of text will render as underlined`
  String get thisLineOfTextWillRenderAsUnderlined {
    return Intl.message(
      'This line of text will render as underlined',
      name: 'thisLineOfTextWillRenderAsUnderlined',
      desc: '',
      args: [],
    );
  }

  /// `This line of text is meant to be treated as an addition to the document.`
  String get thisLineOfTextIsMeantToBeTreatedAsAnAdditionToTheDocument {
    return Intl.message(
      'This line of text is meant to be treated as an addition to the document.',
      name: 'thisLineOfTextIsMeantToBeTreatedAsAnAdditionToTheDocument',
      desc: '',
      args: [],
    );
  }

  /// `This is a paragraph. it stands out from regular text.`
  String get thisIsAParagraphItStandsOutFromRegularText {
    return Intl.message(
      'This is a paragraph. it stands out from regular text.',
      name: 'thisIsAParagraphItStandsOutFromRegularText',
      desc: '',
      args: [],
    );
  }

  /// `This line rendered as bold text.`
  String get thisLineRenderedAsBoldText {
    return Intl.message(
      'This line rendered as bold text.',
      name: 'thisLineRenderedAsBoldText',
      desc: '',
      args: [],
    );
  }

  /// `This line rendered as italicized text.`
  String get thisLineRenderedAsItalicizedText {
    return Intl.message(
      'This line rendered as italicized text.',
      name: 'thisLineRenderedAsItalicizedText',
      desc: '',
      args: [],
    );
  }

  /// `Serial`
  String get serial {
    return Intl.message(
      'Serial',
      name: 'serial',
      desc: '',
      args: [],
    );
  }

  /// `Manager`
  String get manager {
    return Intl.message(
      'Manager',
      name: 'manager',
      desc: '',
      args: [],
    );
  }

  /// `Developer`
  String get developer {
    return Intl.message(
      'Developer',
      name: 'developer',
      desc: '',
      args: [],
    );
  }

  /// `Designer`
  String get designer {
    return Intl.message(
      'Designer',
      name: 'designer',
      desc: '',
      args: [],
    );
  }

  /// `Tester`
  String get tester {
    return Intl.message(
      'Tester',
      name: 'tester',
      desc: '',
      args: [],
    );
  }

  /// `Form Dialog`
  String get formDialog {
    return Intl.message(
      'Form Dialog',
      name: 'formDialog',
      desc: '',
      args: [],
    );
  }

  /// `Image`
  String get image {
    return Intl.message(
      'Image',
      name: 'image',
      desc: '',
      args: [],
    );
  }

  /// `Upload Image`
  String get uploadImage {
    return Intl.message(
      'Upload Image',
      name: 'uploadImage',
      desc: '',
      args: [],
    );
  }

  /// `Select Position`
  String get selectPosition {
    return Intl.message(
      'Select Position',
      name: 'selectPosition',
      desc: '',
      args: [],
    );
  }

  /// `Please select a position`
  String get pleaseSelectAPosition {
    return Intl.message(
      'Please select a position',
      name: 'pleaseSelectAPosition',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Full Name`
  String get enterYourFullName {
    return Intl.message(
      'Enter Your Full Name',
      name: 'enterYourFullName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your full name`
  String get pleaseEnterYourFullName {
    return Intl.message(
      'Please enter your full name',
      name: 'pleaseEnterYourFullName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Email`
  String get enterYourEmail {
    return Intl.message(
      'Enter Your Email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email`
  String get pleaseEnterYourEmail {
    return Intl.message(
      'Please enter your email',
      name: 'pleaseEnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Phone Number`
  String get enterYourPhoneNumber {
    return Intl.message(
      'Enter Your Phone Number',
      name: 'enterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your phone number`
  String get pleaseEnterYourPhoneNumber {
    return Intl.message(
      'Please enter your phone number',
      name: 'pleaseEnterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Note`
  String get note {
    return Intl.message(
      'Note',
      name: 'note',
      desc: '',
      args: [],
    );
  }

  /// `User Profile`
  String get userProfile {
    return Intl.message(
      'User Profile',
      name: 'userProfile',
      desc: '',
      args: [],
    );
  }

  /// `Registration Date`
  String get registrationDate {
    return Intl.message(
      'Registration Date',
      name: 'registrationDate',
      desc: '',
      args: [],
    );
  }

  /// `Profile Picture`
  String get profilePicture {
    return Intl.message(
      'Profile Picture',
      name: 'profilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Save Changes`
  String get saveChanges {
    return Intl.message(
      'Save Changes',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message(
      'Calendar',
      name: 'calendar',
      desc: '',
      args: [],
    );
  }

  /// `Social Media Overview`
  String get socialMediaOverview {
    return Intl.message(
      'Social Media Overview',
      name: 'socialMediaOverview',
      desc: '',
      args: [],
    );
  }

  /// `by`
  String get by {
    return Intl.message(
      'by',
      name: 'by',
      desc: '',
      args: [],
    );
  }

  /// `Statistic`
  String get statistic {
    return Intl.message(
      'Statistic',
      name: 'statistic',
      desc: '',
      args: [],
    );
  }

  /// `Stock Value`
  String get stockValue {
    return Intl.message(
      'Stock Value',
      name: 'stockValue',
      desc: '',
      args: [],
    );
  }

  /// `Low Stock`
  String get lowStock {
    return Intl.message(
      'Low Stock',
      name: 'lowStock',
      desc: '',
      args: [],
    );
  }

  /// `Top Selling Product`
  String get topSellingProduct {
    return Intl.message(
      'Top Selling Product',
      name: 'topSellingProduct',
      desc: '',
      args: [],
    );
  }

  /// `Customer of the month`
  String get customerOfTheMonth {
    return Intl.message(
      'Customer of the month',
      name: 'customerOfTheMonth',
      desc: '',
      args: [],
    );
  }

  /// `Top 5 Purchasing Product`
  String get top5PurchasingProduct {
    return Intl.message(
      'Top 5 Purchasing Product',
      name: 'top5PurchasingProduct',
      desc: '',
      args: [],
    );
  }

  /// `Total Orders`
  String get totalOrders {
    return Intl.message(
      'Total Orders',
      name: 'totalOrders',
      desc: '',
      args: [],
    );
  }

  /// `Running Order`
  String get runningOrder {
    return Intl.message(
      'Running Order',
      name: 'runningOrder',
      desc: '',
      args: [],
    );
  }

  /// `Pending Order`
  String get pendingOrder {
    return Intl.message(
      'Pending Order',
      name: 'pendingOrder',
      desc: '',
      args: [],
    );
  }

  /// `Weekly Value`
  String get weeklyValue {
    return Intl.message(
      'Weekly Value',
      name: 'weeklyValue',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Value`
  String get monthlyValue {
    return Intl.message(
      'Monthly Value',
      name: 'monthlyValue',
      desc: '',
      args: [],
    );
  }

  /// `Yearly Value`
  String get yearlyValue {
    return Intl.message(
      'Yearly Value',
      name: 'yearlyValue',
      desc: '',
      args: [],
    );
  }

  /// `Cash Balance`
  String get cashBalance {
    return Intl.message(
      'Cash Balance',
      name: 'cashBalance',
      desc: '',
      args: [],
    );
  }

  /// `Bank Balance`
  String get bankBalance {
    return Intl.message(
      'Bank Balance',
      name: 'bankBalance',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Due`
  String get supplierDue {
    return Intl.message(
      'Supplier Due',
      name: 'supplierDue',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Expense`
  String get monthlyExpense {
    return Intl.message(
      'Monthly Expense',
      name: 'monthlyExpense',
      desc: '',
      args: [],
    );
  }

  /// `Debit Transaction`
  String get debitTransaction {
    return Intl.message(
      'Debit Transaction',
      name: 'debitTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Credit Transaction`
  String get creditTransaction {
    return Intl.message(
      'Credit Transaction',
      name: 'creditTransaction',
      desc: '',
      args: [],
    );
  }

  /// `Generated Article`
  String get generatedArticle {
    return Intl.message(
      'Generated Article',
      name: 'generatedArticle',
      desc: '',
      args: [],
    );
  }

  /// `Speech To Text`
  String get speechToText {
    return Intl.message(
      'Speech To Text',
      name: 'speechToText',
      desc: '',
      args: [],
    );
  }

  /// `Images Generated`
  String get imagesGenerated {
    return Intl.message(
      'Images Generated',
      name: 'imagesGenerated',
      desc: '',
      args: [],
    );
  }

  /// `PDF Generate`
  String get pDFGenerate {
    return Intl.message(
      'PDF Generate',
      name: 'pDFGenerate',
      desc: '',
      args: [],
    );
  }

  /// `Code Generated`
  String get codeGenerated {
    return Intl.message(
      'Code Generated',
      name: 'codeGenerated',
      desc: '',
      args: [],
    );
  }

  /// `Voiceover Generated`
  String get voiceoverGenerated {
    return Intl.message(
      'Voiceover Generated',
      name: 'voiceoverGenerated',
      desc: '',
      args: [],
    );
  }

  /// `Document Generated`
  String get documentGenerated {
    return Intl.message(
      'Document Generated',
      name: 'documentGenerated',
      desc: '',
      args: [],
    );
  }

  /// `Total Credit Balance`
  String get totalCreditBalance {
    return Intl.message(
      'Total Credit Balance',
      name: 'totalCreditBalance',
      desc: '',
      args: [],
    );
  }

  /// `Apple`
  String get apple {
    return Intl.message(
      'Apple',
      name: 'apple',
      desc: '',
      args: [],
    );
  }

  /// `Bananas`
  String get bananas {
    return Intl.message(
      'Bananas',
      name: 'bananas',
      desc: '',
      args: [],
    );
  }

  /// `Fresh Soyabean Oil`
  String get freshSoyabeanOil {
    return Intl.message(
      'Fresh Soyabean Oil',
      name: 'freshSoyabeanOil',
      desc: '',
      args: [],
    );
  }

  /// `Cabbage`
  String get cabbage {
    return Intl.message(
      'Cabbage',
      name: 'cabbage',
      desc: '',
      args: [],
    );
  }

  /// `Rice`
  String get rice {
    return Intl.message(
      'Rice',
      name: 'rice',
      desc: '',
      args: [],
    );
  }

  /// `Fresh Fruits`
  String get freshFruits {
    return Intl.message(
      'Fresh Fruits',
      name: 'freshFruits',
      desc: '',
      args: [],
    );
  }

  /// `Beef Meat`
  String get beefMeat {
    return Intl.message(
      'Beef Meat',
      name: 'beefMeat',
      desc: '',
      args: [],
    );
  }

  /// `Beetroot`
  String get beetroot {
    return Intl.message(
      'Beetroot',
      name: 'beetroot',
      desc: '',
      args: [],
    );
  }

  /// `Potato`
  String get potato {
    return Intl.message(
      'Potato',
      name: 'potato',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Invoice`
  String get invoice {
    return Intl.message(
      'Invoice',
      name: 'invoice',
      desc: '',
      args: [],
    );
  }

  /// `Party Name`
  String get partyName {
    return Intl.message(
      'Party Name',
      name: 'partyName',
      desc: '',
      args: [],
    );
  }

  /// `Payment Type`
  String get paymentType {
    return Intl.message(
      'Payment Type',
      name: 'paymentType',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Paid`
  String get paid {
    return Intl.message(
      'Paid',
      name: 'paid',
      desc: '',
      args: [],
    );
  }

  /// `Due`
  String get due {
    return Intl.message(
      'Due',
      name: 'due',
      desc: '',
      args: [],
    );
  }

  /// `Esther Howard`
  String get estherHoward {
    return Intl.message(
      'Esther Howard',
      name: 'estherHoward',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message(
      'Cash',
      name: 'cash',
      desc: '',
      args: [],
    );
  }

  /// `Unpaid`
  String get unpaid {
    return Intl.message(
      'Unpaid',
      name: 'unpaid',
      desc: '',
      args: [],
    );
  }

  /// `Jerome Bell`
  String get jeromeBell {
    return Intl.message(
      'Jerome Bell',
      name: 'jeromeBell',
      desc: '',
      args: [],
    );
  }

  /// `Marvin McKinney`
  String get marvinMcKinney {
    return Intl.message(
      'Marvin McKinney',
      name: 'marvinMcKinney',
      desc: '',
      args: [],
    );
  }

  /// `Kathryn Murphy`
  String get kathrynMurphy {
    return Intl.message(
      'Kathryn Murphy',
      name: 'kathrynMurphy',
      desc: '',
      args: [],
    );
  }

  /// `Floyd Miles`
  String get floydMiles {
    return Intl.message(
      'Floyd Miles',
      name: 'floydMiles',
      desc: '',
      args: [],
    );
  }

  /// `Recent Sales`
  String get recentSales {
    return Intl.message(
      'Recent Sales',
      name: 'recentSales',
      desc: '',
      args: [],
    );
  }

  /// `Show 5 Results`
  String get show5Results {
    return Intl.message(
      'Show 5 Results',
      name: 'show5Results',
      desc: '',
      args: [],
    );
  }

  /// `View All`
  String get viewAll {
    return Intl.message(
      'View All',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `Total Sales`
  String get totalSales {
    return Intl.message(
      'Total Sales',
      name: 'totalSales',
      desc: '',
      args: [],
    );
  }

  /// `This Month`
  String get thisMonth {
    return Intl.message(
      'This Month',
      name: 'thisMonth',
      desc: '',
      args: [],
    );
  }

  /// `Total Profit`
  String get totalProfit {
    return Intl.message(
      'Total Profit',
      name: 'totalProfit',
      desc: '',
      args: [],
    );
  }

  /// `Coca cola`
  String get cocaCola {
    return Intl.message(
      'Coca cola',
      name: 'cocaCola',
      desc: '',
      args: [],
    );
  }

  /// `Drinks`
  String get drinks {
    return Intl.message(
      'Drinks',
      name: 'drinks',
      desc: '',
      args: [],
    );
  }

  /// `Fanta`
  String get fanta {
    return Intl.message(
      'Fanta',
      name: 'fanta',
      desc: '',
      args: [],
    );
  }

  /// `Fruits`
  String get fruits {
    return Intl.message(
      'Fruits',
      name: 'fruits',
      desc: '',
      args: [],
    );
  }

  /// `Bread`
  String get bread {
    return Intl.message(
      'Bread',
      name: 'bread',
      desc: '',
      args: [],
    );
  }

  /// `Food`
  String get food {
    return Intl.message(
      'Food',
      name: 'food',
      desc: '',
      args: [],
    );
  }

  /// `Jenny Wilson`
  String get jennyWilson {
    return Intl.message(
      'Jenny Wilson',
      name: 'jennyWilson',
      desc: '',
      args: [],
    );
  }

  /// `Dianne Russell`
  String get dianneRussell {
    return Intl.message(
      'Dianne Russell',
      name: 'dianneRussell',
      desc: '',
      args: [],
    );
  }

  /// `Wade Warren`
  String get wadeWarren {
    return Intl.message(
      'Wade Warren',
      name: 'wadeWarren',
      desc: '',
      args: [],
    );
  }

  /// `Darrell Steward`
  String get darrellSteward {
    return Intl.message(
      'Darrell Steward',
      name: 'darrellSteward',
      desc: '',
      args: [],
    );
  }

  /// `Bessie Cooper`
  String get dessieCooper {
    return Intl.message(
      'Bessie Cooper',
      name: 'dessieCooper',
      desc: '',
      args: [],
    );
  }

  /// `Mango`
  String get mango {
    return Intl.message(
      'Mango',
      name: 'mango',
      desc: '',
      args: [],
    );
  }

  /// `Bessie Cooper`
  String get bessieCooper {
    return Intl.message(
      'Bessie Cooper',
      name: 'bessieCooper',
      desc: '',
      args: [],
    );
  }

  /// `Banana`
  String get banana {
    return Intl.message(
      'Banana',
      name: 'banana',
      desc: '',
      args: [],
    );
  }

  /// `Hello Acnoo`
  String get helloAcnoo {
    return Intl.message(
      'Hello Acnoo',
      name: 'helloAcnoo',
      desc: '',
      args: [],
    );
  }

  /// `Best Regards`
  String get bestRegards {
    return Intl.message(
      'Best Regards',
      name: 'bestRegards',
      desc: '',
      args: [],
    );
  }

  /// `Acnoo`
  String get acnoo {
    return Intl.message(
      'Acnoo',
      name: 'acnoo',
      desc: '',
      args: [],
    );
  }

  /// `Basic Input`
  String get basicInput {
    return Intl.message(
      'Basic Input',
      name: 'basicInput',
      desc: '',
      args: [],
    );
  }

  /// `Input with Value`
  String get inputWithValue {
    return Intl.message(
      'Input with Value',
      name: 'inputWithValue',
      desc: '',
      args: [],
    );
  }

  /// `Rounded`
  String get rounded {
    return Intl.message(
      'Rounded',
      name: 'rounded',
      desc: '',
      args: [],
    );
  }

  /// `Placeholder`
  String get placeholder {
    return Intl.message(
      'Placeholder',
      name: 'placeholder',
      desc: '',
      args: [],
    );
  }

  /// `Input Value`
  String get inputValue {
    return Intl.message(
      'Input Value',
      name: 'inputValue',
      desc: '',
      args: [],
    );
  }

  /// `Input`
  String get input {
    return Intl.message(
      'Input',
      name: 'input',
      desc: '',
      args: [],
    );
  }

  /// `Open this select menu`
  String get openThisSelectMenu {
    return Intl.message(
      'Open this select menu',
      name: 'openThisSelectMenu',
      desc: '',
      args: [],
    );
  }

  /// `Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.`
  String get loremIpsumIsSimplyDummyTextOfThePrintingAndTypesettingIndustry {
    return Intl.message(
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
      name: 'loremIpsumIsSimplyDummyTextOfThePrintingAndTypesettingIndustry',
      desc: '',
      args: [],
    );
  }

  /// `One`
  String get one {
    return Intl.message(
      'One',
      name: 'one',
      desc: '',
      args: [],
    );
  }

  /// `two`
  String get two {
    return Intl.message(
      'two',
      name: 'two',
      desc: '',
      args: [],
    );
  }

  /// `three`
  String get three {
    return Intl.message(
      'three',
      name: 'three',
      desc: '',
      args: [],
    );
  }

  /// `eligendi dolore voluptate`
  String get eligendiDoloreVoluptate {
    return Intl.message(
      'eligendi dolore voluptate',
      name: 'eligendiDoloreVoluptate',
      desc: '',
      args: [],
    );
  }

  /// `natus quia aut`
  String get natusQuiaAut {
    return Intl.message(
      'natus quia aut',
      name: 'natusQuiaAut',
      desc: '',
      args: [],
    );
  }

  /// `aliquam sint libero`
  String get aliquamSintLibero {
    return Intl.message(
      'aliquam sint libero',
      name: 'aliquamSintLibero',
      desc: '',
      args: [],
    );
  }

  /// `reiciendis rem voluptas`
  String get reiciendisRemVoluptas {
    return Intl.message(
      'reiciendis rem voluptas',
      name: 'reiciendisRemVoluptas',
      desc: '',
      args: [],
    );
  }

  /// `repellendus eum eveniet`
  String get repellendusEumEveniet {
    return Intl.message(
      'repellendus eum eveniet',
      name: 'repellendusEumEveniet',
      desc: '',
      args: [],
    );
  }

  /// `doloribus et eos`
  String get doloribuseEtEos {
    return Intl.message(
      'doloribus et eos',
      name: 'doloribuseEtEos',
      desc: '',
      args: [],
    );
  }

  /// `illo excepturi cupiditate`
  String get illoExcepturiCupiditate {
    return Intl.message(
      'illo excepturi cupiditate',
      name: 'illoExcepturiCupiditate',
      desc: '',
      args: [],
    );
  }

  /// `sit sit aut`
  String get sitSitAut {
    return Intl.message(
      'sit sit aut',
      name: 'sitSitAut',
      desc: '',
      args: [],
    );
  }

  /// `autem optio velit`
  String get autemOptioVelit {
    return Intl.message(
      'autem optio velit',
      name: 'autemOptioVelit',
      desc: '',
      args: [],
    );
  }

  /// `quia explicabo possimus`
  String get quiaExplicaboPossimus {
    return Intl.message(
      'quia explicabo possimus',
      name: 'quiaExplicaboPossimus',
      desc: '',
      args: [],
    );
  }

  /// `ipsum aspernatur id`
  String get ipsumAspernaturId {
    return Intl.message(
      'ipsum aspernatur id',
      name: 'ipsumAspernaturId',
      desc: '',
      args: [],
    );
  }

  /// `et ea quis`
  String get etEaQuis {
    return Intl.message(
      'et ea quis',
      name: 'etEaQuis',
      desc: '',
      args: [],
    );
  }

  /// `rerum sint aliquid`
  String get rerumSintAliquid {
    return Intl.message(
      'rerum sint aliquid',
      name: 'rerumSintAliquid',
      desc: '',
      args: [],
    );
  }

  /// `qui iste ratione`
  String get quiIsteRatione {
    return Intl.message(
      'qui iste ratione',
      name: 'quiIsteRatione',
      desc: '',
      args: [],
    );
  }

  /// `debitis unde corrupti`
  String get debitisUndeCorrupti {
    return Intl.message(
      'debitis unde corrupti',
      name: 'debitisUndeCorrupti',
      desc: '',
      args: [],
    );
  }

  /// `quia eos eum`
  String get quiaEosEum {
    return Intl.message(
      'quia eos eum',
      name: 'quiaEosEum',
      desc: '',
      args: [],
    );
  }

  /// `nihil porro est`
  String get nihilPorroEst {
    return Intl.message(
      'nihil porro est',
      name: 'nihilPorroEst',
      desc: '',
      args: [],
    );
  }

  /// `dolorem sunt corrupti`
  String get doloremSuntCorrupti {
    return Intl.message(
      'dolorem sunt corrupti',
      name: 'doloremSuntCorrupti',
      desc: '',
      args: [],
    );
  }

  /// `quia necessitatibus molestiae`
  String get quiaNecessitatibusMolestiae {
    return Intl.message(
      'quia necessitatibus molestiae',
      name: 'quiaNecessitatibusMolestiae',
      desc: '',
      args: [],
    );
  }

  /// `qui molestiae quis`
  String get quiMolestiaeQuis {
    return Intl.message(
      'qui molestiae quis',
      name: 'quiMolestiaeQuis',
      desc: '',
      args: [],
    );
  }

  /// `View`
  String get view {
    return Intl.message(
      'View',
      name: 'view',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `progress`
  String get progress {
    return Intl.message(
      'progress',
      name: 'progress',
      desc: '',
      args: [],
    );
  }

  /// `Duration `
  String get duration {
    return Intl.message(
      'Duration ',
      name: 'duration',
      desc: '',
      args: [],
    );
  }

  /// `Move item from`
  String get moveItemFrom {
    return Intl.message(
      'Move item from',
      name: 'moveItemFrom',
      desc: '',
      args: [],
    );
  }

  /// `to`
  String get to {
    return Intl.message(
      'to',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `Move`
  String get move {
    return Intl.message(
      'Move',
      name: 'move',
      desc: '',
      args: [],
    );
  }

  /// `Export Excel`
  String get exportExcel {
    return Intl.message(
      'Export Excel',
      name: 'exportExcel',
      desc: '',
      args: [],
    );
  }

  /// `Export CSV`
  String get exportCSV {
    return Intl.message(
      'Export CSV',
      name: 'exportCSV',
      desc: '',
      args: [],
    );
  }

  /// `Export PDF`
  String get exportPDF {
    return Intl.message(
      'Export PDF',
      name: 'exportPDF',
      desc: '',
      args: [],
    );
  }

  /// `Print`
  String get print {
    return Intl.message(
      'Print',
      name: 'print',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get copy {
    return Intl.message(
      'Copy',
      name: 'copy',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Describe what kind of code you need`
  String get describeWhatKindOfCodeYouNeed {
    return Intl.message(
      'Describe what kind of code you need',
      name: 'describeWhatKindOfCodeYouNeed',
      desc: '',
      args: [],
    );
  }

  /// `Coding Level`
  String get codingLevel {
    return Intl.message(
      'Coding Level',
      name: 'codingLevel',
      desc: '',
      args: [],
    );
  }

  /// `Programing Language`
  String get programingLanguage {
    return Intl.message(
      'Programing Language',
      name: 'programingLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Beginner`
  String get beginner {
    return Intl.message(
      'Beginner',
      name: 'beginner',
      desc: '',
      args: [],
    );
  }

  /// `Intermediate`
  String get intermediate {
    return Intl.message(
      'Intermediate',
      name: 'intermediate',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advanced {
    return Intl.message(
      'Advanced',
      name: 'advanced',
      desc: '',
      args: [],
    );
  }

  /// `Expert`
  String get expert {
    return Intl.message(
      'Expert',
      name: 'expert',
      desc: '',
      args: [],
    );
  }

  /// `Novice`
  String get novice {
    return Intl.message(
      'Novice',
      name: 'novice',
      desc: '',
      args: [],
    );
  }

  /// `Junior`
  String get junior {
    return Intl.message(
      'Junior',
      name: 'junior',
      desc: '',
      args: [],
    );
  }

  /// `Mid-Level`
  String get midLevel {
    return Intl.message(
      'Mid-Level',
      name: 'midLevel',
      desc: '',
      args: [],
    );
  }

  /// `Senior`
  String get senior {
    return Intl.message(
      'Senior',
      name: 'senior',
      desc: '',
      args: [],
    );
  }

  /// `Proficient`
  String get proficient {
    return Intl.message(
      'Proficient',
      name: 'proficient',
      desc: '',
      args: [],
    );
  }

  /// `Master`
  String get master {
    return Intl.message(
      'Master',
      name: 'master',
      desc: '',
      args: [],
    );
  }

  /// `Lead`
  String get lead {
    return Intl.message(
      'Lead',
      name: 'lead',
      desc: '',
      args: [],
    );
  }

  /// `Sure! Here’s a basic code for an counter app using Dart's Flutter framework`
  String get sureHereABasicCodeForAnCounterAppUsingDartFlutterFramework {
    return Intl.message(
      'Sure! Here’s a basic code for an counter app using Dart\'s Flutter framework',
      name: 'sureHereABasicCodeForAnCounterAppUsingDartFlutterFramework',
      desc: '',
      args: [],
    );
  }

  /// `This code uses the setState method to update 'count' variable's state and update the UI`
  String
      get thisCodeUsesTheSetStateMethodToUpdateCountVariableStateAndUpdateTheUI {
    return Intl.message(
      'This code uses the setState method to update `count` variable\'s state and update the UI',
      name:
          'thisCodeUsesTheSetStateMethodToUpdateCountVariableStateAndUpdateTheUI',
      desc: '',
      args: [],
    );
  }

  /// `Document Name`
  String get documentName {
    return Intl.message(
      'Document Name',
      name: 'documentName',
      desc: '',
      args: [],
    );
  }

  /// `Text to Image`
  String get textToImage {
    return Intl.message(
      'Text to Image',
      name: 'textToImage',
      desc: '',
      args: [],
    );
  }

  /// `Image to Image`
  String get imageToImage {
    return Intl.message(
      'Image to Image',
      name: 'imageToImage',
      desc: '',
      args: [],
    );
  }

  /// `Describe an image you want to Generate`
  String get describeAnImageYouWantToGenerate {
    return Intl.message(
      'Describe an image you want to Generate',
      name: 'describeAnImageYouWantToGenerate',
      desc: '',
      args: [],
    );
  }

  /// `Generate`
  String get generate {
    return Intl.message(
      'Generate',
      name: 'generate',
      desc: '',
      args: [],
    );
  }

  /// `Click or drop an image here`
  String get clickOrDropAnImageHere {
    return Intl.message(
      'Click or drop an image here',
      name: 'clickOrDropAnImageHere',
      desc: '',
      args: [],
    );
  }

  /// `Up to 10MB`
  String get upTo10MB {
    return Intl.message(
      'Up to 10MB',
      name: 'upTo10MB',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `of`
  String get oF {
    return Intl.message(
      'of',
      name: 'oF',
      desc: '',
      args: [],
    );
  }

  /// `Narration`
  String get narration {
    return Intl.message(
      'Narration',
      name: 'narration',
      desc: '',
      args: [],
    );
  }

  /// `Conversational`
  String get conversational {
    return Intl.message(
      'Conversational',
      name: 'conversational',
      desc: '',
      args: [],
    );
  }

  /// `Formal`
  String get formal {
    return Intl.message(
      'Formal',
      name: 'formal',
      desc: '',
      args: [],
    );
  }

  /// `Casual`
  String get casual {
    return Intl.message(
      'Casual',
      name: 'casual',
      desc: '',
      args: [],
    );
  }

  /// `Excited`
  String get excited {
    return Intl.message(
      'Excited',
      name: 'excited',
      desc: '',
      args: [],
    );
  }

  /// `Calm`
  String get calm {
    return Intl.message(
      'Calm',
      name: 'calm',
      desc: '',
      args: [],
    );
  }

  /// `Serious`
  String get serious {
    return Intl.message(
      'Serious',
      name: 'serious',
      desc: '',
      args: [],
    );
  }

  /// `Friendly`
  String get friendly {
    return Intl.message(
      'Friendly',
      name: 'friendly',
      desc: '',
      args: [],
    );
  }

  /// `Inspirational`
  String get inspirational {
    return Intl.message(
      'Inspirational',
      name: 'inspirational',
      desc: '',
      args: [],
    );
  }

  /// `Persuasive`
  String get persuasive {
    return Intl.message(
      'Persuasive',
      name: 'persuasive',
      desc: '',
      args: [],
    );
  }

  /// `Sad`
  String get sad {
    return Intl.message(
      'Sad',
      name: 'sad',
      desc: '',
      args: [],
    );
  }

  /// `Joyful`
  String get joyful {
    return Intl.message(
      'Joyful',
      name: 'joyful',
      desc: '',
      args: [],
    );
  }

  /// `Neutral`
  String get neutral {
    return Intl.message(
      'Neutral',
      name: 'neutral',
      desc: '',
      args: [],
    );
  }

  /// `Authoritative`
  String get authoritative {
    return Intl.message(
      'Authoritative',
      name: 'authoritative',
      desc: '',
      args: [],
    );
  }

  /// `Warm`
  String get warm {
    return Intl.message(
      'Warm',
      name: 'warm',
      desc: '',
      args: [],
    );
  }

  /// `Playful`
  String get playful {
    return Intl.message(
      'Playful',
      name: 'playful',
      desc: '',
      args: [],
    );
  }

  /// `Dramatic`
  String get dramatic {
    return Intl.message(
      'Dramatic',
      name: 'dramatic',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Empathetic`
  String get empathetic {
    return Intl.message(
      'Empathetic',
      name: 'empathetic',
      desc: '',
      args: [],
    );
  }

  /// `Instructional`
  String get instructional {
    return Intl.message(
      'Instructional',
      name: 'instructional',
      desc: '',
      args: [],
    );
  }

  /// `File Name`
  String get fileName {
    return Intl.message(
      'File Name',
      name: 'fileName',
      desc: '',
      args: [],
    );
  }

  /// `Enter File Name`
  String get enterFileName {
    return Intl.message(
      'Enter File Name',
      name: 'enterFileName',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Voices`
  String get voices {
    return Intl.message(
      'Voices',
      name: 'voices',
      desc: '',
      args: [],
    );
  }

  /// `Speaking Style`
  String get speakingStyle {
    return Intl.message(
      'Speaking Style',
      name: 'speakingStyle',
      desc: '',
      args: [],
    );
  }

  /// `Pause`
  String get pause {
    return Intl.message(
      'Pause',
      name: 'pause',
      desc: '',
      args: [],
    );
  }

  /// `Select One`
  String get selectOne {
    return Intl.message(
      'Select One',
      name: 'selectOne',
      desc: '',
      args: [],
    );
  }

  /// `Second`
  String get second {
    return Intl.message(
      'Second',
      name: 'second',
      desc: '',
      args: [],
    );
  }

  /// `Download Fiels`
  String get downloadFiels {
    return Intl.message(
      'Download Fiels',
      name: 'downloadFiels',
      desc: '',
      args: [],
    );
  }

  /// `Speed`
  String get speed {
    return Intl.message(
      'Speed',
      name: 'speed',
      desc: '',
      args: [],
    );
  }

  /// `Make up a 5-sentence story about "Sharky", a tooth-brushing shark superhero`
  String get makeUpA5SentenceStoryAboutSharkyAToothBrushingSharkSuperhero {
    return Intl.message(
      'Make up a 5-sentence story about "Sharky", a tooth-brushing shark superhero',
      name: 'makeUpA5SentenceStoryAboutSharkyAToothBrushingSharkSuperhero',
      desc: '',
      args: [],
    );
  }

  /// `Certainly! To provide you with more relevant and effective UX copy for a subscription plan, I'd need some specific details. However, I can offer you a generic example. Please adapt the following based on your product or service specifics`
  String get certainlyToProvideYouWithMoreRelevant {
    return Intl.message(
      'Certainly! To provide you with more relevant and effective UX copy for a subscription plan, I\'d need some specific details. However, I can offer you a generic example. Please adapt the following based on your product or service specifics',
      name: 'certainlyToProvideYouWithMoreRelevant',
      desc: '',
      args: [],
    );
  }

  /// `Subscription Plan Title: Premium Membership`
  String get subscriptionPlanTitlePremiumMembership {
    return Intl.message(
      'Subscription Plan Title: Premium Membership',
      name: 'subscriptionPlanTitlePremiumMembership',
      desc: '',
      args: [],
    );
  }

  /// `Unlock a world of exclusive benefits with our Premium Membership. Enjoy limitless access, early bird privileges, and personalized insights tailored just for you`
  String get unlockAWorldOfExclusiveBenefitsWithOurPremiumMembership {
    return Intl.message(
      'Unlock a world of exclusive benefits with our Premium Membership. Enjoy limitless access, early bird privileges, and personalized insights tailored just for you',
      name: 'unlockAWorldOfExclusiveBenefitsWithOurPremiumMembership',
      desc: '',
      args: [],
    );
  }

  /// `1. Introduction Section`
  String get introductionSection {
    return Intl.message(
      '1. Introduction Section',
      name: 'introductionSection',
      desc: '',
      args: [],
    );
  }

  /// `Unlock a World of Exclusive Benefits`
  String get unlockAWorldOfExclusiveBenefits {
    return Intl.message(
      'Unlock a World of Exclusive Benefits',
      name: 'unlockAWorldOfExclusiveBenefits',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to our Premium Membership for an unparalleled experience. Enjoy a host of premium features designed to elevate your [Product/Service] journey`
  String get upgradeToOurPremiumMembershipForAnnparalleledExperience {
    return Intl.message(
      'Upgrade to our Premium Membership for an unparalleled experience. Enjoy a host of premium features designed to elevate your [Product/Service] journey',
      name: 'upgradeToOurPremiumMembershipForAnnparalleledExperience',
      desc: '',
      args: [],
    );
  }

  /// `2. Features Highlights`
  String get featuresHighlights {
    return Intl.message(
      '2. Features Highlights',
      name: 'featuresHighlights',
      desc: '',
      args: [],
    );
  }

  /// `3. Pricing Information`
  String get pricingInformation {
    return Intl.message(
      '3. Pricing Information',
      name: 'pricingInformation',
      desc: '',
      args: [],
    );
  }

  /// `Limitless Access: Dive into unrestricted access to our full range of [Product/Service]. Early Bird Access: Be the first to experience new features, products, and updates before anyone else. Personalized Insights: Tailored recommendations and insights to enhance your [Product/Service] experience based on your preferences`
  String get limitlessAccess {
    return Intl.message(
      'Limitless Access: Dive into unrestricted access to our full range of [Product/Service]. Early Bird Access: Be the first to experience new features, products, and updates before anyone else. Personalized Insights: Tailored recommendations and insights to enhance your [Product/Service] experience based on your preferences',
      name: 'limitlessAccess',
      desc: '',
      args: [],
    );
  }

  /// `Choose the plan that suits your needs best:`
  String get chooseThePlanThatSuitsYourNeedsNest {
    return Intl.message(
      'Choose the plan that suits your needs best:',
      name: 'chooseThePlanThatSuitsYourNeedsNest',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Plan: \$9.99/month`
  String get monthlyPlan999Month {
    return Intl.message(
      'Monthly Plan: \\\$9.99/month',
      name: 'monthlyPlan999Month',
      desc: '',
      args: [],
    );
  }

  /// `Annual Plan: Save 20% - \$95.88/year`
  String get annualPlanSave209588year {
    return Intl.message(
      'Annual Plan: Save 20% - \\\$95.88/year',
      name: 'annualPlanSave209588year',
      desc: '',
      args: [],
    );
  }

  /// `4. Call-to-Action Section`
  String get callToActionSection {
    return Intl.message(
      '4. Call-to-Action Section',
      name: 'callToActionSection',
      desc: '',
      args: [],
    );
  }

  /// `Ready to elevate your experience?`
  String get readyToElevateYourExperience {
    return Intl.message(
      'Ready to elevate your experience?',
      name: 'readyToElevateYourExperience',
      desc: '',
      args: [],
    );
  }

  /// `[Subscribe Now] Button`
  String get subscribeNowButton {
    return Intl.message(
      '[Subscribe Now] Button',
      name: 'subscribeNowButton',
      desc: '',
      args: [],
    );
  }

  /// `5. Guarantee Section`
  String get guaranteeSection {
    return Intl.message(
      '5. Guarantee Section',
      name: 'guaranteeSection',
      desc: '',
      args: [],
    );
  }

  /// `Risk-Free Satisfaction Guaranteed`
  String get riskFreeSatisfactionGuaranteed {
    return Intl.message(
      'Risk-Free Satisfaction Guaranteed',
      name: 'riskFreeSatisfactionGuaranteed',
      desc: '',
      args: [],
    );
  }

  /// `6. FAQ Section`
  String get fAQSection {
    return Intl.message(
      '6. FAQ Section',
      name: 'fAQSection',
      desc: '',
      args: [],
    );
  }

  /// `Have Questions? We've Got Answers`
  String get haveQuestionsWeGotAnswers {
    return Intl.message(
      'Have Questions? We\'ve Got Answers',
      name: 'haveQuestionsWeGotAnswers',
      desc: '',
      args: [],
    );
  }

  /// `How do I cancel my subscription`
  String get howDoICancelMySubscription {
    return Intl.message(
      'How do I cancel my subscription',
      name: 'howDoICancelMySubscription',
      desc: '',
      args: [],
    );
  }

  /// `Can I switch plans at any time`
  String get canISwitchPlansAtAnyTime {
    return Intl.message(
      'Can I switch plans at any time',
      name: 'canISwitchPlansAtAnyTime',
      desc: '',
      args: [],
    );
  }

  /// `Is my payment information secure`
  String get isMyPaymentInformationSecure {
    return Intl.message(
      'Is my payment information secure',
      name: 'isMyPaymentInformationSecure',
      desc: '',
      args: [],
    );
  }

  /// `7. Footer Section`
  String get footerSection {
    return Intl.message(
      '7. Footer Section',
      name: 'footerSection',
      desc: '',
      args: [],
    );
  }

  /// `Join [Your Company] Premium and experience [Product/Service] like never before. Subscribe now to unlock a new level of excellence`
  String get joinYourCompanyPremiumAndExperience {
    return Intl.message(
      'Join [Your Company] Premium and experience [Product/Service] like never before. Subscribe now to unlock a new level of excellence',
      name: 'joinYourCompanyPremiumAndExperience',
      desc: '',
      args: [],
    );
  }

  /// `Not satisfied? We offer a 30-day money-back guarantee. No questions asked`
  String get notSatisfiedWeOfferA30DayMoneyBackGuaranteeNoQuestionsAsked {
    return Intl.message(
      'Not satisfied? We offer a 30-day money-back guarantee. No questions asked',
      name: 'notSatisfiedWeOfferA30DayMoneyBackGuaranteeNoQuestionsAsked',
      desc: '',
      args: [],
    );
  }

  /// `Feel free to customize this copy according to your brand voice, specific features, and pricing details`
  String get feelFreeToCustomizeThisCopyAccordingToYourBrandVoice {
    return Intl.message(
      'Feel free to customize this copy according to your brand voice, specific features, and pricing details',
      name: 'feelFreeToCustomizeThisCopyAccordingToYourBrandVoice',
      desc: '',
      args: [],
    );
  }

  /// `Template`
  String get template {
    return Intl.message(
      'Template',
      name: 'template',
      desc: '',
      args: [],
    );
  }

  /// `Maximum Length`
  String get maximumLength {
    return Intl.message(
      'Maximum Length',
      name: 'maximumLength',
      desc: '',
      args: [],
    );
  }

  /// `Number of Results`
  String get numberOfResults {
    return Intl.message(
      'Number of Results',
      name: 'numberOfResults',
      desc: '',
      args: [],
    );
  }

  /// `Creativity`
  String get creativity {
    return Intl.message(
      'Creativity',
      name: 'creativity',
      desc: '',
      args: [],
    );
  }

  /// `Tone of Voice`
  String get toneOfVoice {
    return Intl.message(
      'Tone of Voice',
      name: 'toneOfVoice',
      desc: '',
      args: [],
    );
  }

  /// `Blog Writing  Suggestion`
  String get blogWritingSuggestion {
    return Intl.message(
      'Blog Writing  Suggestion',
      name: 'blogWritingSuggestion',
      desc: '',
      args: [],
    );
  }

  /// `Write a Text`
  String get writeAText {
    return Intl.message(
      'Write a Text',
      name: 'writeAText',
      desc: '',
      args: [],
    );
  }

  /// `Compare business strategies`
  String get compareBusinessStrategies {
    return Intl.message(
      'Compare business strategies',
      name: 'compareBusinessStrategies',
      desc: '',
      args: [],
    );
  }

  /// `Create a personal content for me`
  String get createAPersonalContentForMe {
    return Intl.message(
      'Create a personal content for me',
      name: 'createAPersonalContentForMe',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Product Descriptions`
  String get productDescriptions {
    return Intl.message(
      'Product Descriptions',
      name: 'productDescriptions',
      desc: '',
      args: [],
    );
  }

  /// `Social Media Captions`
  String get socialMediaCaptions {
    return Intl.message(
      'Social Media Captions',
      name: 'socialMediaCaptions',
      desc: '',
      args: [],
    );
  }

  /// `Email Newsletters`
  String get emailNewsletters {
    return Intl.message(
      'Email Newsletters',
      name: 'emailNewsletters',
      desc: '',
      args: [],
    );
  }

  /// `SEO Meta Descriptions`
  String get sEOMetaDescriptions {
    return Intl.message(
      'SEO Meta Descriptions',
      name: 'sEOMetaDescriptions',
      desc: '',
      args: [],
    );
  }

  /// `Ad Copy`
  String get adCopy {
    return Intl.message(
      'Ad Copy',
      name: 'adCopy',
      desc: '',
      args: [],
    );
  }

  /// `Landing Page Copy`
  String get landingPageCopy {
    return Intl.message(
      'Landing Page Copy',
      name: 'landingPageCopy',
      desc: '',
      args: [],
    );
  }

  /// `Press Releases`
  String get pressReleases {
    return Intl.message(
      'Press Releases',
      name: 'pressReleases',
      desc: '',
      args: [],
    );
  }

  /// `Whitepapers`
  String get whitepapers {
    return Intl.message(
      'Whitepapers',
      name: 'whitepapers',
      desc: '',
      args: [],
    );
  }

  /// `Case Studies`
  String get caseStudies {
    return Intl.message(
      'Case Studies',
      name: 'caseStudies',
      desc: '',
      args: [],
    );
  }

  /// `Video Scripts`
  String get videoScripts {
    return Intl.message(
      'Video Scripts',
      name: 'videoScripts',
      desc: '',
      args: [],
    );
  }

  /// `E-commerce Product Listings`
  String get ecommerceProductListings {
    return Intl.message(
      'E-commerce Product Listings',
      name: 'ecommerceProductListings',
      desc: '',
      args: [],
    );
  }

  /// `Website Content`
  String get websiteContent {
    return Intl.message(
      'Website Content',
      name: 'websiteContent',
      desc: '',
      args: [],
    );
  }

  /// `Technical Documentation`
  String get technicalDocumentation {
    return Intl.message(
      'Technical Documentation',
      name: 'technicalDocumentation',
      desc: '',
      args: [],
    );
  }

  /// `Creative Writing (e.g., Short Stories)`
  String get creativeWritingShortStories {
    return Intl.message(
      'Creative Writing (e.g., Short Stories)',
      name: 'creativeWritingShortStories',
      desc: '',
      args: [],
    );
  }

  /// `Brand Storytelling`
  String get brandStorytelling {
    return Intl.message(
      'Brand Storytelling',
      name: 'brandStorytelling',
      desc: '',
      args: [],
    );
  }

  /// `Resume and Cover Letters`
  String get resumeandCoverLetters {
    return Intl.message(
      'Resume and Cover Letters',
      name: 'resumeandCoverLetters',
      desc: '',
      args: [],
    );
  }

  /// `App Store Descriptions`
  String get appStoreDescriptions {
    return Intl.message(
      'App Store Descriptions',
      name: 'appStoreDescriptions',
      desc: '',
      args: [],
    );
  }

  /// `E-book Writing`
  String get ebookWriting {
    return Intl.message(
      'E-book Writing',
      name: 'ebookWriting',
      desc: '',
      args: [],
    );
  }

  /// `Customer Testimonials`
  String get customerTestimonials {
    return Intl.message(
      'Customer Testimonials',
      name: 'customerTestimonials',
      desc: '',
      args: [],
    );
  }

  /// `Sales Copy`
  String get salesCopy {
    return Intl.message(
      'Sales Copy',
      name: 'salesCopy',
      desc: '',
      args: [],
    );
  }

  /// `How-to Guides`
  String get howtoGuides {
    return Intl.message(
      'How-to Guides',
      name: 'howtoGuides',
      desc: '',
      args: [],
    );
  }

  /// `FAQs Writing`
  String get fAQsWriting {
    return Intl.message(
      'FAQs Writing',
      name: 'fAQsWriting',
      desc: '',
      args: [],
    );
  }

  /// `Job Descriptions`
  String get jobDescriptions {
    return Intl.message(
      'Job Descriptions',
      name: 'jobDescriptions',
      desc: '',
      args: [],
    );
  }

  /// `Business Proposals`
  String get businessProposals {
    return Intl.message(
      'Business Proposals',
      name: 'businessProposals',
      desc: '',
      args: [],
    );
  }

  /// `Cold Email Outreach`
  String get coldEmailOutreach {
    return Intl.message(
      'Cold Email Outreach',
      name: 'coldEmailOutreach',
      desc: '',
      args: [],
    );
  }

  /// `Speech Writing`
  String get speechWriting {
    return Intl.message(
      'Speech Writing',
      name: 'speechWriting',
      desc: '',
      args: [],
    );
  }

  /// `Interview Question Writing`
  String get interviewQuestionWriting {
    return Intl.message(
      'Interview Question Writing',
      name: 'interviewQuestionWriting',
      desc: '',
      args: [],
    );
  }

  /// `Review Responses`
  String get reviewResponses {
    return Intl.message(
      'Review Responses',
      name: 'reviewResponses',
      desc: '',
      args: [],
    );
  }

  /// `Event Invitations`
  String get eventInvitations {
    return Intl.message(
      'Event Invitations',
      name: 'eventInvitations',
      desc: '',
      args: [],
    );
  }

  /// `Witty`
  String get witty {
    return Intl.message(
      'Witty',
      name: 'witty',
      desc: '',
      args: [],
    );
  }

  /// `Imaginative`
  String get imaginative {
    return Intl.message(
      'Imaginative',
      name: 'imaginative',
      desc: '',
      args: [],
    );
  }

  /// `Direct`
  String get direct {
    return Intl.message(
      'Direct',
      name: 'direct',
      desc: '',
      args: [],
    );
  }

  /// `Energetic`
  String get energetic {
    return Intl.message(
      'Energetic',
      name: 'energetic',
      desc: '',
      args: [],
    );
  }

  /// `Reflective`
  String get reflective {
    return Intl.message(
      'Reflective',
      name: 'reflective',
      desc: '',
      args: [],
    );
  }

  /// `Adventurous`
  String get adventurous {
    return Intl.message(
      'Adventurous',
      name: 'adventurous',
      desc: '',
      args: [],
    );
  }

  /// `Quirky`
  String get quirky {
    return Intl.message(
      'Quirky',
      name: 'quirky',
      desc: '',
      args: [],
    );
  }

  /// `Professional`
  String get professional {
    return Intl.message(
      'Professional',
      name: 'professional',
      desc: '',
      args: [],
    );
  }

  /// `Confident`
  String get confident {
    return Intl.message(
      'Confident',
      name: 'confident',
      desc: '',
      args: [],
    );
  }

  /// `Respectful`
  String get respectful {
    return Intl.message(
      'Respectful',
      name: 'respectful',
      desc: '',
      args: [],
    );
  }

  /// `Bold`
  String get bold {
    return Intl.message(
      'Bold',
      name: 'bold',
      desc: '',
      args: [],
    );
  }

  /// `Caring`
  String get caring {
    return Intl.message(
      'Caring',
      name: 'caring',
      desc: '',
      args: [],
    );
  }

  /// `Optimistic`
  String get optimistic {
    return Intl.message(
      'Optimistic',
      name: 'optimistic',
      desc: '',
      args: [],
    );
  }

  /// `Sophisticated`
  String get sophisticated {
    return Intl.message(
      'Sophisticated',
      name: 'sophisticated',
      desc: '',
      args: [],
    );
  }

  /// `Humorous`
  String get humorous {
    return Intl.message(
      'Humorous',
      name: 'humorous',
      desc: '',
      args: [],
    );
  }

  /// `Thoughtful`
  String get thoughtful {
    return Intl.message(
      'Thoughtful',
      name: 'thoughtful',
      desc: '',
      args: [],
    );
  }

  /// `Keywords (Separate with comma)`
  String get keywordsSeparateWithComma {
    return Intl.message(
      'Keywords (Separate with comma)',
      name: 'keywordsSeparateWithComma',
      desc: '',
      args: [],
    );
  }

  /// `e.g. maantheme, acnoo`
  String get egMaanthemeAcnoo {
    return Intl.message(
      'e.g. maantheme, acnoo',
      name: 'egMaanthemeAcnoo',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message(
      'Dashboard',
      name: 'dashboard',
      desc: '',
      args: [],
    );
  }

  /// `Open AI Admin`
  String get openAIAdmin {
    return Intl.message(
      'Open AI Admin',
      name: 'openAIAdmin',
      desc: '',
      args: [],
    );
  }

  /// `ERP Admin`
  String get eRPAdmin {
    return Intl.message(
      'ERP Admin',
      name: 'eRPAdmin',
      desc: '',
      args: [],
    );
  }

  /// `POS Admin`
  String get pOSAdmin {
    return Intl.message(
      'POS Admin',
      name: 'pOSAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Earning Admin`
  String get earningAdmin {
    return Intl.message(
      'Earning Admin',
      name: 'earningAdmin',
      desc: '',
      args: [],
    );
  }

  /// `SMS Admin`
  String get sMSAdmin {
    return Intl.message(
      'SMS Admin',
      name: 'sMSAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Influencer Admin`
  String get influencerAdmin {
    return Intl.message(
      'Influencer Admin',
      name: 'influencerAdmin',
      desc: '',
      args: [],
    );
  }

  /// `HRM Admin`
  String get hRMAdmin {
    return Intl.message(
      'HRM Admin',
      name: 'hRMAdmin',
      desc: '',
      args: [],
    );
  }

  /// `News Admin`
  String get newsAdmin {
    return Intl.message(
      'News Admin',
      name: 'newsAdmin',
      desc: '',
      args: [],
    );
  }

  /// `eCommerce Admin`
  String get eCommerceAdmin {
    return Intl.message(
      'eCommerce Admin',
      name: 'eCommerceAdmin',
      desc: '',
      args: [],
    );
  }

  /// `Widgets`
  String get widgets {
    return Intl.message(
      'Widgets',
      name: 'widgets',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get general {
    return Intl.message(
      'General',
      name: 'general',
      desc: '',
      args: [],
    );
  }

  /// `Chart`
  String get chart {
    return Intl.message(
      'Chart',
      name: 'chart',
      desc: '',
      args: [],
    );
  }

  /// `Application`
  String get application {
    return Intl.message(
      'Application',
      name: 'application',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Projects`
  String get projects {
    return Intl.message(
      'Projects',
      name: 'projects',
      desc: '',
      args: [],
    );
  }

  /// `Kanban`
  String get kanban {
    return Intl.message(
      'Kanban',
      name: 'kanban',
      desc: '',
      args: [],
    );
  }

  /// `Open AI`
  String get openAI {
    return Intl.message(
      'Open AI',
      name: 'openAI',
      desc: '',
      args: [],
    );
  }

  /// `AI Writer`
  String get aIWriter {
    return Intl.message(
      'AI Writer',
      name: 'aIWriter',
      desc: '',
      args: [],
    );
  }

  /// `AI Image`
  String get aIImage {
    return Intl.message(
      'AI Image',
      name: 'aIImage',
      desc: '',
      args: [],
    );
  }

  /// `AI Chat`
  String get aIChat {
    return Intl.message(
      'AI Chat',
      name: 'aIChat',
      desc: '',
      args: [],
    );
  }

  /// `AI Code`
  String get aICode {
    return Intl.message(
      'AI Code',
      name: 'aICode',
      desc: '',
      args: [],
    );
  }

  /// `AI Voiceover`
  String get aIVoiceover {
    return Intl.message(
      'AI Voiceover',
      name: 'aIVoiceover',
      desc: '',
      args: [],
    );
  }

  /// `Users`
  String get users {
    return Intl.message(
      'Users',
      name: 'users',
      desc: '',
      args: [],
    );
  }

  /// `Users List`
  String get usersList {
    return Intl.message(
      'Users List',
      name: 'usersList',
      desc: '',
      args: [],
    );
  }

  /// `Users Grid`
  String get usersGrid {
    return Intl.message(
      'Users Grid',
      name: 'usersGrid',
      desc: '',
      args: [],
    );
  }

  /// `Tables & Forms`
  String get tablesForms {
    return Intl.message(
      'Tables & Forms',
      name: 'tablesForms',
      desc: '',
      args: [],
    );
  }

  /// `Tables`
  String get tables {
    return Intl.message(
      'Tables',
      name: 'tables',
      desc: '',
      args: [],
    );
  }

  /// `Basic Table`
  String get basicTable {
    return Intl.message(
      'Basic Table',
      name: 'basicTable',
      desc: '',
      args: [],
    );
  }

  /// `Data Table`
  String get dataTable {
    return Intl.message(
      'Data Table',
      name: 'dataTable',
      desc: '',
      args: [],
    );
  }

  /// `Forms`
  String get forms {
    return Intl.message(
      'Forms',
      name: 'forms',
      desc: '',
      args: [],
    );
  }

  /// `Basic Forms`
  String get basicForms {
    return Intl.message(
      'Basic Forms',
      name: 'basicForms',
      desc: '',
      args: [],
    );
  }

  /// `Form Select`
  String get formSelect {
    return Intl.message(
      'Form Select',
      name: 'formSelect',
      desc: '',
      args: [],
    );
  }

  /// `Validation`
  String get validation {
    return Intl.message(
      'Validation',
      name: 'validation',
      desc: '',
      args: [],
    );
  }

  /// `Components`
  String get components {
    return Intl.message(
      'Components',
      name: 'components',
      desc: '',
      args: [],
    );
  }

  /// `Buttons`
  String get buttons {
    return Intl.message(
      'Buttons',
      name: 'buttons',
      desc: '',
      args: [],
    );
  }

  /// `Colors`
  String get colors {
    return Intl.message(
      'Colors',
      name: 'colors',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alert {
    return Intl.message(
      'Alert',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `Typography`
  String get typography {
    return Intl.message(
      'Typography',
      name: 'typography',
      desc: '',
      args: [],
    );
  }

  /// `Cards`
  String get cards {
    return Intl.message(
      'Cards',
      name: 'cards',
      desc: '',
      args: [],
    );
  }

  /// `Avatars`
  String get avatars {
    return Intl.message(
      'Avatars',
      name: 'avatars',
      desc: '',
      args: [],
    );
  }

  /// `Drag & Drop`
  String get dragDrop {
    return Intl.message(
      'Drag & Drop',
      name: 'dragDrop',
      desc: '',
      args: [],
    );
  }

  /// `Pages`
  String get pages {
    return Intl.message(
      'Pages',
      name: 'pages',
      desc: '',
      args: [],
    );
  }

  /// `Authentication`
  String get authentication {
    return Intl.message(
      'Authentication',
      name: 'authentication',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Maps`
  String get maps {
    return Intl.message(
      'Maps',
      name: 'maps',
      desc: '',
      args: [],
    );
  }

  /// `Pricing`
  String get pricing {
    return Intl.message(
      'Pricing',
      name: 'pricing',
      desc: '',
      args: [],
    );
  }

  /// `FAQs`
  String get fAQs {
    return Intl.message(
      'FAQs',
      name: 'fAQs',
      desc: '',
      args: [],
    );
  }

  /// `Tabs & Pills`
  String get tabsPills {
    return Intl.message(
      'Tabs & Pills',
      name: 'tabsPills',
      desc: '',
      args: [],
    );
  }

  /// `Error `
  String get error {
    return Intl.message(
      'Error ',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms & Conditions`
  String get termsConditions {
    return Intl.message(
      'Terms & Conditions',
      name: 'termsConditions',
      desc: '',
      args: [],
    );
  }

  /// `Introduction`
  String get introduction {
    return Intl.message(
      'Introduction',
      name: 'introduction',
      desc: '',
      args: [],
    );
  }

  /// `Information Collection`
  String get informationCollection {
    return Intl.message(
      'Information Collection',
      name: 'informationCollection',
      desc: '',
      args: [],
    );
  }

  /// `Use of Information`
  String get useofInformation {
    return Intl.message(
      'Use of Information',
      name: 'useofInformation',
      desc: '',
      args: [],
    );
  }

  /// `Data Sharing`
  String get dataSharing {
    return Intl.message(
      'Data Sharing',
      name: 'dataSharing',
      desc: '',
      args: [],
    );
  }

  /// `Data Security`
  String get dataSecurity {
    return Intl.message(
      'Data Security',
      name: 'dataSecurity',
      desc: '',
      args: [],
    );
  }

  /// `Your Rights`
  String get yourRights {
    return Intl.message(
      'Your Rights',
      name: 'yourRights',
      desc: '',
      args: [],
    );
  }

  /// `Changes to This Policy`
  String get changestoThisPolicy {
    return Intl.message(
      'Changes to This Policy',
      name: 'changestoThisPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Our Privacy Policy provides a comprehensive overview of how we manage your information when you visit our website or use our services. It explains the types of data we collect, including personal details and usage information, and how we use this data to improve our offerings. The policy also covers the circumstances under which we may disclose your information to third parties and the measures we take to protect your privacy. We are deeply committed to ensuring that your personal data is handled with the highest level of care and security, safeguarding it against unauthorized access or misuse.`
  String get ourPrivacyPolicyProvidesAComprehensive {
    return Intl.message(
      'Our Privacy Policy provides a comprehensive overview of how we manage your information when you visit our website or use our services. It explains the types of data we collect, including personal details and usage information, and how we use this data to improve our offerings. The policy also covers the circumstances under which we may disclose your information to third parties and the measures we take to protect your privacy. We are deeply committed to ensuring that your personal data is handled with the highest level of care and security, safeguarding it against unauthorized access or misuse.',
      name: 'ourPrivacyPolicyProvidesAComprehensive',
      desc: '',
      args: [],
    );
  }

  /// `We gather a range of information to enhance your experience on our website and services. This includes personal details that you voluntarily provide, such as your name, email address, and other contact information. Additionally, we collect usage data like your IP address, browser type, and operating system through cookies, log files, and other tracking technologies. These technologies help us understand how you interact with our site, allowing us to improve our services and deliver a more personalized experience. We ensure that all collected data is handled with strict confidentiality and security measures.`
  String get weGatherARangeOfInformationToEnhanceYourExperience {
    return Intl.message(
      'We gather a range of information to enhance your experience on our website and services. This includes personal details that you voluntarily provide, such as your name, email address, and other contact information. Additionally, we collect usage data like your IP address, browser type, and operating system through cookies, log files, and other tracking technologies. These technologies help us understand how you interact with our site, allowing us to improve our services and deliver a more personalized experience. We ensure that all collected data is handled with strict confidentiality and security measures.',
      name: 'weGatherARangeOfInformationToEnhanceYourExperience',
      desc: '',
      args: [],
    );
  }

  /// `The information we collect helps us enhance our services and tailor your experience to your preferences. We use your data to communicate with you effectively and to personalize your interactions with our platform. Additionally, your data may be utilized for research and analytics purposes, allowing us to better understand user behavior and improve our offerings.`
  String get theInformationWeCollectHelpsUsEnhanceOurServices {
    return Intl.message(
      'The information we collect helps us enhance our services and tailor your experience to your preferences. We use your data to communicate with you effectively and to personalize your interactions with our platform. Additionally, your data may be utilized for research and analytics purposes, allowing us to better understand user behavior and improve our offerings.',
      name: 'theInformationWeCollectHelpsUsEnhanceOurServices',
      desc: '',
      args: [],
    );
  }

  /// `We do not sell or rent your personal information to third parties. However, we may share your data with trusted partners who help us operate and improve our services. These partners are carefully selected and are required to adhere to our strict privacy standards, ensuring your information remains secure and confidential.`
  String get weDoNotSellOrRentYourPersonalInformationToThirdParties {
    return Intl.message(
      'We do not sell or rent your personal information to third parties. However, we may share your data with trusted partners who help us operate and improve our services. These partners are carefully selected and are required to adhere to our strict privacy standards, ensuring your information remains secure and confidential.',
      name: 'weDoNotSellOrRentYourPersonalInformationToThirdParties',
      desc: '',
      args: [],
    );
  }

  /// `We implement appropriate security measures to protect your personal information from unauthorized access, alteration, or disclosure. Despite our efforts, no data transmission over the internet can be guaranteed to be completely secure.`
  String get weImplementAppropriateSecurityMeasures {
    return Intl.message(
      'We implement appropriate security measures to protect your personal information from unauthorized access, alteration, or disclosure. Despite our efforts, no data transmission over the internet can be guaranteed to be completely secure.',
      name: 'weImplementAppropriateSecurityMeasures',
      desc: '',
      args: [],
    );
  }

  /// `You have the right to access, correct, or delete your personal information. You can also opt out of certain data collection practices. For more details on how to exercise these rights, please contact us.`
  String get youHaveTheRightToAccessCorrect {
    return Intl.message(
      'You have the right to access, correct, or delete your personal information. You can also opt out of certain data collection practices. For more details on how to exercise these rights, please contact us.',
      name: 'youHaveTheRightToAccessCorrect',
      desc: '',
      args: [],
    );
  }

  /// `We may update this Privacy Policy from time to time. Any changes will be posted on this page, and we encourage you to review it periodically.`
  String get weMayUpdateThisPrivacyPolicyFromTimeToTime {
    return Intl.message(
      'We may update this Privacy Policy from time to time. Any changes will be posted on this page, and we encourage you to review it periodically.',
      name: 'weMayUpdateThisPrivacyPolicyFromTimeToTime',
      desc: '',
      args: [],
    );
  }

  /// `If you have any questions or concerns about our Privacy Policy, please contact us at [contact information].`
  String get ifYouHaveAnyQuestionsOrConcernsAboutOurPrivacyPolicy {
    return Intl.message(
      'If you have any questions or concerns about our Privacy Policy, please contact us at [contact information].',
      name: 'ifYouHaveAnyQuestionsOrConcernsAboutOurPrivacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Sub menus cannot be null or empty if the item type is submenu`
  String get subMenusCannotBeNullOrEmptyIfTheItemTypeIsSubmenu {
    return Intl.message(
      'Sub menus cannot be null or empty if the item type is submenu',
      name: 'subMenusCannotBeNullOrEmptyIfTheItemTypeIsSubmenu',
      desc: '',
      args: [],
    );
  }

  /// `Complete`
  String get complete {
    return Intl.message(
      'Complete',
      name: 'complete',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// `Agreement to Terms`
  String get agreementToTerms {
    return Intl.message(
      'Agreement to Terms',
      name: 'agreementToTerms',
      desc: '',
      args: [],
    );
  }

  /// `User Responsibilities`
  String get userResponsibilities {
    return Intl.message(
      'User Responsibilities',
      name: 'userResponsibilities',
      desc: '',
      args: [],
    );
  }

  /// `Prohibited Activities`
  String get prohibitedActivities {
    return Intl.message(
      'Prohibited Activities',
      name: 'prohibitedActivities',
      desc: '',
      args: [],
    );
  }

  /// `Service Modifications`
  String get serviceModifications {
    return Intl.message(
      'Service Modifications',
      name: 'serviceModifications',
      desc: '',
      args: [],
    );
  }

  /// `Limitation of Liability`
  String get limitationOfLiability {
    return Intl.message(
      'Limitation of Liability',
      name: 'limitationOfLiability',
      desc: '',
      args: [],
    );
  }

  /// `Governing Law`
  String get governingLaw {
    return Intl.message(
      'Governing Law',
      name: 'governingLaw',
      desc: '',
      args: [],
    );
  }

  /// `Changes to These Terms`
  String get changesToTheseTerms {
    return Intl.message(
      'Changes to These Terms',
      name: 'changesToTheseTerms',
      desc: '',
      args: [],
    );
  }

  /// `Contact Information`
  String get contactInformation {
    return Intl.message(
      'Contact Information',
      name: 'contactInformation',
      desc: '',
      args: [],
    );
  }

  /// `By accessing or using our website and services, you agree to be bound by these Terms and Conditions. This agreement outlines the rules and regulations governing your use of our platform, including any content, features, and services we offer. It is important that you read these terms carefully before using our services. If you do not agree with any part of these terms, you must not use our website or services. Your continued use of the platform signifies your acceptance of these terms and any future changes to them. We may update these terms from time to time, and it is your responsibility to review them periodically.`
  String get byAccessingOrUsingOurWebsiteAndServices {
    return Intl.message(
      'By accessing or using our website and services, you agree to be bound by these Terms and Conditions. This agreement outlines the rules and regulations governing your use of our platform, including any content, features, and services we offer. It is important that you read these terms carefully before using our services. If you do not agree with any part of these terms, you must not use our website or services. Your continued use of the platform signifies your acceptance of these terms and any future changes to them. We may update these terms from time to time, and it is your responsibility to review them periodically.',
      name: 'byAccessingOrUsingOurWebsiteAndServices',
      desc: '',
      args: [],
    );
  }

  /// `As a user of our platform, you agree to use our services responsibly and in accordance with all applicable laws and regulations. You are responsible for ensuring that any information you provide is accurate and up-to-date. Additionally, you must maintain the confidentiality of your account credentials and are solely responsible for any activities that occur under your account. You agree not to engage in any activity that could harm others or interfere with the normal operation of our services. This includes, but is not limited to, distributing harmful content or attempting to gain unauthorized access to our systems.`
  String get asAUserOfOurPlatform {
    return Intl.message(
      'As a user of our platform, you agree to use our services responsibly and in accordance with all applicable laws and regulations. You are responsible for ensuring that any information you provide is accurate and up-to-date. Additionally, you must maintain the confidentiality of your account credentials and are solely responsible for any activities that occur under your account. You agree not to engage in any activity that could harm others or interfere with the normal operation of our services. This includes, but is not limited to, distributing harmful content or attempting to gain unauthorized access to our systems.',
      name: 'asAUserOfOurPlatform',
      desc: '',
      args: [],
    );
  }

  /// `You are prohibited from engaging in activities that violate the rights of others or the integrity of our platform. This includes, but is not limited to, any form of harassment, intellectual property infringement, or dissemination of malicious software. Using our services for illegal activities, such as fraud or theft, is strictly forbidden. We reserve the right to take appropriate action, including suspending or terminating your access, if you are found to be engaging in any prohibited activities. We also retain the right to report any illegal activities to the appropriate authorities.`
  String get youAreProhibitedFromEngagingInActivities {
    return Intl.message(
      'You are prohibited from engaging in activities that violate the rights of others or the integrity of our platform. This includes, but is not limited to, any form of harassment, intellectual property infringement, or dissemination of malicious software. Using our services for illegal activities, such as fraud or theft, is strictly forbidden. We reserve the right to take appropriate action, including suspending or terminating your access, if you are found to be engaging in any prohibited activities. We also retain the right to report any illegal activities to the appropriate authorities.',
      name: 'youAreProhibitedFromEngagingInActivities',
      desc: '',
      args: [],
    );
  }

  /// `We reserve the right to modify, suspend, or discontinue any part of our services at any time without prior notice. This includes making changes to the functionality, features, or availability of our platform. While we strive to keep you informed about significant changes, we cannot guarantee that all updates will be communicated in advance. It is your responsibility to regularly review our terms and service descriptions for any updates. We are not liable for any loss or damage that may result from such modifications or disruptions. Your continued use of our services following any changes signifies your acceptance of those modifications.`
  String get weReserveTheRightToModify {
    return Intl.message(
      'We reserve the right to modify, suspend, or discontinue any part of our services at any time without prior notice. This includes making changes to the functionality, features, or availability of our platform. While we strive to keep you informed about significant changes, we cannot guarantee that all updates will be communicated in advance. It is your responsibility to regularly review our terms and service descriptions for any updates. We are not liable for any loss or damage that may result from such modifications or disruptions. Your continued use of our services following any changes signifies your acceptance of those modifications.',
      name: 'weReserveTheRightToModify',
      desc: '',
      args: [],
    );
  }

  /// `Our platform and services are provided on an "as is" and "as available" basis. We make no warranties, either express or implied, regarding the accuracy, completeness, or reliability of the content or services provided. We do not guarantee that our services will be uninterrupted or error-free. To the fullest extent permitted by law, we are not liable for any direct, indirect, incidental, or consequential damages arising from your use or inability to use our services. This includes, but is not limited to, damages for loss of data, profits, or other intangible losses. You agree that your sole remedy for dissatisfaction with our services is to stop using them.`
  String get ourPlatformAndServicesAreProvided {
    return Intl.message(
      'Our platform and services are provided on an "as is" and "as available" basis. We make no warranties, either express or implied, regarding the accuracy, completeness, or reliability of the content or services provided. We do not guarantee that our services will be uninterrupted or error-free. To the fullest extent permitted by law, we are not liable for any direct, indirect, incidental, or consequential damages arising from your use or inability to use our services. This includes, but is not limited to, damages for loss of data, profits, or other intangible losses. You agree that your sole remedy for dissatisfaction with our services is to stop using them.',
      name: 'ourPlatformAndServicesAreProvided',
      desc: '',
      args: [],
    );
  }

  /// `These Terms and Conditions are governed by and construed in accordance with the laws of the jurisdiction in which our company is incorporated. Any disputes arising from these terms or your use of our services will be subject to the exclusive jurisdiction of the courts located in that jurisdiction. By agreeing to these terms, you consent to the personal jurisdiction and venue of these courts. This provision does not affect your statutory rights as a consumer. If any part of these terms is found to be invalid or unenforceable, the remaining provisions will continue to apply.`
  String get theseTermsAndConditionsAreGoverned {
    return Intl.message(
      'These Terms and Conditions are governed by and construed in accordance with the laws of the jurisdiction in which our company is incorporated. Any disputes arising from these terms or your use of our services will be subject to the exclusive jurisdiction of the courts located in that jurisdiction. By agreeing to these terms, you consent to the personal jurisdiction and venue of these courts. This provision does not affect your statutory rights as a consumer. If any part of these terms is found to be invalid or unenforceable, the remaining provisions will continue to apply.',
      name: 'theseTermsAndConditionsAreGoverned',
      desc: '',
      args: [],
    );
  }

  /// `We may update these Terms and Conditions periodically to reflect changes in our services or legal requirements. When updates are made, we will post the revised terms on this page with a new effective date. It is your responsibility to review these terms regularly to stay informed about any changes. Continued use of our services after the posting of any changes constitutes acceptance of those changes. If you do not agree with the revised terms, you should discontinue use of our services. We encourage you to check this page frequently to ensure you are aware of the latest terms.`
  String get weMayUpdateTheseTermsAndConditionsPeriodically {
    return Intl.message(
      'We may update these Terms and Conditions periodically to reflect changes in our services or legal requirements. When updates are made, we will post the revised terms on this page with a new effective date. It is your responsibility to review these terms regularly to stay informed about any changes. Continued use of our services after the posting of any changes constitutes acceptance of those changes. If you do not agree with the revised terms, you should discontinue use of our services. We encourage you to check this page frequently to ensure you are aware of the latest terms.',
      name: 'weMayUpdateTheseTermsAndConditionsPeriodically',
      desc: '',
      args: [],
    );
  }

  /// `If you have any questions or concerns regarding these Terms and Conditions, please do not hesitate to contact us. You can reach us through the contact information provided on our website, which includes email addresses, phone numbers, and physical addresses. We are committed to addressing your inquiries and resolving any issues you may have in a timely manner. Your feedback is important to us, and we strive to provide prompt and effective support. Please ensure that you provide accurate contact details so that we can respond to your queries appropriately.`
  String get ifYouHaveAnyQuestionsOrConcernsRegardingTheseTermsAndConditions {
    return Intl.message(
      'If you have any questions or concerns regarding these Terms and Conditions, please do not hesitate to contact us. You can reach us through the contact information provided on our website, which includes email addresses, phone numbers, and physical addresses. We are committed to addressing your inquiries and resolving any issues you may have in a timely manner. Your feedback is important to us, and we strive to provide prompt and effective support. Please ensure that you provide accurate contact details so that we can respond to your queries appropriately.',
      name: 'ifYouHaveAnyQuestionsOrConcernsRegardingTheseTermsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Viewed`
  String get viewed {
    return Intl.message(
      'Viewed',
      name: 'viewed',
      desc: '',
      args: [],
    );
  }

  /// `Default Line Chart`
  String get defaultLineChart {
    return Intl.message(
      'Default Line Chart',
      name: 'defaultLineChart',
      desc: '',
      args: [],
    );
  }

  /// `Multiple Line Chart`
  String get multipleLineChart {
    return Intl.message(
      'Multiple Line Chart',
      name: 'multipleLineChart',
      desc: '',
      args: [],
    );
  }

  /// `Area Chart`
  String get areaChart {
    return Intl.message(
      'Area Chart',
      name: 'areaChart',
      desc: '',
      args: [],
    );
  }

  /// `Transparent Chart`
  String get transparentChart {
    return Intl.message(
      'Transparent Chart',
      name: 'transparentChart',
      desc: '',
      args: [],
    );
  }

  /// `Mingguan Chart`
  String get mingguanChart {
    return Intl.message(
      'Mingguan Chart',
      name: 'mingguanChart',
      desc: '',
      args: [],
    );
  }

  /// `Pie Chart`
  String get pieChart {
    return Intl.message(
      'Pie Chart',
      name: 'pieChart',
      desc: '',
      args: [],
    );
  }

  /// `Bitcoin`
  String get bitcoin {
    return Intl.message(
      'Bitcoin',
      name: 'bitcoin',
      desc: '',
      args: [],
    );
  }

  /// `Solana`
  String get solana {
    return Intl.message(
      'Solana',
      name: 'solana',
      desc: '',
      args: [],
    );
  }

  /// `Ethereum`
  String get ethereum {
    return Intl.message(
      'Ethereum',
      name: 'ethereum',
      desc: '',
      args: [],
    );
  }

  /// `BTC`
  String get bTC {
    return Intl.message(
      'BTC',
      name: 'bTC',
      desc: '',
      args: [],
    );
  }

  /// `SOL`
  String get sOL {
    return Intl.message(
      'SOL',
      name: 'sOL',
      desc: '',
      args: [],
    );
  }

  /// `ETH`
  String get eTH {
    return Intl.message(
      'ETH',
      name: 'eTH',
      desc: '',
      args: [],
    );
  }

  /// `Visits By Day`
  String get visitsByDay {
    return Intl.message(
      'Visits By Day',
      name: 'visitsByDay',
      desc: '',
      args: [],
    );
  }

  /// `This Month Leave Request`
  String get thisMonthLeaveRequest {
    return Intl.message(
      'This Month Leave Request',
      name: 'thisMonthLeaveRequest',
      desc: '',
      args: [],
    );
  }

  /// `Since Last Month Leave Request`
  String get sinceLastMonthLeaveRequest {
    return Intl.message(
      'Since Last Month Leave Request',
      name: 'sinceLastMonthLeaveRequest',
      desc: '',
      args: [],
    );
  }

  /// `This Month Salary`
  String get thisMonthSalary {
    return Intl.message(
      'This Month Salary',
      name: 'thisMonthSalary',
      desc: '',
      args: [],
    );
  }

  /// `Since Last Month Salary`
  String get sinceLastMonthSalary {
    return Intl.message(
      'Since Last Month Salary',
      name: 'sinceLastMonthSalary',
      desc: '',
      args: [],
    );
  }

  /// `Total Employees`
  String get totalEmployees {
    return Intl.message(
      'Total Employees',
      name: 'totalEmployees',
      desc: '',
      args: [],
    );
  }

  /// `Today Present`
  String get todayPresent {
    return Intl.message(
      'Today Present',
      name: 'todayPresent',
      desc: '',
      args: [],
    );
  }

  /// `This Month Expenses`
  String get thisMonthExpenses {
    return Intl.message(
      'This Month Expenses',
      name: 'thisMonthExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Since Last Month Expenses`
  String get sinceLastMonthExpenses {
    return Intl.message(
      'Since Last Month Expenses',
      name: 'sinceLastMonthExpenses',
      desc: '',
      args: [],
    );
  }

  /// `Arlene McCoy`
  String get arleneMcCoy {
    return Intl.message(
      'Arlene McCoy',
      name: 'arleneMcCoy',
      desc: '',
      args: [],
    );
  }

  /// `Event planner`
  String get eventPlanner {
    return Intl.message(
      'Event planner',
      name: 'eventPlanner',
      desc: '',
      args: [],
    );
  }

  /// `Ralph Edwards`
  String get ralphEdwards {
    return Intl.message(
      'Ralph Edwards',
      name: 'ralphEdwards',
      desc: '',
      args: [],
    );
  }

  /// `Language Tutor`
  String get languageTutor {
    return Intl.message(
      'Language Tutor',
      name: 'languageTutor',
      desc: '',
      args: [],
    );
  }

  /// `Fitness Trainer`
  String get fitnessTrainer {
    return Intl.message(
      'Fitness Trainer',
      name: 'fitnessTrainer',
      desc: '',
      args: [],
    );
  }

  /// `Facebook`
  String get facebook {
    return Intl.message(
      'Facebook',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  /// `Twitter`
  String get twitter {
    return Intl.message(
      'Twitter',
      name: 'twitter',
      desc: '',
      args: [],
    );
  }

  /// `Instagram`
  String get instagram {
    return Intl.message(
      'Instagram',
      name: 'instagram',
      desc: '',
      args: [],
    );
  }

  /// `Youtube`
  String get youtube {
    return Intl.message(
      'Youtube',
      name: 'youtube',
      desc: '',
      args: [],
    );
  }

  /// `Linkedin`
  String get linkedin {
    return Intl.message(
      'Linkedin',
      name: 'linkedin',
      desc: '',
      args: [],
    );
  }

  /// `Pinterest`
  String get pinterest {
    return Intl.message(
      'Pinterest',
      name: 'pinterest',
      desc: '',
      args: [],
    );
  }

  /// `Order Status`
  String get orderStatus {
    return Intl.message(
      'Order Status',
      name: 'orderStatus',
      desc: '',
      args: [],
    );
  }

  /// `Sales Overview`
  String get salesOverview {
    return Intl.message(
      'Sales Overview',
      name: 'salesOverview',
      desc: '',
      args: [],
    );
  }

  /// `Total Products`
  String get totalProducts {
    return Intl.message(
      'Total Products',
      name: 'totalProducts',
      desc: '',
      args: [],
    );
  }

  /// `Total Stores`
  String get totalStores {
    return Intl.message(
      'Total Stores',
      name: 'totalStores',
      desc: '',
      args: [],
    );
  }

  /// `Total Delivery Boy`
  String get totalDeliveryBoy {
    return Intl.message(
      'Total Delivery Boy',
      name: 'totalDeliveryBoy',
      desc: '',
      args: [],
    );
  }

  /// `Total Revenue`
  String get totalRevenue {
    return Intl.message(
      'Total Revenue',
      name: 'totalRevenue',
      desc: '',
      args: [],
    );
  }

  /// `Total Users`
  String get totalUsers {
    return Intl.message(
      'Total Users',
      name: 'totalUsers',
      desc: '',
      args: [],
    );
  }

  /// `Total Income`
  String get totalIncome {
    return Intl.message(
      'Total Income',
      name: 'totalIncome',
      desc: '',
      args: [],
    );
  }

  /// `Total Subscription`
  String get totalSubscription {
    return Intl.message(
      'Total Subscription',
      name: 'totalSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Total Expense`
  String get totalExpense {
    return Intl.message(
      'Total Expense',
      name: 'totalExpense',
      desc: '',
      args: [],
    );
  }

  /// `Purchase`
  String get purchase {
    return Intl.message(
      'Purchase',
      name: 'purchase',
      desc: '',
      args: [],
    );
  }

  /// `UPI Pay`
  String get uPIPay {
    return Intl.message(
      'UPI Pay',
      name: 'uPIPay',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get sports {
    return Intl.message(
      'Sports',
      name: 'sports',
      desc: '',
      args: [],
    );
  }

  /// `Courses`
  String get courses {
    return Intl.message(
      'Courses',
      name: 'courses',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `Science`
  String get science {
    return Intl.message(
      'Science',
      name: 'science',
      desc: '',
      args: [],
    );
  }

  /// `Quiz Name`
  String get quizName {
    return Intl.message(
      'Quiz Name',
      name: 'quizName',
      desc: '',
      args: [],
    );
  }

  /// `Reward Point`
  String get rewardPoint {
    return Intl.message(
      'Reward Point',
      name: 'rewardPoint',
      desc: '',
      args: [],
    );
  }

  /// `Created At`
  String get createdAt {
    return Intl.message(
      'Created At',
      name: 'createdAt',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw`
  String get withdraw {
    return Intl.message(
      'Withdraw',
      name: 'withdraw',
      desc: '',
      args: [],
    );
  }

  /// `SMS Deliveried`
  String get sMSDeliveried {
    return Intl.message(
      'SMS Deliveried',
      name: 'sMSDeliveried',
      desc: '',
      args: [],
    );
  }

  /// `SMS Failed`
  String get sMSFailed {
    return Intl.message(
      'SMS Failed',
      name: 'sMSFailed',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get balance {
    return Intl.message(
      'Balance',
      name: 'balance',
      desc: '',
      args: [],
    );
  }

  /// `SMS History Statistics`
  String get sMSHistoryStatistics {
    return Intl.message(
      'SMS History Statistics',
      name: 'sMSHistoryStatistics',
      desc: '',
      args: [],
    );
  }

  /// `SMS Report`
  String get sMSReport {
    return Intl.message(
      'SMS Report',
      name: 'sMSReport',
      desc: '',
      args: [],
    );
  }

  /// `Top Users`
  String get topUsers {
    return Intl.message(
      'Top Users',
      name: 'topUsers',
      desc: '',
      args: [],
    );
  }

  /// `Latest Quiz`
  String get latestQuiz {
    return Intl.message(
      'Latest Quiz',
      name: 'latestQuiz',
      desc: '',
      args: [],
    );
  }

  /// `Total quiz category`
  String get totalQuizCategory {
    return Intl.message(
      'Total quiz category',
      name: 'totalQuizCategory',
      desc: '',
      args: [],
    );
  }

  /// `Total Quizzes`
  String get totalQuizzes {
    return Intl.message(
      'Total Quizzes',
      name: 'totalQuizzes',
      desc: '',
      args: [],
    );
  }

  /// `Total Questions`
  String get totalQuestions {
    return Intl.message(
      'Total Questions',
      name: 'totalQuestions',
      desc: '',
      args: [],
    );
  }

  /// `Total Withdraw`
  String get totalWithdraw {
    return Intl.message(
      'Total Withdraw',
      name: 'totalWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Pending Withdraw`
  String get pendingWithdraw {
    return Intl.message(
      'Pending Withdraw',
      name: 'pendingWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Approved Withdraw`
  String get approvedWithdraw {
    return Intl.message(
      'Approved Withdraw',
      name: 'approvedWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Rejected Withdraw`
  String get rejectedWithdraw {
    return Intl.message(
      'Rejected Withdraw',
      name: 'rejectedWithdraw',
      desc: '',
      args: [],
    );
  }

  /// `Total User`
  String get totalUser {
    return Intl.message(
      'Total User',
      name: 'totalUser',
      desc: '',
      args: [],
    );
  }

  /// `Total Currency`
  String get totalCurrency {
    return Intl.message(
      'Total Currency',
      name: 'totalCurrency',
      desc: '',
      args: [],
    );
  }

  /// `Total Rewards`
  String get totalRewards {
    return Intl.message(
      'Total Rewards',
      name: 'totalRewards',
      desc: '',
      args: [],
    );
  }

  /// `Form Validation`
  String get formValidation {
    return Intl.message(
      'Form Validation',
      name: 'formValidation',
      desc: '',
      args: [],
    );
  }

  /// `Alerts`
  String get alerts {
    return Intl.message(
      'Alerts',
      name: 'alerts',
      desc: '',
      args: [],
    );
  }

  /// `Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the `
  String get loremIpsumIsSimplyDummyTextOfThePrinting {
    return Intl.message(
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the ',
      name: 'loremIpsumIsSimplyDummyTextOfThePrinting',
      desc: '',
      args: [],
    );
  }

  /// `black `
  String get black {
    return Intl.message(
      'black ',
      name: 'black',
      desc: '',
      args: [],
    );
  }

  /// `White `
  String get white {
    return Intl.message(
      'White ',
      name: 'white',
      desc: '',
      args: [],
    );
  }

  /// `Bases `
  String get bases {
    return Intl.message(
      'Bases ',
      name: 'bases',
      desc: '',
      args: [],
    );
  }

  /// `Family`
  String get family {
    return Intl.message(
      'Family',
      name: 'family',
      desc: '',
      args: [],
    );
  }

  /// `Promotions`
  String get promotions {
    return Intl.message(
      'Promotions',
      name: 'promotions',
      desc: '',
      args: [],
    );
  }

  /// `Social`
  String get social {
    return Intl.message(
      'Social',
      name: 'social',
      desc: '',
      args: [],
    );
  }

  /// `This is Image title`
  String get thisIsImageTitle {
    return Intl.message(
      'This is Image title',
      name: 'thisIsImageTitle',
      desc: '',
      args: [],
    );
  }

  /// `UI Design`
  String get uIDesign {
    return Intl.message(
      'UI Design',
      name: 'uIDesign',
      desc: '',
      args: [],
    );
  }

  /// `In Review`
  String get inReview {
    return Intl.message(
      'In Review',
      name: 'inReview',
      desc: '',
      args: [],
    );
  }

  /// `Business Dashboard`
  String get businessDashboard {
    return Intl.message(
      'Business Dashboard',
      name: 'businessDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore`
  String get loremIpsumDolorSitAmet {
    return Intl.message(
      'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore',
      name: 'loremIpsumDolorSitAmet',
      desc: '',
      args: [],
    );
  }

  /// `Molestiae quia ut cumque sit nihil ipsam repellendus.`
  String get molestiaeQuiaUtCumqueSitNihilIpsamRepellendus {
    return Intl.message(
      'Molestiae quia ut cumque sit nihil ipsam repellendus.',
      name: 'molestiaeQuiaUtCumqueSitNihilIpsamRepellendus',
      desc: '',
      args: [],
    );
  }

  /// `Standard`
  String get standard {
    return Intl.message(
      'Standard',
      name: 'standard',
      desc: '',
      args: [],
    );
  }

  /// `Pro Business`
  String get proBusiness {
    return Intl.message(
      'Pro Business',
      name: 'proBusiness',
      desc: '',
      args: [],
    );
  }

  /// `Enterprise`
  String get enterprise {
    return Intl.message(
      'Enterprise',
      name: 'enterprise',
      desc: '',
      args: [],
    );
  }

  /// `For the professionals`
  String get forTheProfessionals {
    return Intl.message(
      'For the professionals',
      name: 'forTheProfessionals',
      desc: '',
      args: [],
    );
  }

  /// `user`
  String get user {
    return Intl.message(
      'user',
      name: 'user',
      desc: '',
      args: [],
    );
  }

  /// `20 Asset Delivery`
  String get assetDelivery {
    return Intl.message(
      '20 Asset Delivery',
      name: 'assetDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited Bandwidth`
  String get unlimitedBandwidth {
    return Intl.message(
      'Unlimited Bandwidth',
      name: 'unlimitedBandwidth',
      desc: '',
      args: [],
    );
  }

  /// `Support System`
  String get supportSystem {
    return Intl.message(
      'Support System',
      name: 'supportSystem',
      desc: '',
      args: [],
    );
  }

  /// `120+ Message all Operator`
  String get messageAllOperator {
    return Intl.message(
      '120+ Message all Operator',
      name: 'messageAllOperator',
      desc: '',
      args: [],
    );
  }

  /// `Freebie`
  String get freebie {
    return Intl.message(
      'Freebie',
      name: 'freebie',
      desc: '',
      args: [],
    );
  }

  /// `Ideal for individuals who need quick access to basic features`
  String get idealForIndividualsWhoNeedQuickAccessToBasicFeatures {
    return Intl.message(
      'Ideal for individuals who need quick access to basic features',
      name: 'idealForIndividualsWhoNeedQuickAccessToBasicFeatures',
      desc: '',
      args: [],
    );
  }

  /// `20,000+ of PNG & SVG graphics`
  String get pNGSVGGraphics {
    return Intl.message(
      '20,000+ of PNG & SVG graphics',
      name: 'pNGSVGGraphics',
      desc: '',
      args: [],
    );
  }

  /// `Access to 100 million stock images`
  String get accessTo100MillionStockImages {
    return Intl.message(
      'Access to 100 million stock images',
      name: 'accessTo100MillionStockImages',
      desc: '',
      args: [],
    );
  }

  /// `Upload custom icons and fonts`
  String get uploadCustomIconsAndFonts {
    return Intl.message(
      'Upload custom icons and fonts',
      name: 'uploadCustomIconsAndFonts',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited Sharing`
  String get unlimitedSharing {
    return Intl.message(
      'Unlimited Sharing',
      name: 'unlimitedSharing',
      desc: '',
      args: [],
    );
  }

  /// `Upload graphics & video in up to 4k`
  String get uploadGraphicsVideoInUpTo4k {
    return Intl.message(
      'Upload graphics & video in up to 4k',
      name: 'uploadGraphicsVideoInUpTo4k',
      desc: '',
      args: [],
    );
  }

  /// `Unlimited Projects`
  String get unlimitedProjects {
    return Intl.message(
      'Unlimited Projects',
      name: 'unlimitedProjects',
      desc: '',
      args: [],
    );
  }

  /// `Instant Access to our design system`
  String get instantAccessToOurDesignSystem {
    return Intl.message(
      'Instant Access to our design system',
      name: 'instantAccessToOurDesignSystem',
      desc: '',
      args: [],
    );
  }

  /// `Create teams to collaborate on designs`
  String get createTeamsToCollaborateOnDesigns {
    return Intl.message(
      'Create teams to collaborate on designs',
      name: 'createTeamsToCollaborateOnDesigns',
      desc: '',
      args: [],
    );
  }

  /// `Ideal for individuals who who need advanced features and tools for client work.`
  String
      get idealForIndividualsWhoWhoNeedAdvancedFeaturesAndToolsForClientWork {
    return Intl.message(
      'Ideal for individuals who who need advanced features and tools for client work.',
      name:
          'idealForIndividualsWhoWhoNeedAdvancedFeaturesAndToolsForClientWork',
      desc: '',
      args: [],
    );
  }

  /// `Ideal for businesses who need personalized services and security for large teams.`
  String
      get idealForBusinessesWhoNeedPersonalizedServicesAndSecurityForLargeTeams {
    return Intl.message(
      'Ideal for businesses who need personalized services and security for large teams.',
      name:
          'idealForBusinessesWhoNeedPersonalizedServicesAndSecurityForLargeTeams',
      desc: '',
      args: [],
    );
  }

  /// `Total Earning`
  String get totalEarning {
    return Intl.message(
      'Total Earning',
      name: 'totalEarning',
      desc: '',
      args: [],
    );
  }

  /// `Word Generated`
  String get wordGenerated {
    return Intl.message(
      'Word Generated',
      name: 'wordGenerated',
      desc: '',
      args: [],
    );
  }

  /// `First`
  String get first {
    return Intl.message(
      'First',
      name: 'first',
      desc: '',
      args: [],
    );
  }

  /// `Third`
  String get third {
    return Intl.message(
      'Third',
      name: 'third',
      desc: '',
      args: [],
    );
  }

  /// `Fourth`
  String get fourth {
    return Intl.message(
      'Fourth',
      name: 'fourth',
      desc: '',
      args: [],
    );
  }

  /// `Start Chat`
  String get startChat {
    return Intl.message(
      'Start Chat',
      name: 'startChat',
      desc: '',
      args: [],
    );
  }

  /// `Orders`
  String get orders {
    return Intl.message(
      'Orders',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Products`
  String get products {
    return Intl.message(
      'Products',
      name: 'products',
      desc: '',
      args: [],
    );
  }

  /// `followers`
  String get followers {
    return Intl.message(
      'followers',
      name: 'followers',
      desc: '',
      args: [],
    );
  }

  /// `following`
  String get following {
    return Intl.message(
      'following',
      name: 'following',
      desc: '',
      args: [],
    );
  }

  /// `Choose Plan`
  String get choosePlan {
    return Intl.message(
      'Choose Plan',
      name: 'choosePlan',
      desc: '',
      args: [],
    );
  }

  /// `Get Started Now`
  String get getStartedNow {
    return Intl.message(
      'Get Started Now',
      name: 'getStartedNow',
      desc: '',
      args: [],
    );
  }

  /// `Daily Uses`
  String get dailyUses {
    return Intl.message(
      'Daily Uses',
      name: 'dailyUses',
      desc: '',
      args: [],
    );
  }

  /// `Today Income`
  String get todayIncome {
    return Intl.message(
      'Today Income',
      name: 'todayIncome',
      desc: '',
      args: [],
    );
  }

  /// `Monthly`
  String get monthly {
    return Intl.message(
      'Monthly',
      name: 'monthly',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get yearly {
    return Intl.message(
      'Yearly',
      name: 'yearly',
      desc: '',
      args: [],
    );
  }

  /// `Articles`
  String get articles {
    return Intl.message(
      'Articles',
      name: 'articles',
      desc: '',
      args: [],
    );
  }

  /// `Codes`
  String get codes {
    return Intl.message(
      'Codes',
      name: 'codes',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get images {
    return Intl.message(
      'Images',
      name: 'images',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
  }

  /// `Voiceover`
  String get voiceover {
    return Intl.message(
      'Voiceover',
      name: 'voiceover',
      desc: '',
      args: [],
    );
  }

  /// `Read More`
  String get readMore {
    return Intl.message(
      'Read More',
      name: 'readMore',
      desc: '',
      args: [],
    );
  }

  /// `Get Started`
  String get getStarted {
    return Intl.message(
      'Get Started',
      name: 'getStarted',
      desc: '',
      args: [],
    );
  }

  /// `Hello, Shaidul Islam`
  String get helloShaidulIslam {
    return Intl.message(
      'Hello, Shaidul Islam',
      name: 'helloShaidulIslam',
      desc: '',
      args: [],
    );
  }

  /// `Your Account is currently `
  String get yourAccountIsCurrently {
    return Intl.message(
      'Your Account is currently ',
      name: 'yourAccountIsCurrently',
      desc: '',
      args: [],
    );
  }

  /// `Free Plan`
  String get freePlan {
    return Intl.message(
      'Free Plan',
      name: 'freePlan',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade Plan`
  String get upgradePlan {
    return Intl.message(
      'Upgrade Plan',
      name: 'upgradePlan',
      desc: '',
      args: [],
    );
  }

  /// `Buy Credits`
  String get buyCredits {
    return Intl.message(
      'Buy Credits',
      name: 'buyCredits',
      desc: '',
      args: [],
    );
  }

  /// `Top Customers`
  String get topCustomers {
    return Intl.message(
      'Top Customers',
      name: 'topCustomers',
      desc: '',
      args: [],
    );
  }

  /// `Top Selling Items`
  String get topSellingItems {
    return Intl.message(
      'Top Selling Items',
      name: 'topSellingItems',
      desc: '',
      args: [],
    );
  }

  /// `Earning Reports`
  String get earningReports {
    return Intl.message(
      'Earning Reports',
      name: 'earningReports',
      desc: '',
      args: [],
    );
  }

  /// `Top Brands`
  String get topBrands {
    return Intl.message(
      'Top Brands',
      name: 'topBrands',
      desc: '',
      args: [],
    );
  }

  /// `User Statistics`
  String get userStatistics {
    return Intl.message(
      'User Statistics',
      name: 'userStatistics',
      desc: '',
      args: [],
    );
  }

  /// `Top Vendors`
  String get topVendors {
    return Intl.message(
      'Top Vendors',
      name: 'topVendors',
      desc: '',
      args: [],
    );
  }

  /// `Top Delivery Man`
  String get topDeliveryMan {
    return Intl.message(
      'Top Delivery Man',
      name: 'topDeliveryMan',
      desc: '',
      args: [],
    );
  }

  /// `Processing`
  String get processing {
    return Intl.message(
      'Processing',
      name: 'processing',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message(
      'Cancelled',
      name: 'cancelled',
      desc: '',
      args: [],
    );
  }

  /// `Shipped`
  String get shipped {
    return Intl.message(
      'Shipped',
      name: 'shipped',
      desc: '',
      args: [],
    );
  }

  /// `Out of Delivery`
  String get outOfDelivery {
    return Intl.message(
      'Out of Delivery',
      name: 'outOfDelivery',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get delivered {
    return Intl.message(
      'Delivered',
      name: 'delivered',
      desc: '',
      args: [],
    );
  }

  /// `Samsung`
  String get samsung {
    return Intl.message(
      'Samsung',
      name: 'samsung',
      desc: '',
      args: [],
    );
  }

  /// `Fashion`
  String get fashion {
    return Intl.message(
      'Fashion',
      name: 'fashion',
      desc: '',
      args: [],
    );
  }

  /// `General Motors`
  String get generalMotors {
    return Intl.message(
      'General Motors',
      name: 'generalMotors',
      desc: '',
      args: [],
    );
  }

  /// `Foods`
  String get foods {
    return Intl.message(
      'Foods',
      name: 'foods',
      desc: '',
      args: [],
    );
  }

  /// `Revenue`
  String get revenue {
    return Intl.message(
      'Revenue',
      name: 'revenue',
      desc: '',
      args: [],
    );
  }

  /// `Sub Title`
  String get subTitle {
    return Intl.message(
      'Sub Title',
      name: 'subTitle',
      desc: '',
      args: [],
    );
  }

  /// `Body Text`
  String get bodyText {
    return Intl.message(
      'Body Text',
      name: 'bodyText',
      desc: '',
      args: [],
    );
  }

  /// `Small Text`
  String get smallText {
    return Intl.message(
      'Small Text',
      name: 'smallText',
      desc: '',
      args: [],
    );
  }

  /// `This is title Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry`
  String get thisIsTitleLoremIpsumIsSimplyDummy {
    return Intl.message(
      'This is title Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry',
      name: 'thisIsTitleLoremIpsumIsSimplyDummy',
      desc: '',
      args: [],
    );
  }

  /// `Customer`
  String get customer {
    return Intl.message(
      'Customer',
      name: 'customer',
      desc: '',
      args: [],
    );
  }

  /// `Store`
  String get store {
    return Intl.message(
      'Store',
      name: 'store',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Man`
  String get deliveryMan {
    return Intl.message(
      'Delivery Man',
      name: 'deliveryMan',
      desc: '',
      args: [],
    );
  }

  /// `Plan`
  String get plan {
    return Intl.message(
      'Plan',
      name: 'plan',
      desc: '',
      args: [],
    );
  }

  /// `Free`
  String get free {
    return Intl.message(
      'Free',
      name: 'free',
      desc: '',
      args: [],
    );
  }

  /// `Review`
  String get review {
    return Intl.message(
      'Review',
      name: 'review',
      desc: '',
      args: [],
    );
  }

  /// `Order Completed`
  String get orderCompleted {
    return Intl.message(
      'Order Completed',
      name: 'orderCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Latest Registered`
  String get latestRegistered {
    return Intl.message(
      'Latest Registered',
      name: 'latestRegistered',
      desc: '',
      args: [],
    );
  }

  /// `2024`
  String get year {
    return Intl.message(
      '2024',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Lorem Ipsumis simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktoppublishing software like Aldus PageMaker including versions of Lorem Ipsum.\nContrary to popular belief, Lorem Ipsum is not simply randomtext. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor atHampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites.\nThestandard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Ciceroare also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.`
  String get loremIpsumIsSimplyDummyTextOfThePrintingAndTypesettingIndustry2 {
    return Intl.message(
      'Lorem Ipsumis simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktoppublishing software like Aldus PageMaker including versions of Lorem Ipsum.\\nContrary to popular belief, Lorem Ipsum is not simply randomtext. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor atHampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites.\\nThestandard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Ciceroare also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.',
      name: 'loremIpsumIsSimplyDummyTextOfThePrintingAndTypesettingIndustry2',
      desc: '',
      args: [],
    );
  }

  /// `Powerful`
  String get powerful {
    return Intl.message(
      'Powerful',
      name: 'powerful',
      desc: '',
      args: [],
    );
  }

  /// ` Features `
  String get features {
    return Intl.message(
      ' Features ',
      name: 'features',
      desc: '',
      args: [],
    );
  }

  /// `\n& Pricing plan`
  String get pricingPlan {
    return Intl.message(
      '\n& Pricing plan',
      name: 'pricingPlan',
      desc: '',
      args: [],
    );
  }

  /// `Customers Growth`
  String get customersGrowth {
    return Intl.message(
      'Customers Growth',
      name: 'customersGrowth',
      desc: '',
      args: [],
    );
  }

  /// `Total Customers`
  String get totalCustomers {
    return Intl.message(
      'Total Customers',
      name: 'totalCustomers',
      desc: '',
      args: [],
    );
  }

  /// `18 This Month Customers`
  String get thisMonthCustomers {
    return Intl.message(
      '18 This Month Customers',
      name: 'thisMonthCustomers',
      desc: '',
      args: [],
    );
  }

  /// `This Month SMS`
  String get thisMonthSMS {
    return Intl.message(
      'This Month SMS',
      name: 'thisMonthSMS',
      desc: '',
      args: [],
    );
  }

  /// `12 Today Send SMS`
  String get todaySendSMS {
    return Intl.message(
      '12 Today Send SMS',
      name: 'todaySendSMS',
      desc: '',
      args: [],
    );
  }

  /// `Total Plan`
  String get totalPlan {
    return Intl.message(
      'Total Plan',
      name: 'totalPlan',
      desc: '',
      args: [],
    );
  }

  /// `Basic, Standard, Enterprise`
  String get basicStandardEnterprise {
    return Intl.message(
      'Basic, Standard, Enterprise',
      name: 'basicStandardEnterprise',
      desc: '',
      args: [],
    );
  }

  /// `10,000 This Month Income`
  String get thisMonthIncome {
    return Intl.message(
      '10,000 This Month Income',
      name: 'thisMonthIncome',
      desc: '',
      args: [],
    );
  }

  /// `Jan`
  String get jan {
    return Intl.message(
      'Jan',
      name: 'jan',
      desc: '',
      args: [],
    );
  }

  /// `Feb`
  String get feb {
    return Intl.message(
      'Feb',
      name: 'feb',
      desc: '',
      args: [],
    );
  }

  /// `Mar`
  String get mar {
    return Intl.message(
      'Mar',
      name: 'mar',
      desc: '',
      args: [],
    );
  }

  /// `Apr`
  String get apr {
    return Intl.message(
      'Apr',
      name: 'apr',
      desc: '',
      args: [],
    );
  }

  /// `May`
  String get may {
    return Intl.message(
      'May',
      name: 'may',
      desc: '',
      args: [],
    );
  }

  /// `Jun`
  String get jun {
    return Intl.message(
      'Jun',
      name: 'jun',
      desc: '',
      args: [],
    );
  }

  /// `Jul`
  String get jul {
    return Intl.message(
      'Jul',
      name: 'jul',
      desc: '',
      args: [],
    );
  }

  /// `Aug`
  String get aug {
    return Intl.message(
      'Aug',
      name: 'aug',
      desc: '',
      args: [],
    );
  }

  /// `Sept`
  String get sept {
    return Intl.message(
      'Sept',
      name: 'sept',
      desc: '',
      args: [],
    );
  }

  /// `Oct`
  String get oct {
    return Intl.message(
      'Oct',
      name: 'oct',
      desc: '',
      args: [],
    );
  }

  /// `Nov`
  String get nov {
    return Intl.message(
      'Nov',
      name: 'nov',
      desc: '',
      args: [],
    );
  }

  /// `Dec`
  String get dec {
    return Intl.message(
      'Dec',
      name: 'dec',
      desc: '',
      args: [],
    );
  }

  /// `Outgoing`
  String get outgoing {
    return Intl.message(
      'Outgoing',
      name: 'outgoing',
      desc: '',
      args: [],
    );
  }

  /// `Incoming`
  String get incoming {
    return Intl.message(
      'Incoming',
      name: 'incoming',
      desc: '',
      args: [],
    );
  }

  /// `Join Date`
  String get joinDate {
    return Intl.message(
      'Join Date',
      name: 'joinDate',
      desc: '',
      args: [],
    );
  }

  /// `Order Done`
  String get orderDone {
    return Intl.message(
      'Order Done',
      name: 'orderDone',
      desc: '',
      args: [],
    );
  }

  /// `Recent Registered Client`
  String get recentRegisteredClient {
    return Intl.message(
      'Recent Registered Client',
      name: 'recentRegisteredClient',
      desc: '',
      args: [],
    );
  }

  /// `Income Report`
  String get incomeReport {
    return Intl.message(
      'Income Report',
      name: 'incomeReport',
      desc: '',
      args: [],
    );
  }

  /// `Recent Registered Influencer`
  String get recentRegisteredInfluencer {
    return Intl.message(
      'Recent Registered Influencer',
      name: 'recentRegisteredInfluencer',
      desc: '',
      args: [],
    );
  }

  /// `Withdraw Report`
  String get withdrawReport {
    return Intl.message(
      'Withdraw Report',
      name: 'withdrawReport',
      desc: '',
      args: [],
    );
  }

  /// `Total Clients`
  String get totalClients {
    return Intl.message(
      'Total Clients',
      name: 'totalClients',
      desc: '',
      args: [],
    );
  }

  /// `Active Clients`
  String get activeClients {
    return Intl.message(
      'Active Clients',
      name: 'activeClients',
      desc: '',
      args: [],
    );
  }

  /// `Total Influencer`
  String get totalInfluencer {
    return Intl.message(
      'Total Influencer',
      name: 'totalInfluencer',
      desc: '',
      args: [],
    );
  }

  /// `Active Influencer`
  String get activeInfluencer {
    return Intl.message(
      'Active Influencer',
      name: 'activeInfluencer',
      desc: '',
      args: [],
    );
  }

  /// `Total Services`
  String get totalServices {
    return Intl.message(
      'Total Services',
      name: 'totalServices',
      desc: '',
      args: [],
    );
  }

  /// `Total Staff`
  String get totalStaff {
    return Intl.message(
      'Total Staff',
      name: 'totalStaff',
      desc: '',
      args: [],
    );
  }

  /// `Present`
  String get present {
    return Intl.message(
      'Present',
      name: 'present',
      desc: '',
      args: [],
    );
  }

  /// `Absent`
  String get absent {
    return Intl.message(
      'Absent',
      name: 'absent',
      desc: '',
      args: [],
    );
  }

  /// `Late User`
  String get lateUser {
    return Intl.message(
      'Late User',
      name: 'lateUser',
      desc: '',
      args: [],
    );
  }

  /// `Employee Id`
  String get employeeId {
    return Intl.message(
      'Employee Id',
      name: 'employeeId',
      desc: '',
      args: [],
    );
  }

  /// `Employee Name`
  String get employeeName {
    return Intl.message(
      'Employee Name',
      name: 'employeeName',
      desc: '',
      args: [],
    );
  }

  /// `From`
  String get from {
    return Intl.message(
      'From',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `Leave Duration`
  String get leaveDuration {
    return Intl.message(
      'Leave Duration',
      name: 'leaveDuration',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected {
    return Intl.message(
      'Rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `Leslie Alexander`
  String get leslieAlexander {
    return Intl.message(
      'Leslie Alexander',
      name: 'leslieAlexander',
      desc: '',
      args: [],
    );
  }

  /// `Courtney Henry`
  String get courtneyHenry {
    return Intl.message(
      'Courtney Henry',
      name: 'courtneyHenry',
      desc: '',
      args: [],
    );
  }

  /// `Kristin Watson`
  String get kristinWatson {
    return Intl.message(
      'Kristin Watson',
      name: 'kristinWatson',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message(
      'Total',
      name: 'total',
      desc: '',
      args: [],
    );
  }

  /// `Salary Report`
  String get salaryReport {
    return Intl.message(
      'Salary Report',
      name: 'salaryReport',
      desc: '',
      args: [],
    );
  }

  /// `Leave Request`
  String get leaveRequest {
    return Intl.message(
      'Leave Request',
      name: 'leaveRequest',
      desc: '',
      args: [],
    );
  }

  /// `Upcoming Birthday`
  String get upcomingBirthday {
    return Intl.message(
      'Upcoming Birthday',
      name: 'upcomingBirthday',
      desc: '',
      args: [],
    );
  }

  /// `Birthday Date`
  String get birthdayDate {
    return Intl.message(
      'Birthday Date',
      name: 'birthdayDate',
      desc: '',
      args: [],
    );
  }

  /// `Exit Employee`
  String get exitEmployee {
    return Intl.message(
      'Exit Employee',
      name: 'exitEmployee',
      desc: '',
      args: [],
    );
  }

  /// `Employee Attendance`
  String get employeeAttendance {
    return Intl.message(
      'Employee Attendance',
      name: 'employeeAttendance',
      desc: '',
      args: [],
    );
  }

  /// `Free Users`
  String get freeUsers {
    return Intl.message(
      'Free Users',
      name: 'freeUsers',
      desc: '',
      args: [],
    );
  }

  /// `Subscribed`
  String get subscribed {
    return Intl.message(
      'Subscribed',
      name: 'subscribed',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe`
  String get subscribe {
    return Intl.message(
      'Subscribe',
      name: 'subscribe',
      desc: '',
      args: [],
    );
  }

  /// `User Statistic`
  String get userStatistic {
    return Intl.message(
      'User Statistic',
      name: 'userStatistic',
      desc: '',
      args: [],
    );
  }

  /// `Category Wise News`
  String get categoryWiseNews {
    return Intl.message(
      'Category Wise News',
      name: 'categoryWiseNews',
      desc: '',
      args: [],
    );
  }

  /// `Most Viewed News`
  String get mostViewedNews {
    return Intl.message(
      'Most Viewed News',
      name: 'mostViewedNews',
      desc: '',
      args: [],
    );
  }

  /// `Latest Comments`
  String get latestComments {
    return Intl.message(
      'Latest Comments',
      name: 'latestComments',
      desc: '',
      args: [],
    );
  }

  /// `News Readers`
  String get newsReaders {
    return Intl.message(
      'News Readers',
      name: 'newsReaders',
      desc: '',
      args: [],
    );
  }

  /// `Category`
  String get category {
    return Intl.message(
      'Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `Featured Sectioion`
  String get featuredSection {
    return Intl.message(
      'Featured Sectioion',
      name: 'featuredSection',
      desc: '',
      args: [],
    );
  }

  /// `Ad Spaces`
  String get adSpaces {
    return Intl.message(
      'Ad Spaces',
      name: 'adSpaces',
      desc: '',
      args: [],
    );
  }

  /// `Breaking News`
  String get breakingNews {
    return Intl.message(
      'Breaking News',
      name: 'breakingNews',
      desc: '',
      args: [],
    );
  }

  /// `Published News`
  String get publishedNews {
    return Intl.message(
      'Published News',
      name: 'publishedNews',
      desc: '',
      args: [],
    );
  }

  /// `Draft News`
  String get draftNews {
    return Intl.message(
      'Draft News',
      name: 'draftNews',
      desc: '',
      args: [],
    );
  }

  /// `Total Blogs`
  String get totalBlogs {
    return Intl.message(
      'Total Blogs',
      name: 'totalBlogs',
      desc: '',
      args: [],
    );
  }

  /// `US inflation decelerating in boost to economy`
  String get uSInflationDeceleratingInBoostToEconomy {
    return Intl.message(
      'US inflation decelerating in boost to economy',
      name: 'uSInflationDeceleratingInBoostToEconomy',
      desc: '',
      args: [],
    );
  }

  /// `Politics`
  String get politics {
    return Intl.message(
      'Politics',
      name: 'politics',
      desc: '',
      args: [],
    );
  }

  /// `Family's`
  String get familyS {
    return Intl.message(
      'Family\'s',
      name: 'familyS',
      desc: '',
      args: [],
    );
  }

  /// `Health`
  String get health {
    return Intl.message(
      'Health',
      name: 'health',
      desc: '',
      args: [],
    );
  }

  /// `Travels`
  String get travels {
    return Intl.message(
      'Travels',
      name: 'travels',
      desc: '',
      args: [],
    );
  }

  /// `Religion`
  String get religion {
    return Intl.message(
      'Religion',
      name: 'religion',
      desc: '',
      args: [],
    );
  }

  /// `Mins ago`
  String get minsAgo {
    return Intl.message(
      'Mins ago',
      name: 'minsAgo',
      desc: '',
      args: [],
    );
  }

  /// `Great News`
  String get greatNews {
    return Intl.message(
      'Great News',
      name: 'greatNews',
      desc: '',
      args: [],
    );
  }

  /// `eCommerce`
  String get eCommerce {
    return Intl.message(
      'eCommerce',
      name: 'eCommerce',
      desc: '',
      args: [],
    );
  }

  /// `Order Summary`
  String get orderSummary {
    return Intl.message(
      'Order Summary',
      name: 'orderSummary',
      desc: '',
      args: [],
    );
  }

  /// `Coupon Code`
  String get couponCode {
    return Intl.message(
      'Coupon Code',
      name: 'couponCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter coupon code`
  String get enterCouponCode {
    return Intl.message(
      'Enter coupon code',
      name: 'enterCouponCode',
      desc: '',
      args: [],
    );
  }

  /// `Proceed to Checkout`
  String get proceedToCheckout {
    return Intl.message(
      'Proceed to Checkout',
      name: 'proceedToCheckout',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message(
      'Subtotal',
      name: 'subtotal',
      desc: '',
      args: [],
    );
  }

  /// `Discount`
  String get discount {
    return Intl.message(
      'Discount',
      name: 'discount',
      desc: '',
      args: [],
    );
  }

  /// `Shipping Charge`
  String get shippingCharge {
    return Intl.message(
      'Shipping Charge',
      name: 'shippingCharge',
      desc: '',
      args: [],
    );
  }

  /// `Tax`
  String get tax {
    return Intl.message(
      'Tax',
      name: 'tax',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get price {
    return Intl.message(
      'Price',
      name: 'price',
      desc: '',
      args: [],
    );
  }

  /// `Quantity`
  String get quantity {
    return Intl.message(
      'Quantity',
      name: 'quantity',
      desc: '',
      args: [],
    );
  }

  /// `Enter first name`
  String get enterFirstName {
    return Intl.message(
      'Enter first name',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Enter last name`
  String get enterLastName {
    return Intl.message(
      'Enter last name',
      name: 'enterLastName',
      desc: '',
      args: [],
    );
  }

  /// `Company name (optional)`
  String get companyName {
    return Intl.message(
      'Company name (optional)',
      name: 'companyName',
      desc: '',
      args: [],
    );
  }

  /// `Enter Company name`
  String get enterCompanyName {
    return Intl.message(
      'Enter Company name',
      name: 'enterCompanyName',
      desc: '',
      args: [],
    );
  }

  /// `Country / Region`
  String get countryRegion {
    return Intl.message(
      'Country / Region',
      name: 'countryRegion',
      desc: '',
      args: [],
    );
  }

  /// `Street Address`
  String get streetAddress {
    return Intl.message(
      'Street Address',
      name: 'streetAddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter street address`
  String get enterStreetAddress {
    return Intl.message(
      'Enter street address',
      name: 'enterStreetAddress',
      desc: '',
      args: [],
    );
  }

  /// `Town / City`
  String get townCity {
    return Intl.message(
      'Town / City',
      name: 'townCity',
      desc: '',
      args: [],
    );
  }

  /// `Enter Town / City`
  String get enterTownCity {
    return Intl.message(
      'Enter Town / City',
      name: 'enterTownCity',
      desc: '',
      args: [],
    );
  }

  /// `Enter State`
  String get enterState {
    return Intl.message(
      'Enter State',
      name: 'enterState',
      desc: '',
      args: [],
    );
  }

  /// `ZIP Code`
  String get zIPCode {
    return Intl.message(
      'ZIP Code',
      name: 'zIPCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter ZIP Code`
  String get enterZIPCode {
    return Intl.message(
      'Enter ZIP Code',
      name: 'enterZIPCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter Phone`
  String get enterPhone {
    return Intl.message(
      'Enter Phone',
      name: 'enterPhone',
      desc: '',
      args: [],
    );
  }

  /// `Email Address`
  String get emailAddress {
    return Intl.message(
      'Email Address',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Additional information`
  String get additionalInformation {
    return Intl.message(
      'Additional information',
      name: 'additionalInformation',
      desc: '',
      args: [],
    );
  }

  /// `Order notes (optional)`
  String get orderNotes {
    return Intl.message(
      'Order notes (optional)',
      name: 'orderNotes',
      desc: '',
      args: [],
    );
  }

  /// `notes about your order`
  String get notesAboutYourOrder {
    return Intl.message(
      'notes about your order',
      name: 'notesAboutYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `Your Orders`
  String get yourOrders {
    return Intl.message(
      'Your Orders',
      name: 'yourOrders',
      desc: '',
      args: [],
    );
  }

  /// `Product`
  String get product {
    return Intl.message(
      'Product',
      name: 'product',
      desc: '',
      args: [],
    );
  }

  /// `Place Order`
  String get placeOrder {
    return Intl.message(
      'Place Order',
      name: 'placeOrder',
      desc: '',
      args: [],
    );
  }

  /// `Click here to enter your code`
  String get clickHereToEnterYourCode {
    return Intl.message(
      'Click here to enter your code',
      name: 'clickHereToEnterYourCode',
      desc: '',
      args: [],
    );
  }

  /// `Have a coupon`
  String get haveACoupon {
    return Intl.message(
      'Have a coupon',
      name: 'haveACoupon',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message(
      'Add to Cart',
      name: 'addToCart',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Related products`
  String get relatedProducts {
    return Intl.message(
      'Related products',
      name: 'relatedProducts',
      desc: '',
      args: [],
    );
  }

  /// `Savannah Nguyen`
  String get savannahNguyen {
    return Intl.message(
      'Savannah Nguyen',
      name: 'savannahNguyen',
      desc: '',
      args: [],
    );
  }

  /// `In Stock`
  String get inStock {
    return Intl.message(
      'In Stock',
      name: 'inStock',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Price Range`
  String get priceRange {
    return Intl.message(
      'Price Range',
      name: 'priceRange',
      desc: '',
      args: [],
    );
  }

  /// `Product Status`
  String get productStatus {
    return Intl.message(
      'Product Status',
      name: 'productStatus',
      desc: '',
      args: [],
    );
  }

  /// `On Sale`
  String get onSale {
    return Intl.message(
      'On Sale',
      name: 'onSale',
      desc: '',
      args: [],
    );
  }

  /// `Star Rating`
  String get starRating {
    return Intl.message(
      'Star Rating',
      name: 'starRating',
      desc: '',
      args: [],
    );
  }

  /// `All Category`
  String get allCategory {
    return Intl.message(
      'All Category',
      name: 'allCategory',
      desc: '',
      args: [],
    );
  }

  /// `Woman Dress`
  String get womanDress {
    return Intl.message(
      'Woman Dress',
      name: 'womanDress',
      desc: '',
      args: [],
    );
  }

  /// `T-Shirts`
  String get tShirts {
    return Intl.message(
      'T-Shirts',
      name: 'tShirts',
      desc: '',
      args: [],
    );
  }

  /// `Shoes`
  String get shoes {
    return Intl.message(
      'Shoes',
      name: 'shoes',
      desc: '',
      args: [],
    );
  }

  /// `Sun glass`
  String get sunGlass {
    return Intl.message(
      'Sun glass',
      name: 'sunGlass',
      desc: '',
      args: [],
    );
  }

  /// `Woman Bag`
  String get womanBag {
    return Intl.message(
      'Woman Bag',
      name: 'womanBag',
      desc: '',
      args: [],
    );
  }

  /// `Fresh Food`
  String get freshFood {
    return Intl.message(
      'Fresh Food',
      name: 'freshFood',
      desc: '',
      args: [],
    );
  }

  /// `Smart Phone`
  String get smartPhone {
    return Intl.message(
      'Smart Phone',
      name: 'smartPhone',
      desc: '',
      args: [],
    );
  }

  /// `Computer`
  String get computer {
    return Intl.message(
      'Computer',
      name: 'computer',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Popularity`
  String get sortByPopularity {
    return Intl.message(
      'Sort by Popularity',
      name: 'sortByPopularity',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Newest First`
  String get sortByNewestFirst {
    return Intl.message(
      'Sort by Newest First',
      name: 'sortByNewestFirst',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Oldest First`
  String get sortByOldestFirst {
    return Intl.message(
      'Sort by Oldest First',
      name: 'sortByOldestFirst',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Price: Low to High`
  String get sortByPriceLowToHigh {
    return Intl.message(
      'Sort by Price: Low to High',
      name: 'sortByPriceLowToHigh',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Price: High to Low`
  String get sortByPriceHighToLow {
    return Intl.message(
      'Sort by Price: High to Low',
      name: 'sortByPriceHighToLow',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Best Rating`
  String get sortByBestRating {
    return Intl.message(
      'Sort by Best Rating',
      name: 'sortByBestRating',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Most Reviewed`
  String get sortByMostReviewed {
    return Intl.message(
      'Sort by Most Reviewed',
      name: 'sortByMostReviewed',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Featured`
  String get sortByFeatured {
    return Intl.message(
      'Sort by Featured',
      name: 'sortByFeatured',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Relevance`
  String get sortByRelevance {
    return Intl.message(
      'Sort by Relevance',
      name: 'sortByRelevance',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Discount`
  String get sortByDiscount {
    return Intl.message(
      'Sort by Discount',
      name: 'sortByDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Alphabetical: A-Z`
  String get sortByAlphabeticalAZ {
    return Intl.message(
      'Sort by Alphabetical: A-Z',
      name: 'sortByAlphabeticalAZ',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Alphabetical: Z-A`
  String get sortByAlphabeticalZA {
    return Intl.message(
      'Sort by Alphabetical: Z-A',
      name: 'sortByAlphabeticalZA',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Closest Location`
  String get sortByClosestLocation {
    return Intl.message(
      'Sort by Closest Location',
      name: 'sortByClosestLocation',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Trending`
  String get sortByTrending {
    return Intl.message(
      'Sort by Trending',
      name: 'sortByTrending',
      desc: '',
      args: [],
    );
  }

  /// `Sort by Most Liked`
  String get sortByMostLiked {
    return Intl.message(
      'Sort by Most Liked',
      name: 'sortByMostLiked',
      desc: '',
      args: [],
    );
  }

  /// `Product List`
  String get productList {
    return Intl.message(
      'Product List',
      name: 'productList',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message(
      'Cart',
      name: 'cart',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get checkout {
    return Intl.message(
      'Checkout',
      name: 'checkout',
      desc: '',
      args: [],
    );
  }

  /// `POS & Inventory`
  String get pOSInventory {
    return Intl.message(
      'POS & Inventory',
      name: 'pOSInventory',
      desc: '',
      args: [],
    );
  }

  /// `POS Sale`
  String get pOSSale {
    return Intl.message(
      'POS Sale',
      name: 'pOSSale',
      desc: '',
      args: [],
    );
  }

  /// `Sale List`
  String get saleList {
    return Intl.message(
      'Sale List',
      name: 'saleList',
      desc: '',
      args: [],
    );
  }

  /// `Purchase List`
  String get purchaseList {
    return Intl.message(
      'Purchase List',
      name: 'purchaseList',
      desc: '',
      args: [],
    );
  }

  /// `Add Purchase`
  String get addPurchase {
    return Intl.message(
      'Add Purchase',
      name: 'addPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Code`
  String get code {
    return Intl.message(
      'Code',
      name: 'code',
      desc: '',
      args: [],
    );
  }

  /// `Brand`
  String get brand {
    return Intl.message(
      'Brand',
      name: 'brand',
      desc: '',
      args: [],
    );
  }

  /// `Unit`
  String get unit {
    return Intl.message(
      'Unit',
      name: 'unit',
      desc: '',
      args: [],
    );
  }

  /// `Qty`
  String get qty {
    return Intl.message(
      'Qty',
      name: 'qty',
      desc: '',
      args: [],
    );
  }

  /// `Purchase Price`
  String get purchasePrice {
    return Intl.message(
      'Purchase Price',
      name: 'purchasePrice',
      desc: '',
      args: [],
    );
  }

  /// `Sales Price`
  String get salesPrice {
    return Intl.message(
      'Sales Price',
      name: 'salesPrice',
      desc: '',
      args: [],
    );
  }

  /// `Sub Total`
  String get subTotal {
    return Intl.message(
      'Sub Total',
      name: 'subTotal',
      desc: '',
      args: [],
    );
  }

  /// `Shipping`
  String get shipping {
    return Intl.message(
      'Shipping',
      name: 'shipping',
      desc: '',
      args: [],
    );
  }

  /// `Total Amount`
  String get totalAmount {
    return Intl.message(
      'Total Amount',
      name: 'totalAmount',
      desc: '',
      args: [],
    );
  }

  /// `Receive Amount`
  String get receiveAmount {
    return Intl.message(
      'Receive Amount',
      name: 'receiveAmount',
      desc: '',
      args: [],
    );
  }

  /// `Ex:25`
  String get ex25 {
    return Intl.message(
      'Ex:25',
      name: 'ex25',
      desc: '',
      args: [],
    );
  }

  /// `Change Amount`
  String get changeAmount {
    return Intl.message(
      'Change Amount',
      name: 'changeAmount',
      desc: '',
      args: [],
    );
  }

  /// `Due Amount`
  String get dueAmount {
    return Intl.message(
      'Due Amount',
      name: 'dueAmount',
      desc: '',
      args: [],
    );
  }

  /// `Ex: out of limit`
  String get exOutOfLimit {
    return Intl.message(
      'Ex: out of limit',
      name: 'exOutOfLimit',
      desc: '',
      args: [],
    );
  }

  /// `Transaction ID`
  String get transactionID {
    return Intl.message(
      'Transaction ID',
      name: 'transactionID',
      desc: '',
      args: [],
    );
  }

  /// `Ex: HF5gJ7`
  String get exHF5gJ7 {
    return Intl.message(
      'Ex: HF5gJ7',
      name: 'exHF5gJ7',
      desc: '',
      args: [],
    );
  }

  /// `Search product by name`
  String get searchProductByName {
    return Intl.message(
      'Search product by name',
      name: 'searchProductByName',
      desc: '',
      args: [],
    );
  }

  /// `Select a supplier`
  String get selectASupplier {
    return Intl.message(
      'Select a supplier',
      name: 'selectASupplier',
      desc: '',
      args: [],
    );
  }

  /// `Supplier`
  String get supplier {
    return Intl.message(
      'Supplier',
      name: 'supplier',
      desc: '',
      args: [],
    );
  }

  /// `Watch`
  String get watch {
    return Intl.message(
      'Watch',
      name: 'watch',
      desc: '',
      args: [],
    );
  }

  /// `Mobile`
  String get mobile {
    return Intl.message(
      'Mobile',
      name: 'mobile',
      desc: '',
      args: [],
    );
  }

  /// `Bag`
  String get bag {
    return Intl.message(
      'Bag',
      name: 'bag',
      desc: '',
      args: [],
    );
  }

  /// `Warehouse`
  String get warehouse {
    return Intl.message(
      'Warehouse',
      name: 'warehouse',
      desc: '',
      args: [],
    );
  }

  /// `Add New Purchase`
  String get addNewPurchase {
    return Intl.message(
      'Add New Purchase',
      name: 'addNewPurchase',
      desc: '',
      args: [],
    );
  }

  /// `Invoice No`
  String get invoiceNo {
    return Intl.message(
      'Invoice No',
      name: 'invoiceNo',
      desc: '',
      args: [],
    );
  }

  /// `Select a warehouse`
  String get selectAWarehouse {
    return Intl.message(
      'Select a warehouse',
      name: 'selectAWarehouse',
      desc: '',
      args: [],
    );
  }

  /// `Items`
  String get items {
    return Intl.message(
      'Items',
      name: 'items',
      desc: '',
      args: [],
    );
  }

  /// `Sale Price`
  String get salePrice {
    return Intl.message(
      'Sale Price',
      name: 'salePrice',
      desc: '',
      args: [],
    );
  }

  /// `Ex:25411`
  String get ex25411 {
    return Intl.message(
      'Ex:25411',
      name: 'ex25411',
      desc: '',
      args: [],
    );
  }

  /// `Supplier Name`
  String get supplierName {
    return Intl.message(
      'Supplier Name',
      name: 'supplierName',
      desc: '',
      args: [],
    );
  }

  /// `Grand Total`
  String get grandTotal {
    return Intl.message(
      'Grand Total',
      name: 'grandTotal',
      desc: '',
      args: [],
    );
  }

  /// `Payment Status`
  String get paymentStatus {
    return Intl.message(
      'Payment Status',
      name: 'paymentStatus',
      desc: '',
      args: [],
    );
  }

  /// `Sales By`
  String get salesBy {
    return Intl.message(
      'Sales By',
      name: 'salesBy',
      desc: '',
      args: [],
    );
  }

  /// `Add Sales`
  String get addSales {
    return Intl.message(
      'Add Sales',
      name: 'addSales',
      desc: '',
      args: [],
    );
  }

  /// `Scan / search product by code or name`
  String get scanSearchProductByCodeOrName {
    return Intl.message(
      'Scan / search product by code or name',
      name: 'scanSearchProductByCodeOrName',
      desc: '',
      args: [],
    );
  }

  /// `Select Customer`
  String get selectCustomer {
    return Intl.message(
      'Select Customer',
      name: 'selectCustomer',
      desc: '',
      args: [],
    );
  }

  /// `Select Warehouse`
  String get selectWarehouse {
    return Intl.message(
      'Select Warehouse',
      name: 'selectWarehouse',
      desc: '',
      args: [],
    );
  }

  /// `Total Item`
  String get totalItem {
    return Intl.message(
      'Total Item',
      name: 'totalItem',
      desc: '',
      args: [],
    );
  }

  /// `Quotation`
  String get quotation {
    return Intl.message(
      'Quotation',
      name: 'quotation',
      desc: '',
      args: [],
    );
  }

  /// `Payment`
  String get payment {
    return Intl.message(
      'Payment',
      name: 'payment',
      desc: '',
      args: [],
    );
  }

  /// `welcome`
  String get welcome {
    return Intl.message(
      'welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Wall`
  String get wall {
    return Intl.message(
      'Wall',
      name: 'wall',
      desc: '',
      args: [],
    );
  }

  /// `Ceiling`
  String get ceiling {
    return Intl.message(
      'Ceiling',
      name: 'ceiling',
      desc: '',
      args: [],
    );
  }

  /// `Door`
  String get door {
    return Intl.message(
      'Door',
      name: 'door',
      desc: '',
      args: [],
    );
  }

  /// `Window`
  String get window {
    return Intl.message(
      'Window',
      name: 'window',
      desc: '',
      args: [],
    );
  }

  /// `Sofa`
  String get sofa {
    return Intl.message(
      'Sofa',
      name: 'sofa',
      desc: '',
      args: [],
    );
  }

  /// `Lamp`
  String get lamp {
    return Intl.message(
      'Lamp',
      name: 'lamp',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'ko'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'sw'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'th'),
      Locale.fromSubtags(languageCode: 'ur'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
