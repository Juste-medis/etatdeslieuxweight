// 🐦 Flutter imports:
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class MainRouteWrapper extends StatefulWidget {
  const MainRouteWrapper({super.key, required this.child});

  final Widget child;

  @override
  State<MainRouteWrapper> createState() => _MainRouteWrapperState();
}

class _MainRouteWrapperState extends State<MainRouteWrapper> {
  @override
  Widget build(BuildContext context) {
    const mobileMaxWidth = 430.0;
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final theme = Theme.of(context);
    final clampToMobileWidth = size.width > mobileMaxWidth;
    final appliedWidth = math.min(size.width, mobileMaxWidth);

    return ColoredBox(
      color: theme.colorScheme.primaryContainer,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: mobileMaxWidth),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: clampToMobileWidth
                  ? BorderRadius.circular(16)
                  : BorderRadius.zero,
              boxShadow: clampToMobileWidth
                  ? [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 8),
                      ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: clampToMobileWidth
                  ? BorderRadius.circular(16)
                  : BorderRadius.zero,
              child: MediaQuery(
                data: mediaQuery.copyWith(
                  size: Size(appliedWidth, size.height),
                ),
                child: widget.child,
              ),
            ),
          ).paddingAll(20),
        ),
      ),
    );
  }
}
