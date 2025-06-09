// 🐦 Flutter imports:
import 'dart:convert';
import 'dart:io';

import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/store/app_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_strategy/url_strategy.dart';

// 🌎 Project imports:
import 'app/core/app_config/app_config.dart';
import 'app/core/static/static.dart';
import 'app/core/theme/theme.dart';
import 'app/providers/providers.dart';
import 'app/routes/app_routes.dart';
import 'generated/l10n.dart' as g10;

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

  setPathUrlStrategy();
  ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
    sm: 576,
    md: 1240,
    lg: double.infinity,
  );

  final _app = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppThemeProvider()),
      ChangeNotifierProvider(create: (_) => ReviewProvider()),
      ChangeNotifierProvider(create: (_) => AppLanguageProvider()),
      ChangeNotifierProvider(create: (_) => ECommerceMockProductsNotifier()),
    ],
    child: const EtatDesLieuxApp(),
  );
  await _initializeAppStore();

  runApp(_app);
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

Future<void> _initializeAppStore() async {
  await appStore.setLoggedIn(getBoolAsync(IS_LOGGED_IN), isInitializing: true);

  if (appStore.isLoggedIn) {
    // Set token if available
    String token = getStringAsync(TOKEN);
    if (token.validate().isNotEmpty) await appStore.setToken(token);

    // Set basic user info
    await appStore.setUserEmail(getStringAsync(USER_EMAIL).validate());
    await appStore.setUserId(getIntAsync(USER_ID).validate());
    await appStore.setFirstName(getStringAsync(FIRST_NAME).validate());
    await appStore.setLastName(getStringAsync(LAST_NAME).validate());
    await appStore.setUserName(getStringAsync(USERNAME).validate());
    await appStore.setAddress(getStringAsync(ADDRESS).validate());
    await appStore.setUserType(getStringAsync(USER_TYPE).validate());

    // Set user profile image URL if available
    String profileImage = getStringAsync(PROFILE_IMAGE);
    if (profileImage.validate().isNotEmpty) {
      await appStore.setImageUrl(profileImage);
    }

    // Set additional user info
    await appStore.setPhoneNumber(getStringAsync(PHONE_NUMBER).validate());
    await appStore.setGender(getStringAsync(GENDER).validate());
    await appStore.setplaceOfBirth(getStringAsync("placeOfBirth").validate());

    String meta = getStringAsync(META);
    if (meta.validate().isNotEmpty) {
      final rawAgeRange = jsonDecode(meta) as Map<dynamic, dynamic>;
      final formattedmeta = rawAgeRange.map(
        (key, value) => MapEntry(key.toString(), value),
      );
      await appStore.setMeta(formattedmeta);
    }
    // Set about info
    await appStore.setAbout(getStringAsync(ABOUT).validate());
    await appStore.set_id(getStringAsync("IID").validate());

    // Set last online (if available)
    int? lastOnline = getIntAsync(LAST_ONLINE);

    await appStore.setLastOnline(lastOnline);

    // Set lists (favorites, images, interests)
    await appStore.setFavorites(
      (getStringListAsync(FAVORITES) ?? []).map((e) => e.toString()).toList(),
    );
    await appStore.setImages(
      (getStringListAsync(IMAGES) ?? []).map((e) => e.toString()).toList(),
    );
    // Set level info
    await appStore.setLevel(getStringAsync(LEVEL).validate());

    // Mark user as logged in
    appStore.setLoggedIn(true);
  }
}
