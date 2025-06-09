import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AppStore {
  bool isLoggedIn = false;

  bool isDarkMode = false;

  bool isLoading = false;

  bool isRememberMe = false;

  String selectedLanguageCode = "en";

  String loginType = '';

  String displayname = '';

  String iid = '';

  String userFirstName = '';

  String userLastName = '';
  String placeOfBirth = '';

  String uid = '';

  String userEmail = '';

  String userName = '';

  String currentAddress = '';

  String token = '';

  String currencySymbol = '';

  String userDob = '';

  String currencyCountryId = '';

  String address = '';

  String playerId = '';

  int? userId = -1;

  int? unreadCount = 0;

  bool useMaterialYouTheme = true;

  String userType = '';

  String purchaseString = '';

  // New fields added

  String? phoneNumber;

  int? lastmsg;

  String? gender;

  Map<String, dynamic>? meta;

  String? about;

  String? level;

  List<String>? favorites;

  List<String>? images;

  List<String>? privates;

  String? imageUrl;

  int? lastOnline;

  Future<void> setUserType(String val, {bool isInitializing = false}) async {
    userType = val;
    if (!isInitializing) await setValue(USER_TYPE, val);
  }

  Future<void> setpurchaseString(String val,
      {bool isInitializing = false}) async {
    purchaseString = val;
    if (!isInitializing) await setValue(USER_PS, val);
  }

  Future<void> setAddress(String val, {bool isInitializing = false}) async {
    address = val;
    if (!isInitializing) await setValue(ADDRESS, val);
  }

  Future<void> setLoginType(String val, {bool isInitializing = false}) async {
    loginType = val;
    if (!isInitializing) await setValue(LOGIN_TYPE, val);
  }

  Future<void> setDisplayname(String val, {bool isInitializing = false}) async {
    displayname = val;
    if (!isInitializing) await setValue(INQUIRY_EMAIL, val);
  }

  Future<void> set_id(String val, {bool isInitializing = false}) async {
    iid = val;
    if (!isInitializing) await setValue("IID", val);
  }

  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(TOKEN, val);
  }

  Future<void> setCurrencySymbol(String val,
      {bool isInitializing = false}) async {
    currencySymbol = val;
    if (!isInitializing) await setValue(CURRENCY_COUNTRY_SYMBOL, val);
  }

  Future<void> setUserDob(String val, {bool isInitializing = false}) async {
    userDob = val;
    if (!isInitializing) await setValue(DOB, val);
  }

  Future<void> setCurrencyCountryId(String val,
      {bool isInitializing = false}) async {
    currencyCountryId = val;
    if (!isInitializing) await setValue(CURRENCY_COUNTRY_ID, val);
  }

  Future<void> setUId(String val, {bool isInitializing = false}) async {
    uid = val;
    if (!isInitializing) await setValue(UID, val);
  }

  Future<void> setUserId(int val, {bool isInitializing = false}) async {
    userId = val;
    if (!isInitializing) await setValue(USER_ID, val);
  }

  Future<void> setUserEmail(String val, {bool isInitializing = false}) async {
    userEmail = val;
    if (!isInitializing) await setValue(USER_EMAIL, val);
  }

  Future<void> setFirstName(String val, {bool isInitializing = false}) async {
    userFirstName = val;
    if (!isInitializing) await setValue(FIRST_NAME, val);
  }

  Future<void> setLastName(String val, {bool isInitializing = false}) async {
    userLastName = val;
    if (!isInitializing) await setValue(LAST_NAME, val);
  }

  Future<void> setplaceOfBirth(String val,
      {bool isInitializing = false}) async {
    placeOfBirth = val;
    if (!isInitializing) await setValue("placeOfBirth", val);
  }

  Future<void> setUserName(String val, {bool isInitializing = false}) async {
    userName = val;
    if (!isInitializing) await setValue(USERNAME, val);
  }

  Future<void> setCurrentAddress(String val,
      {bool isInitializing = false}) async {
    currentAddress = val;
    if (!isInitializing) await setValue(CURRENT_ADDRESS, val);
  }

  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }

  void setLoading(bool val) {
    isLoading = val;
  }

  void setUnreadCount(int val) {
    unreadCount = val;
  }

  void setRemember(bool val) {
    isRememberMe = val;
  }

  Future<void> setPhoneNumber(String? val) async {
    phoneNumber = val;
    await setValue(PHONE_NUMBER, val);
  }

  Future<void> setLastMsg(int? val) async {
    lastmsg = val;
    await setValue(LAST_MSG, val);
  }

  Future<void> setGender(String? val) async {
    gender = val;
    await setValue(GENDER, val);
  }

  Future<void> setMeta(Map<String, dynamic>? val) async {
    meta = val;
    await setValue(AGE_RANGE, val);
  }

  Future<void> setAbout(String? val) async {
    about = val;
    await setValue(ABOUT, val);
  }

  Future<void> setLevel(String? val) async {
    level = val;
    await setValue(LEVEL, val);
  }

  Future<void> setFavorites(List<String>? val) async {
    favorites = val;
    await setValue(FAVORITES, val);
  }

  Future<void> setImages(List<String>? val) async {
    images = val;
    await setValue(IMAGES, val);
  }

  Future<void> setImageUrl(String? val) async {
    imageUrl = val;
    await setValue(IMAGES, val);
  }

  Future<void> setLastOnline(int? val) async {
    lastOnline = val;
    await setValue(LAST_ONLINE, val);
  }

  Future<void> setDarkMode(bool val) async {
    isDarkMode = val;

    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;
      defaultLoaderBgColorGlobal = AcnooAppColors.kPrimary900;
      appButtonBackgroundColorGlobal = AcnooAppColors.kPrimary900;
      shadowColorGlobal = Colors.white12;
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;
      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;
    }
  }
}
