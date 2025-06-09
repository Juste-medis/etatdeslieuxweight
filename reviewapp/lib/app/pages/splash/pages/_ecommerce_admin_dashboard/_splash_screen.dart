// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/fuctions/_get_image.dart';
import 'package:jatai_etatsdeslieux/app/core/static/static.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import '../../../../core/app_config/app_config.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: _isDark ? Colors.black : Colors.white,
      body: Center(
        child: Container(
          height: rf.ResponsiveValue<double?>(
            context,
            conditionalValues: [
              rf.Condition.largerThan(
                name: BreakpointName.SM.name,
                value: 100,
              )
            ],
          ).value,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Consumer<AppThemeProvider>(
                builder: (context, appTheme, child) {
                  appTheme.isAuthenticated();
                  return const SizedBox();
                },
              ),
              Container(
                constraints: BoxConstraints.tight(const Size.square(200)),
                child: const AnimageWidget(
                  imagePath: AppConfig.appIcon,
                  fit: BoxFit.cover,
                  height: double.maxFinite,
                  width: double.maxFinite,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
