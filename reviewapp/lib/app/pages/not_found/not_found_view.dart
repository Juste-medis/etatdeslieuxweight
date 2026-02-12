// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
// import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mon_etatsdeslieux/app/core/static/model_keys.dart';

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;

class NotFoundView extends StatelessWidget {
  const NotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return Scaffold(
      backgroundColor: _theme.colorScheme.primaryContainer,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: MediaQuery.of(context).size.height * .12,
                  color: _theme.colorScheme.primary,
                ),
                const SizedBox(height: 20.0),
                Text(
                  lang.ooopsPageNotFound,
                  textAlign: TextAlign.center,
                  style: _textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  lang.thisPageDoesNotExist,
                  textAlign: TextAlign.center,
                  style: _textTheme.bodyMedium?.copyWith(
                    color: _theme.colorScheme.onTertiary,
                  ),
                ),
                const SizedBox(height: 16.0),

                // Raccourcis utiles
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ActionChip(
                      avatar: Icon(
                        Icons.arrow_back,
                        color: _theme.colorScheme.onTertiary,
                      ),
                      side: BorderSide.none,
                      label: Text(lang.goBack),
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          Jks.checkingAuth = false;
                          context.go('/');
                        }
                      },
                    ),
                    ActionChip(
                      side: BorderSide.none,
                      color: WidgetStateProperty.all(
                        _theme.colorScheme.primary,
                      ),
                      label: const Text(
                        'Accueil',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () => context.go('/'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
