// 🐦 Flutter imports:

import 'package:flutter/material.dart';

class AppLanguageProvider extends ChangeNotifier {
  bool showNotification = false;
  String notificationMessage = "";
  Color notificationColor = Colors.green;
  String? notificationTitle;
  VoidCallback? onNotificationTap;

  void showAppNotification(
      {required String message,
      Color color = Colors.green,
      String? title,
      VoidCallback? onTap}) {
    notificationMessage = message;
    notificationColor = color;
    notificationTitle = title;
    onNotificationTap = onTap;
    showNotification = true;

    Future.delayed(const Duration(seconds: 5), () {
      showNotification = false;
      notifyListeners();
    });

    notifyListeners();
  }

  void hideAppNotification() {
    showNotification = false;
    notificationMessage = "";
    notificationTitle = null;
    onNotificationTap = null;

    notifyListeners();
  }

  // Supported Languages
  final locales = const <String, Locale>{
    "Arabic": Locale('ar', 'SA'), // Arabic, Saudi Arabia
    "Bengali": Locale('bn', 'BD'), // Bengali, Bangladesh
    "English": Locale('en', 'US'), // English, United States
    "Hindi": Locale('hi', 'IN'), // Hindi, India
    "Français": Locale('fr', 'FR'), // Francais, Frnace
    // "Indonesian": Locale('id', 'ID'), // Indonesian, Indonesia
    "Korean": Locale('ko', 'KR'), // Korean, South Korea (Republic of Korea)
    "Portuguese": Locale('pt', 'BR'), // Portuguese, Brazil
    // "Swahili": Locale('sw', 'KE'), // Swahili, Kenya
    // "Thai": Locale('th', 'TH'), // Thai, Thailand
    // "Urdu": Locale('ur', 'PK'), // Urdu, Pakistan
  };

  Locale _currentLocale = const Locale("fr", "FR");
  // Locale _currentLocale = const Locale('ar', 'SA');
  Locale get currentLocale => _currentLocale;
  bool isRTL = false;
  void changeLocale(Locale? value) {
    if (value == null) return;

    _currentLocale = value;
    notifyListeners();
  }
}
