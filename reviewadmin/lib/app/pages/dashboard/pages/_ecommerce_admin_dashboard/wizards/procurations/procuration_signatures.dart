import 'package:flutter/material.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/copole2.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/utls.dart';
import 'package:jatai_etadmin/app/core/static/model_keys.dart';
import 'package:jatai_etadmin/app/providers/_payment_provider.dart';
import 'package:jatai_etadmin/app/providers/_proccuration_provider.dart';
import 'package:jatai_etadmin/app/providers/providers.dart';
import 'package:jatai_etadmin/app/widgets/dialogs/confirm_dialog.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etadmin/app/core/helpers/utils/french_translations.dart';

class Signatures extends StatelessWidget {
  final AppThemeProvider wizardState;
  const Signatures({super.key, required this.wizardState});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final proccurationState = context.watch<ProccurationProvider>();
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
                          "Signatures".tr.capitalizeFirstLetter(),
                          style: theme.textTheme.labelLarge?.copyWith(
                            fontSize: 40,
                          ),
                        ),
                        20.height,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Règlement des procurations"
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
                                  ? Text(
                                      "Le paiement a été effectué avec succès. Vous pouvez maintenant compléter la procuration."
                                          .tr,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.colorScheme.primary,
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Solde actuel:",
                                              style:
                                                  theme.textTheme.titleMedium,
                                            ),
                                            Text(
                                              "${wizardState.currentUser.balance?.procurement ?? 0} Crédits",
                                              style: theme.textTheme.titleMedium
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
                                                                  ?.procurement ??
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
                                                            'Utiliser un double crédit État des Lieux ?'
                                                                .tr,
                                                        description:
                                                            'Ce crédit vous permet de déleguer vos états de lieux à vos locataires'
                                                                .tr,
                                                      );
                                                      if (confirmed ?? false) {
                                                        appState.useOneCredit({
                                                          'type': "procurement",
                                                          "procuration_id":
                                                              wizardState
                                                                      .formValues[
                                                                  'procurationId']
                                                        }).then((val) {
                                                          var newpro =
                                                              proccurationState
                                                                  .editingProccuration!;
                                                          newpro.setCredited(Jks
                                                              .paymentState
                                                              .paymentMade);

                                                          proccurationState
                                                              .seteditingProcuration(
                                                                  newpro);
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
                                                        color: theme.colorScheme
                                                            .onPrimary,
                                                      ),
                                                    )
                                                  : const Icon(Icons.payment),
                                              label: Text("Utiliser 1 crédit"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    theme.colorScheme.primary,
                                                foregroundColor:
                                                    theme.colorScheme.onPrimary,
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
                                                            "procurationcreated",
                                                        onConfirmed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      );
                                                    },
                                              child:
                                                  Text("Acheter des crédits"),
                                            ),
                                            8.height,
                                            TextButton(
                                              onPressed: appState.isLoading
                                                  ? null
                                                  : () {
                                                      Jks.wizardNextStep();
                                                    },
                                              child: Text("Régler plus tard"),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: Text(
                                            "Vous pourrez signer le document après avoir effectué le paiement.",
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
                            signatureDivider(),
                          ],
                        ),
                        if (appState.paymentMade == "done") ...[
                          Text(
                            wizardState.inventoryProprietaires.length > 1
                                ? "Signatures des bailleurs"
                                    .tr
                                    .capitalizeFirstLetter()
                                : "Signature du bailleur"
                                    .tr
                                    .capitalizeFirstLetter(),
                            style: theme.textTheme.labelLarge
                                ?.copyWith(fontSize: 40),
                          ),
                          for (final tenant
                              in wizardState.inventoryProprietaires)
                            Column(
                              key: Key('tenant_${tenant.id}_signature'),
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                signatureDivider(),
                                SignatureSection(
                                  userkey: "Bailleur",
                                  title: authorname(tenant),
                                  signatureKey: '${tenant.id}',
                                  showApproval: true,
                                  formKey: Jks.tenantApprovals['${tenant.id}'],
                                  acceptText: "Bon pour pouvoir".tr,
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 8),
                        ]
                      ],
                    ),
                  ))));
    });
  }
}
