import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/models/_inventory.dart';
import 'package:jatai_etatsdeslieux/app/models/mylocale.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';

/// DO NOT CHANGE THIS PACKAGE NAME
var appPackageName =
    isAndroid ? 'com.jatai.etatdeslieux' : 'com.jatai.etatdeslieux';

//region Common Configs
const DEFAULT_FIREBASE_PASSWORD = 12345678;
const DECIMAL_POINT = 2;
const MAXIMUM_INTERESTS = 5;
const PER_PAGE_ITEM = 20;
const LABEL_TEXT_SIZE = 18;
const double SETTING_ICON_SIZE = 22;
const MARK_AS_READ = 'markas_read';
const PERMISSION_STATUS = 'permissionStatus';

const ONESIGNAL_TAG_KEY = 'appType';
const ONESIGNAL_TAG_VALUE = 'userApp';
const PER_PAGE_CHAT_LIST_COUNT = 50;

const USER_NOT_CREATED = "User not created";
const USER_CANNOT_LOGIN = "User can't login";
const USER_NOT_FOUND = "User not found";

const BOOKING_TYPE_ALL = 'Tout';
//endregion

//region LIVESTREAM KEYS
const LIVESTREAM_TOKEN = 'tokenStream';
const LIVESTREAM_UPDATE_BOOKING_LIST = "UpdateBookingList";
const SLIDE_PROVIER_SCREEN = "SLIDE_PROVIER_SCREEN";
const LIVESTREAM_UPDATE_SERVICE_LIST = "LIVESTREAM_UPDATE_SERVICE_LIST";
const LIVESTREAM_UPDATE_job_LIST = "LIVESTREAM_UPDATE_job_LIST";
const LIVESTREAM_UPDATE_DASHBOARD = "streamUpdateDashboard";
const LIVESTREAM_START_TIMER = "startTimer";
const LIVESTREAM_PAUSE_TIMER = "pauseTimer";
//endregion

//region default USER login
const DEFAULT_EMAIL = 'demo@user.com';
const DEFAULT_PASS = '12345678';
//endregion

//region THEME MODE TYPE
const THEME_MODE_LIGHT = 0;
const THEME_MODE_DARK = 1;
const THEME_MODE_SYSTEM = 2;
//endregion
//region User Properties Keys
const PHONE_NUMBER = 'PHONE_NUMBER';
const LAST_MSG = 'LAST_MSG';
const GENDER = 'GENDER';
const SHOW_GENDER = 'SHOW_GENDER';
const SHOW_INTERESTS = 'SHOW_INTERESTS';
const AGE_RANGE = 'AGE_RANGE';
const META = 'META';
const MAX_DISTANCE = 'MAX_DISTANCE';
const ABOUT = 'ABOUT';
const DISTANCE_BW = 'DISTANCE_BW';
const INTERESTS = 'INTERESTS';
const LEVEL = 'LEVEL';
const DOB = 'DOB';
const FAVORITES = 'FAVORITES';
const IMAGES = 'IMAGES';
const PRIVATES = 'PRIVATES';
const LAST_ONLINE = 'LAST_ONLINE';
//endregion
//region SHARED PREFERENCES KEYS
const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const USER_ID = 'USER_ID';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_FULL_NAME = 'USER_FULL_NAME';
const USER_PASSWORD = 'USER_PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const DISPLAY_NAME = 'DISPLAY_NAME';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const COORDINATE = 'COORDINATE';
const COUNTRY_INDICATIF = 'COUNTRY_INDICATIF';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const ADDRESS = 'ADDRESS';
const PLAYERID = 'PLAYERID';
const UID = 'UID';
const LATITUDE = 'LATITUDE';
const LONGITUDE = 'LONGITUDE';
const CURRENT_ADDRESS = 'CURRENT_ADDRESS';
const LOGIN_TYPE = 'LOGIN_TYPE';
const PAYMENT_LIST = 'PAYMENT_LIST';
const USER_TYPE = 'USER_TYPE';
const USER_PS = 'USER_PS';

