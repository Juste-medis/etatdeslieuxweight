import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/providers/_payment_provider.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';

class ReviewSignatures extends StatelessWidget {
  final AppThemeProvider wizardState;
  const ReviewSignatures({super.key, required this.wizardState});

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

    return Consumer<PaymentProvider>(builder: (context, appState, child) {
      Jks.paymentState = appState;
      return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: wizardState.formKeys[WizardStep.values[6]],
                  child: Padding(
                    padding: EdgeInsets.all(_padding / 2.75),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Etat des lieux simple".tr.capitalizeFirstLetter(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 40,
                          ),
                        ),
                        Text(
                          "Pour finaliser l'état des lieux, il est nécessaire de procéder au règlement et ensuite aux signatures électroniques des parties concernées."
                              .tr
                              .capitalizeFirstLetter(),
                          style: theme.textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                        20.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Règlement de l'etat des lieux"
                                  .tr
                                  .capitalizeFirstLetter(),
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            16.height,
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: appState.paymentMade == "done"
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Merci d'avoir réglé l'état des lieux. vous pouvez désormais procéder à l’évaluation du bien"
                                              .tr,
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                        16.height,
                                        OutlinedButton.icon(
                                          onPressed: () {
                                            Jks.wizardNextStep();
                                          },
                                          icon: const Icon(
                                              Icons.arrow_forward_ios),
                                          label: Text(
                                              "Compléter l'état des lieux"
                                                  .tr
                                                  .capitalizeFirstLetter()),
                                        ),
                                      ],
                                    )
                                  : appState.paymentMade == "after"
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Vous avez choisi de régler plus tard. Vous pourrez procéder au paiement et aux signatures plus tard depuis votre espace personnel."
                                                  .tr,
                                              style: theme.textTheme.bodyLarge,
                                            ),
                                            16.height,
                                            OutlinedButton.icon(
                                              onPressed: () {
                                                appState.setPaidStatus("none");
                                              },
                                              icon: const Icon(Icons
                                                  .arrow_circle_left_outlined),
                                              label: Text("Retour"
                                                  .tr
                                                  .capitalizeFirstLetter()),
                                            ),
                                            16.height,
                                            OutlinedButton.icon(
                                              onPressed: () {
                                                Jks.wizardNextStep();
                                              },
                                              icon: const Icon(
                                                  Icons.arrow_forward_ios),
                                              label: Text(
                                                  "Aller vers l'état des lieux"
                                                      .tr
                                                      .capitalizeFirstLetter()),
                                            ),
                                            16.height,
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                  foregroundColor:
                                                      theme.colorScheme.primary,
                                                  padding: EdgeInsets.zero),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Aller à l'accueil"
                                                  .tr
                                                  .capitalizeFirstLetter()),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Solde actuel:",
                                                  style: theme
                                                      .textTheme.titleMedium,
                                                ),
                                                Text(
                                                  "${wizardState.currentUser.balance?.simple ?? 0} Crédits",
                                                  style: theme
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            16.height,
                                            Text(
                                              "Nombre de crédit nécessaire: 1",
                                              style: theme.textTheme.bodyLarge,
                                            ),
                                            20.height,
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ElevatedButton.icon(
                                                  onPressed: ((appState
                                                              .isLoading) ||
                                                          (wizardState
                                                                      .currentUser
                                                                      .balance
                                                                      ?.simple ??
                                                                  0) <
                                                              1)
                                                      ? null
                                                      : () async {
                                                          final confirmed =
                                                              await showAwesomeConfirmDialog(
                                                            forceHorizontalButtons:
                                                                true,
                                                            cancelText:
                                                                'Annuler'.tr,
                                                            confirmText:
                                                                'confirmer'.tr,
                                                            context: context,
                                                            title:
                                                                'Utiliser un crédit État des Lieux simple ?'
                                                                    .tr,
                                                            description:
                                                                'Ce crédit sera utilisé pour régler l\'état des lieux en cours de création.'
                                                                    .tr,
                                                          );
                                                          if (confirmed ??
                                                              false) {
                                                            appState
                                                                .useOneCredit({
                                                              'type': "simple",
                                                              "review_id": wizardState
                                                                      .formValues[
                                                                  'review_id']
                                                            }).then((val) {
                                                              if (val ==
                                                                  "done") {
                                                                Jks.languageState
                                                                    .showAppNotification(
                                                                  title:
                                                                      "Paiement réussi"
                                                                          .tr,
                                                                  message:
                                                                      "Votre état des lieux a été réglé avec succès."
                                                                          .tr,
                                                                );
                                                              }
                                                            });
                                                          }
                                                        },
                                                  icon: appState.isLoading
                                                      ? SizedBox(
                                                          width: 16,
                                                          height: 16,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: theme
                                                                .colorScheme
                                                                .onPrimary,
                                                          ),
                                                        )
                                                      : const Icon(
                                                          Icons.payment),
                                                  label:
                                                      Text("Utiliser 1 crédit"),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: theme
                                                        .colorScheme.primary,
                                                    foregroundColor: theme
                                                        .colorScheme.onPrimary,
                                                  ),
                                                ),
                                                8.height,
                                                OutlinedButton(
                                                  onPressed: appState.isLoading
                                                      ? null
                                                      : () {
                                                          showpayementDialog(
                                                            context,
                                                            source:
                                                                "reviewcreated",
                                                            onConfirmed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          );
                                                        },
                                                  child: Text(
                                                      "Acheter des crédits"),
                                                ),
                                                8.height,
                                                TextButton(
                                                  onPressed: appState.isLoading
                                                      ? null
                                                      : () {
                                                          appState
                                                              .setPaidStatus(
                                                                  "after");
                                                        },
                                                  child:
                                                      Text("Régler plus tard"),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16.0),
                                              child: Text(
                                                "Vous pourrez procéder au paiement et aux signatures plus tard depuis votre espace personnel."
                                                    .tr,
                                                style: theme.textTheme.bodySmall
                                                    ?.copyWith(
                                                  color: wizardState.isDarkTheme
                                                      ? whiteColor
                                                      : blackColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ))));
    });
  }
}
