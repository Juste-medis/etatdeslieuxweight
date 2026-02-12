import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:jatai_etadmin/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/extensions/_build_context_extensions.dart';
import 'package:go_router/go_router.dart';

class ProcurationWelcome extends StatelessWidget {
  const ProcurationWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    Jks.reviewState.seteditingReview(null, quiet: true);
    Jks.savereviewStep = () async {};
    final bgColor = wizardState.isDarkTheme
        ? theme.colorScheme.surface
        : theme.colorScheme.onPrimary;

    return SingleChildScrollView(
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: ShadowContainer(
              decoration: BoxDecoration(color: bgColor),
              contentPadding: EdgeInsets.all(_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  backbutton(() => {context.popRoute()}),
                  Text(
                    "Procurations et accès locataires"
                        .tr
                        .capitalizeFirstLetter(),
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontSize: 40,
                    ),
                  ),
                  20.height,
                  Text(
                    "Vous avez  ${wizardState.currentUser.balance?.procurement ?? 0} crédits double état des lieux "
                        .tr
                        .capitalizeFirstLetter(),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge
                        ?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  30.height,
                  ElevatedButton(
                    onPressed: () async {
                      wizardState.initialiseProcuration("procuration");

                      context.push(
                        '/createprocuration',
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.all(15)),
                    child: Text(
                      "Démarrer mes procurations + accès locataire".tr,
                      style: theme.textTheme.titleLarge?.copyWith(
                          fontSize: 16,
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold),
                    ),
                  ).paddingOnly(bottom: 10).center(),
                ],
              ),
            ).withHeight(MediaQuery.of(context).size.height)));
  }
}
