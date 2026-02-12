import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'dart:async';

import 'package:nb_utils/nb_utils.dart';

class AwfulToast {
  // Displays an awful toast
  static void show({
    required BuildContext context,
    required String message,
    ToastType toastType = ToastType.info, // Nouveau paramètre
    Color? backgroundColor, // Devient optionnel car déterminé par toastType
    Color? textColor, // Devient optionnel car déterminé par toastType
    double fontSize = 14,
    IconData? icon, // Devient optionnel car déterminé par toastType
    Duration duration = const Duration(seconds: 6),
    bool blinking = true,
  }) {
    // Détermine les couleurs et icône en fonction du type si non spécifiés
    final toastColors = _getToastColors(toastType, context);
    final bgColor = backgroundColor ?? toastColors.backgroundColor;
    final txtColor = textColor ?? toastColors.textColor;
    final toastIcon = icon ?? toastColors.icon;

    // Create overlay entry
    final entry = OverlayEntry(
      builder: (context) => _AwfulToastOverlay(
        message: message,
        bgColor: bgColor,
        textColor: txtColor,
        fontSize: fontSize,
        icon: toastIcon,
        duration: duration,
        blinking: blinking,
      ),
    );

    // Insert overlay
    Overlay.of(context).insert(entry);

    // Remove after duration
    Future.delayed(duration, () => entry.remove());
  }

  static _ToastColors _getToastColors(ToastType type, BuildContext context) {
    final _theme = Theme.of(context);
    final _isDark = _theme.brightness == Brightness.dark;

    switch (type) {
      case ToastType.success:
        return _ToastColors(
          backgroundColor: _isDark ? _theme.colorScheme.primary : whiteColor,
          textColor: _isDark ? _theme.colorScheme.onPrimary : blackColor,
          barColor: _isDark ? _theme.colorScheme.onPrimary : blackColor,
          icon: Icons.check_circle,
        );
      case ToastType.warning:
        return _ToastColors(
          backgroundColor: _isDark ? _theme.colorScheme.primary : whiteColor,
          textColor: _isDark ? _theme.colorScheme.onPrimary : orange,
          barColor: _isDark ? _theme.colorScheme.onPrimary : orange,
          icon: Icons.warning,
        );
      case ToastType.error:
        return _ToastColors(
          backgroundColor: _isDark ? _theme.colorScheme.primary : whiteColor,
          textColor: Colors.red,
          barColor: Colors.red,
          icon: Icons.error,
        );
      case ToastType.info:
      default:
        return _ToastColors(
          backgroundColor: _isDark ? _theme.colorScheme.primary : whiteColor,
          textColor: _isDark ? _theme.colorScheme.onPrimary : blackColor,
          barColor: _theme.colorScheme.onSurface,
          icon: Icons.info,
        );
    }
  }
}

// Classe helper pour les couleurs et icônes
class _ToastColors {
  final Color backgroundColor;
  final Color textColor;
  final Color barColor;
  final IconData icon;

  _ToastColors({
    required this.backgroundColor,
    required this.textColor,
    required this.barColor,
    required this.icon,
  });
}

// Enum pour les types de toast
enum ToastType {
  success,
  warning,
  error,
  info,
}

class _AwfulToastOverlay extends StatefulWidget {
  final String message;
  final Color bgColor;
  final Color textColor;
  final double fontSize;
  final IconData? icon;
  final Duration duration;
  final bool blinking;

  const _AwfulToastOverlay({
    required this.message,
    required this.bgColor,
    required this.textColor,
    required this.fontSize,
    this.icon,
    required this.duration,
    required this.blinking,
  });

  @override
  _AwfulToastOverlayState createState() => _AwfulToastOverlayState();
}

class _AwfulToastOverlayState extends State<_AwfulToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Timer _blinkTimer;
  bool _visible = true;

  @override
  void initState() {
    super.initState();

    // Bouncing animation
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    // Blinking effect
    if (widget.blinking) {
      int blinkCount = 0;
      _blinkTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
        setState(() => _visible = !_visible);
        blinkCount++;
        if (blinkCount >= 4) {
          // Two times visible and invisible
          _blinkTimer.cancel();
          _visible = true; // Ensure it stays visible after blinking
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (widget.blinking) _blinkTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.sizeOf(context).width;

    return Positioned(
      top: 50,
      left: 20,
      right: _screenWidth < 480 ? 20 : (_screenWidth * 0.57),
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: widget.textColor.withOpacity(0.5),
                offset: const Offset(5, 5),
                blurRadius: 15,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  color: widget.textColor,
                  size: widget.fontSize + 10,
                ),
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.fontSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Comic Sans MS',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ).center(),
        ),
      ),
    );
  }
}
