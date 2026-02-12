// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

import 'package:go_router/go_router.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';

extension GoRouterX on BuildContext {
  void goTo(String path) {
    GoRouter.of(this).go(path);
  }

  void pushTo(String path) {
    GoRouter.of(this).push(path);
  }

  void mypushReplacement(String path, {Object? extra}) {
    GoRouter.of(this).push(path, extra: extra);
  }

  void popRoute() {
    GoRouter.of(Jks.context!).pop();
  }

  bool get isKeyboardOpen => MediaQuery.of(this).viewInsets.bottom > 0;

  // Optionnel : accès au router
  GoRouter get router => GoRouter.of(this);
}

extension LocaleExtension on BuildContext {
  /// if [locale] is null, it takes the current locale of current context
  String getLocaleCurrency({Locale? locale}) {
    final currentLocale = locale ?? Localizations.localeOf(this);

    return NumberFormat.simpleCurrency(
      locale: currentLocale.countryCode,
    ).currencySymbol;
  }
}