const PRIVACY_POLICY = 'PRIVACY_POLICY';
const TERM_CONDITIONS = 'TERM_CONDITIONS';
const INQUIRY_EMAIL = 'INQUIRY_EMAIL';
const HELPLINE_NUMBER = 'HELPLINE_NUMBER';
const USE_MATERIAL_YOU_THEME = 'USE_MATERIAL_YOU_THEME';
const IN_MAINTENANCE_MODE = 'inMaintenanceMode';
const HAS_IN_APP_STORE_REVIEW = 'hasInAppStoreReview1';
const HAS_IN_PLAY_STORE_REVIEW = 'hasInPlayStoreReview1';
const HAS_IN_REVIEW = 'hasInReview';
const SERVER_LANGUAGES = 'SERVER_LANGUAGES';
const AUTO_SLIDER_STATUS = 'AUTO_SLIDER_STATUS';
const UPDATE_NOTIFY = 'UPDATE_NOTIFY';
const CURRENCY_POSITION = 'CURRENCY_POSITION';
//endregion

//region FORCE UPDATE
const FORCE_UPDATE = 'forceUpdate';
const FORCE_UPDATE_USER = 'forceUpdateInUser';
const USER_CHANGE_LOG = 'userChangeLog';
const LATEST_VERSIONCODE_USER_APP_ANDROID = 'latestVersionCodeUserAndroid';
const LATEST_VERSIONCODE_USER_APP_IOS = 'latestVersionCodeUseriOS';
//endregion

//region CURRENCY POSITION
const CURRENCY_POSITION_LEFT = 'left';
const CURRENCY_POSITION_RIGHT = 'right';
//endregion

//region CONFIGURATION KEYS
const CONFIGURATION_TYPE_CURRENCY = 'CURRENCY';
const CONFIGURATION_TYPE_CURRENCY_POSITION = 'CURRENCY_POSITION';
const CURRENCY_COUNTRY_SYMBOL = 'CURRENCY_COUNTRY_SYMBOL';
const CURRENCY_COUNTRY_CODE = 'CURRENCY_COUNTRY_CODE';
const CURRENCY_COUNTRY_ID = 'CURRENCY_COUNTRY_ID';
const IS_CURRENT_LOCATION = 'CURRENT_LOCATION';
//endregion

//region User Types
const USER_TYPE_PROVIDER = 'provider';
const USER_TYPE_HANDYMAN = 'handyman';
const USER_TYPE_USER = 'user';
//endregion

//region LOGIN TYPE
const LOGIN_TYPE_USER = 'user';
const LOGIN_TYPE_GOOGLE = 'google';
const LOGIN_TYPE_FACEBOOK = 'facebook';
const LOGIN_TYPE_OTP = 'mobile';
//endregion

//region SERVICE TYPE
const SERVICE_TYPE_FIXED = 'fixed';
const SERVICE_TYPE_PERCENT = 'percent';
const SERVICE_TYPE_HOURLY = 'hourly';
//endregion

//region PAYMENT METHOD
const PAYMENT_METHOD_COD = 'cash';
const PAYMENT_METHOD_STRIPE = 'stripe';
const PAYMENT_METHOD_RAZOR = 'razorPay';
const PAYMENT_METHOD_PAYSTACK = 'paystack';
const PAYMENT_METHOD_FLUTTER_WAVE = 'wave';
//endregion

//region SERVICE PAYMENT STATUS
const SERVICE_PAYMENT_STATUS_PAID = 'paid';
const SERVICE_PAYMENT_STATUS_PENDING = 'pending';
//endregion

//region FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_DATA_IMAGES = "chatImages";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const PER_PAGE_CHAT_COUNT = 50;
//endregion

//region FILE TYPE
const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";
//endregion

//region CHAT LANGUAGE
const List<String> RTL_LanguageS = ['ar', 'ur'];
//endregion

//region MessageType
enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
}
//endregion

//region MessageExtension
extension MessageExtension on MessageType {
  String? get name {
    switch (this) {
      case MessageType.TEXT:
        return 'TEXT';
      case MessageType.IMAGE:
        return 'IMAGE';
      case MessageType.VIDEO:
        return 'VIDEO';
      case MessageType.AUDIO:
        return 'AUDIO';
      default:
        return null;
    }
  }
}
//endregion

