import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/fuctions/_get_image.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/core/static/static.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
import '../../core/app_config/app_config.dart';

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
                  Jks.wizardState = appTheme;
                  Future.delayed(const Duration(seconds: 2), () {
                    appTheme.isAuthenticated();
                  });
                  return const SizedBox();
                },
              ),
              DelayedInfiniteAnimation()
            ],
          ),
        ),
      ),
    );
  }
}

class DelayedInfiniteAnimation extends StatefulWidget {
  const DelayedInfiniteAnimation({super.key});

  @override
  State<DelayedInfiniteAnimation> createState() =>
      _DelayedInfiniteAnimationState();
}

class _DelayedInfiniteAnimationState extends State<DelayedInfiniteAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showAnimation = true);
        _controller = AnimationController(
          vsync: this,
          duration: const Duration(
              milliseconds: 3000), // Augmenté pour inclure le retour
        )..repeat();
      }
    });
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
    } catch (e) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 200.0;

    return Center(
      child: _showAnimation
          ? AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Animation aller-retour
                double animationValue;
                if (_controller.value <= 0.5) {
                  // Première moitié : de droite à gauche (0 à 1)
                  animationValue = _controller.value * 2;
                } else {
                  // Deuxième moitié : de gauche à droite (1 à 0)
                  animationValue = 2 - (_controller.value * 2);
                }

                return Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Logo central
                    SizedBox(
                      width: iconSize,
                      height: iconSize,
                      child: const AnimageWidget(
                        imagePath: AppConfig.appIcon,
                        fit: BoxFit.contain,
                        width: iconSize + 100,
                        height: iconSize + 100,
                      ),
                    ),

                    // Clé qui va de droite à gauche puis retour
                    Positioned(
                      left: iconSize * 0.1 +
                          (iconSize * 0.6) * (1 - animationValue),
                      top: 0,
                      child: getImageType(
                        "assets/images/sidebar_icons/keys.png",
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                );
              },
            )
          : SizedBox(
              width: iconSize,
              height: iconSize,
              child: const AnimageWidget(
                imagePath: AppConfig.appIcon,
                fit: BoxFit.contain,
              ),
            ),
    );
  }
}
