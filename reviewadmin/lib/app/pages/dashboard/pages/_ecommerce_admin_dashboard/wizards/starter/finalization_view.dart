import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:jatai_etadmin/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etadmin/app/core/helpers/extensions/_build_context_extensions.dart';

class FinalizationView extends StatelessWidget {
  final AppThemeProvider wizardState;
  const FinalizationView({super.key, required this.wizardState});

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

    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: Form(
                autovalidateMode: AutovalidateMode.disabled,
                key: wizardState.formKeys[WizardStep.values[9]],
                child: ShadowContainer(
                  contentPadding: EdgeInsets.all(_padding / 2.75),
                  customHeader: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      20.height,
                      20.height,
                      Text(
                        "Proccuration terminé".tr.capitalizeFirstLetter(),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelLarge?.copyWith(
                          fontSize: 40,
                        ),
                      ),
                      20.height,
                      Text(
                        "Merci d’avoir utilisé Jatai !"
                            .tr
                            .capitalizeFirstLetter(),
                        style: theme.textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                      30.height,
                      inventoryAddButton(
                        context,
                        title: "Ok".tr,
                        icon: Icons.check_circle,
                        onPressed: () async {
                          Jks.reviewState.fetchReviews(refresh: true);
                          context.pushReplacement(
                            '/',
                          );
                        },
                      ).paddingOnly(bottom: 10).center(),
                    ],
                  ),
                ))));
  }
}