//region DateFormat
const DATE_FORMAT_1 = 'dd-MMM-yyyy hh:mm a';
const DATE_FORMAT_2 = 'd MMM, yyyy';
const DATE_FORMAT_3 = 'dd-MMM-yyyy';
const HOUR_12_FORMAT = 'HH:mm';
const DATE_FORMAT_4 = 'dd MMM';
const YEAR = 'yyyy';
const MONTH_YEAR = 'MMM yyyy';
const BOOKING_SAVE_FORMAT = "yyyy-MM-dd kk:mm:ss";
//endregion

//region Mail And Tel URL
const MAIL_TO = 'mailto:';
const TEL = 'tel:';
const GOOGLE_MAP_PREFIX = 'https://www.google.com/maps/search/?api=1&query=';
const GOOGLE_MAP_DIRECTION = 'http://maps.google.com/maps?saddr=';

// max Video upload limit in MB
int maxUploadMB = 50;
// max Video upload second
int maxUploadSecond = 360;
const int paginationLimit = 5;
var heatingTypes = <String, String>{
  "gas": "Gaz".tr,
  "electric": "Électrique".tr,
  "oil": "Fioul".tr,
  "other": "Autre".tr,
};
var heatingmODes = <String, String>{
  "individual": "Individuel".tr,
  "collective": "Collectif".tr,
  "not_applicable": "Pas de chauffage".tr,
};
var heatingwatermODes = <String, String>{
  "individual": "Individuel".tr,
  "collective": "Collectif".tr,
  "not_applicable": "Pas d'eau chaude".tr,
};
var hotWaterTypes = <String, String>{
  "gas": "Gaz".tr,
  "electric": "Électrique".tr,
  "oil": "Fioul".tr,
  "other": "Autre".tr,
};
var defaultthings = <String, Map<String, dynamic>>{
  "wall": {
    "name": "Mur".tr,
    "properties": {
      "state": {"name": "Etat".tr, "type": "String"},
      "color": {"name": "Couleur".tr, "type": "color"},
      "coating": {"name": "Revêtement".tr, "type": "String"},
      "comment": {"name": "Commentaire".tr, "type": "String"},
    }
  },
  "ceiling": {
    "name": "Plafond".tr,
    "properties": {
      "state": {"name": "Etat".tr, "type": "String"},
      "color": {"name": "Couleur".tr, "type": "color"},
      "material": {"name": "Matériau".tr, "type": "String"},
      "comment": {"name": "Commentaire".tr, "type": "String"},
    }
  },
  // "floor": {
  //   "name": "Sol".tr,
  //   "properties": {
  //     "state": {"name": "Etat".tr, "type": "String"},
  //     "material": {"name": "Matériau".tr, "type": "String"},
  //     "covering": {"name": "Revêtement".tr, "type": "String"},
  //     "comment": {"name": "Commentaire".tr, "type": "String"},
  //   }
  // },
  // "door": {
  //   "name": "Porte".tr,
  //   "properties": {
  //     "state": {"name": "Etat".tr, "type": "String"},
  //     "color": {"name": "Couleur".tr, "type": "color"},
  //     "material": {"name": "Matériau".tr, "type": "String"},
  //     "lock": {"name": "Serrure".tr, "type": "String"},
  //     "comment": {"name": "Commentaire".tr, "type": "String"},
  //   }
  // },
  // "window": {
  //   "name": "Fenêtre".tr,
  //   "properties": {
  //     "state": {"name": "Etat".tr, "type": "String"},
  //     "glass": {"name": "Vitrage".tr, "type": "String"},
  //     "shutter": {"name": "Volet".tr, "type": "String"},
  //     "comment": {"name": "Commentaire".tr, "type": "String"},
  //   }
  // },
  // "sofa": {
  //   "name": "Canapé".tr,
  //   "properties": {
  //     "state": {"name": "Etat".tr, "type": "String"},
  //     "color": {"name": "Couleur".tr, "type": "color"},
  //     "material": {"name": "Matériau".tr, "type": "String"},
  //     "comment": {"name": "Commentaire".tr, "type": "String"},
  //   }
  // },
  // "lamp": {
  //   "name": "Lampe".tr,
  //   "properties": {
  //     "state": {"name": "Etat".tr, "type": "String"},
  //     "type": {"name": "Type".tr, "type": "String"},
  //     "bulb": {"name": "Ampoule".tr, "type": "String"},
  //     "comment": {"name": "Commentaire".tr, "type": "String"},
  //   }
  // },
};
var defaultroooms = <String, Map<String, dynamic>>{
  "livingRoom": {
    "name": "Salon".tr,
    "icon": "assets/images/static_images/icons/sofa.png"
  },
  "bedroom": {
    "name": "Chambre".tr,
    "icon": "assets/images/static_images/icons/bathroom.png"
  },
  "kitchen": {
    "name": "Cuisine".tr,
    "icon": "assets/images/static_images/icons/kitchen.png"
  },
  "bathroom": {
    "name": "Salle de bain".tr,
    "icon": "assets/images/static_images/icons/bathroom.png"
  },
  "toilets": {
    "name": "Toilettes".tr,
    "icon": "assets/images/static_images/icons/toilet.png"
  },
  "laundry": {
    "name": "Buanderie".tr,
    "icon": "assets/images/static_images/icons/laundry.png"
  },
  "entrance": {
    "name": "Entrée".tr,
    "icon": "assets/images/static_images/icons/entrance.png"
  },
  "balcony": {
    "name": "Balcon".tr,
    "icon": "assets/images/static_images/icons/balcony.png"
  },
  "terrace": {
    "name": "Terrasse".tr,
    "icon": "assets/images/static_images/icons/terrace.png"
  },
  "parkingGarage": {
    "name": "Parking-Garage".tr,
    "icon": "assets/images/static_images/icons/parking_garage.png"
  },
  "otherRoom": {
    "name": "Autre Pièce".tr,
    "icon": "assets/images/static_images/icons/other.png"
  },
};
var defaulcompteurs = <String, Map<String, dynamic>>{
  "electricity": {
    "name": "Électricité".tr,
    "icon": "assets/images/static_images/icons/electricity.png"
  },
  "gas": {
    "name": "Gaz".tr,
    "icon": "assets/images/static_images/icons/gas.png"
  },
  "cold_water": {
    "name": "Eau froide".tr,
    "icon": "assets/images/static_images/icons/cold_water.png"
  },
  "hot_water": {
    "name": "Eau chaude".tr,
    "icon": "assets/images/static_images/icons/hot_water.png"
  },
  "thermal_energy": {
    "name": "Énergie thermique".tr,
    "icon": "assets/images/static_images/icons/thermal.png"
  },
  "other": {
    "name": "Autre".tr,
    "icon": "assets/images/static_images/icons/other_counter.png"
  }
};

