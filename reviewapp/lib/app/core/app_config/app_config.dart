import 'package:flutter/foundation.dart';

abstract class AppConfig {
  static const appName = 'Jatai Etat des Lieux';
  static const appIcon = 'assets/app_icons/app_icon_main.png';
  static const logowhite = 'assets/app_icons/logowhite.png';
  static const organizationName = 'Jatai';
  static const DOMAIN_URL = 'https://jataietatdeslieu.adidome.com';
// const debug_host = 'http://192.168.12.1:5000';
  static const debug_host = 'https://jataietatdeslieu.adidome.com';

  static const BASE_URL = '${kReleaseMode ? DOMAIN_URL : debug_host}/api/';
}
