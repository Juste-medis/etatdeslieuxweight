import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/constants/constant.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/copole.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/utls.dart';
import 'package:jatai_etatsdeslieux/app/core/static/model_keys.dart';
import 'package:jatai_etatsdeslieux/app/core/theme/theme.dart';
import 'package:jatai_etatsdeslieux/app/models/review.dart';
import 'package:jatai_etatsdeslieux/app/pages/dashboard/pages/_ecommerce_admin_dashboard/components/_components.dart';
import 'package:jatai_etatsdeslieux/app/providers/providers.dart';
import 'package:jatai_etatsdeslieux/app/widgets/widgets.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';
import 'package:jatai_etatsdeslieux/generated/l10n.dart' as l;
import 'package:responsive_grid/responsive_grid.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/utils/french_translations.dart';
import 'package:jatai_etatsdeslieux/app/core/helpers/extensions/_build_context_extensions.dart';

class LocataireSortantAddress extends StatelessWidget {
  final Review? review;
  const LocataireSortantAddress({super.key, this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final wizardState = context.watch<AppThemeProvider>();
    final _lang = l.S.of(context);
    final _padding = responsiveValue<double>(
      context,
      xs: 16,
      sm: 16,
      md: 16,
      lg: 24,
    );
    final reviewState = context.watch<ReviewProvider>();

    Jks.savereviewStep = () async {
      if (review != null) {
        try {
          wizardState.setloading(true);
          await reviewState.updateThereview(
            review!,
            "commentsection",
            wizardState: wizardState,
          );
          wizardState.setloading(false);
        } catch (e) {
          my_inspect(e);
          show_common_toast(
              "Une erreur s'est produite, veuillez réessayer plus tard.".tr,
              context);
        }
      } else {}
    };
    return Scaffold(
      backgroundColor: review != null
          ? wizardState.isDarkTheme
              ? blackColor
              : whiteColor
          : null,
      bottomNavigationBar: (review != null && wizardState.edited)
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: wizardState.loading ? null : Jks.savereviewStep,
                    icon: wizardState.loading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              color: AcnooAppColors.kWhiteColor,
                              strokeWidth: 2,
                            ),
                          )
                        : null,
                    label: Text("Enrégistrer les modifications".tr),
                  ),
                ],
              ),
            )
          : null,
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                scrollbars: false,
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.disabled,
                  key: wizardState.formKeys[WizardStep.values[4]],
                  child: ShadowContainer(
                    contentPadding: EdgeInsets.all(_padding / 2.75),
                    customHeader: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (review != null)
                          backbutton(
                            () => {context.popRoute()},
                          ),
                        20.height,
                        if (wizardState.reviewType == 'exit')
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nouvelle addresse".capitalizeFirstLetter(),
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              // complementary information
                              Text(
                                "Details et informations sur le locataire ".tr,
                                style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onSurface),
                              ),
                              5.height,
                              editUserField(
                                textEditingController: TextEditingController(
                                    text: wizardState
                                        .formValues['tenant_new_address']),
                                type: "place",
                                title:
                                    "Entrer la nouvelle adresse du locataire sortant"
                                        .tr,
                                placeholder:
                                    "${_lang.enterThe} ${_lang.ownerfullname}",
                                onChanged: (text) {
                                  wizardState.updateFormValue(
                                      'tenant_new_address', text);
                                },
                                required: true,
                              ),
                              30.height,
                              Text(
                                "Date d'état des lieux d'entrée"
                                    .capitalizeFirstLetter(),
                                style: theme.textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              // complementary information
                              Text(
                                "Date à laquelle le locataire est entré dans le logement"
                                    .tr,
                                style: theme.textTheme.labelLarge?.copyWith(
                                    color: theme.colorScheme.onSurface),
                              ),
                              5.height,
                              editUserField(
                                textEditingController: TextEditingController(
                                  text: wizardState.formValues[
                                              'tenant_entry_date'] !=
                                          null
                                      ? DateFormat('dd-MM-yyyy')
                                          .format(wizardState.formValues[
                                                      'tenant_entry_date']
                                                  is DateTime
                                              ? wizardState.formValues[
                                                  'tenant_entry_date']
                                              : DateTime.parse(
                                                  wizardState.formValues[
                                                      'tenant_entry_date'],
                                                ))
                                          .toString()
                                      : '',
                                ),
                                type: "date",
                                title:
                                    "Entrer la date d'entrée du locataire".tr,
                                placeholder:
                                    "${_lang.enterThe} ${_lang.ownerfullname}",
                                onChanged: (text) {
                                  wizardState.updateFormValue(
                                      'tenant_entry_date', text);
                                },
                                required: true,
                              ),
                              30.height
                            ],
                          ),
                        Text(
                          "Pésence de detecteur de fumée"
                              .capitalizeFirstLetter(),
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        10.height,
                        SelectGrid(
                          entries: [
                            SelectionTile(
                              title: "Oui".tr,
                              isSelected:
                                  wizardState.formValues['security_smoke'] ==
                                      "yes",
                              onTap: () => wizardState.updateFormValue(
                                  'security_smoke', "yes"),
                            ),
                            SelectionTile(
                              title: "Non".tr,
                              isSelected:
                                  wizardState.formValues['security_smoke'] ==
                                      "no",
                              onTap: () => wizardState.updateFormValue(
                                  'security_smoke', "no"),
                            ),
                          ],
                        ),
                        30.height,
                        if (wizardState.formValues['security_smoke'] == "yes")
                          editUserField(
                            required: true,
                            title: "Fonctionnel ?".capitalizeFirstLetter(),
                            type: "select",
                            layout: 'simplerow',
                            items: yesnonotTested,
                            initialvalue: wizardState
                                .formValues['security_smoke_functioning'],
                            onChanged: (text) {
                              wizardState.updateFormValue(
                                  'security_smoke_functioning', text);
                            },
                          ),
                        30.height,
                        Text(
                          "Commentaires".capitalizeFirstLetter(),
                          style: theme.textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        editUserField(
                          title: "Commentaires".tr,
                          showLabel: false,
                          type: "textarea",
                          initialvalue: wizardState.formValues['comments'],
                          placeholder:
                              "${_lang.enterThe} ${_lang.ownerfullname}",
                          onChanged: (text) {
                            wizardState.updateFormValue('comments', text);
                          },
                          required: true,
                        ),
                      ],
                    ),
                  )))),
    );
  }
}