var defaulcles = <String, String>{
  "principal_key": "Porte principale".tr,
  "common_area": "Partie communes".tr,
  "badge": "Badge".tr,
  "mailbox": "Boîte aux lettres".tr,
  "parking_garage": "Parking-Garage".tr,
  "gate": "Portail".tr,
  "bike_room": "Local à vélo".tr,
  "trash_room": "Local poubelle".tr,
  "cellar": "Cave".tr,
};
var defaultStates = <String, String>{
  "good": "Bon Etat".tr,
  "average": "Etat Moyen".tr,
  "bad": "Mauvais Etat".tr,
  "new": "Neuf".tr,
  "not_applicable": "Non Applicable".tr,
};
var yesnonotTested = <String, String>{
  "yes": "Oui".tr,
  "no": "Non".tr,
  "not_tested": "Non testé".tr,
};
var defaultcountNumber = <String, String>{
  "1": "1",
  "2": "2",
  "3": "3",
  "counterfield": "4",
};

var fairplaymap = <String, String>{
  "text": "4",
};

var defaultTestingStates = <String, String>{
  "ok": "Fonctionne".tr,
  "not_working": "Ne fonctionne pas".tr,
  "not_testes": "Non testé".tr,
  "unknown": "N/A".tr,
};

var defaultActionButtons = <String, String>{
  "unknown": "Non applicable".tr,
  "ok": "Fonctionne".tr,
  "not_working": "Ne fonctionne pas".tr,
  "not_testes": "Non testé".tr,
};
var defaultphotos = <String, List<String>>{
  "piece": [
    'assets/images/static_images/background_images/background_image_11.png',
    'assets/images/static_images/background_images/background_image_12.png',
    'assets/images/static_images/background_images/background_image_13.png',
    'assets/images/static_images/background_images/background_image_14.png',
    'assets/images/static_images/background_images/background_image_15.png',
    'assets/images/static_images/background_images/background_image_16.png',
    'assets/images/static_images/background_images/background_image_17.png',
    'assets/images/static_images/background_images/background_image_18.png',
  ],
};

