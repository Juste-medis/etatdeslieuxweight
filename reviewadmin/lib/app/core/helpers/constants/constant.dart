import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/models/_inventory.dart';
import 'package:jatai_etadmin/app/models/mylocale.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';

/// DO NOT CHANGE THIS PACKAGE NAME
var appPackageName = isAndroid
    ? 'com.jatai.jatai_etatsdeslieux'
    : 'com.jatai.jatai_etatsdeslieux';

const LIVESTREAM_TOKEN = 'tokenStream';

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
const USER_BALENCE = 'USER_BALENCE';
const META = 'META';
const APP_SETTINGS = 'APP_SETTINGS';
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
const IS_DARK_MODE = 'IS_DARK_MODE';
//endregion
//region SHARED PREFERENCES KEYS
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
const USER_TYPE = 'USER_TYPE';

const LOGIN_TYPE_USER = 'user';

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
var coupponTypes = <String, String>{
  "fixed": "Fixe".tr,
  "percentage": "Pourcentage".tr,
  "free": "Gratuit".tr,
};
var userLevels = <String, String>{
  "standard": "Standard".tr,
  "admin": "Administrateur".tr,
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

var defaulcles = <String, Map<String, dynamic>>{
  "": {"name": "".tr},
  "principal_key": {
    "name": "Porte principale".tr,
    "icon": "assets/images/static_images/icons/door.png"
  },
  "common_area": {
    "name": "Partie communes".tr,
    "icon": "assets/images/static_images/icons/common_area.png"
  },
  "badge": {
    "name": "Badge".tr,
    "icon": "assets/images/static_images/icons/badge.png"
  },
  "mailbox": {
    "name": "Boîte aux lettres".tr,
    "icon": "assets/images/static_images/icons/mailbox.svg"
  },
  "parking_garage": {
    "name": "Parking-Garage".tr,
    "icon": "assets/images/static_images/icons/parking_garage.png"
  },
  "gate": {
    "name": "Portail".tr,
    "icon": "assets/images/static_images/icons/portal.png"
  },
  "bike_room": {
    "name": "Local à vélo".tr,
    "icon": "assets/images/static_images/icons/bike_room.png"
  },
  "trash_room": {
    "name": "Local poubelle".tr,
    "icon": "assets/images/static_images/icons/trash_room.png"
  },
  "cellar": {
    "name": "Cave".tr,
    "icon": "assets/images/static_images/icons/cellar.png"
  },
  "other": {
    "name": "Autre".tr,
    "icon": "assets/images/static_images/icons/door.png"
  }
};

var defaultStates = <String, String>{
  "good": "Bon Etat".tr,
  "average": "Etat Moyen".tr,
  "bad": "Mauvais Etat".tr,
  "new": "Neuf".tr,
  "not_applicable": "Non Applicable".tr,
};
// "Ce mois",
//   "30 derniers jours",
//   "7 derniers jours",
var defaultPeriods = {
  "monthly": "Ce mois".tr,
  "30d": "30 derniers jours".tr,
  "7d": "7 derniers jours".tr,
};

var defaultReviewStatus = <String, String>{
  "all": "Tous".tr,
  "draft": "Brouillon".tr,
  "completed": "Terminé".tr,
  "signing": "Signature".tr,
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
final ownerpositions = ["sortant", "entrant"];
