// 🐦 Flutter imports:
import 'dart:convert';
import 'dart:io';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:jatai_etadmin/app/core/helpers/constants/constant.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole3.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/network/rest_apis.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/core/store/app_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jatai_etadmin/app/models/_user_model.dart';
import 'package:jatai_etadmin/app/providers/_forms_provider.dart';
import 'package:jatai_etadmin/app/providers/_payment_provider.dart';
import 'package:jatai_etadmin/app/providers/_proccuration_provider.dart';
import 'package:jatai_etadmin/app/providers/_settings_provider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';

// 🌎 Project imports:
import 'app/core/app_config/app_config.dart';
import 'app/core/static/static.dart';
import 'app/core/theme/theme.dart';
import 'app/providers/providers.dart';
import 'app/routes/app_routes.dart';
import 'generated/l10n.dart' as g10;
//flutter run -d chrome --web-port 38803
//flutter run -d web-server --web-port 6000

AppStore appStore = AppStore();
var primaryColor, secondryColor;

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await initialize();
  await initializeDateFormatting();

  await initializeApp(null, null);
  ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
    sm: 576,
    md: 1240,
    lg: double.infinity,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppThemeProvider()),
      ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ChangeNotifierProvider(create: (_) => ProccurationProvider()),
      ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
      ChangeNotifierProvider(create: (_) => PaymentProvider()),
      ChangeNotifierProvider(create: (_) => FormsProvider()),
      ChangeNotifierProvider(create: (_) => SettingsProvider()),
    ],
    child: const EtatDesLieuxApp(),
  ));
}

class EtatDesLieuxApp extends StatelessWidget {
  const EtatDesLieuxApp({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;
    primaryColor = _isDark ? Colors.white : _theme.primaryColor;

    return Consumer2<AppThemeProvider, AppLanguageProvider>(
      builder: (context, appTheme, appLang, child) {
        Jks.languageState = appLang;
        return rf.ResponsiveBreakpoints.builder(
          breakpoints: [
            rf.Breakpoint(
              start: BreakpointName.XS.start,
              end: BreakpointName.XS.end,
              name: BreakpointName.XS.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.SM.start,
              end: BreakpointName.SM.end,
              name: BreakpointName.SM.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.MD.start,
              end: BreakpointName.MD.end,
              name: BreakpointName.MD.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.LG.start,
              end: BreakpointName.LG.end,
              name: BreakpointName.LG.name,
            ),
            rf.Breakpoint(
              start: BreakpointName.XL.start,
              end: BreakpointName.XL.end,
              name: BreakpointName.XL.name,
            ),
          ],
          child: MaterialApp.router(
            title: AppConfig.appName,
            theme: AcnooAppTheme.kLightTheme(),
            darkTheme: AcnooAppTheme.kDarkTheme(),
            themeMode: appTheme.themeMode,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(rf.ResponsiveValue<double>(
                    context,
                    conditionalValues: [],
                    defaultValue: 1.0,
                  ).value),
                ),
                child: Directionality(
                  textDirection: Directionality.of(context),
                  child: Stack(
                    children: [
                      child!,
                      if (kDebugMode)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Material(
                            child: Text("${MediaQuery.sizeOf(context)}"),
                          ),
                        ),
                      Consumer<AppLanguageProvider>(
                        builder: (context, notificationProvider, _) {
                          return buildAppNotificationWidget(
                              context, notificationProvider);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },

            // Language & Locale
            locale: appLang.currentLocale,
            localizationsDelegates: const [
              g10.S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: g10.S.delegate.supportedLocales,

            // Navigation Configuration
            routerConfig: AcnooAppRoutes.routerConfig,
            debugShowCheckedModeBanner: false,
          ),
        );
      },
    );
  }
}

Future<void> initializeApp(
  User? mUser,
  String? mToken,
) async {
  if (mUser != null && mToken != null) {
  } else {
    await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN),
        isInitializing: true);

    String settings = getStringAsync(APP_SETTINGS);

    Jks.appSettings =
        settings.isNotEmpty ? jsonDecode(settings) as Map<String, dynamic> : {};

    //<><><><><><><><><><><><><><><><><><><><><><><><><><><>
    Map<String, dynamic>? formattedata;
    if (appStore.isLoggedIn) {
      String? userBalence = getStringAsync(USER_BALENCE);
      String meta = getStringAsync(META);
      if (userBalence.validate().isNotEmpty) {
        final data = jsonDecode(userBalence) as Map<dynamic, dynamic>;
        formattedata = data.map(
          (key, value) => MapEntry(key.toString(), value),
        );
        await appStore.setBalence(formattedata);
      }
      final rawAgeRange =
          jsonDecode(meta.validate(value: "{}")) as Map<dynamic, dynamic>;
      final formattedmeta = rawAgeRange.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      mUser = User.fromJson({
        "ID": getIntAsync(USER_ID),
        "_id": getStringAsync("IID"),
        "firstName": getStringAsync(FIRST_NAME),
        "lastName": getStringAsync(LAST_NAME),
        "address": getStringAsync(ADDRESS),
        "level": getStringAsync(LEVEL),
        "favorites": (getStringListAsync(FAVORITES) ?? [])
            .map((e) => e.toString())
            .toList(),
        "images": (getStringListAsync(IMAGES) ?? [])
            .map((e) => e.toString())
            .toList(),
        "lastOnline": getIntAsync(LAST_ONLINE),
        "isBlocked": getBoolAsync("isBlocked", defaultValue: false),
        "phone": getStringAsync(PHONE_NUMBER),
        "username": getStringAsync(USERNAME),
        "email": getStringAsync(USER_EMAIL),
        "about": getStringAsync(ABOUT),
        "meta": formattedmeta,
        "gender": getStringAsync(GENDER),
        "type": getStringAsync(USER_TYPE),
        "placeOfBirth": getStringAsync("placeOfBirth"),
        "countryCode": getStringAsync("COUNTRY_CODE"),
        "country": getStringAsync("COUNTRY"),
        "imageUrl": getStringAsync(PROFILE_IMAGE),
        "balances": formattedata ?? {},
      });
      mToken = getStringAsync(TOKEN);
    }
  }
  if (mUser == null) return;

  await saveUserData(mUser, token: mToken);

  if (!kIsWeb && !Platform.isLinux) {
    Stripe.publishableKey =
        "pk_test_51QnmwlFaAGSj5LN0GPRQBts0PllIclJF70aHw1yc2fWYmpMJ5D1DHD2neKIDFyXofvN1VmdCBtHRuUjWRChFGjZD00Q4W7MwXe";
    Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
    Stripe.urlScheme = 'flutterstripe';

    await Stripe.instance.applySettings();
  }
}