final basethings = [...defaultthings.entries]
    .map((e) => InventoryOfThing(
        name: e.value['name'],
        id: "${generateRandomStrings(5)}${DateTime.now().millisecondsSinceEpoch.toString()}",
        type: e.key,
        condition: 'good',
        order: defaultthings.keys.toList().indexOf(e.key)))
    .toList();

var countryCodes = <String, MyLocale>{
  "Afghanistan": MyLocale("af", "+93"),
  "Albania": MyLocale("al", "+355"),
  "Algeria": MyLocale("dz", "+213"),
  "Andorra": MyLocale("ad", "+376"),
  "Angola": MyLocale("ao", "+244"),
  "Antigua and Barbuda": MyLocale("ag", "+1-268"),
  "Argentina": MyLocale("ar", "+54"),
  "Armenia": MyLocale("am", "+374"),
  "Australia": MyLocale("au", "+61"),
  "Austria": MyLocale("at", "+43"),
  "Azerbaijan": MyLocale("az", "+994"),
  "Bahamas": MyLocale("bs", "+1-242"),
  "Bahrain": MyLocale("bh", "+973"),
  "Bangladesh": MyLocale("bd", "+880"),
  "Barbados": MyLocale("bb", "+1-246"),
  "Belarus": MyLocale("by", "+375"),
  "Belgium": MyLocale("be", "+32"),
  "Belize": MyLocale("bz", "+501"),
  "Benin": MyLocale("bj", "+229"),
  "Bhutan": MyLocale("bt", "+975"),
  "Bolivia": MyLocale("bo", "+591"),
  "Bosnia and Herzegovina": MyLocale("ba", "+387"),
  "Botswana": MyLocale("bw", "+267"),
  "Brazil": MyLocale("br", "+55"),
  "Brunei": MyLocale("bn", "+673"),
  "Bulgaria": MyLocale("bg", "+359"),
  "Burkina Faso": MyLocale("bf", "+226"),
  "Burundi": MyLocale("bi", "+257"),
  "Côte d'Ivoire": MyLocale("ci", "+225"),
  "Cabo Verde": MyLocale("cv", "+238"),
  "Cambodia": MyLocale("kh", "+855"),
  "Cameroon": MyLocale("cm", "+237"),
  "Canada": MyLocale("ca", "+1"),
  "Central African Republic": MyLocale("cf", "+236"),
  "Chad": MyLocale("td", "+235"),
  "Chile": MyLocale("cl", "+56"),
  "China": MyLocale("cn", "+86"),
  "Colombia": MyLocale("co", "+57"),
  "Comoros": MyLocale("km", "+269"),
  "Congo (Congo-Brazzaville)": MyLocale("cg", "+242"),
  "Costa Rica": MyLocale("cr", "+506"),
  "Croatia": MyLocale("hr", "+385"),
  "Cuba": MyLocale("cu", "+53"),
  "Cyprus": MyLocale("cy", "+357"),
  "Czechia (Czech Republic)": MyLocale("cz", "+420"),
  "Democratic Republic of the Congo": MyLocale("cd", "+243"),
  "Denmark": MyLocale("dk", "+45"),
  "Djibouti": MyLocale("dj", "+253"),
  "Dominica": MyLocale("dm", "+1-767"),
  "Dominican Republic": MyLocale("do", "+1-809"),
  "Ecuador": MyLocale("ec", "+593"),
  "Egypt": MyLocale("eg", "+20"),
  "El Salvador": MyLocale("sv", "+503"),
  "Equatorial Guinea": MyLocale("gq", "+240"),
  "Eritrea": MyLocale("er", "+291"),
  "Estonia": MyLocale("ee", "+372"),
  "Eswatini": MyLocale("sz", "+268"),
  "Ethiopia": MyLocale("et", "+251"),
  "Fiji": MyLocale("fj", "+679"),
  "Finland": MyLocale("fi", "+358"),
  "France": MyLocale("fr", "+33"),
  "Gabon": MyLocale("ga", "+241"),
  "Gambia": MyLocale("gm", "+220"),
  "Georgia": MyLocale("ge", "+995"),
  "Germany": MyLocale("de", "+49"),
  "Ghana": MyLocale("gh", "+233"),
  "Greece": MyLocale("gr", "+30"),
  "Grenada": MyLocale("gd", "+1-473"),
  "Guatemala": MyLocale("gt", "+502"),
  "Guinea": MyLocale("gn", "+224"),
  "Guinea-Bissau": MyLocale("gw", "+245"),
  "Guyana": MyLocale("gy", "+592"),
  "Haiti": MyLocale("ht", "+509"),
  "Holy See": MyLocale("va", "+379"),
  "Honduras": MyLocale("hn", "+504"),
  "Hungary": MyLocale("hu", "+36"),
  "Iceland": MyLocale("is", "+354"),
  "India": MyLocale("in", "+91"),
  "Indonesia": MyLocale("id", "+62"),
  "Iran": MyLocale("ir", "+98"),
  "Iraq": MyLocale("iq", "+964"),
  "Ireland": MyLocale("ie", "+353"),
  "Israel": MyLocale("il", "+972"),
  "Italy": MyLocale("it", "+39"),
  "Jamaica": MyLocale("jm", "+1-876"),
  "Japan": MyLocale("jp", "+81"),
  "Jordan": MyLocale("jo", "+962"),
  "Kazakhstan": MyLocale("kz", "++7"),
  "Kenya": MyLocale("ke", "+254"),
  "Kiribati": MyLocale("ki", "+686"),
  "Kuwait": MyLocale("kw", "+965"),
  "Kyrgyzstan": MyLocale("kg", "+996"),
  "Laos": MyLocale("la", "+856"),
  "Latvia": MyLocale("lv", "+371"),
  "Lebanon": MyLocale("lb", "+961"),
  "Lesotho": MyLocale("ls", "+266"),
  "Liberia": MyLocale("lr", "+231"),
  "Libya": MyLocale("ly", "+218"),
  "Liechtenstein": MyLocale("li", "+423"),
  "Lithuania": MyLocale("lt", "+370"),
  "Luxembourg": MyLocale("lu", "+352"),
  "Madagascar": MyLocale("mg", "+261"),
  "Malawi": MyLocale("mw", "+265"),
  "Malaysia": MyLocale("my", "+60"),
  "Maldives": MyLocale("mv", "+960"),
  "Mali": MyLocale("ml", "+223"),
  "Malta": MyLocale("mt", "+356"),
  "Marshall Islands": MyLocale("mh", "+692"),
  "Mauritania": MyLocale("mr", "+222"),
  "Mauritius": MyLocale("mu", "+230"),
  "Mexico": MyLocale("mx", "+52"),
  "Micronesia": MyLocale("fm", "+691"),
  "Moldova": MyLocale("md", "+373"),
  "Monaco": MyLocale("mc", "+377"),
  "Mongolia": MyLocale("mn", "+976"),
  "Montenegro": MyLocale("me", "+382"),
  "Morocco": MyLocale("ma", "+212"),
  "Mozambique": MyLocale("mz", "+258"),
  "Myanmar (Burma)": MyLocale("mm", "+95"),
  "Namibia": MyLocale("na", "+264"),
  "Nauru": MyLocale("nr", "+674"),
  "Nepal": MyLocale("np", "+977"),
  "Netherlands": MyLocale("nl", "+31"),
  "New Zealand": MyLocale("nz", "+64"),
  "Nicaragua": MyLocale("ni", "+505"),
  "Niger": MyLocale("ne", "+227"),
  "Nigeria": MyLocale("ng", "+234"),
  "North Korea": MyLocale("kp", "+850"),
  "North Macedonia": MyLocale("mk", "+389"),
  "Norway": MyLocale("no", "+47"),
  "Oman": MyLocale("om", "+968"),
  "Pakistan": MyLocale("pk", "+92"),
  "Palau": MyLocale("pw", "+680"),
  "Palestine State": MyLocale("ps", "+970"),
  "Panama": MyLocale("pa", "+507"),
  "Papua New Guinea": MyLocale("pg", "+675"),
  "Paraguay": MyLocale("py", "+595"),
  "Peru": MyLocale("pe", "+51"),
  "Philippines": MyLocale("ph", "+63"),
  "Poland": MyLocale("pl", "+48"),
  "Portugal": MyLocale("pt", "+351"),
  "Qatar": MyLocale("qa", "+974"),
  "Romania": MyLocale("ro", "+40"),
  "Russia": MyLocale("ru", "+7"),
  "Rwanda": MyLocale("rw", "+250"),
  "Saint Kitts and Nevis": MyLocale("kn", "+1-869"),
  "Saint Lucia": MyLocale("lc", "+1-758"),
  "Saint Vincent and the Grenadines": MyLocale("vc", "+1-784"),
  "Samoa": MyLocale("ws", "+685"),
  "San Marino": MyLocale("sm", "+378"),
  "Sao Tome and Principe": MyLocale("st", "+239"),
  "Saudi Arabia": MyLocale("sa", "+966"),
  "Senegal": MyLocale("sn", "+221"),
  "Serbia": MyLocale("rs", "+381"),
  "Seychelles": MyLocale("sc", "+248"),
  "Sierra Leone": MyLocale("sl", "+232"),
  "Singapore": MyLocale("sg", "+65"),
  "Slovakia": MyLocale("sk", "+421"),
  "Slovenia": MyLocale("si", "+386"),
  "Solomon Islands": MyLocale("sb", "+677"),
  "Somalia": MyLocale("so", "+252"),
  "South Africa": MyLocale("za", "+27"),
  "South Korea": MyLocale("kr", "+82"),
  "South Sudan": MyLocale("ss", "+211"),
  "Spain": MyLocale("es", "+34"),
  "Sri Lanka": MyLocale("lk", "+94"),
  "Sudan": MyLocale("sd", "+249"),
  "Suriname": MyLocale("sr", "+597"),
  "Sweden": MyLocale("se", "+46"),
  "Switzerland": MyLocale("ch", "+41"),
  "Syria": MyLocale("sy", "+963"),
  "Tajikistan": MyLocale("tj", "+992"),
  "Tanzania": MyLocale("tz", "+255"),
  "Thailand": MyLocale("th", "+66"),
  "Timor-Leste": MyLocale("tl", "+670"),
  "Togo": MyLocale("tg", "+228"),
  "Tonga": MyLocale("to", "+676"),
  "Trinidad and Tobago": MyLocale("tt", "+1-868"),
  "Tunisia": MyLocale("tn", "+216"),
  "Turkey": MyLocale("tr", "+90"),
  "Turkmenistan": MyLocale("tm", "+993"),
  "Tuvalu": MyLocale("tv", "+688"),
  "Uganda": MyLocale("ug", "+256"),
  "Ukraine": MyLocale("ua", "+380"),
  "United Arab Emirates": MyLocale("ae", "+971"),
  "United Kingdom": MyLocale("gb", "+44"),
  "United States": MyLocale("us", "+1"),
  "Uruguay": MyLocale("uy", "+598"),
  "Uzbekistan": MyLocale("uz", "+998"),
  "Vanuatu": MyLocale("vu", "+678"),
  "Venezuela": MyLocale("ve", "+58"),
  "Vietnam": MyLocale("vn", "+84"),
  "Yemen": MyLocale("ye", "+967"),
  "Zambia": MyLocale("zm", "+260"),
  "Zimbabwe": MyLocale("zw", "+263"),
};
