import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:mon_etatsdeslieux/app/providers/providers.dart';
import 'package:provider/provider.dart';

class RouteGuard {
  static Future<String?> redirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final authProvider = Provider.of<AppThemeProvider>(context, listen: false);
    final isLoggedIn = authProvider.token != null;
    final isAuthRoute =
        state.matchedLocation == "/" ||
        state.matchedLocation.startsWith('/resetpassword') ||
        state.matchedLocation.startsWith('/authentication') ||
        state.matchedLocation.startsWith('/otp');

    // If user is not logged in and trying to access protected route
    if (!isLoggedIn && !isAuthRoute) {
      return '/authentication/signin';
    }

    // If user is logged in but trying to access auth route
    if (isLoggedIn && isAuthRoute) {
      Jks.checkingAuth = false;
      return '/';
    }

    return null; // No redirect needed
  }
}
