import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mon_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:nb_utils/nb_utils.dart';

String rawsettings = getStringAsync(APP_SETTINGS);

var settings = rawsettings.isNotEmpty
    ? jsonDecode(rawsettings) as Map<String, dynamic>
    : {};

abstract class AppConfig {
  AppConfig._();

  static final appName = settings['appName'] ?? 'Jatai État des Lieux';
  static const appIcon = 'assets/app_icons/app_icon_main.png';
  static const logowhite = 'assets/app_icons/logowhite.png';
  static const organizationName = 'Jatai';
  static final String domainUrl =
      (settings['appUrl'] as String?) ??
      'https://etatdeslieux.adidomedis.cloud';

  // const debugHost = 'http://192.168.12.1:5000';
  static const String debugHost = 'http://localhost:5000';

  static final String baseUrl = '${kReleaseMode ? domainUrl : domainUrl}/api/';

  static final String simplebaseUrl = kReleaseMode ? domainUrl : domainUrl;
}
